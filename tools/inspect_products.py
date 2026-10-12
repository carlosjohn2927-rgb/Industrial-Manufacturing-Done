import glob
import re
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_duplicate_products import iter_insert_blocks, extract_rows

def check_file(filename):
    if not os.path.exists(filename):
        print(f"File {filename} does not exist.")
        return []
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # Reuse the duplicate checker's parser: it understands every product-row
    # shape in this repo (VALUES tuples from 008/010, INSERT ... SELECT with
    # literal or UUID() ids from 015/008, UNION chains, multi-line rows).
    products = []
    for _line_no, block in iter_insert_blocks(content, 'products'):
        for name, slug, sku in extract_rows(block, 'products'):
            products.append({'name': name, 'slug': slug, 'sku': sku})
    print(f"File {filename}: Found {len(products)} products")
    return products

ajr_prods = check_file("database/ajr_ndt_products.sql")
mig10_prods = check_file("database/migrations/010_add_ajr_ndt_product_range.sql")
mig15_prods = check_file("database/migrations/015_add_refteck_product_range.sql")
prod_sql_prods = check_file("database/production.sql")
seed_sql_prods = check_file("install/seed.sql")

print("\n--- ALL 93 PRODUCTS IN CATALOG ---")
for i, p in enumerate(ajr_prods, 1):
    print(f"{i:2d}. [{p['sku']}] {p['name']} (slug: {p['slug']})")

if mig15_prods:
    print(f"\n--- REFTECK RANGE ({len(mig15_prods)} PRODUCTS IN MIGRATION 015) ---")
    for i, p in enumerate(mig15_prods, 1):
        print(f"{i:3d}. [{p['sku']}] {p['name']} (slug: {p['slug']})")
