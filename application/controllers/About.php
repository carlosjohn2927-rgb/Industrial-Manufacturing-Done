
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class About extends MY_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model(['Testimonial_model', 'Partner_model', 'Setting_model']);
    }

    public function index()
    {
        $this->page_title = 'About Vortex Precision';
        $this->page_description = $vp_settings['site_tagline'] ?? 'About Vortex Precision - industrial manufacturing excellence.';

        $data = [
            'intro'       => $vp_settings['about_intro'] ?? '',
            'testimonials'=> $this->Testimonial_model->find_all(['isActive' => 1], ['createdAt' => 'DESC'], 6),
            'partners'    => $this->Partner_model->find_all(['isActive' => 1], ['sortOrder' => 'ASC'], 12),
        ];
        $this->render('about/index', $data);
    }
}