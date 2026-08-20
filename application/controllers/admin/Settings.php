<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Settings extends Admin_Controller
{
    protected $allowed_roles = [ROLE_SUPER_ADMIN, ROLE_ADMIN];

    public function __construct()
    {
        parent::__construct();
        $this->load->model('Setting_model');
        $this->load->library('settings');
        $this->load->library('form_validation');
        $this->load->helper(['form', 'url']);
    }

    public function index()
    {
        $this->page_title = 'Settings';
        $rows = $this->db->order_by('group', 'ASC')->order_by('sortOrder', 'ASC')->get('settings')->result_array();
        $grouped = [];
        foreach ($rows as $r) $grouped[$r['group']][] = $r;
        $this->render('admin/settings/index', ['grouped' => $grouped]);
    }

    public function save()
    {
        if ($this->input->method() !== 'post') show_404();
        $keys   = (array) $this->input->post('key');
        $values = (array) $this->input->post('value');
        $types  = (array) $this->input->post('type');
        $groups = (array) $this->input->post('group');
        $count = 0;
        foreach ($keys as $i => $k) {
            $k = trim((string) $k);
            if ($k === '') continue;
            $this->settings->set($k, $values[$i] ?? '', $types[$i] ?? 'STRING', $groups[$i] ?? 'GENERAL');
            $count++;
        }
        $this->settings->clear_cache();
        $this->audit->log(AUDIT_UPDATE, 'settings', null, ['count' => $count]);
        $this->flash('success', "Saved $count settings.");
        redirect('admin/settings');
    }
}
