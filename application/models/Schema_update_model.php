<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision IT — shipped SQL database updates.
 *
 * Why this exists
 * ---------------
 * Product data (categories, products, images …) lives in the DATABASE, not in
 * PHP. Merging new code into the repository — or even uploading it to cPanel —
 * does not change the database, so a release that "adds products" adds
 * nothing to the live site until its SQL in database/migrations/ is applied.
 *
 * This model applies those SQL files from the Super Admin dashboard
 * (System → Database Updates), tracks what has run in a `schema_migrations`
 * table, and detects updates that were already imported by hand so the list
 * starts accurate on long-lived installs.
 *
 * Safety
 * ------
 *  - Only files matching database/migrations/NNN_name.sql on disk are ever
 *    executed (never user-supplied SQL).
 *  - Every shipped update is idempotent / safe to re-run; statements that
 *    fail with "duplicate column/key/entry/already exists" are counted as
 *    skipped instead of aborting (they only occur on re-runs).
 *  - Statement splitting is quote-aware and mirrors install/dev-sqlite.php.
 *  - The development SQLite driver is not supported (the files use MySQL
 *    syntax); use install/dev-sqlite.php there instead.
 */
class Schema_update_model extends MY_Model
{
    /** Tracking table. */
    const TABLE = 'schema_migrations';

    /** Relative location of the shipped SQL updates (from the web root). */
    const DIR = 'database/migrations';

    /* ------------------------------------------------------------------ */
    /* Discovery                                                           */
    /* ------------------------------------------------------------------ */

    /** Absolute path of the migrations directory. */
    public function dir()
    {
        return rtrim(FCPATH, '/\\') . '/' . self::DIR;
    }

    /**
     * All shipped update files, keyed by version ('001' …), in version order.
     * Registry metadata (title/description/probe) from config/db_updates.php
     * is merged in; unregistered files still appear with a derived title.
     */
    public function files()
    {
        $this->config->load('db_updates', TRUE);
        $registry = (array) $this->config->item('db_updates', 'db_updates');

        $out = [];
        foreach ((array) glob($this->dir() . '/*.sql') as $path) {
            $base = basename($path);
            if (!preg_match('/^(\d{3})_[a-z0-9_]+\.sql$/', $base, $m)) continue;
            $version = $m[1];
            $meta    = isset($registry[$version]) ? $registry[$version] : [];
            $out[$version] = [
                'version'     => $version,
                'file'        => $base,
                'path'        => $path,
                'title'       => isset($meta['title']) ? $meta['title'] : ucwords(str_replace('_', ' ', substr($base, 4, -4))),
                'description' => isset($meta['description']) ? $meta['description'] : '',
                'probe'       => isset($meta['probe']) ? $meta['probe'] : null,
            ];
        }
        ksort($out);
        return $out;
    }

    /* ------------------------------------------------------------------ */
    /* Tracking table                                                      */
    /* ------------------------------------------------------------------ */

    /** Create the schema_migrations table when missing. TRUE on success. */
    public function ensure_table()
    {
        static $done = false;
        if ($done) return true;
        if ($this->db->table_exists(self::TABLE)) { $done = true; return true; }

        $ok = $this->db->query(
            'CREATE TABLE IF NOT EXISTS `' . self::TABLE . '` (
                `version`    VARCHAR(20)  NOT NULL,
                `name`       VARCHAR(190) NOT NULL DEFAULT \'\',
                `file`       VARCHAR(190) NOT NULL DEFAULT \'\',
                `checksum`   CHAR(32)     NOT NULL DEFAULT \'\',
                `statements` INT          NOT NULL DEFAULT 0,
                `skipped`    INT          NOT NULL DEFAULT 0,
                `source`     VARCHAR(20)  NOT NULL DEFAULT \'runner\',
                `appliedBy`  CHAR(36)     DEFAULT NULL,
                `appliedAt`  DATETIME     NOT NULL,
                PRIMARY KEY (`version`)
            )'
        );
        $done = (bool) $ok;
        return $done;
    }

    /** Tracked rows keyed by version. */
    public function tracked()
    {
        if (!$this->ensure_table()) return [];
        $out = [];
        foreach ($this->db->get(self::TABLE)->result_array() as $row) {
            $out[$row['version']] = $row;
        }
        return $out;
    }

    /* ------------------------------------------------------------------ */
    /* Status                                                              */
    /* ------------------------------------------------------------------ */

    /**
     * Full status list (version order): each shipped file with its state —
     * 'applied', 'pending' or 'unknown' (no probe, never tracked).
     *
     * Legacy databases (installed before the dashboard runner existed) get
     * one automatic probe pass per untracked update; anything the probe
     * proves present is recorded as source='legacy'.
     */
    public function all()
    {
        $this->ensure_table();
        $this->sync_legacy();

        $tracked = $this->tracked();
        $rows    = [];
        foreach ($this->files() as $version => $file) {
            $row = isset($tracked[$version]) ? $tracked[$version] : null;
            $state = $row ? 'applied' : ($file['probe'] ? 'pending' : 'unknown');
            $rows[] = $file + [
                'state'     => $state,
                'appliedAt' => $row ? $row['appliedAt'] : null,
                'source'    => $row ? $row['source'] : null,
                'appliedBy' => $row ? $row['appliedBy'] : null,
                'statements'=> $row ? (int) $row['statements'] : null,
                'skipped'   => $row ? (int) $row['skipped'] : 0,
            ];
        }
        return $rows;
    }

    /** ['count' => n, 'items' => [['version','file','title'], …]] of open updates. */
    public function pending_summary()
    {
        $items = [];
        foreach ($this->all() as $row) {
            if ($row['state'] === 'applied') continue;
            $items[] = [
                'version' => $row['version'],
                'file'    => $row['file'],
                'title'   => $row['title'],
            ];
        }
        return ['count' => count($items), 'items' => $items];
    }

    /**
     * Record updates the probe proves already present (hand-imported in
     * phpMyAdmin, or baked into database/production.sql). Runs on every
     * status read but only issues queries for still-untracked versions.
     */
    public function sync_legacy()
    {
        if (!$this->ensure_table()) return;
        $tracked = $this->tracked();
        foreach ($this->files() as $version => $file) {
            if (isset($tracked[$version]) || !$file['probe']) continue;
            if ($this->probe_applied($file['probe'])) {
                $this->record($version, $file, 0, 0, 'legacy', null);
            }
        }
    }

    /** Evaluate a probe: [type, sql]. Query errors mean "not present". */
    protected function probe_applied($probe)
    {
        list($type, $sql) = $probe;
        $query = $this->db->query($sql);
        if ($query === false) return false;

        switch ($type) {
            case 'exists':
                return true;
            case 'zero':
                $row = $query->row_array();
                return $row && (int) reset($row) === 0;
            case 'positive':
            default:
                $row = $query->row_array();
                return $row && (int) reset($row) > 0;
        }
    }

    /* ------------------------------------------------------------------ */
    /* Applying                                                           */
    /* ------------------------------------------------------------------ */

    /**
     * Apply one shipped SQL file and record it in schema_migrations.
     *
     * @return array {ok: bool, applied: int, skipped: int, error: ?string}
     */
    public function apply($version, $user_id = null)
    {
        if ($this->db->dbdriver === 'sqlite3') {
            return ['ok' => false, 'applied' => 0, 'skipped' => 0,
                'error' => 'The dashboard runner supports MySQL/MariaDB only. '
                    . 'In the development SQLite environment run install/dev-sqlite.php to rebuild the database.'];
        }
        if (!$this->ensure_table()) {
            return ['ok' => false, 'applied' => 0, 'skipped' => 0,
                'error' => 'Could not create the schema_migrations tracking table (check the database user\'s permissions).'];
        }

        $files = $this->files();
        if (!isset($files[$version])) {
            return ['ok' => false, 'applied' => 0, 'skipped' => 0, 'error' => 'Unknown database update "' . $version . '".'];
        }
        $file = $files[$version];

        $sql = file_get_contents($file['path']);
        if ($sql === false) {
            return ['ok' => false, 'applied' => 0, 'skipped' => 0, 'error' => 'Could not read ' . $file['file'] . '.'];
        }

        $applied = 0;
        $skipped = 0;
        foreach ($this->split_statements($sql) as $stmt) {
            if ($this->db->query($stmt) === false) {
                $err = $this->db->error();
                if ($this->is_benign_rerun_error($err)) {
                    $skipped++;
                    continue;
                }
                $message = isset($err['message']) ? $err['message'] : 'unknown error';
                return [
                    'ok'      => false,
                    'applied' => $applied,
                    'skipped' => $skipped,
                    'error'   => 'Statement ' . ($applied + $skipped + 1) . ' failed: '
                        . trim($message) . ' — statement: '
                        . substr(preg_replace('/\s+/', ' ', $stmt), 0, 200),
                ];
            }
            $applied++;
        }

        $this->record($version, $file, $applied, $skipped, 'runner', $user_id);
        return ['ok' => true, 'applied' => $applied, 'skipped' => $skipped, 'error' => null];
    }

    /** Mark an update as applied without running it (already imported by hand). */
    public function mark_applied($version, $user_id = null)
    {
        if (!$this->ensure_table()) {
            return ['ok' => false, 'error' => 'Could not create the schema_migrations tracking table.'];
        }
        $files = $this->files();
        if (!isset($files[$version])) {
            return ['ok' => false, 'error' => 'Unknown database update "' . $version . '".'];
        }
        $this->record($version, $files[$version], 0, 0, 'manual', $user_id);
        return ['ok' => true, 'error' => null];
    }

    /** Insert/replace the tracking row for one update. */
    protected function record($version, array $file, $applied, $skipped, $source, $user_id)
    {
        $this->db->where('version', $version)->delete(self::TABLE);
        $this->db->insert(self::TABLE, [
            'version'    => $version,
            'name'       => $file['title'],
            'file'       => $file['file'],
            'checksum'   => md5_file($file['path']) ?: '',
            'statements' => (int) $applied,
            'skipped'    => (int) $skipped,
            'source'     => $source,
            'appliedBy'  => $user_id ?: null,
            'appliedAt'  => date('Y-m-d H:i:s'),
        ]);
    }

    /**
     * Errors that only ever mean "this statement already ran" — the shipped
     * updates are idempotent, so these are skipped, not fatal.
     */
    protected function is_benign_rerun_error($err)
    {
        $code = isset($err['code']) ? (int) $err['code'] : 0;
        if (in_array($code, [1050, 1051, 1060, 1061, 1062], true)) return true;
        $message = isset($err['message']) ? strtolower($err['message']) : '';
        return (bool) preg_match('/duplicate column|duplicate key|duplicate entry|already exists/i', $message);
    }

    /* ------------------------------------------------------------------ */
    /* SQL statement splitting                                             */
    /* ------------------------------------------------------------------ */

    /**
     * Split a SQL script into statements, respecting quoted strings and
     * -- comments. Mirrors install/dev-sqlite.php::sql_statements() so the
     * dashboard and the dev installer parse files identically.
     */
    public function split_statements($sql)
    {
        $out = [];
        $buf = '';
        $len = strlen($sql);
        $q   = null;
        for ($i = 0; $i < $len; $i++) {
            $c = $sql[$i];
            if ($q !== null) {
                $buf .= $c;
                if ($c === '\\' && $i + 1 < $len) { $buf .= $sql[++$i]; continue; }
                if ($c === $q) $q = null;
                continue;
            }
            if ($c === "'" || $c === '"' || $c === '`') { $q = $c; $buf .= $c; continue; }
            if ($c === '-' && substr($sql, $i, 2) === '--') {
                $nl = strpos($sql, "\n", $i);
                $i  = $nl === false ? $len : $nl;
                continue;
            }
            if ($c === ';') { $out[] = trim($buf); $buf = ''; continue; }
            $buf .= $c;
        }
        if (trim($buf) !== '') $out[] = trim($buf);
        return array_values(array_filter($out, function ($s) { return $s !== ''; }));
    }
}
