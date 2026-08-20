<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Audit extends Admin_Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index()
    {
        $this->page_title = 'Audit log';
        $user = $this->input->get('userId');
        $action = $this->input->get('action');
        $resource = $this->input->get('resource');
        $page = max(1, (int) $this->input->get('page'));
        $per = 50;
        $this->db->order_by('createdAt', 'DESC');
        if ($user) $this->db->where('userId', $user);
        if ($action) $this->db->where('action', $action);
        if ($resource) $this->db->where('resource', $resource);
        $total = $this->db->count_all_results('audit_logs');
        $this->db->order_by('createdAt', 'DESC')->limit($per, ($page - 1) * $per);
        if ($user) $this->db->where('userId', $user);
        if ($action) $this->db->where('action', $action);
        if ($resource) $this->db->where('resource', $resource);
        $rows = $this->db->get('audit_logs')->result_array();

        $this->render('admin/audit/index', [
            'rows' => $rows,
            'total' => $total,
            'total_pages' => (int) ceil($total / $per),
            'page' => $page,
            'user' => $user,
            'action' => $action,
            'resource' => $resource,
            'base_url' => base_url('admin/audit') . '?' . http_build_query(array_filter(['userId' => $user, 'action' => $action, 'resource' => $resource])) . '&page={page}',
            'users' => $this->db->get('users')->result_array(),
        ]);
    }
}
