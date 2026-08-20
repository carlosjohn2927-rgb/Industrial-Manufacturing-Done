<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Media extends Admin_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('Media_model');
        $this->load->library(['vp_upload']);
        $this->load->helper(['form', 'url', 'security_helper']);
    }

    public function index()
    {
        $this->page_title = 'Media';
        $folder = $this->input->get('folder');
        $page = max(1, (int) $this->input->get('page'));
        $per = 48;
        $where = [];
        if ($folder) $where['folder'] = $folder;
        $result = $this->Media_model->paginate($where, $per, $page, ['createdAt' => 'DESC']);
        $this->render('admin/media/index', [
            'rows' => $result['rows'],
            'total' => $result['total'],
            'total_pages' => $result['total_pages'],
            'page' => $result['page'],
            'folder' => $folder,
            'base_url' => base_url('admin/media') . '?' . http_build_query(['folder' => $folder]) . '&page={page}',
        ]);
    }

    public function upload()
    {
        if ($this->input->method() !== 'post') show_404();
        $folder = $this->input->post('folder') ?: 'general';
        // SVG deliberately excluded: SVG can carry scripts and would be an
        // XSS vector when opened directly. Logos should be served from
        // assets/img (code-reviewed, static files).
        $result = $this->vp_upload->handle('file', $folder, 'jpg|jpeg|png|webp|gif|pdf|doc|docx|xls|xlsx|zip', 16384);
        if (is_array($result) && empty($result['error'])) {
            $id = $this->Media_model->insert([
                'filename'     => $result['filename'],
                'originalName' => $result['name'],
                'url'          => $result['url'],
                'mimeType'     => $result['mime'],
                'size'         => $result['size'],
                'folder'       => $result['folder'],
            ]);
            $this->vp_upload->resize_image($result['path'], 1600);
            $this->audit->log(AUDIT_CREATE, 'media', $id, ['name' => $result['name']]);
            $this->flash('success', 'Uploaded.');
        } else {
            $this->flash('error', is_array($result) ? $result['error'] : 'Upload failed.');
        }
        redirect('admin/media?folder=' . urlencode($folder));
    }

    public function delete($id = null)
    {
        if (!$id) show_404();
        $row = $this->Media_model->find($id);
        if (!$row) show_404();
        $path = VP_UPLOAD_PATH . $row['folder'] . '/' . $row['filename'];
        if (is_file($path)) @unlink($path);
        $this->Media_model->delete($id);
        $this->audit->log(AUDIT_DELETE, 'media', $id, ['name' => $row['originalName']]);
        $this->flash('success', 'Deleted.');
        redirect('admin/media?folder=' . urlencode($row['folder']));
    }
}
