<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - Session config.
 *
 * Keep the `database` driver for central session management and
 * high-concurrency safety. The `ci_sessions` table is created by
 * install/install.sql. Values mirror config.php so either file can be
 * loaded; every value is overridable via environment (see .env.example).
 */

if (!function_exists('vp_session_env')) {
    function vp_session_env($key, $default)
    {
        $v = getenv($key);
        return ($v === false || $v === '') ? $default : $v;
    }
}

$config['sess_driver']          = 'database';
$config['sess_cookie_name']     = 'vp_session';
$config['sess_expiration']      = (int) vp_session_env('VP_SESSION_EXPIRATION', 7200);
$config['sess_save_path']       = 'ci_sessions';
$config['sess_match_ip']        = FALSE;
$config['sess_time_to_update']  = 300;
$config['sess_regenerate_destroy'] = FALSE;
