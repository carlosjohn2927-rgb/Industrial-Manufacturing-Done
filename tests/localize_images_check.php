<?php
/**
 * Product-image localizer check (CLI, no database and no network required).
 *
 *   php tests/localize_images_check.php
 *
 * Exercises the real logic in scripts/lib/localize.php - the code
 * scripts/localize_product_images.php runs on the server - including the parts
 * that touch the filesystem: a real JPEG is generated with GD, a PHP payload is
 * appended to a second copy, and both are pushed through vp_loc_store_image()
 * to prove the verification/re-encode path actually strips it.
 *
 * Exit code 0 = every check passed.
 */

error_reporting(E_ALL);
ini_set('display_errors', '1');

$ROOT = dirname(__DIR__);
require_once $ROOT . '/scripts/lib/localize.php';

/* ------------------------------------------------------------------ */
/* Tiny test framework (same shape as tests/acceptance.php)            */
/* ------------------------------------------------------------------ */
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

$TMP = sys_get_temp_dir() . '/vp-loc-check-' . getmypid();
@mkdir($TMP, 0700, true);
register_shutdown_function(function () use ($TMP) {
    foreach ((array) @glob($TMP . '/*') as $f) @unlink($f);
    @rmdir($TMP);
});

$baseOpts = vp_loc_args(['localize_product_images.php']);   // defaults
check('defaults parsed', $baseOpts['dry_run'] === false && $baseOpts['reencode'] === true
    && $baseOpts['timeout'] === 30 && $baseOpts['max_mb'] === 10);

$dryOpts = vp_loc_args(['x', '--dry-run']);
check('--dry-run parsed', $dryOpts['dry_run'] === true);

$sqlOpts = vp_loc_args(['x', '--from-sql=database/ajr_ndt_products.sql']);
check('--from-sql implies a dry run (no DB writes)', $sqlOpts['dry_run'] === true && $sqlOpts['from_sql'] !== null);

$mixOpts = vp_loc_args(['x', '--limit=2', '--sku-prefix=AJR-', '--force', '--no-reencode', '--max-mb=4']);
check('filters parsed', $mixOpts['limit'] === 2 && $mixOpts['sku_prefix'] === 'AJR-'
    && $mixOpts['force'] === true && $mixOpts['reencode'] === false && $mixOpts['max_mb'] === 4);

/* ------------------------------------------------------------------ */
/* Planning                                                            */
/* ------------------------------------------------------------------ */
section('Planning (vp_loc_plan)');

$rows = [
    ['id' => 'i1', 'productId' => 'p1', 'sku' => 'AJR-AFD-100', 'slug' => 'afd100-ut-flaw-detector',
     'name' => 'AFD100 UT Flaw Detector', 'url' => 'https://cdn.example.com/a.jpg'],
    ['id' => 'i2', 'productId' => 'p1', 'sku' => 'AJR-AFD-100', 'slug' => 'afd100-ut-flaw-detector',
     'name' => 'AFD100 UT Flaw Detector', 'url' => 'https://cdn.example.com/b.jpg'],
    ['id' => 'i3', 'productId' => 'p2', 'sku' => 'VP-VLV-BV150', 'slug' => 'vortexpro-ball-valve-vp150',
     'name' => 'VortexPro Ball Valve', 'url' => '/assets/img/products/vortexpro-ball-valve-vp150.jpg'],
    ['id' => 'i4', 'productId' => 'p3', 'sku' => 'AJR-ATG-140', 'slug' => 'atg140',
     'name' => 'ATG140', 'url' => ''],
    ['id' => 'i5', 'productId' => 'p4', 'sku' => 'AJR-AJE-220B', 'slug' => 'aje220b',
     'name' => 'AJE220B', 'url' => 'HTTPS://cdn.example.com/c.jpg'],
    ['id' => 'i6', 'productId' => 'p5', 'sku' => 'VP-HX-ST500', 'slug' => 'vortexpro-shell-tube-exchanger',
     'name' => 'VortexPro Shell & Tube Exchanger', 'url' => 'https://cdn.example.com/d.jpg'],
];

$plan = vp_loc_plan($rows, $baseOpts);
$byId = [];
foreach ($plan as $a) $byId[$a['id']] = $a;

check('remote image is scheduled for download', $byId['i1']['do'] === 'download', $byId['i1']['do']);
check('second photo of the same product gets -2', $byId['i2']['file'] === 'afd100-ut-flaw-detector-2.jpg', $byId['i2']['file']);
check('first photo of that product gets -1', $byId['i1']['file'] === 'afd100-ut-flaw-detector-1.jpg', $byId['i1']['file']);
check('already-local image is left alone', $byId['i3']['do'] === 'skip-local', $byId['i3']['reason']);
check('empty url is skipped', $byId['i4']['do'] === 'skip-empty', $byId['i4']['reason']);
check('uppercase HTTPS is still treated as remote', $byId['i5']['do'] === 'download', $byId['i5']['do']);
check('target path stays inside assets/uploads/products/',
    strpos($byId['i1']['path'], 'assets/uploads/products/') === 0 && strpos($byId['i1']['path'], '..') === false,
    $byId['i1']['path']);

$prefixPlan = [];
foreach (vp_loc_plan($rows, $mixOpts) as $a) $prefixPlan[$a['id']] = $a;
check('--sku-prefix keeps matching rows', $prefixPlan['i1']['do'] === 'download', $prefixPlan['i1']['do']);
check('--sku-prefix skips a remote row of another brand', $prefixPlan['i6']['do'] === 'skip-prefix', $prefixPlan['i6']['reason']);
check('--sku-prefix does not resurrect an already-local row', $prefixPlan['i3']['do'] === 'skip-local', $prefixPlan['i3']['do']);

$limitPlan = [];
foreach (vp_loc_plan($rows, ['limit' => 1] + $baseOpts) as $a) $limitPlan[$a['id']] = $a;
$downloads = array_filter($limitPlan, function ($a) { return $a['do'] === 'download'; });
check('--limit=1 leaves exactly one download', count($downloads) === 1, count($downloads) . ' download(s)');
check('--limit marks the rest as skip-limit', $limitPlan['i2']['do'] === 'skip-limit', $limitPlan['i2']['reason']);

/* ------------------------------------------------------------------ */
/* File names and SQL                                                  */
/* ------------------------------------------------------------------ */
section('File names and SQL');

check('slug is lower-cased and hyphenated', vp_loc_slug('AFD100 UT Flaw Detector') === 'afd100-ut-flaw-detector',
    vp_loc_slug('AFD100 UT Flaw Detector'));
check('traversal attempt is neutralised', vp_loc_slug('../../etc/passwd') === 'etc-passwd', vp_loc_slug('../../etc/passwd'));
check('empty slug falls back safely', vp_loc_slug('///') === 'product', vp_loc_slug('///'));
check('slug is capped at 80 chars', strlen(vp_loc_slug(str_repeat('a', 500))) === 80);

$sql = vp_loc_update_sql('img-1', '/assets/uploads/products/afd100-1.jpg');
check('UPDATE targets product_images by id',
    $sql === "UPDATE `product_images` SET `url` = '/assets/uploads/products/afd100-1.jpg' WHERE `id` = 'img-1';", $sql);

$quoted = vp_loc_update_sql("o'brien", "/assets/uploads/products/it's.jpg");
check("quotes in the UPDATE are escaped",
    strpos($quoted, "it\\'s.jpg") !== false && strpos($quoted, "o\\'brien") !== false, $quoted);

/* ------------------------------------------------------------------ */
/* Plan built from the shipped seed file (no database)                 */
/* ------------------------------------------------------------------ */
section('Plan from database/ajr_ndt_products.sql');

$seedRows = vp_loc_rows_from_sql($ROOT . '/database/ajr_ndt_products.sql', $ROOT);
check('93 product images read from the seed', count($seedRows) === 93, 'got ' . count($seedRows));

$seedPlan = vp_loc_plan($seedRows, $baseOpts);
$seedDownloads = array_values(array_filter($seedPlan, function ($a) { return $a['do'] === 'download'; }));
check('all 93 are remote and would be downloaded', count($seedDownloads) === 93, count($seedDownloads) . ' planned');

$targets = array_column($seedDownloads, 'new_url');
check('93 distinct local target paths', count(array_unique($targets)) === count($targets),
    count(array_unique($targets)) . ' unique');
check('no target path escapes the uploads folder',
    count(array_filter($targets, function ($u) {
        return strpos($u, '/assets/uploads/products/') !== 0 || strpos($u, '..') !== false;
    })) === 0);
check('every plan row carries a real product name',
    count(array_filter($seedDownloads, function ($a) { return trim((string) $a['product']) === ''; })) === 0);

/* ------------------------------------------------------------------ */
/* Storing: verification + re-encode (real files)                      */
/* ------------------------------------------------------------------ */
section('Storing downloaded files (vp_loc_store_image)');

if (!extension_loaded('gd')) {
    echo "  [SKIP] GD is not available - cannot generate fixtures\n";
} else {
    // A real JPEG fixture.
    $im = imagecreatetruecolor(120, 90);
    imagefilledrectangle($im, 0, 0, 120, 90, imagecolorallocate($im, 20, 60, 120));
    $goodJpeg = $TMP . '/good.jpg';
    imagejpeg($im, $goodJpeg, 90);
    imagedestroy($im);

    $dest = $TMP . '/stored-good.jpg';
    $res = vp_loc_store_image($goodJpeg, $dest, $baseOpts);
    check('a real JPEG is accepted', $res['ok'] === true, $res['error']);
    check('the stored file exists', is_file($dest), $dest);
    check('the stored file is still a valid image', @getimagesize($dest) !== false);
    check('GD pass reported as re-encoded', $res['reencoded'] === true);
    check('temp download file is removed', !is_file($goodJpeg));
    check('stored file name is returned', $res['file'] === basename($dest), $res['file']);

    // A text file wearing a .jpg name must never be stored.
    $fake = $TMP . '/fake.jpg';
    file_put_contents($fake, "<html>403 Forbidden</html>\n");
    $resFake = vp_loc_store_image($fake, $TMP . '/stored-fake.jpg', $baseOpts);
    check('an HTML error page is rejected', $resFake['ok'] === false, $resFake['error']);
    check('the rejected file is not stored', !is_file($TMP . '/stored-fake.jpg'));
    check('the rejected temp file is cleaned up', !is_file($fake));

    // A PHP payload appended after valid image data must not survive.
    $im2 = imagecreatetruecolor(60, 40);
    imagefilledrectangle($im2, 0, 0, 60, 40, imagecolorallocate($im2, 200, 30, 30));
    $payloadJpeg = $TMP . '/payload.jpg';
    imagejpeg($im2, $payloadJpeg, 90);
    imagedestroy($im2);
    file_put_contents($payloadJpeg, "<?php echo 'pwned'; ?>\n", FILE_APPEND);
    check('fixture really carries a payload before storing',
        strpos((string) file_get_contents($payloadJpeg), '<?php') !== false);

    $payloadDest = $TMP . '/stored-payload.jpg';
    $resPayload = vp_loc_store_image($payloadJpeg, $payloadDest, $baseOpts);
    check('image with an appended PHP payload is still usable', $resPayload['ok'] === true, $resPayload['error']);
    check('the appended PHP payload is stripped by the re-encode',
        is_file($payloadDest) && strpos((string) file_get_contents($payloadDest), '<?php') === false);

    // --no-reencode keeps the bytes but names the file after the verified type.
    $im3 = imagecreatetruecolor(40, 30);
    $rawPng = $TMP . '/raw.png';
    imagepng($im3, $rawPng);
    imagedestroy($im3);
    $rawRes = vp_loc_store_image($rawPng, $TMP . '/stored-raw.jpg', ['reencode' => false] + $baseOpts);
    check('--no-reencode keeps a valid image', $rawRes['ok'] === true, $rawRes['error']);
    check('--no-reencode names the file after the verified type',
        $rawRes['file'] === 'stored-raw.png', $rawRes['file']);
}

/* ------------------------------------------------------------------ */
/* Download failure handling (no external network needed)              */
/* ------------------------------------------------------------------ */
section('Download handling (vp_loc_fetch)');

if (!function_exists('curl_init')) {
    echo "  [SKIP] the curl extension is not available\n";
} else {
    $bad = vp_loc_fetch('http://127.0.0.1:9/does-not-exist.jpg', $TMP . '/nope.jpg', $baseOpts);
    check('an unreachable host fails cleanly', $bad['ok'] === false, $bad['error']);
    check('a failed download leaves no file behind', !is_file($TMP . '/nope.jpg'));
    check('a failed download reports an error message', trim((string) $bad['error']) !== '');
}

/* ------------------------------------------------------------------ */
/* Credentials guard                                                   */
/* ------------------------------------------------------------------ */
section('Database credential guard (vp_loc_db_config)');

$noCreds = vp_loc_db_config('', '', '', '');
check('missing credentials are refused', $noCreds['ok'] === false);
check('every missing variable is named', count($noCreds['missing']) === 4, implode(', ', $noCreds['missing']));
check('port defaults to 3306', $noCreds['port'] === 3306, (string) $noCreds['port']);

$partial = vp_loc_db_config('localhost', 'vortex_ci', 'vortex_user', '', '3307');
check('a missing password alone is enough to refuse', $partial['ok'] === false && $partial['missing'] === ['VP_DB_PASS'],
    implode(', ', $partial['missing']));
check('a custom port is cast to int', $partial['port'] === 3307, (string) $partial['port']);

$full = vp_loc_db_config('localhost', 'vortex_ci', 'vortex_user', 'secret', '3306');
check('complete credentials pass', $full['ok'] === true && $full['missing'] === []);

/* ------------------------------------------------------------------ */
/* Result                                                              */
/* ------------------------------------------------------------------ */
echo "\n" . str_repeat('-', 62) . "\n";
echo 'Localizer checks: ' . $GLOBALS['VP_PASS'] . ' passed, ' . $GLOBALS['VP_FAIL'] . " failed\n";
if ($GLOBALS['VP_FAIL'] > 0) {
    echo "\nFailures:\n";
    foreach ($GLOBALS['VP_FAILURES'] as $f) echo "  - $f\n";
    exit(1);
}
echo "Planning, file naming, image verification and re-encoding all behave.\n";
exit(0);
