<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Users extends Admin_Controller
{
    protected $allowed_roles = [ROLE_SUPER_ADMIN, ROLE_ADMIN];

    public function __construct()
    {
        parent::__construct();
        $this->load->model('User_model');
        $this->load->library('form_validation');
        $this->load->helper(['form', 'url', 'security_helper']);
    }

    public function index()
    {
        $this->page_title = 'Users';
        $search = $this->input->get('q');
        $role = $this->input->get('role');
        $page = max(1, (int) $this->input->get('page'));
        $per = 25;
        $where = [];
        if ($role) $where['role'] = $role;
        $result = $this->User_model->paginate($where, $per, $page, ['createdAt' => 'DESC'], $search, ['email','firstName','lastName','company']);
        $this->render('admin/users/index', [
            'rows' => $result['rows'],
            'total' => $result['total'],
            'total_pages' => $result['total_pages'],
            'page' => $result['page'],
            'search' => $search,
            'role' => $role,
            'base_url' => base_url('admin/users') . '?' . http_build_query(array_filter(['q' => $search, 'role' => $role])) . '&page={page}',
        ]);
    }

    public function create()
    {
        $this->page_title = 'New user';
        $this->form_validation->set_rules('email', 'Email', 'required|valid_email');
        $this->form_validation->set_rules('password', 'Password', 'required|min_length[8]');
        $this->render('admin/users/form', ['row' => null]);
    }

    public function edit($id = null)
    {
        if (!$id) show_404();
        $row = $this->User_model->find($id);
        if (!$row) show_404();
        $this->page_title = 'Edit: ' . trim($row['firstName'] . ' ' . $row['lastName']);
        $this->render('admin/users/form', ['row' => $row]);
    }

    public function save()
    {
        if ($this->input->method() !== 'post') show_404();
        $id = $this->input->post('id');
        $this->form_validation->set_rules('email', 'Email', 'required|valid_email');
        $this->form_validation->set_rules('firstName', 'First name', 'required|max_length[100]');
        $this->form_validation->set_rules('lastName',  'Last name',  'required|max_length[100]');
        $pwd_post = (string) $this->input->post('password');
        if ($pwd_post !== '') {
            $this->form_validation->set_rules('password', 'Password', 'min_length[8]');
        }
        if ($this->form_validation->run() === false) {
            $this->flash('error', trim(validation_errors(' ', ' ')) ?: 'Please correct the errors.');
            return $id ? redirect('admin/users/edit/' . $id) : redirect('admin/users/create');
        }
        $email = strtolower(trim($this->input->post('email')));
        // Uniqueness
        $existing = $this->User_model->find_by_email($email);
        if ($existing && (!$id || $existing['id'] !== $id)) {
            $this->flash('error', 'Email already in use.');
            return $id ? redirect('admin/users/edit/' . $id) : redirect('admin/users/create');
        }
        // If the role field was not posted (e.g. a trimmed-down profile form),
        // keep the existing role instead of silently demoting to CUSTOMER -
        // a demoted staff account is locked out of /admin entirely.
        $role = $this->input->post('role');
        if (($role === null || $role === '') && $id) {
            $current = $this->User_model->find($id);
            $role = $current ? $current['role'] : ROLE_CUSTOMER;
        }
        $data = [
            'email'     => $email,
            'firstName' => $this->input->post('firstName'),
            'lastName'  => $this->input->post('lastName'),
            'phone'     => $this->input->post('phone'),
            'company'   => $this->input->post('company'),
            'role'      => ($role === null || $role === '') ? ROLE_CUSTOMER : $role,
            'isActive'  => (int) $this->input->post('isActive', 1),
        ];
        $pwd = $pwd_post;
        if ($pwd !== '' && strlen($pwd) >= 8) {
            $data['password'] = password_hash($pwd, PASSWORD_BCRYPT);
            // Changing your own password clears the "must change" flag.
            if ($id && $id === $this->vp_auth->id()) {
                $data['mustChangePassword'] = 0;
            }
        }
        if ($id) {
            $this->User_model->update($id, $data);
            $this->audit->log(AUDIT_UPDATE, 'user', $id, ['email' => $email]);
            $this->flash('success', 'Updated.');
            // When you have just changed your own password (which also
            // completes the forced temp-password change), leave the profile
            // form and go to the dashboard instead of looping back onto it.
            if ($id === $this->vp_auth->id() && isset($data['password'])) {
                redirect('admin');
            }
        } else {
            $data['password'] = password_hash($pwd ?: bin2hex(random_bytes(8)), PASSWORD_BCRYPT);
            $id = $this->User_model->insert($data);
            $this->audit->log(AUDIT_CREATE, 'user', $id, ['email' => $email]);
            $this->flash('success', 'User created.');
        }
        redirect('admin/users/edit/' . $id);
    }

    public function delete($id = null)
    {
        if (!$this->vp_auth->has_role(ROLE_SUPER_ADMIN)) {
            show_error('Only Super Admin can delete users.', 403);
        }
        if (!$id) show_404();
        $row = $this->User_model->find($id);
        if (!$row) show_404();
        if ($row['id'] === $this->vp_auth->id()) {
            $this->flash('error', 'You cannot delete your own account.');
            return redirect('admin/users');
        }
        $this->User_model->delete($id);
        $this->audit->log(AUDIT_DELETE, 'user', $id, ['email' => $row['email']]);
        $this->flash('success', 'Deleted.');
        redirect('admin/users');
    }
}
