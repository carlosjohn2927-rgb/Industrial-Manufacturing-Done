<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision — CSRF error handling for AJAX requests.
 *
 * CI3 rejects a POST with a stale CSRF token by rendering a plain HTML
 * error page. That breaks every AJAX workflow that posts from a page
 * without reloading it (media-library uploads, homepage reordering, the
 * inline page editor): with csrf_regenerate enabled the token rotates on
 * EVERY post, so the page's token is already stale for the next submit
 * and the user just sees an opaque "not allowed" page.
 *
 * When the request is an XHR we answer with JSON instead — including the
 * freshly rotated token — so the client can resync all tokens on the page
 * (and retry the request) without any page reload.
 */
class MY_Security extends CI_Security
{
    public function csrf_show_error()
    {
        $xh = isset($_SERVER['HTTP_X_REQUESTED_WITH'])
            ? strtolower((string) $_SERVER['HTTP_X_REQUESTED_WITH'])
            : '';

        if ($xh === 'xmlhttprequest') {
            // csrf_verify() already regenerated + sent the new cookie before
            // calling csrf_show_error(); include the fresh hash so the client
            // can resync every token on the page and retry.
            set_status_header(403);
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode([
                'ok'    => false,
                'error' => 'Your login session is out of date — the page was refreshed with a new security token.',
                'csrf'  => $this->get_csrf_hash(),
            ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            exit;
        }

        parent::csrf_show_error();
    }
}
