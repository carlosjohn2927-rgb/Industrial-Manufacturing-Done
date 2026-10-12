<?php
/**
 * Migration chain execution + idempotency check (SQLite).
 *
 *   php tests/migration_sqlite_check.php
 *
 * Runs the REAL development installer (install/dev-sqlite.php) against a
 * temporary SQLite database — the same MySQL schema, migrations 001–015 and
 * seed data the production runner applies — then:
 *
 *   1. asserts the seeded catalog is complete and duplicate-free, including
 *      the full 107-product Refteck range of migration 015;
 *   2. RE-APPLIES every statement of migration 015 on top of the finished
 *      database and asserts nothing changes (the NOT EXISTS guards make the
 *      migration repeatable without duplicates).
 *
 * Needs the pdo_sqlite extension. No MySQL server, no network, no .env.
 *
 * Exit code 0 = every check passed.
 */

if (PHP_SAPI !== 'cli' && PHP_SAPI !== 'wasm') {
    http_response_code(403);
    exit("This test can only be run from the command line.\n");
}
if (!extension_loaded('pdo_sqlite')) {
    fwrite(STDERR, "The pdo_sqlite PHP extension is required for this test.\n");
    exit(2);
}

error_reporting(E_ALL);
ini_set('display_errors', '1');

$ROOT = dirname(__DIR__);

/* Tiny test framework (same shape as tests/acceptance.php) */
$GLOBALS['VP_PASS'] = 0;
$GLOBALS['VP_FAIL'] = 0;
$GLOBALS['VP_FAILURES'] = [];

function section($name) { echo "\n== " . $name . " ==\n"; }

function check($name, $cond, $detail = '')
{
    if ($cond) {
        $GLOBALS['VP_PASS']++;
        echo "  [PASS] $name" . ($detail !== '' ? " - $detail" : '') . "\n";
    } else {
        $GLOBALS['VP_FAIL']++;
        $GLOBALS['VP_FAILURES'][] = $name . ($detail !== '' ? " - $detail" : '');
        echo "  [FAIL] $name" . ($detail !== '' ? " - $detail" : '') . "\n";
    }
}

function vp_count(PDO $pdo, $sql)
{
    return (int) $pdo->query($sql)->fetchColumn();
}

/* ------------------------------------------------------------------ */
/* 1. Build the database with the real installer                       */
/* ------------------------------------------------------------------ */
section('Build (install/dev-sqlite.php: install.sql + migrations + seed)');

$dbFile = sys_get_temp_dir() . '/vp-migration-check-' . getmypid() . '.sqlite';
@unlink($dbFile);

$argv = ['dev-sqlite.php', $dbFile];
$_SERVER['argv'] = $argv;
ob_start();
require $ROOT . '/install/dev-sqlite.php';
$installerLog = ob_get_clean();

check('installer wrote the database', is_file($dbFile), $dbFile);
check('installer applied migration 015', strpos($installerLog, 'Applying 015_add_refteck_product_range.sql') !== false);

// Statements the SQLite translator cannot run: migration 012's legacy-dedupe
// passes use MySQL multi-table UPDATE/DELETE ... JOIN syntax (and its temp
// tables). On a freshly built database there are no duplicates to remove
// (asserted below), so these are no-ops in this environment; on MySQL
// (production) they run as written. Every skipped statement must belong to
// that dedupe machinery (tmp_keep / tmp_dup_map / related_products moves).
$badFailures = [];
foreach (explode("\n", $installerLog) as $line) {
    if (strpos($line, '  ! ') === 0
        && !preg_match('/tmp_keep|tmp_dup_map|related_products/', $line)) {
        $badFailures[] = $line;
    }
}
check('only migration 012\'s MySQL-only dedupe statements are skipped by the SQLite translator',
    $badFailures === [], count($badFailures) . ' unexpected'
    . (isset($badFailures[0]) ? ' - ' . $badFailures[0] : ''));

$pdo = new PDO('sqlite:' . $dbFile);
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

/* ------------------------------------------------------------------ */
/* 2. Catalog completeness                                             */
/* ------------------------------------------------------------------ */
section('Seeded catalog');

check('29 categories', vp_count($pdo, 'SELECT COUNT(*) FROM categories') === 29,
    vp_count($pdo, 'SELECT COUNT(*) FROM categories') . ' rows');
check('222 products', vp_count($pdo, 'SELECT COUNT(*) FROM products') === 222,
    vp_count($pdo, 'SELECT COUNT(*) FROM products') . ' rows');
check('107 Refteck products (RF- SKUs)', vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%'") === 107,
    vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%'") . ' rows');
check('0 products with empty slug or SKU',
    vp_count($pdo, "SELECT COUNT(*) FROM products WHERE TRIM(IFNULL(slug,'')) = '' OR TRIM(IFNULL(sku,'')) = ''") === 0);
check('0 duplicate product slugs',
    vp_count($pdo, 'SELECT COUNT(*) FROM (SELECT LOWER(TRIM(slug)) s FROM products GROUP BY s HAVING COUNT(*) > 1)') === 0);
check('0 duplicate product SKUs',
    vp_count($pdo, 'SELECT COUNT(*) FROM (SELECT LOWER(TRIM(sku)) s FROM products GROUP BY s HAVING COUNT(*) > 1)') === 0);

/* Refteck range, per category, exactly as published on refteck.com */
$ranges = [
    'RF-VLV' => 16, 'RF-DRL' => 9,  'RF-MRT' => 4,  'RF-RTY' => 8,
    'RF-PMP' => 10, 'RF-PRC' => 9,  'RF-INS' => 3,  'RF-ELX' => 16,
    'RF-MRO' => 7,  'RF-OLC' => 4,  'RF-HVC' => 6,  'RF-HPM' => 9,
    'RF-SFT' => 6,
];
foreach ($ranges as $prefix => $want) {
    $got = vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE '" . $prefix . "-%'");
    check("SKU range {$prefix}- has {$want} products", $got === $want, "{$got} rows");
}
check('every RF product is active',
    vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%' AND isActive <> 1") === 0);
check('every RF product has a description',
    vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%' AND TRIM(IFNULL(description,'')) = ''") === 0);
check('every RF product has a short description',
    vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%' AND TRIM(IFNULL(shortDescription,'')) = ''") === 0);
check('every RF product is in a category',
    vp_count($pdo, "SELECT COUNT(*) FROM products p WHERE p.sku LIKE 'RF-%'
        AND NOT EXISTS (SELECT 1 FROM categories c WHERE c.id = p.categoryId)") === 0);

section('Refteck images');

check('107 RF product images', vp_count($pdo,
    "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId
      WHERE p.sku LIKE 'RF-%'") === 107,
    vp_count($pdo, "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId WHERE p.sku LIKE 'RF-%'") . ' rows');
check('every RF product has exactly one primary image', vp_count($pdo,
    "SELECT COUNT(*) FROM (SELECT p.id FROM products p
        JOIN product_images pi ON pi.productId = p.id AND pi.isPrimary = 1
       WHERE p.sku LIKE 'RF-%' GROUP BY p.id HAVING COUNT(*) <> 1)") === 0);
check('every RF image URL points at refteck.com (until localized)',
    vp_count($pdo,
    "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId
      WHERE p.sku LIKE 'RF-%' AND pi.url NOT LIKE 'https://www.refteck.com/wp-content/uploads/%'") === 0);
check('all 107 RF image URLs are distinct', vp_count($pdo,
    "SELECT COUNT(*) FROM (SELECT pi.url FROM product_images pi JOIN products p ON p.id = pi.productId
       WHERE p.sku LIKE 'RF-%' GROUP BY pi.url HAVING COUNT(*) > 1)") === 0);
check('10 VortexPro artwork image rows (008 multi-row insert)', vp_count($pdo,
    "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId
      WHERE p.sku LIKE 'VP-%' AND pi.url LIKE '/assets/img/products/%'") === 10,
    vp_count($pdo, "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId WHERE p.sku LIKE 'VP-%'") . ' rows');
check('210 product images in total (10 VP + 93 AJR + 107 RF)',
    vp_count($pdo, 'SELECT COUNT(*) FROM product_images') === 210,
    vp_count($pdo, 'SELECT COUNT(*) FROM product_images') . ' rows');

section('Categories and homepage');

foreach (['drilling-equipment', 'maintenance-repair-tools', 'rotary-equipment', 'process-equipment',
          'electrical-power-transmission', 'maintenance-repair-operation-tools',
          'industrial-oil-chemicals-lubrications', 'hvac-refrigeration',
          'heavy-plant-machinery-vehicles', 'safety-products'] as $slug) {
    check("category '{$slug}' exists with artwork URL",
        vp_count($pdo, "SELECT COUNT(*) FROM categories WHERE slug = '" . $slug . "' AND image <> ''") === 1);
}
check('base categories keep the curated local artwork (014 not overwritten)',
    vp_count($pdo, "SELECT COUNT(*) FROM categories WHERE slug IN ('valves','pumps','instrumentation')
        AND image LIKE '/assets/img/%'") === 3);
check('homepage category grid limit raised to 32 on every home row (015)',
    vp_count($pdo, "SELECT COUNT(*) FROM page_sections WHERE pageKey = 'home' AND type = 'categories'
        AND IFNULL(json_extract(settings, '$.limit'), 0) = 32")
    === vp_count($pdo, "SELECT COUNT(*) FROM page_sections WHERE pageKey = 'home' AND type = 'categories'")
    && vp_count($pdo, "SELECT COUNT(*) FROM page_sections WHERE pageKey = 'home' AND type = 'categories'") > 0);
check('unique SKU index exists (012)',
    vp_count($pdo, "SELECT COUNT(*) FROM sqlite_master WHERE type = 'index'
        AND tbl_name = 'products' AND sql LIKE '%UNIQUE%' AND (sql LIKE '%sku%' OR sql LIKE '%slug%')") >= 1);

/* ------------------------------------------------------------------ */
/* 3. Idempotency: re-apply migration 015 on the finished database     */
/* ------------------------------------------------------------------ */
section('Idempotency (migration 015 applied twice)');

$before = [
    'products'      => vp_count($pdo, 'SELECT COUNT(*) FROM products'),
    'categories'    => vp_count($pdo, 'SELECT COUNT(*) FROM categories'),
    'product_images'=> vp_count($pdo, 'SELECT COUNT(*) FROM product_images'),
    'rf_products'   => vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%'"),
    'rf_images'     => vp_count($pdo, "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId
                                          WHERE p.sku LIKE 'RF-%'"),
];

$sql015  = file_get_contents($ROOT . '/database/migrations/015_add_refteck_product_range.sql');
$stmts   = sql_statements($sql015);          // from the installer, via require above
$applied = 0;
$errors  = [];
foreach ($stmts as $stmt) {
    if (preg_match('/^(SET|LOCK|UNLOCK|\/\*|DELIMITER)/i', $stmt)) continue;
    if (preg_match('/^CREATE TABLE/i', $stmt) || preg_match('/^(CREATE (UNIQUE )?INDEX)/i', $stmt)) {
        // none in 015, but keep the parity with the installer's pipeline
    }
    $stmt = translate_functions($stmt);
    $stmt = preg_replace('/^INSERT IGNORE/i', 'INSERT OR IGNORE', $stmt);
    if (preg_match('/\bON DUPLICATE KEY UPDATE\b/i', $stmt)) {
        $stmt = preg_replace('/\s*ON DUPLICATE KEY UPDATE.*$/is', '', $stmt);
        $stmt = preg_replace('/^INSERT(\s+OR\s+\w+)?\s+INTO/i', 'INSERT OR REPLACE INTO', $stmt);
    }
    $stmt = str_replace('\\"', '"', $stmt);
    $stmt = str_replace("\\'", "''", $stmt);
    try {
        $pdo->exec($stmt);
        $applied++;
    } catch (PDOException $e) {
        $errors[] = substr(preg_replace('/\s+/', ' ', $stmt), 0, 100) . ' :: ' . $e->getMessage();
    }
}

check('all migration 015 statements re-applied without error', $errors === [],
    count($errors) . ' errors' . (isset($errors[0]) ? ' - ' . $errors[0] : ''));
check('statement count is 225', count($stmts) === 225, count($stmts) . ' statements');

$after = [
    'products'      => vp_count($pdo, 'SELECT COUNT(*) FROM products'),
    'categories'    => vp_count($pdo, 'SELECT COUNT(*) FROM categories'),
    'product_images'=> vp_count($pdo, 'SELECT COUNT(*) FROM product_images'),
    'rf_products'   => vp_count($pdo, "SELECT COUNT(*) FROM products WHERE sku LIKE 'RF-%'"),
    'rf_images'     => vp_count($pdo, "SELECT COUNT(*) FROM product_images pi JOIN products p ON p.id = pi.productId
                                         WHERE p.sku LIKE 'RF-%'"),
];
foreach ($before as $what => $n) {
    check("second run did not change {$what}", $after[$what] === $n, "{$n} -> {$after[$what]}");
}
check('still 0 duplicate slugs after the second run',
    vp_count($pdo, 'SELECT COUNT(*) FROM (SELECT LOWER(TRIM(slug)) s FROM products GROUP BY s HAVING COUNT(*) > 1)') === 0);
check('still 0 duplicate SKUs after the second run',
    vp_count($pdo, 'SELECT COUNT(*) FROM (SELECT LOWER(TRIM(sku)) s FROM products GROUP BY s HAVING COUNT(*) > 1)') === 0);

/* ------------------------------------------------------------------ */
/* Done                                                                */
/* ------------------------------------------------------------------ */
@unlink($dbFile);

echo "\nMigration SQLite checks: " . $GLOBALS['VP_PASS'] . " passed, " . $GLOBALS['VP_FAIL'] . " failed\n";
if ($GLOBALS['VP_FAIL'] > 0) {
    echo "Failures:\n";
    foreach ($GLOBALS['VP_FAILURES'] as $f) echo "  - $f\n";
    exit(1);
}
exit(0);
