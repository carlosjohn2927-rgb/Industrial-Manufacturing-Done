<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - public home page.
 */
class Home extends MY_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model(['Category_model', 'Product_model', 'Industry_model', 'Testimonial_model', 'Partner_model', 'Setting_model']);
    }

    public function index()
    {
        $this->page_title       = 'Industrial Manufacturing Excellence';
        $this->page_description = 'Vortex Precision designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems for the world\'s most demanding operators.';

        $data = [
            // attach_images() adds imageUrl/categorySlug so the cards render
            // real product photos rather than the generic placeholder.
            'featured'    => $this->Product_model->attach_images(
                $this->Product_model->find_all(['isActive' => 1, 'featured' => 1], ['views' => 'DESC', 'createdAt' => 'DESC'], 4)
            ),
            'industries'  => $this->Industry_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 6),
            'testimonials'=> $this->Testimonial_model->find_all(['isActive' => 1, 'featured' => 1], ['createdAt' => 'DESC'], 4),
            'partners'    => $this->Partner_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 12),
            'categories'  => $this->Category_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 6),
        ];

        $this->render('home/index', $data);
    }
}
