<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Categories extends Admin_Crud
{
    /** Permission enforced server-side for every action (see Admin_Controller). */
    protected $required_permission = 'categories.manage';

    protected $model_name   = 'Category_model';
    protected $view_prefix  = 'categories';
    protected $redirect_url = 'admin/categories';
    protected $order_by     = ['sortOrder' => 'ASC', 'name' => 'ASC'];
    protected $list_columns = [
        'Order'        => 'sortOrder',
        'Name'         => 'name',
        'Slug'         => 'slug',
        'Active'       => 'isActive',
        'Created'      => 'createdAt',
    ];
    protected $search_fields = ['name','slug','description'];

    protected function _form()
    {
        $this->form_validation->set_rules('name', 'Name', 'required|max_length[190]');
        $this->form_validation->set_rules('slug', 'Slug', 'max_length[190]');
        $this->form_validation->set_rules('description', 'Description', 'max_length[65535]');
        $this->form_validation->set_rules('icon', 'Icon', 'max_length[190]');
        $this->form_validation->set_rules('image', 'Image', 'max_length[255]');
        $this->form_validation->set_rules('parentId', 'Parent category', 'max_length[36]');
        $this->form_validation->set_rules('sortOrder', 'Sort order', 'integer');
        $this->form_validation->set_rules('metaTitle', 'Meta title', 'max_length[255]');
        $this->form_validation->set_rules('metaDescription', 'Meta description', 'max_length[500]');
    }

    /** Dropdown options for the "Parent category" field (a category can't be its own parent). */
    protected function _form_data($row = null)
    {
        $where = [];
        if (!empty($row['id'])) {
            $where = ['id !=' => $row['id']];
        }
        return [
            'parent_options' => $this->M()->find_all($where, ['sortOrder' => 'ASC', 'name' => 'ASC']),
        ];
    }

    /** Collect every editable field (the generic _collect_post only covers list columns). */
    protected function _collect_post()
    {
        $data = parent::_collect_post(); // name, slug, sortOrder, isActive

        foreach (['description', 'icon', 'image', 'metaTitle', 'metaDescription'] as $field) {
            $val = $this->input->post($field);
            if ($val !== null) {
                $data[$field] = trim($val);
            }
        }

        // Parent: empty string = top-level category (NULL in the database).
        $parent = trim((string) $this->input->post('parentId'));
        if ($parent !== '') {
            $pRow = $this->_find_row($parent);
            $data['parentId'] = $pRow ? $pRow['id'] : $parent;
        } else {
            $data['parentId'] = null;
        }

        // Slug: fall back to the name, then make sure it stays unique so the
        // database's uk_categories_slug index can never reject the save.
        $slug = trim((string) ($data['slug'] ?? ''));
        if ($slug === '') {
            $slug = vp_slugify((string) ($data['name'] ?? 'category'));
        }
        $data['slug'] = $this->_unique_slug($slug, $this->input->post('id'));

        return $data;
    }

    /** Append -2, -3, … while the slug is already used by another category. */
    protected function _unique_slug($slug, $ignoreId = null)
    {
        $base = $slug !== '' ? $slug : 'category';
        $candidate = $base;
        $n = 2;
        while ($this->_slug_taken($candidate, $ignoreId)) {
            $candidate = $base . '-' . $n++;
        }
        return $candidate;
    }

    protected function _slug_taken($slug, $ignoreId = null)
    {
        // Resolve the id before starting the query. _find_row() executes its
        // own query and resets CodeIgniter's query builder; doing that after
        // where('slug', ...) silently dropped the slug condition. On an edit
        // the old code therefore saw any other category as a collision and
        // kept adding suffixes forever, leaving the request hanging (and the
        // site appearing to stop loading after Save).
        $realId = null;
        if ($ignoreId) {
            $row = $this->_find_row($ignoreId);
            $realId = $row ? $row['id'] : $ignoreId;
        }

        $this->db->where('slug', $slug);
        if ($realId) {
            $this->db->where('id !=', $realId);
        }
        return (bool) $this->db->get('categories')->row_array();
    }
}
