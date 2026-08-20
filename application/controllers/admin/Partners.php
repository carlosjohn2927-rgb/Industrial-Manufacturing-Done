<?php defined('BASEPATH') OR exit('No direct script access allowed');
class Partners extends Admin_Crud
{
    protected $model_name   = 'Partner_model';
    protected $redirect_url = 'admin/partners';
    protected $order_by     = ['sortOrder' => 'ASC', 'name' => 'ASC'];
    protected $list_columns = [
        'Order'  => 'sortOrder',
        'Name'   => 'name',
        'Website'=> 'website',
        'Active' => 'isActive',
    ];
    protected $search_fields = ['name','category','website'];
}
