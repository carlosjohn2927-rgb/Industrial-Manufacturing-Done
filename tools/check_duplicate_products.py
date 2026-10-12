#!/usr/bin/env python3
"""Check SQL files for duplicate products.

Scans ``INSERT INTO products`` statements (and ``categories``) in the given
files — or, by default, every ``database/**/*.sql`` and ``install/*.sql`` file
in the repository — and reports products that appear more than once with the
same SKU, slug, or name.

Comparison matches MySQL ``utf8mb4_*_ci`` semantics: names/slugs/skus are
normalised to NFC, case-folded, and stripped of leading/trailing whitespace,
so ``'Ball Valve '`` and ``'ball valve'`` count as duplicates.

A duplicate is a problem only when it occurs *within a single file* (one file
= one import unit = one database state).  The same product legitimately
appears in several files: base seed data is mirrored in ``production.sql`` and
``seed.sql``, and migrations are appended verbatim to those dumps; the
``NOT EXISTS`` / fixed-PK guards in the migrations prevent double insertion.
Those cross-file overlaps are only listed with ``--all``.

Usage:
    python3 tools/check_duplicate_products.py                    # repo defaults
    python3 tools/check_duplicate_products.py dump.sql ...       # e.g. a mysqldump
    python3 tools/check_duplicate_products.py --near             # + fuzzy name pairs
    python3 tools/check_duplicate_products.py --all              # + cross-file overlaps

Exit status: 0 = no intra-file duplicates, 1 = duplicates found (or usage error).
"""

from __future__ import annotations

import argparse
import glob
import os
import re
import sys
import unicodedata
from collections import defaultdict

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_GLOBS = ("database/**/*.sql", "install/*.sql")
TABLES = ("products", "categories")
NEAR_THRESHOLD = 0.85


# --------------------------------------------------------------------------- #
# quote-aware SQL statement scanning
# --------------------------------------------------------------------------- #
def iter_insert_blocks(sql: str, table: str):
    """Yield (line_number, statement_text) for every INSERT into ``table``.

    Statement boundaries are found with a small scanner that is aware of
    single/double-quoted strings (with backslash escapes) and ``--`` comments,
    so semicolons inside descriptions never truncate a statement.
    """
    pat = re.compile(
        r"INSERT\s+(?:IGNORE\s+)?INTO\s+`?" + re.escape(table) + r"`?\s*",
        re.I,
    )
    for m in pat.finditer(sql):
        i = m.end()
        # optional column list / VALUES keyword before the row data
        while i < len(sql) and sql[i] in " \t\r\n":
            i += 1
        if i < len(sql) and sql[i] == "(":
            depth, q = 0, None
            while i < len(sql):
                c = sql[i]
                if q:
                    if c == "\\":
                        i += 2
                        continue
                    if c == q:
                        q = None
                elif c in "'\"":
                    q = c
                elif c == "(":
                    depth += 1
                elif c == ")":
                    depth -= 1
                    if depth == 0:
                        i += 1
                        break
                i += 1
            while i < len(sql) and sql[i] in " \t\r\n":
                i += 1
        kw = re.match(r"VALUES\b", sql[i:], re.I)
        if kw:
            i += kw.end()
        start = m.start()
        # scan to the terminating semicolon, quote-aware
        while i < len(sql):
            c = sql[i]
            if c == "\\":
                i += 2
                continue
            if c in "'\"":
                q = c
                i += 1
                while i < len(sql):
                    if sql[i] == "\\":
                        i += 2
                        continue
                    if sql[i] == q:
                        break
                    i += 1
            elif c == "-" and sql[i : i + 2] == "--":
                j = sql.find("\n", i)
                i = len(sql) if j < 0 else j
                continue
            elif c == ";":
                yield sql.count("\n", 0, start) + 1, sql[start : i + 1]
                break
            i += 1


# --------------------------------------------------------------------------- #
# row extraction
# --------------------------------------------------------------------------- #
_STR = r"'((?:[^'\\]|\\.)*)'"
_ID_PREFIX = re.compile(r"^(?:rp|p00\d|prod-|prd|img|ri|rc|cat-|ct)", re.I)
_UUID_LIKE = re.compile(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", re.I)


def _unesc(s: str) -> str:
    return (
        s.replace("\\'", "'")
        .replace('\\"', '"')
        .replace("\\\\", "\\")
        .replace("\\n", "\n")
        .replace("\\t", "\t")
    )


def _norm(s: str) -> str:
    """NFC + casefold + strip ≈ utf8mb4 ci comparison with trailing-space pad."""
    return unicodedata.normalize("NFC", s).casefold().strip()


def extract_rows(block: str, table: str):
    """Return [(name, slug, sku)] for products (or [(name, slug)] for categories)."""
    rows, seen = [], set()

    def add(*vals):
        key = tuple(_norm(v) for v in vals)
        if key not in seen:
            seen.add(key)
            rows.append(vals)

    if table == "products":
        # SELECT UUID(), 'name', 'slug', 'sku', ...   (block-wide: UNION chains,
        # multi-line projections)
        for m in re.finditer(
            r"UUID\(\)\s*,\s*" + _STR + r"\s*,\s*" + _STR + r"\s*,\s*" + _STR,
            block,
            re.S,
        ):
            add(*(_unesc(g) for g in m.groups()))
        # SELECT 'rp000001-...', 'name', 'slug', 'sku', ...
        for m in re.finditer(
            r"SELECT\s+'rp[^']*'\s*,\s*" + _STR + r"\s*,\s*" + _STR + r"\s*,\s*" + _STR,
            block,
        ):
            add(*(_unesc(g) for g in m.groups()))
        # VALUES rows: first literal is the id (p001… / prod-… / UUID-like)
        if re.search(r"\bVALUES\b", block, re.I):
            for tup in _iter_tuples(block):
                lits = _first_literals(tup, 4)
                if len(lits) == 4 and (_ID_PREFIX.match(lits[0]) or _UUID_LIKE.match(lits[0])):
                    add(*(_unesc(v) for v in lits[1:]))
    else:  # categories
        for m in re.finditer(r"UUID\(\)\s*,\s*" + _STR + r"\s*,\s*" + _STR, block, re.S):
            add(*(_unesc(g) for g in m.groups()))
        for m in re.finditer(r"SELECT\s+'rc[^']*'\s*,\s*" + _STR + r"\s*,\s*" + _STR, block):
            add(*(_unesc(g) for g in m.groups()))
        if re.search(r"\bVALUES\b", block, re.I):
            for tup in _iter_tuples(block):
                lits = _first_literals(tup, 3)
                if len(lits) == 3 and (_ID_PREFIX.match(lits[0]) or _UUID_LIKE.match(lits[0])):
                    add(*(_unesc(v) for v in lits[1:]))
    return rows


def _iter_tuples(block: str):
    """Yield top-level parenthesised tuples of a VALUES(...) statement."""
    start = block.find("VALUES")
    if start < 0:
        return
    i, depth, begin = start + 6, 0, None
    while i < len(block):
        c = block[i]
        if c == "'":
            i += 1
            while i < len(block):
                if block[i] == "\\":
                    i += 2
                    continue
                if block[i] == "'":
                    break
                i += 1
        elif c == "(":
            if depth == 0:
                begin = i
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0 and begin is not None:
                yield block[begin : i + 1]
                begin = None
        elif c == ";" and depth == 0:
            break
        i += 1


def _first_literals(tup: str, n: int):
    lits, i = [], 0
    while i < len(tup) and len(lits) < n:
        if tup[i] == "'":
            j = i + 1
            buf = []
            while j < len(tup):
                if tup[j] == "\\" and j + 1 < len(tup):
                    buf.append(tup[j : j + 2])
                    j += 2
                    continue
                if tup[j] == "'":
                    break
                buf.append(tup[j])
                j += 1
            lits.append("".join(buf))
            i = j + 1
        else:
            i += 1
    return lits


# --------------------------------------------------------------------------- #
# reporting
# --------------------------------------------------------------------------- #
def squash(s: str) -> str:
    s = unicodedata.normalize("NFC", s).casefold()
    s = re.sub(r"[^a-z0-9]+", " ", s)
    return " ".join(sorted(s.split()))


def scan_file(path: str, table: str):
    sql = open(path, encoding="utf-8", errors="replace").read()
    entries = []  # (line, fields, raw_fields)
    for line, block in iter_insert_blocks(sql, table):
        for fields in extract_rows(block, table):
            entries.append((line, fields))
    return entries


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("files", nargs="*", help="SQL files to scan (default: repo database/** and install/*.sql)")
    ap.add_argument("--near", action="store_true", help=f"also list fuzzy near-duplicate product names (>= {NEAR_THRESHOLD})")
    ap.add_argument("--all", action="store_true", help="also list cross-file overlaps (mirrors are expected)")
    args = ap.parse_args(argv)

    if args.files:
        files = [os.path.abspath(f) for f in args.files]
        for f in files:
            if not os.path.isfile(f):
                print(f"error: no such file: {f}", file=sys.stderr)
                return 1
    else:
        files = sorted(
            {
                os.path.abspath(p)
                for g in DEFAULT_GLOBS
                for p in glob.glob(os.path.join(REPO_ROOT, g), recursive=True)
            }
        )
        # skip this tool's own repo copy of fixtures if any appear later

    failed = False
    all_by_key = defaultdict(list)  # (table, field, normkey) -> [(file, line, raw)]

    for table in TABLES:
        nfields = 3 if table == "products" else 2
        per_file = {}
        for f in files:
            entries = scan_file(f, table)
            if entries:
                per_file[f] = entries
            for line, fields in entries:
                for i in range(nfields):
                    all_by_key[(table, i, _norm(fields[i]))].append((f, line, fields))

        # intra-file duplicates => failure
        for f, entries in per_file.items():
            dups_here = []
            for i, label in enumerate(("name", "slug", "sku")[:nfields]):
                idx = defaultdict(list)
                for line, fields in entries:
                    idx[_norm(fields[i])].append((line, fields))
                for key, hits in idx.items():
                    if len(hits) > 1:
                        dups_here.append((label, key, hits))
            rel = os.path.relpath(f, REPO_ROOT)
            print(f"{rel}: {len(entries)} {table} rows" + ("" if not dups_here else f"  *** {len(dups_here)} duplicate key(s) ***"))
            for label, key, hits in dups_here:
                failed = True
                print(f"  duplicate {label}: {key!r} x{len(hits)}")
                for line, fields in hits:
                    shown = " | ".join(fields)
                    print(f"    line {line}: {shown}")
        if table == "products":
            print()

    # cross-file overlaps (informational)
    if args.all:
        print("\n-- cross-file overlaps (expected: migrations are mirrored in the dumps) --")
        for (table, i, key), hits in sorted(all_by_key.items()):
            distinct_files = {os.path.relpath(f, REPO_ROOT) for f, _, _ in hits}
            if len(distinct_files) > 1:
                label = ("name", "slug", "sku")[i] if table == "products" else ("name", "slug")[i]
                where = ", ".join(f"{os.path.relpath(f, REPO_ROOT)}:{ln}" for f, ln, _ in hits)
                print(f"  {table}.{label} {key!r} x{len(hits)} -> {where}")

    # fuzzy near-duplicate names (informational)
    if args.near and not failed:
        from difflib import SequenceMatcher
        import itertools

        print(f"\n-- near-duplicate product names (>= {NEAR_THRESHOLD}, informational) --")
        prod_entries = []
        for f in files:
            prod_entries += [(fields[0], fields) for _, fields in scan_file(f, "products")]
        found = 0
        seen_pairs = set()
        for (na, a), (nb, b) in itertools.combinations(prod_entries, 2):
            sa, sb = squash(na), squash(nb)
            r = 1.0 if sa == sb else SequenceMatcher(None, sa, sb).ratio()
            if r >= NEAR_THRESHOLD and a[2] != b[2]:  # different sku required
                pair = tuple(sorted((a[1], b[1])))
                if pair in seen_pairs:
                    continue
                seen_pairs.add(pair)
                found += 1
                print(f"  {r:.2f}: {a[0]!r} [{a[2]}] <-> {b[0]!r} [{b[2]}]")
        if not found:
            print("  none")

    print()
    if failed:
        print("RESULT: DUPLICATES FOUND")
        return 1
    print("RESULT: no duplicate products (within any single file)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
