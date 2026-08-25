<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Search extends MY_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('Product_model');
    }

    public function index()
    {
        $q = trim((string) $this->input->get('q'));
        $this->page_title = $q ? "Search: $q" : 'Search';
        $this->page_description = 'Search Vortex Precision products, blog posts, downloads and FAQs.';

        $products = [];
        $posts = [];
        $faqs = [];

        if ($q !== '') {
            $products = $this->db->group_start()
                                 ->like('name', $q)->or_like('description', $q)->or_like('shortDescription', $q)->or_like('sku', $q)
                                 ->group_end()
                                 ->where('isActive', 1)->order_by('createdAt', 'DESC')->limit(24)
                                 ->get('products')->result_array();
            $products = $this->Product_model->attach_images($products);
            $posts = $this->db->group_start()
                             ->like('title', $q)->or_like('content', $q)->or_like('excerpt', $q)
                             ->group_end()
                             ->where('status', 'PUBLISHED')->order_by('publishedAt', 'DESC')->limit(12)
                             ->get('blog_posts')->result_array();
            $faqs = $this->db->group_start()
                            ->like('question', $q)->or_like('answer', $q)
                            ->group_end()
                            ->where('isActive', 1)->limit(12)
                            ->get('faqs')->result_array();
        }

        $this->render('search/index', [
            'q' => $q,
            'products' => $products,
            'posts' => $posts,
            'faqs' => $faqs,
        ]);
    }

    /**
     * AJAX endpoint: return up to 8 matching products as JSON for the header
     * search overlay live suggestions.
     *
     * GET /search/ajax?q=term
     */
    public function ajax()
    {
        // Only respond to AJAX requests.
        if (!$this->input->is_ajax_request()) {
            show_404();
        }

        $q = trim((string) $this->input->get('q'));
        $results = [];

        if ($q !== '' && mb_strlen($q) >= 2) {
            $rows = $this->db->group_start()
                             ->like('name', $q)
                             ->or_like('shortDescription', $q)
                             ->or_like('description', $q)
                             ->or_like('sku', $q)
                             ->or_like('material', $q)
                             ->group_end()
                             ->where('isActive', 1)
                             ->order_by('featured', 'DESC')
                             ->order_by('createdAt', 'DESC')
                             ->limit(8)
                             ->get('products')
                             ->result_array();

            $rows = $this->Product_model->attach_images($rows);

            foreach ($rows as $r) {
                $img = function_exists('vp_product_image') ? vp_product_image($r) : '';
                $results[] = [
                    'name'  => $r['name'],
                    'sku'   => $r['sku'] ?? '',
                    'slug'  => $r['slug'],
                    'desc'  => function_exists('vp_truncate') ? vp_truncate($r['shortDescription'] ?? $r['description'] ?? '', 90) : '',
                    'image' => $img,
                    'url'   => base_url('products/' . $r['slug']),
                ];
            }
        }

        $this->output
             ->set_content_type('application/json')
             ->set_output(json_encode([
                 'q'       => $q,
                 'results' => $results,
                 'count'   => count($results),
             ]));
    }
}
