#!/usr/bin/env python3
"""
Vortex Precision IT — SQLite database builder in Python.
Replicates install/dev-sqlite.php to build database/dev.sqlite from schema and migrations.
"""

import os
import re
import sys
import sqlite3
import uuid

def uuid4():
    return str(uuid.uuid4())

def split_sql_statements(sql):
    out = []
    buf = []
    q = None
    i = 0
    length = len(sql)
    while i < length:
        c = sql[i]
        if q is not None:
            buf.append(c)
            if c == '\\' and i + 1 < length:
                i += 1
                buf.append(sql[i])
            elif c == q:
                q = None
            i += 1
            continue
        if c in ("'", '"', '`'):
            q = c
            buf.append(c)
            i += 1
            continue
        if c == '-' and i + 1 < length and sql[i+1] == '-':
            nl = sql.find('\n', i)
            if nl == -1:
                i = length
            else:
                i = nl
            continue
        if c == ';':
            stmt = ''.join(buf).strip()
            if stmt:
                out.append(stmt)
            buf = []
            i += 1
            continue
        buf.append(c)
        i += 1
    stmt = ''.join(buf).strip()
    if stmt:
        out.append(stmt)
    return out

def translate_mysql_to_sqlite(stmt):
    # UUID() -> uuid
    while 'UUID()' in stmt.upper():
        pos = stmt.upper().find('UUID()')
        stmt = stmt[:pos] + f"'{uuid4()}'" + stmt[pos+6:]
    
    # NOW() -> datetime
    stmt = re.sub(r'\bNOW\(\)', "'2026-08-29 12:00:00'", stmt, flags=re.IGNORECASE)
    
    # INSERT IGNORE -> INSERT OR IGNORE
    stmt = re.sub(r'^INSERT\s+IGNORE', 'INSERT OR IGNORE', stmt, flags=re.IGNORECASE)
    
    # ON DUPLICATE KEY UPDATE -> INSERT OR REPLACE
    if re.search(r'\bON\s+DUPLICATE\s+KEY\s+UPDATE\b', stmt, flags=re.IGNORECASE):
        stmt = re.sub(r'\s*ON\s+DUPLICATE\s+KEY\s+UPDATE.*$', '', stmt, flags=re.IGNORECASE | re.DOTALL)
        stmt = re.sub(r'^INSERT(\s+OR\s+\w+)?\s+INTO', 'INSERT OR REPLACE INTO', stmt, flags=re.IGNORECASE)
    
    # CONCAT(...) -> (...)
    # Handle CONCAT('...', id) -> '...' || id
    while 'CONCAT(' in stmt.upper():
        pos = stmt.upper().find('CONCAT(')
        # find matching closing parenthesis
        depth = 1
        q = None
        j = pos + 7
        slen = len(stmt)
        while j < slen and depth > 0:
            c = stmt[j]
            if q is not None:
                if c == '\\' and j + 1 < slen:
                    j += 1
                elif c == q:
                    q = None
                j += 1
                continue
            if c in ("'", '"'):
                q = c
                j += 1
                continue
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
            j += 1
        inner = stmt[pos+7:j-1]
        args = [a.strip() for a in inner.split(',')]
        concat_expr = ' || '.join(args)
        stmt = stmt[:pos] + concat_expr + stmt[j:]

    stmt = stmt.replace('\\"', '"')
    stmt = stmt.replace("\\'", "''")
    return stmt

def translate_create_table(stmt):
    m = re.search(r'CREATE\s+TABLE(?:\s+IF\s+NOT\s+EXISTS)?\s+`?([A-Za-z0-9_]+)`?\s*\((.*)\)\s*(ENGINE.*)?$', stmt, re.IGNORECASE | re.DOTALL)
    if not m:
        return stmt, []
    table = m.group(1)
    body = m.group(2)
    
    # split columns
    lines = []
    buf = []
    depth = 0
    q = None
    i = 0
    blen = len(body)
    while i < blen:
        c = body[i]
        if q is not None:
            buf.append(c)
            if c == '\\' and i + 1 < blen:
                i += 1
                buf.append(body[i])
            elif c == q:
                q = None
            i += 1
            continue
        if c in ("'", '"'):
            q = c
            buf.append(c)
            i += 1
            continue
        if c == '(':
            depth += 1
            buf.append(c)
        elif c == ')':
            depth -= 1
            buf.append(c)
        elif c == ',' and depth == 0:
            lines.append(''.join(buf).strip())
            buf = []
            i += 1
            continue
        else:
            buf.append(c)
        i += 1
    if buf:
        lines.append(''.join(buf).strip())
    
    cols = []
    indexes = []
    for line in lines:
        line = line.strip()
        if not line:
            continue
        km = re.match(r'^(UNIQUE\s+)?(?:KEY|INDEX)\s+`?([A-Za-z0-9_]+)`?\s*\((.+)\)$', line, re.IGNORECASE)
        if km:
            uniq = 'UNIQUE ' if km.group(1) else ''
            indexes.append(f"CREATE {uniq}INDEX IF NOT EXISTS `{km.group(2)}` ON `{table}` ({km.group(3)})")
            continue
        if re.match(r'^FULLTEXT\s+', line, re.IGNORECASE):
            continue
        if re.match(r'^(PRIMARY\s+KEY|CONSTRAINT|FOREIGN\s+KEY|CHECK)', line, re.IGNORECASE):
            cols.append(line)
            continue
        
        # Column conversions
        line = re.sub(r'\bENUM\s*\([^)]*\)', 'TEXT', line, flags=re.IGNORECASE)
        line = re.sub(r'\b(LONGTEXT|MEDIUMTEXT|TINYTEXT|JSON|BLOB|LONGBLOB)\b', 'TEXT', line, flags=re.IGNORECASE)
        line = re.sub(r'\bTINYINT\s*\(\s*1\s*\)', 'INTEGER', line, flags=re.IGNORECASE)
        line = re.sub(r'\b(BIGINT|SMALLINT|MEDIUMINT|TINYINT|INT)\s*(\(\d+\))?\s*(UNSIGNED)?', 'INTEGER', line, flags=re.IGNORECASE)
        line = re.sub(r'\bDOUBLE\b', 'REAL', line, flags=re.IGNORECASE)
        line = re.sub(r'\bDEFAULT\s+CURRENT_TIMESTAMP\s+ON\s+UPDATE\s+CURRENT_TIMESTAMP', 'DEFAULT CURRENT_TIMESTAMP', line, flags=re.IGNORECASE)
        line = re.sub(r'\bON\s+UPDATE\s+CURRENT_TIMESTAMP', '', line, flags=re.IGNORECASE)
        line = re.sub(r'\bDEFAULT\s+\(UUID\(\)\)', '', line, flags=re.IGNORECASE)
        line = re.sub(r'\bCHARACTER\s+SET\s+\S+', '', line, flags=re.IGNORECASE)
        line = re.sub(r'\bCOLLATE\s+\S+', '', line, flags=re.IGNORECASE)
        line = re.sub(r'\bAUTO_INCREMENT\b', '', line, flags=re.IGNORECASE)
        cols.append(line.strip())
        
    create = f"CREATE TABLE IF NOT EXISTS `{table}` (\n  " + ",\n  ".join(cols) + "\n)"
    return create, indexes

def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    target = os.path.join(root, 'database', 'dev.sqlite')
    if os.path.exists(target):
        os.remove(target)
        print(f"Removed existing {target}")
        
    conn = sqlite3.connect(target)
    conn.execute('PRAGMA foreign_keys = ON')
    
    files = [
        os.path.join(root, 'install', 'install.sql'),
        os.path.join(root, 'database', 'migrations', '001_cms_and_permissions.sql'),
        os.path.join(root, 'install', 'seed.sql'),
        os.path.join(root, 'database', 'migrations', '002_cms_seed.sql'),
        os.path.join(root, 'database', 'migrations', '003_admin_full_page_editing.sql'),
        os.path.join(root, 'database', 'migrations', '004_black_writeup.sql'),
        os.path.join(root, 'database', 'migrations', '005_testimonials_admin_access.sql'),
        os.path.join(root, 'database', 'migrations', '006_admin_full_dashboard_access.sql'),
        os.path.join(root, 'database', 'migrations', '007_vortex_precision_it_branding.sql'),
        os.path.join(root, 'database', 'migrations', '008_add_industrial_product_range.sql'),
        os.path.join(root, 'database', 'migrations', '009_catalog_prices_500_to_5000.sql'),
        os.path.join(root, 'database', 'migrations', '010_add_ajr_ndt_product_range.sql'),
        os.path.join(root, 'database', 'migrations', '011_show_ajr_ndt_catalog_on_site.sql'),
    ]
    
    indexes = []
    deferred = []
    applied = 0
    
    for f in files:
        if not os.path.exists(f):
            print(f"Skipping missing {f}")
            continue
        print(f"Applying {os.path.basename(f)} ...")
        with open(f, 'r', encoding='utf-8') as fp:
            sql = fp.read()
            
        stmts = split_sql_statements(sql)
        for stmt in stmts:
            if re.match(r'^(SET|LOCK|UNLOCK|/\*|DELIMITER)', stmt, re.IGNORECASE):
                continue
            if re.match(r'^CREATE\s+TABLE', stmt, re.IGNORECASE):
                create, idxs = translate_create_table(stmt)
                conn.execute(create)
                indexes.extend(idxs)
                applied += 1
                continue
            if re.match(r'^(CREATE\s+(UNIQUE\s+)?INDEX)', stmt, re.IGNORECASE):
                indexes.append(stmt)
                continue
            if re.match(r'^ALTER\s+TABLE', stmt, re.IGNORECASE):
                try:
                    conn.execute(stmt)
                    applied += 1
                except Exception:
                    pass
                continue
            deferred.append(stmt)
            
    for idx in indexes:
        try:
            conn.execute(idx)
        except Exception:
            pass
            
    for stmt in deferred:
        stmt = translate_mysql_to_sqlite(stmt)
        try:
            conn.execute(stmt)
            applied += 1
        except Exception as e:
            # print error
            print(f"Error on stmt: {str(e)[:100]} | Stmt: {stmt[:60]}")
            
    conn.commit()
    
    # Check counts
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM products")
    prod_count = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM categories")
    cat_count = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM product_images")
    img_count = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM specifications")
    spec_count = cur.fetchone()[0]
    
    print(f"\nSuccessfully built {target}!")
    print(f"Products: {prod_count}")
    print(f"Categories: {cat_count}")
    print(f"Product Images: {img_count}")
    print(f"Product Specifications: {spec_count}")

if __name__ == '__main__':
    main()
