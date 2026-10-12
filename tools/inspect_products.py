import glob
import re
import os

def check_file(filename):
    if not os.path.exists(filename):
        print(f"File {filename} does not exist.")
        return []
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract product rows. Two shapes exist in this repo:
    #   ('p0010001-...', 'Name', 'slug', 'SKU', ...)          (migration 010)
    #   SELECT 'rp000001-...','Name','slug','SKU', ...        (migration 015)
    products = []
    lines = content.splitlines()
    for line in lines:
        line_clean = line.strip()
        if (
            line_clean.startswith("('p0010001-")
            or line_clean.startswith("('prod-")
            or line_clean.startswith("SELECT 'rp")
        ):
            fields = re.findall(r"'((?:[^'\\]|\\.)*)'", line_clean)
            if len(fields) >= 4:
                products.append({
                    'id': fields[0],
                    'name': fields[1],
                    'slug': fields[2],
                    'sku': fields[3]
                })
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
