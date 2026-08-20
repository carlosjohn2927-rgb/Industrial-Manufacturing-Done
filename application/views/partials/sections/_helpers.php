<?php
/**
 * Shared helper for section partials: turns a stored link into a URL.
 * (Internal paths are resolved against base_url, full URLs pass through.)
 */
if (!function_exists('vp_section_link')) {
    function vp_section_link($url)
    {
        $url = trim((string) $url);
        if ($url === '') return '';
        if (preg_match('~^(https?:)?//~i', $url) || strpos($url, 'mailto:') === 0 || strpos($url, 'tel:') === 0) return $url;
        return base_url(ltrim($url, '/'));
    }
}
