<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - admin products CRUD.
 */
class Products extends Admin_Controller
{
    /** Permission enforced server-side for every action (see Admin_Controller). */
    protected $required_permission = 'products.manage';


    public function __construct()
    {
        parent::__construct();
        $this->load->model(['Product_model', 'Category_model', 'Industry_model', 'Product_image_model', 'Specification_model', 'Product_download_model', 'Related_product_model']);
        $this->load->library('vp_upload');
        $this->load->helper(['form', 'url', 'security_helper']);
    }

    public function index()
    {
        $this->page_title = 'Products';
        $search = $this->input->get('q');
        $cat    = $this->input->get('category');
        $page   = max(1, (int) $this->input->get('page'));
        $per    = 25;

        $where = [];
        if ($cat) {
            $c = $this->Category_model->find_one(['slug' => $cat]);
            if ($c) $where['categoryId'] = $c['id'];
        }
        $result = $this->Product_model->paginate($where, $per, $page, ['createdAt' => 'DESC'], $search, ['name','sku','shortDescription','description']);

        $this->render('admin/products/index', [
            'rows' => $this->Product_model->attach_images($result['rows']),
            'total' => $result['total'],
            'total_pages' => $result['total_pages'],
            'page' => $result['page'],
            'search' => $search,
            'categories' => $this->Category_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 50),
            'current_category' => $cat,
            'base_url' => base_url('admin/products') . '?' . http_build_query(array_filter(['q' => $search, 'category' => $cat])) . '&page={page}',
        ]);
    }

    public function create()
    {
        $this->page_title = 'New product';
        $this->_form();
        $this->render('admin/products/form', [
            'product' => null,
            'industries' => $this->Industry_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 50),
            'categories' => $this->Category_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 50),
            'all_products' => $this->Product_model->find_all(['isActive' => 1], ['name' => 'ASC'], 200),
            'selected_industries' => [],
            'selected_related' => [],
            'certifications_csv' => '',
            'specs_rows' => [],
        ]);
    }

    public function edit($id = null)
    {
        if (!$id) show_404();
        $p = $this->Product_model->find($id);
        if (!$p) show_404();
        $this->page_title = 'Edit: ' . $p['name'];
        $this->_form();

        $specs = $this->Specification_model->find_all(['productId' => $p['id']], ['sortOrder' => 'ASC']);
        $sel_inds = $p['industryIds'] ? json_decode($p['industryIds'], true) : [];
        $certs    = $p['certifications'] ? json_decode($p['certifications'], true) : [];
        $related  = $this->db->select('relatedId')->get_where('related_products', ['productId' => $p['id']])->result_array();
        $sel_rel = array_column($related, 'relatedId');

        $this->render('admin/products/form', [
            'product' => $p,
            'industries' => $this->Industry_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 50),
            'categories' => $this->Category_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 50),
            'all_products' => $this->Product_model->find_all(['isActive' => 1, 'id !=' => $p['id']], ['name' => 'ASC'], 200),
            'selected_industries' => $sel_inds,
            'selected_related' => $sel_rel,
            'certifications_csv' => implode(', ', $certs),
            'specs_rows' => $specs,
        ]);
    }

    public function delete($id = null)
    {
        if (!$id) show_404();
        $p = $this->Product_model->find($id);
        if (!$p) show_404();
        $this->Product_model->delete($id);
        $this->audit->log(AUDIT_DELETE, 'product', $id, ['name' => $p['name']]);
        $this->flash('success', 'Product deleted.');
        redirect('admin/products');
    }

    /**
     * POST /admin/products/{productId}/images/{imageId}/delete
     * Delete a single product image.
     */
    public function image_delete($productId = null, $imageId = null)
    {
        if (!$productId || !$imageId) show_404();
        $img = $this->Product_image_model->find($imageId);
        if (!$img || $img['productId'] !== $productId) show_404();
        // Remove the file from disk
        $abs = FCPATH . $img['url'];
        if ($img['url'] && is_file($abs)) @unlink($abs);
        $wasPrimary = (int) $img['isPrimary'];
        $this->Product_image_model->delete($imageId);
        // If we just deleted the primary, promote the next image
        if ($wasPrimary) {
            $next = $this->db->where('productId', $productId)
                             ->order_by('sortOrder', 'ASC')
                             ->order_by('createdAt', 'ASC')
                             ->limit(1)
                             ->get('product_images')->row_array();
            if ($next) {
                $this->Product_image_model->update($next['id'], ['isPrimary' => 1]);
            }
        }
        $this->audit->log(AUDIT_DELETE, 'product_image', $imageId, ['productId' => $productId]);
        $this->flash('success', 'Image deleted.');
        redirect('admin/products/edit/' . $productId);
    }

    /**
     * POST /admin/products/{productId}/images/{imageId}/primary
     * Mark an image as the primary one for the product.
     */
    public function image_primary($productId = null, $imageId = null)
    {
        if (!$productId || !$imageId) show_404();
        $img = $this->Product_image_model->find($imageId);
        if (!$img || $img['productId'] !== $productId) show_404();
        $this->db->update('product_images', ['isPrimary' => 0], ['productId' => $productId]);
        $this->Product_image_model->update($imageId, ['isPrimary' => 1]);
        $this->audit->log(AUDIT_UPDATE, 'product_image', $imageId, ['productId' => $productId, 'isPrimary' => 1]);
        $this->flash('success', 'Primary image updated.');
        redirect('admin/products/edit/' . $productId);
    }

    /**
     * Normalise the $_FILES multi-upload into an array of upload results.
     * @return array  Each entry is the same shape as Upload::handle(), or ['error' => ...]
     */
    private function _collect_uploads($field, $folder)
    {
        if (empty($_FILES[$field]) || !isset($_FILES[$field]['name'])) return [];
        $names = (array) $_FILES[$field]['name'];
        $results = [];
        $count = count($names);
        for ($i = 0; $i < $count; $i++) {
            if (empty($names[$i])) continue;
            if (($_FILES[$field]['error'][$i] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) continue;
            // Re-shape into a single-file $_FILES entry
            $entry = [
                'name'     => $_FILES[$field]['name'][$i],
                'type'     => $_FILES[$field]['type'][$i],
                'tmp_name' => $_FILES[$field]['tmp_name'][$i],
                'error'    => $_FILES[$field]['error'][$i],
                'size'     => $_FILES[$field]['size'][$i],
            ];
            // Re-key the global to match this single-file, then call the library, then restore
            $original = $_FILES;
            $_FILES = [$field => $entry];
            $r = $this->vp_upload->handle($field, $folder, 'jpg|jpeg|png|webp|gif', 8192);
            $_FILES = $original;
            if (is_array($r) && empty($r['error'])) $results[] = $r;
        }
        return $results;
    }

    private function _form()
    {
        $this->load->library('form_validation');
        $this->form_validation->set_rules('name', 'Name', 'required|max_length[255]');
        $this->form_validation->set_rules('sku',  'SKU',  'required|max_length[100]');
        $this->form_validation->set_rules('description', 'Description', 'required');
    }

    public function save()
    {
        $id = $this->input->post('id');
        $is_create = empty($id);
        if ($is_create) {
            $this->form_validation->set_rules('name', 'Name', 'required|max_length[255]');
            $this->form_validation->set_rules('sku',  'SKU',  'required|max_length[100]');
            $this->form_validation->set_rules('description', 'Description', 'required');
        }
        if ($this->form_validation->run() === false) {
            $this->flash('error', 'Please fix the highlighted errors.');
            return $is_create ? redirect('admin/products/create') : redirect('admin/products/edit/' . $id);
        }

        $data = [
            'name'             => $this->input->post('name'),
            'slug'             => $this->input->post('slug') ?: vp_slugify($this->input->post('name')),
            'sku'              => $this->input->post('sku'),
            'description'      => $this->input->post('description'),
            'shortDescription' => $this->input->post('shortDescription'),
            'price'            => $this->input->post('price') ?: null,
            'categoryId'       => $this->input->post('categoryId') ?: null,
            'material'         => $this->input->post('material'),
            'pressure'         => $this->input->post('pressure'),
            'temperature'      => $this->input->post('temperature'),
            'voltage'          => $this->input->post('voltage'),
            'dimensions'       => $this->input->post('dimensions'),
            'weight'           => $this->input->post('weight'),
            'availability'     => $this->input->post('availability') ?: 'IN_STOCK',
            'featured'         => (int) $this->input->post('featured'),
            'isActive'         => (int) $this->input->post('isActive', 1),
            'metaTitle'        => $this->input->post('metaTitle'),
            'metaDescription'  => $this->input->post('metaDescription'),
        ];
        $inds = (array) $this->input->post('industries');
        $data['industryIds'] = json_encode($inds);
        $certs = array_filter(array_map('trim', explode(',', (string) $this->input->post('certifications_csv'))));
        $data['certifications'] = json_encode(array_values($certs));
        $data['metaKeywords'] = json_encode(array_filter(array_map('trim', explode(',', (string) $this->input->post('metaKeywords')))));

        if ($is_create) {
            $new_id = $this->Product_model->insert($data);
            $this->audit->log(AUDIT_CREATE, 'product', $new_id, ['name' => $data['name']]);
            $id = $new_id;
            $this->flash('success', 'Product created.');
        } else {
            $this->Product_model->update($id, $data);
            $this->audit->log(AUDIT_UPDATE, 'product', $id, ['name' => $data['name']]);
            $this->flash('success', 'Product updated.');
        }

        // Image upload (multi-file). If the product has no images yet, the first one becomes primary.
        $hasPrimary = (int) $this->db->where('productId', $id)->where('isPrimary', 1)
                                     ->count_all_results('product_images');
        $newFiles = $this->_collect_uploads('images', 'products');
        foreach ($newFiles as $idx => $file) {
            $this->Product_image_model->insert([
                'productId' => $id,
                'url'       => $file['url'],
                'alt'       => $data['name'],
                'isPrimary' => (!$hasPrimary && $idx === 0) ? 1 : 0,
                'sortOrder'     => 999 + $idx,
            ]);
            $this->vp_upload->resize_image($file['path'], 1600);
        }

        // Specifications
        $this->db->delete('specifications', ['productId' => $id]);
        $keys   = (array) $this->input->post('spec_key');
        $values = (array) $this->input->post('spec_value');
        $units  = (array) $this->input->post('spec_unit');
        foreach ($keys as $i => $k) {
            $k = trim((string) $k);
            $v = trim((string) ($values[$i] ?? ''));
            if ($k === '' || $v === '') continue;
            $this->Specification_model->insert([
                'productId' => $id,
                'key'       => $k,
                'value'     => $v,
                'unit'      => trim((string) ($units[$i] ?? '')) ?: null,
                'sortOrder'     => $i,
            ]);
        }

        // Related products
        $this->db->delete('related_products', ['productId' => $id]);
        $related = (array) $this->input->post('related');
        foreach ($related as $rid) {
            if (!$rid || $rid === $id) continue;
            $this->db->insert('related_products', ['id' => MY_Model::uuid(), 'productId' => $id, 'relatedId' => $rid]);
        }

        redirect('admin/products/edit/' . $id);
    }
}
