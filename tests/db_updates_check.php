<?php
/**
 * Vortex Precision IT — database updates consistency check (CLI).
 *
 *   php tests/db_updates_check.php
 *
 * Guards the "Dashboard → System → Database Updates" screen:
 *   1. every SQL file in database/migrations/ is registered in
 *      application/config/db_updates.php (title + valid probe), and vice versa;
 *   2. the runner's quote-aware statement splitter parses every shipped file
 *      into at least one non-empty statement;
 *   3. probe SQL is a single statement (no semicolons outside strings).
 *
 * No database or framework boot required. Exit code 0 = all good.
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("CLI only\n");
}

error_reporting(E_ALL);
ini_set('display_errors', '1');

$root = dirname(__DIR__);

// Minimal stubs so the model can be loaded outside the framework.
define('BASEPATH', 1);
define('FCPATH', $root . '/');
class CI_Model { public function __construct() {} }
class MY_Model extends CI_Model {}
require $root . '/application/models/Schema_update_model.php';
include $root . '/application/config/db_updates.php';

$fail = 0;
function check($label, $cond)
{
    global $fail;
    echo ($cond ? 'PASS ' : 'FAIL ') . $label . PHP_EOL;
    if (!$cond) $fail++;
}

$registry = $config['db_updates'] ?? [];

$files = [];
foreach ((array) glob($root . '/database/migrations/*.sql') as $path) {
    $base = basename($path);
    if (preg_match('/^(\d{3})_[a-z0-9_]+\.sql$/', $base, $m)) {
        $files[$m[1]] = $base;
    }
}
ksort($files);

check('shipped migration files found', count($files) > 0);

foreach ($files as $version => $base) {
    check("$base is registered in config/db_updates.php", isset($registry[$version]));
    if (!isset($registry[$version])) continue;

    $meta = $registry[$version];
    check("$base has a title", !empty($meta['title']));
    check("$base has a description", !empty($meta['description']));

    $probe = $meta['probe'] ?? null;
    $ok = is_array($probe) && count($probe) === 2
        && in_array($probe[0], ['exists', 'positive', 'zero'], true)
        && is_string($probe[1]) && $probe[1] !== '';
    check("$base has a valid probe", $ok);
    if ($ok) {
        // A probe must be exactly one statement.
        $runner = new Schema_update_model();
        $parts = $runner->split_statements($probe[1]);
        check("$base probe is a single statement", count($parts) === 1);
    }
}

foreach ($registry as $version => $meta) {
    check("registry entry $version has a file", isset($files[$version]));
}

$runner = new Schema_update_model();
foreach ($files as $version => $base) {
    $sql = file_get_contents($root . '/database/migrations/' . $base);
    $stmts = $runner->split_statements($sql === false ? '' : $sql);
    check("$base splits into statements (" . count($stmts) . ')', count($stmts) > 0);
}

echo $fail === 0 ? 'ALL CHECKS PASSED' . PHP_EOL : $fail . ' CHECK(S) FAILED' . PHP_EOL;
exit($fail === 0 ? 0 : 1);
