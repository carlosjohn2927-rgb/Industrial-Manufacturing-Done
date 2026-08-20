<?php defined('BASEPATH') OR exit('No direct script access allowed');
class Testimonials extends Admin_Crud
{
    protected $model_name   = 'Testimonial_model';
    protected $redirect_url = 'admin/testimonials';
    protected $list_columns = [
        'Name'    => 'name',
        'Company' => 'company',
        'Rating'  => 'rating',
        'Featured'=> 'featured',
        'Active'  => 'isActive',
    ];
    protected $search_fields = ['name','title','company','content','industry'];
}
