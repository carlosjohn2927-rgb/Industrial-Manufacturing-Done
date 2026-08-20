<?php
/**
 * Vortex Precision - PHP built-in server router (development/testing only).
 *
 * Usage:  php -S 127.0.0.1:8099 -t app app/tests/router.php
 *
 * Static files (assets) are served by the built-in server; everything else
 * goes through CodeIgniter. Not used in production (Apache handles routing
 * via .htaccess) and blocked from web access by the root .htaccess.
 */

$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);
$docroot = __DIR__ . '/..';
$file = $docroot . '/' . rawurldecode((string) $uri);

if ($uri !== '/' && $uri !== '/index.php' && is_file($file)) {
    return false; // let the built-in server serve this static file
}

require $docroot . '/index.php';
