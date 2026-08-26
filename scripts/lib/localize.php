<?php
/**
 * Product-image localizer — reusable logic.
 *
 * Everything here is pure or explicitly I/O-isolated so it can be exercised by
 * `php tests/localize_images_check.php` without a database or a network:
 *
 *   vp_loc_is_remote()      is this URL something we have to download?
 *   vp_loc_slug()           filesystem-safe file-name component
 *   vp_loc_ext_for()        extension matching a verified image type
 *   vp_loc_plan()           one action per product_images row (no I/O)
 *   vp_loc_update_sql()     the exact UPDATE that will be applied
 *   vp_loc_fetch()          download with timeout / size cap / redirects
 *   vp_loc_store_image()    verify it is a real image, then store it
 *   vp_loc_rows_from_sql()  plan source when there is no database
 *   vp_loc_rows_from_db()   plan source in production
 *   vp_loc_args() / vp_loc_usage()
 *
 * The CLI entry point is scripts/localize_product_images.php.
 */

/* ------------------------------------------------------------------ */
/* CLI options                                                         */
/* ------------------------------------------------------------------ */
if (!function_exists('vp_loc_usage')) {
    function vp_loc_usage($script = 'localize_product_images.php')
    {
        echo <<<TXT
Usage: php scripts/$script [options]

  --dry-run               Plan and print; download nothing, write nothing.
  --from-sql=<file>       Build the plan from a seed .sql file (implies --dry-run).
  --limit=<n>             Only the first <n> remote images.
  --sku-prefix=<p>        Only products whose SKU starts with <p> (e.g. AJR-).
  --force                 Re-download and overwrite an existing local file.
  --no-reencode           Keep the downloaded bytes as-is (skip the GD pass).
  --timeout=<sec>         Per-image download timeout (default 30).
  --max-mb=<n>            Reject downloads larger than <n> MB (default 10).
  --referer=<url>         Send this Referer header.
  --help                  This text.

TXT;
    }
}

if (!function_exists('vp_loc_args')) {
    /** Parse argv into an options array. Exits(2) on an unknown option. */
    function vp_loc_args(array $argv)
    {
        $opts = [
            'dry_run'    => false,
            'from_sql'   => null,
            'limit'      => 0,
            'sku_prefix' => '',
            'force'      => false,
            'reencode'   => true,
            'timeout'    => 30,
            'max_mb'     => 10,
            'referer'    => '',
            'help'       => false,
        ];

        foreach (array_slice($argv, 1) as $arg) {
            if ($arg === '--help' || $arg === '-h') { $opts['help'] = true; continue; }
            if ($arg === '--dry-run')               { $opts['dry_run'] = true; continue; }
            if ($arg === '--force')                 { $opts['force'] = true; continue; }
            if ($arg === '--no-reencode')           { $opts['reencode'] = false; continue; }
            if (strpos($arg, '--from-sql=') === 0)   { $opts['from_sql']   = substr($arg, 11); continue; }
            if (strpos($arg, '--limit=') === 0)      { $opts['limit']      = max(0, (int) substr($arg, 8)); continue; }
            if (strpos($arg, '--sku-prefix=') === 0) { $opts['sku_prefix'] = substr($arg, 13); continue; }
            if (strpos($arg, '--timeout=') === 0)    { $opts['timeout']    = max(1, (int) substr($arg, 10)); continue; }
            if (strpos($arg, '--max-mb=') === 0)     { $opts['max_mb']     = max(1, (int) substr($arg, 9)); continue; }
            if (strpos($arg, '--referer=') === 0)    { $opts['referer']    = substr($arg, 10); continue; }

            fwrite(STDERR, "Unknown option: $arg\n\n");
            vp_loc_usage();
            exit(2);
        }

        // A seed file as the source means there is no database to write to.
        if ($opts['from_sql'] !== null) $opts['dry_run'] = true;
        return $opts;
    }
}

/* ------------------------------------------------------------------ */
/* Pure helpers                                                        */
/* ------------------------------------------------------------------ */
if (!function_exists('vp_loc_is_remote')) {
    /** Only http(s) URLs need downloading; anything else is already local. */
    function vp_loc_is_remote($url)
    {
        return is_string($url) && preg_match('~^https?://~i', trim($url)) === 1;
    }
}

if (!function_exists('vp_loc_slug')) {
    /**
     * Filesystem-safe file-name component. A product slug comes from the
     * database, so it is treated as untrusted: no separators, no dots, no
     * traversal - whatever survives is [a-z0-9-] only.
     */
    function vp_loc_slug($text)
    {
        $text = strtolower((string) $text);
        $text = preg_replace('~[^a-z0-9]+~', '-', $text);
        $text = trim($text, '-');
        if ($text === '') $text = 'product';
        return substr($text, 0, 80);
    }
}

if (!function_exists('vp_loc_ext_for')) {
    /** Extension we will store, derived from the verified image type. */
    function vp_loc_ext_for($imageType)
    {
        $map = [IMAGETYPE_JPEG => 'jpg', IMAGETYPE_PNG => 'png',
                IMAGETYPE_GIF => 'gif', IMAGETYPE_WEBP => 'webp'];
        return $map[$imageType] ?? 'jpg';
    }
}

if (!function_exists('vp_loc_plan')) {
    /**
     * Decide what to do with every product_images row. No I/O.
     *
     * @param  array $rows  ['id','url','productId','slug','name','sku']
     * @param  array $opts  from vp_loc_args()
     * @return array        One action per row with 'do' set to
     *                      download | skip-local | skip-empty | skip-prefix | skip-limit
     */
    function vp_loc_plan(array $rows, array $opts)
    {
        $perProduct = [];
        $actions    = [];

        foreach ($rows as $row) {
            $url  = isset($row['url']) ? trim((string) $row['url']) : '';
            $base = [
                'id'      => $row['id'] ?? null,
                'product' => $row['name'] ?? ($row['slug'] ?? '(unknown)'),
                'sku'     => $row['sku'] ?? '',
                'old_url' => $url,
                'do'      => 'skip-empty',
                'reason'  => 'no url',
            ];

            if ($url === '') {
                $actions[] = $base;
                continue;
            }

            if (!vp_loc_is_remote($url)) {
                $base['do']     = 'skip-local';
                $base['reason'] = 'already local';
                $actions[] = $base;
                continue;
            }

            if ($opts['sku_prefix'] !== '' && strpos((string) ($row['sku'] ?? ''), $opts['sku_prefix']) !== 0) {
                $base['do']     = 'skip-prefix';
                $base['reason'] = 'sku does not start with ' . $opts['sku_prefix'];
                $actions[] = $base;
                continue;
            }

            $pid = $row['productId'] ?? ($row['id'] ?? 'x');
            $perProduct[$pid] = ($perProduct[$pid] ?? 0) + 1;

            $base['do']       = 'download';
            $base['reason']   = 'remote';
            $base['slug']     = vp_loc_slug($row['slug'] ?? $row['sku'] ?? $row['name'] ?? 'product');
            $base['position'] = $perProduct[$pid];
            $base['file']     = $base['slug'] . '-' . $base['position'] . '.jpg';
            $base['path']     = 'assets/uploads/products/' . $base['file'];
            $base['new_url']  = '/assets/uploads/products/' . $base['file'];
            $actions[] = $base;
        }

        if ($opts['limit'] > 0) {
            $seen = 0;
            foreach ($actions as &$a) {
                if ($a['do'] !== 'download') continue;
                $seen++;
                if ($seen > $opts['limit']) {
                    $a['do']     = 'skip-limit';
                    $a['reason'] = 'beyond --limit=' . $opts['limit'];
                }
            }
            unset($a);
        }

        return $actions;
    }
}

if (!function_exists('vp_loc_update_sql')) {
    /**
     * The exact UPDATE applied for one row. $escape should be
     * mysqli::real_escape_string() in production; the built-in fallback keeps
     * this callable (and testable) without a database connection.
     */
    function vp_loc_update_sql($imageId, $newUrl, $escape = null)
    {
        $esc = is_callable($escape) ? $escape : function ($v) {
            return str_replace(["\\", "'"], ["\\\\", "\\'"], (string) $v);
        };
        return "UPDATE `product_images` SET `url` = '" . $esc($newUrl)
             . "' WHERE `id` = '" . $esc($imageId) . "';";
    }
}

/* ------------------------------------------------------------------ */
/* Environment / credentials (same semantics as install/install.php)   */
/* ------------------------------------------------------------------ */
if (!function_exists('vp_loc_load_env')) {
    function vp_loc_load_env($path)
    {
        if (!is_file($path)) return;
        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        if ($lines === false) return;
        foreach ($lines as $line) {
            $line = trim($line);
            if ($line === '' || $line[0] === '#' || strpos($line, '=') === false) continue;
            [$k, $v] = explode('=', $line, 2);
            $k = trim($k); $v = trim($v);
            if ($k === '' || !preg_match('/^[A-Za-z_][A-Za-z0-9_]*$/', $k)) continue;
            if (strlen($v) >= 2 && (($v[0] === '"' && substr($v, -1) === '"') || ($v[0] === "'" && substr($v, -1) === "'"))) {
                $v = substr($v, 1, -1);
            }
            if (getenv($k) === false) putenv($k . '=' . $v);
        }
    }
}

if (!function_exists('vp_loc_env')) {
    function vp_loc_env($key, $default = '')
    {
        foreach ([getenv($key), isset($_ENV[$key]) ? $_ENV[$key] : null, isset($_SERVER[$key]) ? $_SERVER[$key] : null] as $v) {
            if ($v !== false && $v !== null && $v !== '') return $v;
        }
        return $default;
    }
}

/* ------------------------------------------------------------------ */
/* Download + verify                                                   */
/* ------------------------------------------------------------------ */
if (!function_exists('vp_loc_fetch')) {
    /**
     * Download $url to $tmp.
     *
     * @return array ['ok' => bool, 'error' => string, 'bytes' => int]
     */
    function vp_loc_fetch($url, $tmp, array $opts)
    {
        if (!function_exists('curl_init')) {
            return ['ok' => false, 'error' => 'the curl PHP extension is required', 'bytes' => 0];
        }

        $maxBytes = $opts['max_mb'] * 1024 * 1024;
        $fh = @fopen($tmp, 'wb');
        if ($fh === false) {
            return ['ok' => false, 'error' => 'cannot open temp file ' . $tmp, 'bytes' => 0];
        }

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_FILE           => $fh,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_MAXREDIRS      => 5,
            CURLOPT_TIMEOUT        => $opts['timeout'],
            CURLOPT_CONNECTTIMEOUT => 15,
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2,
            CURLOPT_USERAGENT      => 'Mozilla/5.0 (compatible; VortexPrecision-Catalog/1.0)',
            CURLOPT_FAILONERROR    => true,
            CURLOPT_NOPROGRESS     => false,
            CURLOPT_PROGRESSFUNCTION => function ($ch, $dlTotal) use ($maxBytes) {
                // Abort as soon as the server announces a too-large file.
                return ($dlTotal > 0 && $dlTotal > $maxBytes) ? 1 : 0;
            },
        ]);
        if (!empty($opts['referer'])) {
            curl_setopt($ch, CURLOPT_REFERER, $opts['referer']);
        }

        $ok    = curl_exec($ch);
        $err   = $ok ? '' : curl_error($ch);
        $code  = (int) curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
        $bytes = (int) curl_getinfo($ch, CURLINFO_SIZE_DOWNLOAD);
        curl_close($ch);
        fclose($fh);

        if (!$ok) {
            @unlink($tmp);
            return ['ok' => false, 'error' => $err !== '' ? $err : 'download failed', 'bytes' => 0];
        }
        if ($code >= 400) {
            @unlink($tmp);
            return ['ok' => false, 'error' => 'HTTP ' . $code, 'bytes' => 0];
        }
        if ($bytes <= 0 || $bytes > $maxBytes) {
            @unlink($tmp);
            return ['ok' => false, 'error' => $bytes > $maxBytes ? 'larger than --max-mb' : 'empty response', 'bytes' => $bytes];
        }

        return ['ok' => true, 'error' => '', 'bytes' => $bytes];
    }
}

if (!function_exists('vp_loc_store_image')) {
    /**
     * Verify a downloaded file really is an image, then store it at $dest.
     *
     * With GD available the image is re-encoded, which is what makes the file
     * trustworthy: anything appended after the image data (a PHP payload, a
     * shell, tracker bytes) is discarded, and transparency is flattened onto
     * white so product cards look consistent. Without GD the bytes are kept,
     * but the file is still named after the *verified* image type.
     *
     * @return array ['ok'=>bool,'error'=>string,'mime'=>string,'reencoded'=>bool,'file'=>string]
     */
    function vp_loc_store_image($tmp, $dest, array $opts)
    {
        $info = @getimagesize($tmp);
        if ($info === false || empty($info[2])) {
            @unlink($tmp);
            return ['ok' => false, 'error' => 'not a valid image (getimagesize failed)',
                    'mime' => '', 'reencoded' => false, 'file' => ''];
        }

        $mime    = $info['mime'] ?? '';
        $allowed = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        if (!in_array($mime, $allowed, true)) {
            @unlink($tmp);
            return ['ok' => false, 'error' => 'unexpected content type ' . $mime,
                    'mime' => $mime, 'reencoded' => false, 'file' => ''];
        }

        if ($opts['reencode'] && extension_loaded('gd')) {
            $src = null;
            switch ($info[2]) {
                case IMAGETYPE_JPEG: $src = @imagecreatefromjpeg($tmp); break;
                case IMAGETYPE_PNG:  $src = @imagecreatefrompng($tmp);  break;
                case IMAGETYPE_GIF:  $src = @imagecreatefromgif($tmp);  break;
                case IMAGETYPE_WEBP: $src = function_exists('imagecreatefromwebp') ? @imagecreatefromwebp($tmp) : false; break;
            }
            if ($src !== false && $src !== null) {
                if (in_array($info[2], [IMAGETYPE_PNG, IMAGETYPE_GIF, IMAGETYPE_WEBP], true)) {
                    $flat  = imagecreatetruecolor(imagesx($src), imagesy($src));
                    $white = imagecolorallocate($flat, 255, 255, 255);
                    imagefilledrectangle($flat, 0, 0, imagesx($src), imagesy($src), $white);
                    imagecopy($flat, $src, 0, 0, 0, 0, imagesx($src), imagesy($src));
                    imagedestroy($src);
                    $src = $flat;
                }
                $written = @imagejpeg($src, $dest, 88);
                imagedestroy($src);
                @unlink($tmp);
                if ($written) {
                    return ['ok' => true, 'error' => '', 'mime' => 'image/jpeg',
                            'reencoded' => true, 'file' => basename($dest)];
                }
                return ['ok' => false, 'error' => 'GD could not write ' . $dest,
                        'mime' => $mime, 'reencoded' => false, 'file' => ''];
            }
            // GD present but could not decode it: fall through to a raw copy.
        }

        // No GD (or --no-reencode): keep the bytes, but name the file after the
        // verified image type so the extension always matches the content.
        $ext  = vp_loc_ext_for($info[2]);
        $dest = preg_replace('/\.[a-z0-9]+$/i', '.' . $ext, $dest);
        if (!@rename($tmp, $dest)) {
            @unlink($tmp);
            return ['ok' => false, 'error' => 'could not move file to ' . $dest,
                    'mime' => $mime, 'reencoded' => false, 'file' => ''];
        }
        return ['ok' => true, 'error' => '', 'mime' => $mime,
                'reencoded' => false, 'file' => basename($dest)];
    }
}

/* ------------------------------------------------------------------ */
/* Row sources                                                         */
/* ------------------------------------------------------------------ */
if (!function_exists('vp_loc_rows_from_sql')) {
    /**
     * Plan source when there is no database: read the product + product_images
     * rows straight out of a seed .sql file.
     */
    function vp_loc_rows_from_sql($file, $root)
    {
        require_once $root . '/scripts/lib/seed_sql.php';
        $sql = (string) @file_get_contents($file);
        if ($sql === '') {
            fwrite(STDERR, "Cannot read --from-sql file: $file\n");
            exit(1);
        }

        $products = [];
        foreach (vp_seed_insert_rows($sql, 'products') as $p) {
            $products[$p['id'] ?? ''] = [
                'slug' => $p['slug'] ?? '', 'name' => $p['name'] ?? '', 'sku' => $p['sku'] ?? '',
            ];
        }

        $rows = [];
        foreach (vp_seed_insert_rows($sql, 'product_images') as $img) {
            $pid  = $img['productId'] ?? '';
            $meta = $products[$pid] ?? ['slug' => '', 'name' => '', 'sku' => ''];
            $rows[] = [
                'id'        => $img['id'] ?? null,
                'productId' => $pid,
                'url'       => $img['url'] ?? '',
                'slug'      => $meta['slug'],
                'name'      => $meta['name'] !== '' ? $meta['name'] : ($img['alt'] ?? ''),
                'sku'       => $meta['sku'],
            ];
        }
        return $rows;
    }
}

if (!function_exists('vp_loc_db_config')) {
    /**
     * Validate the database credentials before connecting, so the CLI can name
     * exactly which variables are missing.
     *
     * @return array ['ok'=>bool,'missing'=>string[],'host','name','user','pass','port'=>int]
     */
    function vp_loc_db_config($host, $name, $user, $pass, $port = '3306')
    {
        $missing = [];
        if ($host === '') $missing[] = 'VP_DB_HOST';
        if ($name === '') $missing[] = 'VP_DB_NAME';
        if ($user === '') $missing[] = 'VP_DB_USER';
        if ($pass === '') $missing[] = 'VP_DB_PASS';

        return [
            'ok'      => $missing === [],
            'missing' => $missing,
            'host'    => $host,
            'name'    => $name,
            'user'    => $user,
            'pass'    => $pass,
            'port'    => (int) ($port !== '' ? $port : 3306),
        ];
    }
}

if (!function_exists('vp_loc_rows_from_db')) {
    /**
     * Plan source in production: every product image, ordered the same way the
     * site picks a primary image (isPrimary DESC, sortOrder ASC).
     */
    function vp_loc_rows_from_db(mysqli $db)
    {
        $res = $db->query(
            'SELECT pi.id, pi.productId, pi.url, p.slug, p.name, p.sku
               FROM product_images pi
               LEFT JOIN products p ON p.id = pi.productId
              ORDER BY pi.productId ASC, pi.isPrimary DESC, pi.sortOrder ASC'
        );
        if ($res === false) {
            fwrite(STDERR, 'Query failed: ' . $db->error . "\n");
            exit(1);
        }
        $rows = [];
        while ($r = $res->fetch_assoc()) $rows[] = $r;
        return $rows;
    }
}
