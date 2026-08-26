#!/usr/bin/env php
<?php
/**
 * localize_product_images.php — copy remote product photos onto your own
 * server and point the catalog at the local copies.
 *
 *   php scripts/localize_product_images.php --dry-run          # plan (from DB)
 *   php scripts/localize_product_images.php                    # download + apply
 *   php scripts/localize_product_images.php --from-sql=database/ajr_ndt_products.sql
 *                                                              # plan, no DB needed
 *
 * Why
 * ---
 * The AJR NDT catalog seed (migration 010) stores 93 product photos as remote
 * URLs on a third-party CDN (image.chukouplus.com). Hotlinking them means the
 * catalog depends on someone else's server: if that host blocks hotlinking,
 * rate-limits or drops the files, every card degrades to fallback artwork at
 * once. This script makes the photos yours:
 *
 *   product_images.url = https://image.chukouplus.com/...jpg
 *                     -> /assets/uploads/products/<product-slug>-1.jpg
 *
 * What it does per image
 * ----------------------
 *   1. downloads it (curl: redirects, timeout, hard size cap, browser UA),
 *   2. verifies it is really an image (getimagesize + MIME check) - an HTML
 *      error page or a script wearing a .jpg name is rejected, never stored,
 *   3. re-encodes it through GD when available, which discards anything
 *      appended after the image data and normalises the file to .jpg,
 *   4. writes assets/uploads/products/<slug>-<n>.jpg (never overwrites an
 *      existing file unless --force),
 *   5. UPDATEs that one product_images row to the local path.
 *
 * Safe to re-run: rows that are already local are skipped, and each row is
 * updated immediately after its file lands, so an interrupted run leaves the
 * database and the disk consistent. A JSON report is written to assets/logs/.
 *
 * Database credentials: VP_DB_HOST / VP_DB_NAME / VP_DB_USER / VP_DB_PASS
 * (+ optional VP_DB_PORT) from the environment or the .env in the repository
 * root - exactly what the application itself reads.
 *
 * All of the logic lives in scripts/lib/localize.php and is covered by
 * `php tests/localize_images_check.php` (no database, no network needed).
 *
 * Exit code 0 = nothing failed.
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("This tool can only be run from the command line.\n");
}

error_reporting(E_ALL);
ini_set('display_errors', '1');

$ROOT = dirname(__DIR__);
require_once $ROOT . '/scripts/lib/localize.php';

$opts = vp_loc_args($argv ?? []);
if ($opts['help']) { vp_loc_usage(); exit(0); }

echo "Vortex Precision - localize product images\n";
echo '  mode:      ' . ($opts['dry_run'] ? 'DRY RUN (nothing is downloaded or written)' : 'APPLY') . "\n";
echo '  source:    ' . ($opts['from_sql'] !== null ? $opts['from_sql'] : 'database') . "\n";
echo '  gd:        ' . (extension_loaded('gd') ? 'available' : 'not loaded (files stored as downloaded)') . "\n";
echo '  re-encode: ' . ($opts['reencode'] ? 'yes' : 'no') . "\n";
if ($opts['sku_prefix'] !== '') echo '  filter:    sku prefix ' . $opts['sku_prefix'] . "\n";
if ($opts['limit'] > 0)         echo '  limit:     ' . $opts['limit'] . "\n";

/* ------------------------------------------------------------------ */
/* 1. Rows                                                             */
/* ------------------------------------------------------------------ */
$db = null;
if ($opts['from_sql'] !== null) {
    $rows = vp_loc_rows_from_sql($opts['from_sql'], $ROOT);
} else {
    vp_loc_load_env($ROOT . '/.env');
    vp_loc_load_env($ROOT . '/app/.env');

    $cfg = vp_loc_db_config(
        vp_loc_env('VP_DB_HOST'),
        vp_loc_env('VP_DB_NAME'),
        vp_loc_env('VP_DB_USER'),
        vp_loc_env('VP_DB_PASS'),
        vp_loc_env('VP_DB_PORT', '3306')
    );

    if (!$cfg['ok']) {
        fwrite(STDERR, "\nMissing database environment variable(s): " . implode(', ', $cfg['missing']) . "\n"
            . "Set them in the .env file in the repository root - see .env.example.\n"
            . "Or plan without a database:\n"
            . "  php scripts/localize_product_images.php --from-sql=database/ajr_ndt_products.sql\n");
        exit(1);
    }
    if (!class_exists('mysqli')) {
        fwrite(STDERR, "\nThe mysqli PHP extension is required.\n");
        exit(1);
    }

    echo "  database:  {$cfg['user']}@{$cfg['host']}:{$cfg['port']}/{$cfg['name']}\n";
    $db = @new mysqli($cfg['host'], $cfg['user'], $cfg['pass'], $cfg['name'], $cfg['port']);
    if ($db->connect_errno) {
        fwrite(STDERR, "\nDatabase connection failed: {$db->connect_error}\n");
        exit(1);
    }
    $rows = vp_loc_rows_from_db($db);
}

echo '  rows:      ' . count($rows) . " product images\n\n";

/* ------------------------------------------------------------------ */
/* 2. Plan                                                             */
/* ------------------------------------------------------------------ */
$actions = vp_loc_plan($rows, $opts);

$counts = [];
foreach ($actions as $a) $counts[$a['do']] = ($counts[$a['do']] ?? 0) + 1;
ksort($counts);
foreach ($counts as $what => $n) printf("  %-12s %d\n", $what, $n);
echo "\n";

$toDownload = array_values(array_filter($actions, function ($a) { return $a['do'] === 'download'; }));
$preview = array_slice($toDownload, 0, $opts['dry_run'] ? 5 : PHP_INT_MAX);
foreach ($preview as $a) {
    echo '  ' . str_pad(mb_substr($a['product'], 0, 44), 46) . $a['old_url'] . "\n"
       . str_repeat(' ', 46) . '-> /' . $a['path'] . "\n";
}
if (count($toDownload) > count($preview)) {
    echo '  ... and ' . (count($toDownload) - count($preview)) . " more\n";
}

if ($opts['dry_run']) {
    if (!empty($toDownload)) {
        echo "\nSQL that would be applied (first row shown):\n  "
           . vp_loc_update_sql($toDownload[0]['id'], $toDownload[0]['new_url']) . "\n";
    }
    echo "\nDry run complete: " . count($toDownload) . " image(s) would be downloaded.\n";
    if ($opts['from_sql'] === null) {
        echo "Re-run without --dry-run to apply.\n";
    }
    exit(0);
}

if (empty($toDownload)) {
    echo "Nothing to do - every product image is already local.\n";
    exit(0);
}

/* ------------------------------------------------------------------ */
/* 3. Apply                                                            */
/* ------------------------------------------------------------------ */
$destDir = $ROOT . '/assets/uploads/products';
if (!is_dir($destDir) && !@mkdir($destDir, 0755, true) && !is_dir($destDir)) {
    fwrite(STDERR, "Cannot create $destDir\n");
    exit(1);
}

$tmpDir = sys_get_temp_dir();
$report = ['started' => date('c'), 'rows' => [], 'counts' => ['ok' => 0, 'failed' => 0, 'skipped' => 0]];
$failed = 0;

foreach ($toDownload as $i => $a) {
    $no    = $i + 1;
    $dest  = $destDir . '/' . $a['file'];
    $label = '[' . $no . '/' . count($toDownload) . '] ' . $a['product'];

    if (is_file($dest) && !$opts['force']) {
        echo '  SKIP  ' . $label . ' - ' . $a['file'] . " already exists (use --force to replace)\n";
        $report['rows'][] = ['id' => $a['id'], 'status' => 'exists', 'file' => $a['file']];
        $report['counts']['skipped']++;
        continue;
    }

    $tmp = $tmpDir . '/vp-loc-' . getmypid() . '-' . $no . '.download';
    $fetched = vp_loc_fetch($a['old_url'], $tmp, $opts);
    if (!$fetched['ok']) {
        echo '  FAIL  ' . $label . ' - ' . $fetched['error'] . "\n";
        $report['rows'][] = ['id' => $a['id'], 'status' => 'failed',
                             'error' => $fetched['error'], 'url' => $a['old_url']];
        $report['counts']['failed']++;
        $failed++;
        continue;
    }

    $stored = vp_loc_store_image($tmp, $dest, $opts);
    if (!$stored['ok']) {
        echo '  FAIL  ' . $label . ' - ' . $stored['error'] . "\n";
        $report['rows'][] = ['id' => $a['id'], 'status' => 'rejected',
                             'error' => $stored['error'], 'url' => $a['old_url']];
        $report['counts']['failed']++;
        $failed++;
        continue;
    }

    // Without GD the stored file can carry a different extension than planned;
    // always use what is really on disk.
    $finalFile = $stored['file'];
    $newUrl    = '/assets/uploads/products/' . $finalFile;

    $sql = "UPDATE `product_images` SET `url` = '" . $db->real_escape_string($newUrl)
         . "' WHERE `id` = '" . $db->real_escape_string($a['id']) . "'";
    if (!$db->query($sql)) {
        echo '  FAIL  ' . $label . ' - stored the file but the UPDATE failed: ' . $db->error . "\n";
        $report['rows'][] = ['id' => $a['id'], 'status' => 'db-failed',
                             'error' => $db->error, 'file' => $finalFile];
        $report['counts']['failed']++;
        $failed++;
        continue;
    }

    echo '  OK    ' . $label . ' - ' . round($fetched['bytes'] / 1024) . ' KB'
       . ($stored['reencoded'] ? ', re-encoded' : '') . ' -> ' . $newUrl . "\n";
    $report['rows'][] = [
        'id' => $a['id'], 'status' => 'ok', 'file' => $finalFile,
        'bytes' => $fetched['bytes'], 'reencoded' => $stored['reencoded'],
        'old_url' => $a['old_url'], 'new_url' => $newUrl,
    ];
    $report['counts']['ok']++;
}

/* ------------------------------------------------------------------ */
/* 4. Report                                                           */
/* ------------------------------------------------------------------ */
$report['finished'] = date('c');
$logDir = $ROOT . '/assets/logs';
if (is_dir($logDir)) {
    $logFile = $logDir . '/localize-product-images-' . date('Ymd-His') . '.json';
    @file_put_contents($logFile, json_encode($report, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
    echo "\nReport: " . str_replace($ROOT, '', $logFile) . "\n";
}

echo "\nDone: {$report['counts']['ok']} localized, {$report['counts']['skipped']} skipped, "
   . "{$report['counts']['failed']} failed.\n";
echo "Every product keeps its own distinct photo, now served from your own domain.\n";

exit($failed > 0 ? 1 : 0);
