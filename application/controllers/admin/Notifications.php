<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Notifications extends Admin_Controller
{
    public function index()
    {
        $this->page_title = 'Notifications';
        $rows = $this->db->where('userId', $this->vp_auth->id())
                         ->order_by('createdAt', 'DESC')
                         ->limit(100)
                         ->get('notifications')->result_array();
        $this->render('admin/notifications/index', ['rows' => $rows]);
    }

    public function read($id = null)
    {
        if (!$id) show_404();
        $this->db->update('notifications', ['read' => 1], ['id' => $id, 'userId' => $this->vp_auth->id()]);
        redirect('admin/notifications');
    }
}
