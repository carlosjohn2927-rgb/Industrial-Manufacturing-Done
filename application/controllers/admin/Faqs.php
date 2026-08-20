<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Faqs extends Admin_Crud
{
    protected $model_name   = 'Faq_model';
    protected $redirect_url = 'admin/faqs';
    protected $order_by     = ['category' => 'ASC', 'sortOrder' => 'ASC'];
    protected $list_columns = [
        'Category' => 'category',
        'Order'    => 'sortOrder',
        'Question' => 'question',
        'Active'   => 'isActive',
    ];
    protected $search_fields = ['question','answer','category'];
}
