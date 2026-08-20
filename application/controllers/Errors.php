<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Errors extends MY_Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function not_found()
    {
        $this->output->set_status_header(404);
        $this->page_title = 'Page not found';
        $this->render('errors/404', [], '');
    }

    public function server_error()
    {
        $this->output->set_status_header(500);
        $this->page_title = 'Something went wrong';
        $this->render('errors/500', [], '');
    }
}
