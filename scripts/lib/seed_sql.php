<?php
/**
 * Tiny reader for the seed .sql files shipped in database/ and install/.
 *
 * It understands two shapes only:
 *
 *   INSERT INTO <table> (cols) VALUES (...),(...);
 *   INSERT INTO <table> (cols) SELECT <literals> FROM ... WHERE ...;
 *
 * with single-quoted MySQL string literals (backslash escapes included). That
 * is enough to inspect the seed data WITHOUT a database - used by
 *
 *   tests/localize_images_check.php                (regression check)
 *   scripts/localize_product_images.php            (--from-sql dry run)
 *
 * It is deliberately not a general SQL parser: no expressions, no functions,
 * no multi-statement values. Anything it cannot parse is skipped.
 *
 * @param  string $sql    Contents of the .sql file
 * @param  string $table  Table name (backticks optional)
 * @return array  List of associative rows keyed by column name; NULL -> null
 */
if (!function_exists('vp_seed_insert_rows')) {
    function vp_seed_insert_rows($sql, $table)
    {
        $pattern = '/INSERT\s+INTO\s+`?' . preg_quote($table, '/') . '`?\s*\(([^)]*)\)\s*VALUES/is';
        if (!preg_match_all($pattern, $sql, $heads, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
            return [];
        }

        $out = [];
        foreach ($heads as $m) {
            $cols = array_map(function ($c) {
                return trim(trim($c), '`');
            }, explode(',', $m[1][0]));

            $body  = substr($sql, $m[0][1] + strlen($m[0][0]));
            $rows  = [];
            $row   = [];
            $cur   = '';
            $depth = 0;
            $inStr = false;
            $n     = strlen($body);

            for ($i = 0; $i < $n; $i++) {
                $ch = $body[$i];

                if ($inStr) {
                    if ($ch === '\\') {
                        $next = $body[$i + 1] ?? '';
                        $map  = ['n' => "\n", 't' => "\t", 'r' => "\r", '0' => "\0",
                                 '\\' => '\\', "'" => "'", '"' => '"', 'b' => "\x08", 'Z' => "\x1a"];
                        $cur .= array_key_exists($next, $map) ? $map[$next] : $next;
                        $i++;
                        continue;
                    }
                    if ($ch === "'") { $inStr = false; } else { $cur .= $ch; }
                    continue;
                }

                if ($ch === "'") { $inStr = true; continue; }
                if ($ch === '(') { $depth++; continue; }

                if ($ch === ')') {
                    $depth--;
                    if ($depth === 0) {
                        $row[] = $cur;
                        $rows[] = $row;
                        $row = [];
                        $cur = '';
                    }
                    continue;
                }

                if ($depth === 0) {
                    if ($ch === ';') break;
                    continue;
                }

                if ($ch === ',') { $row[] = $cur; $cur = ''; continue; }
                $cur .= $ch;
            }

            foreach ($rows as $values) {
                if (count($values) !== count($cols)) continue;
                $assoc = [];
                foreach ($cols as $idx => $col) {
                    $v = trim($values[$idx]);
                    $assoc[$col] = (strcasecmp($v, 'NULL') === 0) ? null : $v;
                }
                $out[] = $assoc;
            }
        }
        return $out;
    }
}

if (!function_exists('vp_seed_unquote')) {
    /**
     * Unquote one SQL string literal (both MySQL `\'` and SQL `''` escapes).
     */
    function vp_seed_unquote($literal)
    {
        $s = substr($literal, 1, -1);
        $out = '';
        $n = strlen($s);
        for ($i = 0; $i < $n; $i++) {
            $ch = $s[$i];
            if ($ch === '\\' && $i + 1 < $n) {
                $next = $s[++$i];
                $map = ['n' => "\n", 't' => "\t", 'r' => "\r", '0' => "\0",
                        '\\' => '\\', "'" => "'", '"' => '"', 'b' => "\x08", 'Z' => "\x1a"];
                $out .= array_key_exists($next, $map) ? $map[$next] : $next;
                continue;
            }
            if ($ch === "'" && $i + 1 < $n && $s[$i + 1] === "'") { $out .= "'"; $i++; continue; }
            $out .= $ch;
        }
        return $out;
    }
}

if (!function_exists('vp_seed_select_rows')) {
    /**
     * Read rows from `INSERT INTO <table> (cols) SELECT <items> FROM ...`
     * statements — the style migrations 008 and 015 use (one row per
     * statement, built with NOT EXISTS guards so re-runs are no-ops).
     *
     * Literal select items ('text', 3, NULL) become values. Expressions such
     * as `c.id`, `p.id` or `(SELECT ...)` cannot be resolved without a
     * database and become '', with the join keys preserved in extras:
     *
     *   '_sku'           product SKU from the WHERE clause   (product_images)
     *   '_category_slug' category slug from the WHERE clause (products, categories)
     *
     * @return array[] one assoc row per statement, keyed by column name
     */
    function vp_seed_select_rows($sql, $table)
    {
        $rows = [];
        $offset = 0;
        $needle = '/INSERT\s+INTO\s+`?' . preg_quote($table, '/') . '`?\s*\(/i';
        while (preg_match($needle, $sql, $hm, PREG_OFFSET_CAPTURE, $offset)) {
            $start = $hm[0][1];
            // Find the end of this statement (semicolon outside strings/parens).
            $depth = 0; $q = null; $end = null; $len = strlen($sql);
            for ($i = $start; $i < $len; $i++) {
                $c = $sql[$i];
                if ($q !== null) {
                    if ($c === '\\') { $i++; continue; }
                    if ($c === $q) $q = null;
                    continue;
                }
                if ($c === "'" || $c === '"' || $c === '`') { $q = $c; continue; }
                if ($c === '(') { $depth++; continue; }
                if ($c === ')') { $depth--; continue; }
                if ($c === ';' && $depth <= 0) { $end = $i; break; }
            }
            if ($end === null) break;
            $stmt  = substr($sql, $start, $end - $start);
            $offset = $end + 1;

            if (!preg_match('/\(([^)]*)\)\s*SELECT\s+/i', $stmt, $cm, PREG_OFFSET_CAPTURE)) continue;
            $cols = array_map(function ($c) {
                return trim(trim($c), "` \t\n\r");
            }, explode(',', $cm[1][0]));
            $pos = $cm[0][1] + strlen($cm[0][0]);

            // Split the select list at top-level commas until top-level FROM.
            $items = []; $cur = ''; $depth = 0; $q = null; $tail = null;
            for ($i = $pos, $n = strlen($stmt); $i < $n; $i++) {
                $c = $stmt[$i];
                if ($q !== null) {
                    $cur .= $c;
                    if ($c === '\\') { $cur .= $stmt[$i + 1] ?? ''; $i++; continue; }
                    if ($c === $q) $q = null;
                    continue;
                }
                if ($c === "'" || $c === '"' || $c === '`') { $q = $c; $cur .= $c; continue; }
                if ($c === '(') { $depth++; $cur .= $c; continue; }
                if ($c === ')') { $depth--; $cur .= $c; continue; }
                if ($depth === 0 && $c === ',') { $items[] = trim($cur); $cur = ''; continue; }
                // Top-level FROM ends the select list (prev char must not be
                // part of an identifier, so columns like `from` are safe).
                if ($depth === 0 && preg_match('/^FROM\b/i', substr($stmt, $i, 5))
                    && !preg_match('/[A-Za-z0-9_`$]/', substr($stmt, $i - 1, 1))) {
                    $items[] = trim($cur);
                    $tail = substr($stmt, $i + 4);
                    break;
                }
                $cur .= $c;
            }
            if ($tail === null) continue;

            $assoc = [];
            foreach ($cols as $idx => $col) {
                $item = trim($items[$idx] ?? 'NULL');
                if ($item !== '' && $item[0] === "'" && substr($item, -1) === "'") {
                    $assoc[$col] = vp_seed_unquote($item);
                } elseif (is_numeric($item)) {
                    $assoc[$col] = $item + 0;
                } elseif (strcasecmp($item, 'NULL') === 0 || $item === '') {
                    $assoc[$col] = $item === '' ? '' : null;
                } else {
                    $assoc[$col] = '';   // expression (p.id, c.id, sub-selects)
                }
            }
            if (preg_match("/\\bp\\.sku\\s*=\\s*'((?:[^'\\\\]|\\\\.)*)'/i", $tail, $m)) {
                $assoc['_sku'] = vp_seed_unquote("'" . $m[1] . "'");
            }
            if (preg_match("/\\bc\\.slug\\s*=\\s*'((?:[^'\\\\]|\\\\.)*)'/i", $tail, $m)) {
                $assoc['_category_slug'] = vp_seed_unquote("'" . $m[1] . "'");
            }
            $rows[] = $assoc;
        }
        return $rows;
    }
}
