<?php defined('BASEPATH') OR exit('No direct script access allowed');

/** Manage customer testimonials displayed by the Testimonials page block. */
class Testimonials extends Admin_Controller
{
    protected $required_permission = 'testimonials.manage';

    public function __construct()
    {
        parent::__construct();
        $this->load->model('Testimonial_model');
        $this->load->library('form_validation');
        $this->load->helper(['form', 'url', 'security_helper']);
    }

    public function index()
    {
        $this->page_title = 'Testimonials';
        $search = trim((string) $this->input->get('q'));
        $page = max(1, (int) $this->input->get('page'));
        $result = $this->Testimonial_model->paginate([], 25, $page, ['featured' => 'DESC', 'createdAt' => 'DESC'], $search, ['name', 'title', 'company', 'content', 'industry']);

        $this->render('admin/testimonials/index', [
            'rows' => $result['rows'],
            'total_pages' => $result['total_pages'],
            'page' => $result['page'],
            'search' => $search,
            'base_url' => base_url('admin/testimonials') . '?' . http_build_query(array_filter(['q' => $search])) . '&page={page}',
        ]);
    }

    public function create()
    {
        $this->page_title = 'New testimonial';
        $this->render('admin/testimonials/form', ['row' => null]);
    }

    public function edit($id = null)
    {
        $row = $id ? $this->Testimonial_model->find($id) : null;
        if (!$row) show_404();
        $this->page_title = 'Edit testimonial: ' . $row['name'];
        $this->render('admin/testimonials/form', ['row' => $row]);
    }

    public function save()
    {
        if ($this->input->method() !== 'post') show_404();
        $id = $this->input->post('id');
        $this->form_validation->set_rules('name', 'Name', 'required|max_length[190]');
        $this->form_validation->set_rules('title', 'Job title', 'required|max_length[190]');
        $this->form_validation->set_rules('company', 'Company', 'required|max_length[190]');
        $this->form_validation->set_rules('content', 'Testimonial', 'required');
        $this->form_validation->set_rules('rating', 'Rating', 'required|integer|greater_than_equal_to[1]|less_than_equal_to[5]');

        if (!$this->form_validation->run()) {
            $this->flash('error', 'Please complete the required fields. Rating must be between 1 and 5.');
            return $id ? redirect('admin/testimonials/edit/' . $id) : redirect('admin/testimonials/create');
        }

        $data = [
            'name'     => trim((string) $this->input->post('name')),
            'title'    => trim((string) $this->input->post('title')),
            'company'  => trim((string) $this->input->post('company')),
            'content'  => trim((string) $this->input->post('content')),
            'rating'   => (int) $this->input->post('rating'),
            'avatar'   => trim((string) $this->input->post('avatar')),
            'industry' => trim((string) $this->input->post('industry')),
            'featured' => (int) $this->input->post('featured', 0),
            'isActive' => (int) $this->input->post('isActive', 0),
        ];

        if ($id) {
            if (!$this->Testimonial_model->find($id)) show_404();
            $this->Testimonial_model->update($id, $data);
            $this->audit->log(AUDIT_UPDATE, 'testimonial', $id, ['name' => $data['name']]);
            $this->flash('success', 'Testimonial updated.');
        } else {
            $id = $this->Testimonial_model->insert($data);
            $this->audit->log(AUDIT_CREATE, 'testimonial', $id, ['name' => $data['name']]);
            $this->flash('success', 'Testimonial created.');
        }
        redirect('admin/testimonials/edit/' . $id);
    }

    public function delete($id = null)
    {
        $row = $id ? $this->Testimonial_model->find($id) : null;
        if (!$row) show_404();
        $this->Testimonial_model->delete($id);
        $this->audit->log(AUDIT_DELETE, 'testimonial', $id, ['name' => $row['name']]);
        $this->flash('success', 'Testimonial deleted.');
        redirect('admin/testimonials');
    }
}
