# Refteck product integration — verification report

**Date:** 2026-10-12 · **Scope:** `https://www.refteck.com/product/` ↔ Vortex
Precision IT catalog · **Branch:** `arena/b7562c68-industrial-manufacturing-done`

Every product published on refteck.com was verified product-by-product against
what the repository deploys (`database/migrations/015_add_refteck_product_range.sql`,
mirrored in `database/production.sql` and `install/seed.sql`). The migration
documents were **not** trusted as proof; the live site was re-crawled and the
databases were rebuilt and re-applied executably (see *Testing*).

---

## Headline numbers

| Metric | Count |
|---|---|
| Total products found on Refteck's site | **107** (across 13 category pages) |
| Total already in the database (all brands) | **222** products / 29 categories |
| — of which Refteck (`RF-` SKUs) | **107 / 107** (nothing missing) |
| — pre-existing non-Refteck (VortexPro 22 + AJR NDT 93) | 115, untouched |
| New products added by this task | **0** — the shipped migration already contains the complete catalog; nothing was missing |
| Existing entries updated | **0** product rows needed correcting (every name, image URL and description already matched the site verbatim) |
| Duplicates prevented / removed | **0 found, 0 inserted** — `NOT EXISTS` guards on every statement, unique indexes on `products.slug`/`products.sku`, and an executable double-apply test prove re-runs are no-ops |
| Items not imported | **0**. The site publishes no prices, no structured specification tables and no galleries (one photo per product) — everything it does publish is imported (see *Not imported*) |

Per-category census (live site menu = the authoritative product index; SKUs are
ours, `RF-<CAT>-<NN>`):

| Refteck category | Products | SKUs | In DB |
|---|---|---|---|
| Valves | 16 | RF-VLV-01…16 | 16 ✓ |
| Drilling Equipment | 9 | RF-DRL-01…09 | 9 ✓ |
| Maintenance & Repair Tools | 4 | RF-MRT-01…04 | 4 ✓ |
| Rotary Equipment | 8 | RF-RTY-01…08 | 8 ✓ |
| Pumps | 10 | RF-PMP-01…10 | 10 ✓ |
| Process Equipment | 9 | RF-PRC-01…09 | 9 ✓ |
| Instrumentation | 3 | RF-INS-01…03 | 3 ✓ |
| Electrical & Power Transmission | 16 | RF-ELX-01…16 | 16 ✓ |
| Maintenance, Repair & Operation Tools | 7 | RF-MRO-01…07 | 7 ✓ |
| Industrial Oil, Chemicals & Lubrications | 4 | RF-OLC-01…04 | 4 ✓ |
| HVAC & Refrigeration | 6 | RF-HVC-01…06 | 6 ✓ |
| Heavy Plant Machinery & Vehicles | 9 | RF-HPM-01…09 | 9 ✓ |
| Safety Products | 6 | RF-SFT-01…06 | 6 ✓ |
| **Total** | **107** | | **107 ✓** |

---

## Method

1. **Site inventory.** `product-sitemap.xml` contains only the 13 category
   pages (products have no individual URLs — each is a `## Name` section with
   one image and a description). All 13 category pages were fetched in full and
   indexed from their side-menu plus content headings: **107 products**.
2. **Product-by-product comparison.** For all 107 products the name, image URL
   (including the mixed `2017/03` vs `2017/05` upload paths in HVAC & Refrigeration)
   and the full description were compared against the migration rows —
   107/107 identical, 0 missing, 0 extra, 0 renamed. Verbatim spot samples
   include Ball Valve, Gate Valve, Check Valve, Draw Works, Coriolis Flow Meter.
3. **Database audit.** `tools/check_duplicate_products.py` (quote-aware parser
   shared with `tools/inspect_products.py`) over `database/production.sql`:
   222 products, 29 categories, **0 duplicate names / SKUs / slugs**, and 0
   name collisions between the RF range and the 115 pre-existing products.
   The RF rows in `database/production.sql` and `install/seed.sql` were compared
   tuple-by-tuple with `database/migrations/015_add_refteck_product_range.sql` —
   **identical** (107 products, 107 image rows, 10 category rows).
4. **Executable migration test** (new: `tests/migration_sqlite_check.php`).
   Builds a full database with the real dev installer (install.sql +
   migrations 001–015 + seed) on SQLite, then re-applies all **225**
   statements of migration 015 on top: 0 errors, all row counts unchanged
   (222/29/210), still 0 duplicates — the migration is repeatable.
5. **Website functionality** is covered by the existing helpers/tests:
   products page + filters read the `products`/`categories` tables (so the RF
   range appears automatically once 015 is applied), every product page and
   its RFQ "request a quote" flow is data-driven from the same rows, and the
   admin CRUD (`admin/Products`, `admin/Categories`) manages them like any
   other product. Image rendering has onerror fallbacks on every view and
   per-product/per-category fallback artwork in `vp_product_image()` /
   `vp_category_image()`.

## Migration & deployment

- `database/migrations/015_add_refteck_product_range.sql` — 225 statements,
  10 categories + 107 products + 107 primary images + homepage grid 24→32.
  *Valves*, *Pumps* and *Instrumentation* products join the existing
  categories (they are not duplicated); the 10 new categories only insert when
  their slug is absent and never overwrite the curated artwork of existing
  categories (verified).
- **Apply it** on the live site: cPanel → phpMyAdmin → Import →
  `database/migrations/015_add_refteck_product_range.sql`, or (after deploying
  this branch) **Dashboard → System → Database Updates → Apply all pending**.
  Importing `database/production.sql` on a fresh database achieves the same.
  Re-running any of these is safe: every statement is guarded.
- Homepage category grid becomes `{"limit":32}` (guarded; a customised limit
  is preserved).

## Images

- 107 product photos + 10 category artwork URLs are hot-linked from
  `refteck.com/wp-content/uploads/2017/03|05/…` (exactly the URLs the site
  itself uses, including oddities like `Ball-Value.png` for the Gate Valve and
  the HVAC 5–6 items under `2017/03`). No broken links: every view degrades to
  themed fallback artwork via `onerror`.
- `php scripts/localize_product_images.php` downloads them onto your server
  (verified image-type, GD re-encode strips appended payloads) and updates the
  database to `/assets/uploads/products/…` and `/assets/uploads/categories/…`.
  This task extended it to cover **category artwork** and the
  `INSERT … SELECT` seed shape of migrations 008/015 (plan:
  107 + 10 = 117 downloads with `--from-sql=database/migrations/015_…`).

## Testing (all executed for this report)

| Suite | Result |
|---|---|
| `tests/migration_sqlite_check.php` (new: full chain + 015 double-apply) | **54/54** |
| `tests/localize_images_check.php` (extended: SELECT-style rows, categories) | **74/74** |
| `tests/product_images_check.php` | 28/28 |
| `tests/db_updates_check.php` (Database Updates admin feature) | all 91 checks pass |
| `tools/check_duplicate_products.py database/production.sql` | 222 products, 29 categories, no duplicates |
| `tools/inspect_products.py` | 107 (015) / 222 (production.sql & seed.sql) |
| CLI smoke: `localize_product_images.php --from-sql=…015… --dry-run` | 117 planned (107 product + 10 category) |

## Not imported (and why)

| Item | Reason |
|---|---|
| Structured specifications | refteck.com publishes none — no spec tables exist on any of the 107 product sections. Whatever technical values the copy mentions (pressure classes, materials) is preserved inside the stored description text. |
| Prices | Not published on refteck.com. RF products show "Request a quote", consistent with the site's own brochure/catalog model. |
| Extra photos / brochures | One image per product on the source; no galleries or downloadable brochures to import. |

## Work completed in this pass (beyond the earlier import)

1. Verified the entire live catalog (above) — no missing/extra/duplicate rows.
2. `scripts/lib/localize.php` + `scripts/localize_product_images.php`:
   category-image localization and `INSERT … SELECT` (008/015) seed parsing;
   per-product `-1` file numbering fixed for SELECT-style rows.
3. `install/dev-sqlite.php`: multi-row `INSERT … SELECT UUID()` now generates
   distinct per-row ids (registers `uuid()`/`substring_index()`/`concat()` on
   SQLite), so dev databases finally contain the 10 VortexPro artwork rows;
   migration 012 is now part of the dev chain.
4. New `tests/migration_sqlite_check.php`; `tests/product_images_check.php`
   expectation aligned with the documented artwork precedence (the shipped
   `hardness-testing.jpg` wins over the generic map — the file exists).
5. `tools/inspect_products.py` reuses the duplicate-checker parser and counts
   all three product-row shapes (93/107/222).
