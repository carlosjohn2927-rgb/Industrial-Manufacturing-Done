import glob
import re
import os

def check_file(filename):
    if not os.path.exists(filename):
        print(f"File {filename} does not exist.")
        return []
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract tuples starting with ('p0010001-...
    products = []
    lines = content.splitlines()
    for line in lines:
        line_clean = line.strip()
        if line_clean.startswith("('p0010001-") or line_clean.startswith("('prod-"):
            # Check if this line looks like a product insert
            # Format: ('id', 'name', 'slug', 'sku', ...)
            parts = [p.strip().strip("'") for p in line_clean.rstrip(',;').strip('()').split("', '")]
            if len(parts) >= 4:
                products.append({
                    'id': parts[0],
                    'name': parts[1],
                    'slug': parts[2],
                    'sku': parts[3]
                })
    print(f"File {filename}: Found {len(products)} products")
    return products

ajr_prods = check_file("database/ajr_ndt_products.sql")
mig10_prods = check_file("database/migrations/010_add_ajr_ndt_product_range.sql")
prod_sql_prods = check_file("database/production.sql")
seed_sql_prods = check_file("install/seed.sql")

print("\n--- ALL 93 PRODUCTS IN CATALOG ---")
for i, p in enumerate(ajr_prods, 1):
    print(f"{i:2d}. [{p['sku']}] {p['name']} (slug: {p['slug']})")
