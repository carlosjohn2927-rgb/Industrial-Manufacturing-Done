<?php
/**
 * Product-image resolution check (CLI, no database required).
 *
 *   php tests/product_images_check.php
 *
 * Why this exists
 * ---------------
 * Every card on the site (catalog grid, homepage "featured products",
 * search results + AJAX suggestions, industry pages, admin product list)
 * resolves its picture through ONE function: `vp_product_image()`. When
 * that function ignores a product's own photo, the whole catalog silently
 * collapses onto the two shared placeholder photos
 * (`/assets/img/products/instrumentation.jpg` and `default.jpg`) — which
 * is exactly the "all the product images look the same" bug.
 *
 * What it does
 * ------------
 *  - parses the shipped seed data (database/ajr_ndt_products.sql — 13
 *    categories, 93 products, 93 primary images, 1:1) with a small SQL
 *    row tokenizer,
 *  - enriches the rows with exactly the three fields
 *    Product_model::attach_images() adds at runtime (imageUrl, imageAlt,
 *    categorySlug),
 *  - then calls the REAL vp_product_image() / vp_product_image_tag() from
 *    application/helpers/app_helper.php and asserts:
 *      1. every product resolves to a non-empty image,
 *      2. every product resolves to a DIFFERENT image (93 rows -> 93 URLs),
 *      3. a product with its own photo never resolves to shared artwork,
 *      4. the fallback chain still works for products WITHOUT a photo,
 *      5. the rendered <img> carries a fallback that differs from the
 *         primary src, so one dead URL cannot blank a whole grid.
 *
 * Product_model::attach_images() is a CI model method that needs a live
 * MySQL connection, so its (unchanged) three-field enrichment is
 * reproduced here from the same seed rows. Everything that is *asserted*
 * is the shipped helper code, not a copy of it.
 *
 * Exit code 0 = every check passed.
 */

error_reporting(E_ALL);
ini_set('display_errors', '1');

$ROOT = dirname(__DIR__);

/* ------------------------------------------------------------------ */
/* Tiny test framework (same shape as tests/acceptance.php)            */
/* ------------------------------------------------------------------ */
$GLOBALS['VP_PASS'] = 0;
$GLOBALS['VP_FAIL'] = 0;
$GLOBALS['VP_FAILURES'] = [];

function section($name)
{
    echo "\n== " . $name . " ==\n";
}

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

/* ------------------------------------------------------------------ */
/* Seed .sql reader (shared with scripts/localize_ajr_product_images)  */
/* ------------------------------------------------------------------ */
require_once $ROOT . '/scripts/lib/seed_sql.php';

function vp_sql_insert_rows($sql, $table)
{
    return vp_seed_insert_rows($sql, $table);
}

/* ------------------------------------------------------------------ */
/* Boot just enough of the app to load the real helper                 */
/* ------------------------------------------------------------------ */
define('BASEPATH', $ROOT . '/system/');
if (!defined('ASSETS_URL')) define('ASSETS_URL', '/assets/');
if (!defined('IMG_URL'))    define('IMG_URL', ASSETS_URL . 'img/');
define('FCPATH', $ROOT . DIRECTORY_SEPARATOR);

require $ROOT . '/application/helpers/app_helper.php';

section('Helper under test');
check('vp_product_image() is loaded', function_exists('vp_product_image'));
check('vp_product_image_tag() is loaded', function_exists('vp_product_image_tag'));

/* ------------------------------------------------------------------ */
/* Seed data                                                           */
/* ------------------------------------------------------------------ */
section('Seed data (database/ajr_ndt_products.sql)');

$seedFile = $ROOT . '/database/ajr_ndt_products.sql';
check('seed file exists', is_file($seedFile), $seedFile);
$seed = (string) @file_get_contents($seedFile);

$categories = vp_sql_insert_rows($seed, 'categories');
$products   = vp_sql_insert_rows($seed, 'products');
$imgRows    = vp_sql_insert_rows($seed, 'product_images');

check('13 AJR NDT categories parsed', count($categories) === 13, 'got ' . count($categories));
check('93 AJR NDT products parsed', count($products) === 93, 'got ' . count($products));
check('93 primary product images parsed', count($imgRows) === 93, 'got ' . count($imgRows));

$catSlug = [];
foreach ($categories as $c) $catSlug[$c['id']] = $c['slug'];

// Same ordering attach_images() uses: isPrimary DESC, sortOrder ASC.
usort($imgRows, function ($a, $b) {
    $p = ((int) $b['isPrimary']) <=> ((int) $a['isPrimary']);
    return $p !== 0 ? $p : ((int) $a['sortOrder']) <=> ((int) $b['sortOrder']);
});
$primaryImage = [];
foreach ($imgRows as $img) {
    if (empty($img['url'])) continue;
    if (!isset($primaryImage[$img['productId']])) $primaryImage[$img['productId']] = $img;
}

$seedUrlCount = count(array_unique(array_column($imgRows, 'url')));
check('every seeded product has its own image URL', count($primaryImage) === 93, count($primaryImage) . '/93');
check('the 93 seeded image URLs are all different', $seedUrlCount === 93, $seedUrlCount . ' unique');

/* ------------------------------------------------------------------ */
/* Resolve every product the way the site does                         */
/* ------------------------------------------------------------------ */
section('vp_product_image() over all 93 catalog rows');

$rows = [];
foreach ($products as $p) {
    $img = $primaryImage[$p['id']] ?? null;
    // The three fields Product_model::attach_images() adds at runtime.
    $p['imageUrl']    = $img['url'] ?? null;
    $p['imageAlt']    = (!empty($img['alt'])) ? $img['alt'] : ($p['name'] ?? '');
    $p['categorySlug'] = $catSlug[$p['categoryId']] ?? null;
    $rows[] = $p;
}

$resolved = [];
$sharedArtwork = [
    IMG_URL . 'products/default.jpg',
    IMG_URL . 'products/valves.jpg',
    IMG_URL . 'products/pumps.jpg',
    IMG_URL . 'products/heat-exchangers.jpg',
    IMG_URL . 'products/pressure-vessels.jpg',
    IMG_URL . 'products/filtration.jpg',
    IMG_URL . 'products/instrumentation.jpg',
];

$empty = [];
$shared = [];
$notOwn = [];
foreach ($rows as $r) {
    $src = vp_product_image($r);
    $resolved[$r['slug']] = $src;
    if (empty($src)) $empty[] = $r['slug'];
    if (in_array($src, $sharedArtwork, true)) $shared[] = $r['slug'] . ' => ' . $src;
    if ($src !== $r['imageUrl']) $notOwn[] = $r['slug'] . ' => ' . $src;
}

$unique = count(array_unique($resolved));

check('every product resolves to a non-empty image', $empty === [],
    $empty === [] ? '93/93' : count($empty) . ' empty: ' . implode(', ', array_slice($empty, 0, 5)));
check('no product falls back to shared placeholder artwork', $shared === [],
    $shared === [] ? '0 shared' : count($shared) . ' shared, e.g. ' . implode('; ', array_slice($shared, 0, 3)));
check("each product keeps its own photo (imageUrl wins)", $notOwn === [],
    $notOwn === [] ? '93/93' : count($notOwn) . ' overridden, e.g. ' . implode('; ', array_slice($notOwn, 0, 3)));
check('93 products resolve to 93 different images', $unique === count($rows),
    $unique . ' unique for ' . count($rows) . ' products');

$tally = array_count_values($resolved);
arsort($tally);
$most = array_slice($tally, 0, 3, true);
$summary = [];
foreach ($most as $url => $count) $summary[] = $count . 'x ' . $url;
check('no single image is reused across the catalog', max($tally) === 1,
    'most used: ' . implode(' | ', $summary));

echo "\n  sample of resolved images:\n";
foreach (array_slice($resolved, 0, 3, true) as $slug => $url) {
    echo "    - $slug => $url\n";
}

/* ------------------------------------------------------------------ */
/* Rendered <img> tag                                                  */
/* ------------------------------------------------------------------ */
section('vp_product_image_tag() rendering');

$tag = vp_product_image_tag($rows[0]);
$ownUrl = $rows[0]['imageUrl'];
check('tag uses the product photo as src', strpos($tag, 'src="' . $ownUrl . '"') !== false, $ownUrl);
check('tag keeps a working alt', strpos($tag, 'alt="' . $rows[0]['imageAlt'] . '"') !== false);
preg_match('/onerror="[^"]*this\.src=\'([^\']+)\'/', $tag, $om);
$onerror = $om[1] ?? '';
check('tag has an onerror fallback', $onerror !== '', $onerror !== '' ? $onerror : 'none');
check('onerror fallback is not the same URL as src', $onerror !== '' && $onerror !== $ownUrl,
    $onerror !== '' ? 'fallback = ' . $onerror : 'no fallback');
check('onerror fallback is a local file', strpos($onerror, IMG_URL . 'products/') === 0, $onerror);

/* ------------------------------------------------------------------ */
/* Fallback chain for products with no photo of their own              */
/* ------------------------------------------------------------------ */
section('Fallback chain (products without their own photo)');

$noImage = vp_product_image(['name' => 'Mystery Widget', 'sku' => 'XX-1', 'slug' => 'mystery-widget']);
check('product with no image still resolves', $noImage !== '', $noImage);
check('product with no image lands on the default photo',
    $noImage === IMG_URL . 'products/default.jpg', $noImage);

$byKeyword = vp_product_image(['name' => 'Centrifugal Pump CP-9', 'sku' => 'XX-2', 'slug' => 'cp-9']);
check('keyword fallback picks relevant artwork', $byKeyword === IMG_URL . 'products/pumps.jpg', $byKeyword);

$ajrCat = vp_product_image([
    'name' => 'AJH300 Portable Hardness Tester', 'sku' => 'AJR-AJH-300',
    'slug' => 'ajh300-portable-hardness-tester',
], 'hardness-testing');
check('AJR category fallback picks relevant artwork', $ajrCat !== IMG_URL . 'products/default.jpg', $ajrCat);

// A product whose src IS already the local artwork must not be given an
// onerror that swaps it for the identical file.
$plainTag = vp_product_image_tag(['name' => 'Mystery Widget', 'sku' => 'XX-1', 'slug' => 'mystery-widget'], 'w-full h-full object-cover');
preg_match('/onerror="[^"]*this\.src=\'([^\']+)\'/', $plainTag, $pm);
check('no self-referential onerror swap', ($pm[1] ?? '') !== IMG_URL . 'products/default.jpg',
    ($pm[1] ?? '') !== '' ? $pm[1] : 'no onerror emitted');

$ajrTag = vp_product_image_tag(['name' => 'AJH300 Portable Hardness Tester', 'sku' => 'AJR-AJH-300'], 'w-full h-full object-cover', 'hardness-testing');
preg_match('/\ssrc="([^"]+)"/', $ajrTag, $am);
check('AJR product without a photo gets category artwork', ($am[1] ?? '') === IMG_URL . 'products/instrumentation.jpg', $am[1] ?? 'no src');

/* ------------------------------------------------------------------ */
/* Non-AJR (Vortex) catalog must keep working too                      */
/* ------------------------------------------------------------------ */
section('Process-equipment catalog (local artwork)');

$vpRows = [
    ['slug' => 'vortexpro-globe-valve-vp-gv-300', 'sku' => 'VP-VLV-GV300',
     'name' => 'VortexPro Globe Valve VP-GV-300', 'imageUrl' => '/assets/img/products/vortexpro-globe-valve-vp-gv-300.jpg'],
    ['slug' => 'vortexpro-shell-tube-exchanger-vp-st-500', 'sku' => 'VP-HX-ST500',
     'name' => 'VortexPro Shell & Tube Exchanger VP-ST-500', 'imageUrl' => null],
    ['slug' => 'vortexpro-ball-valve-vp150', 'sku' => 'VP-VLV-BV150',
     'name' => 'VortexPro Ball Valve VP150', 'imageUrl' => null],
];
$vpResolved = [];
foreach ($vpRows as $r) $vpResolved[$r['slug']] = vp_product_image($r);

check('uploaded local photo is used verbatim',
    $vpResolved['vortexpro-globe-valve-vp-gv-300'] === $vpRows[0]['imageUrl'],
    $vpResolved['vortexpro-globe-valve-vp-gv-300']);
check('curated artwork still used for a product with no photo',
    $vpResolved['vortexpro-shell-tube-exchanger-vp-st-500'] === IMG_URL . 'products/vortexpro-shell-tube-exchanger-vp-st-500.jpg',
    $vpResolved['vortexpro-shell-tube-exchanger-vp-st-500']);
check('process-equipment products also resolve to distinct images',
    count(array_unique($vpResolved)) === count($vpRows), count(array_unique($vpResolved)) . ' unique');

// Every artwork file the fallback chain can name must really be on disk,
// otherwise a typo silently degrades every card to default.jpg.
$missing = [];
foreach ($vpResolved as $url) {
    if (strpos($url, IMG_URL) !== 0) continue;
    if (!is_file(FCPATH . 'assets/' . ltrim(substr($url, strlen(ASSETS_URL)), '/'))) $missing[] = $url;
}
$missingDefault = is_file(FCPATH . 'assets/img/products/default.jpg') ? [] : ['default.jpg'];
check('every referenced local artwork file exists', $missing === [] && $missingDefault === [],
    $missing === [] && $missingDefault === [] ? 'all present' : implode(', ', array_merge($missing, $missingDefault)));

/* ------------------------------------------------------------------ */
/* Result                                                              */
/* ------------------------------------------------------------------ */
echo "\n" . str_repeat('-', 62) . "\n";
echo 'Product image checks: ' . $GLOBALS['VP_PASS'] . ' passed, ' . $GLOBALS['VP_FAIL'] . " failed\n";
if ($GLOBALS['VP_FAIL'] > 0) {
    echo "\nFailures:\n";
    foreach ($GLOBALS['VP_FAILURES'] as $f) echo "  - $f\n";
    exit(1);
}
echo "Every catalog product resolves to its own distinct image.\n";
exit(0);
