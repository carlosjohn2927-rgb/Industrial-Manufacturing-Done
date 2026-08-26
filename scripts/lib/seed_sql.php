<?php
/**
 * Tiny reader for the seed .sql files shipped in database/ and install/.
 *
 * It understands one thing only: `INSERT INTO <table> (cols) VALUES (...),(...);`
 * with single-quoted MySQL string literals (backslash escapes included). That
 * is enough to inspect the seed data WITHOUT a database - used by
 *
 *   tests/product_images_check.php          (regression check)
 *   scripts/localize_ajr_product_images.php (--from-sql dry run)
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
        if (!preg_match($pattern, $sql, $m, PREG_OFFSET_CAPTURE)) {
            return [];
        }

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

        $out = [];
        foreach ($rows as $values) {
            if (count($values) !== count($cols)) continue;
            $assoc = [];
            foreach ($cols as $idx => $col) {
                $v = trim($values[$idx]);
                $assoc[$col] = (strcasecmp($v, 'NULL') === 0) ? null : $v;
            }
            $out[] = $assoc;
        }
        return $out;
    }
}
