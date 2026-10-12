<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision IT — shipped SQL database updates.
 *
 * Super Admin only. Applying new code (git merge / cPanel upload) never
 * changes the database by itself: catalog data and schema live in MySQL and
 * arrive through the SQL files in database/migrations/. This screen shows
 * which of those updates are already in the database and applies the rest
 * with one click — no phpMyAdmin, no terminal.
 */
class Updates extends Admin_Controller
{
    /** Running SQL against the database is reserved for the Super Admin. */
    protected $super_admin_only    = true;
    protected $required_permission = 'system.manage';

    public function __construct()
    {
        parent::__construct();
        $this->load->model('Schema_update_model');
    }

    /* ---------------- List ------------------------------------------- */

    public function index()
    {
        $this->page_title = 'Database updates';

        $updates = $this->Schema_update_model->all();
        $pending = 0;
        foreach ($updates as &$u) {
            if ($u['state'] !== 'applied') $pending++;
            $sql = file_get_contents($u['path']);
            $u['stmt_total'] = $sql === false ? 0 : count($this->Schema_update_model->split_statements($sql));
        }
        unset($u);

        $this->render('admin/updates/index', [
            'updates'      => $updates,
            'pending'      => $pending,
            'driver'       => $this->db->dbdriver,
            'can_run'      => $this->db->dbdriver !== 'sqlite3',
            'table_ok'     => $this->Schema_update_model->ensure_table(),
        ]);
    }

    /* ---------------- Apply ------------------------------------------ */

    /** Apply one update. POST only. */
    public function apply($version = '')
    {
        if ($this->input->method() !== 'post') show_404();
        if (!preg_match('/^\d{3}$/', (string) $version)) show_404();

        $result = $this->Schema_update_model->apply($version, $this->vp_auth->id());

        if ($result['ok']) {
            $this->audit->log('DB_UPDATE_APPLIED', 'system', $version, [
                'file'      => $version,
                'applied'   => $result['applied'],
                'skipped'   => $result['skipped'],
            ]);
            $this->flash('success', 'Database update ' . $version . ' applied ('
                . $result['applied'] . ' statement(s)'
                . ($result['skipped'] ? ', ' . $result['skipped'] . ' already in place' : '') . ').');
        } else {
            $this->audit->log('DB_UPDATE_FAILED', 'system', $version, ['error' => (string) $result['error']]);
            $this->flash('error', 'Database update ' . $version . ' failed — ' . $result['error']);
        }
        redirect('admin/updates');
    }

    /** Apply every pending update in version order. POST only. */
    public function apply_all()
    {
        if ($this->input->method() !== 'post') show_404();

        if ($this->db->dbdriver === 'sqlite3') {
            $this->flash('error', 'The dashboard runner supports MySQL/MariaDB only. In the development SQLite environment run install/dev-sqlite.php.');
            redirect('admin/updates');
        }

        $done = 0;
        foreach ($this->Schema_update_model->all() as $row) {
            if ($row['state'] === 'applied') continue;

            $result = $this->Schema_update_model->apply($row['version'], $this->vp_auth->id());
            if (!$result['ok']) {
                $this->audit->log('DB_UPDATE_FAILED', 'system', $row['version'], ['error' => (string) $result['error']]);
                $this->flash('error', 'Stopped after ' . $done . ' update(s): ' . $row['file'] . ' failed — ' . $result['error']);
                redirect('admin/updates');
                return;
            }
            $this->audit->log('DB_UPDATE_APPLIED', 'system', $row['version'], [
                'applied' => $result['applied'],
                'skipped' => $result['skipped'],
            ]);
            $done++;
        }

        $this->flash('success', $done ? $done . ' database update(s) applied.' : 'Everything is already up to date.');
        redirect('admin/updates');
    }

    /* ---------------- Mark as applied -------------------------------- */

    /** Record one update as applied without running it. POST only. */
    public function mark($version = '')
    {
        if ($this->input->method() !== 'post') show_404();
        if (!preg_match('/^\d{3}$/', (string) $version)) show_404();

        $result = $this->Schema_update_model->mark_applied($version, $this->vp_auth->id());
        if ($result['ok']) {
            $this->audit->log('DB_UPDATE_MARKED', 'system', $version);
            $this->flash('success', 'Database update ' . $version . ' marked as applied.');
        } else {
            $this->flash('error', (string) $result['error']);
        }
        redirect('admin/updates');
    }

    /** Record every untracked update as applied without running it. POST only. */
    public function mark_all()
    {
        if ($this->input->method() !== 'post') show_404();

        $done = 0;
        foreach ($this->Schema_update_model->all() as $row) {
            if ($row['state'] === 'applied') continue;
            $this->Schema_update_model->mark_applied($row['version'], $this->vp_auth->id());
            $this->audit->log('DB_UPDATE_MARKED', 'system', $row['version']);
            $done++;
        }
        $this->flash('success', $done ? $done . ' database update(s) marked as applied.' : 'Everything is already recorded.');
        redirect('admin/updates');
    }
}
