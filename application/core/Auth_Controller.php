<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - requires the user to be logged in.
 */
class Auth_Controller extends MY_Controller
{
    public function __construct()
    {
        parent::__construct();
        if (!$this->vp_auth->check()) {
            $this->flash('warning', 'Please log in to continue.');
            $back = urlencode(current_url());
            redirect('login?next=' . $back);
        }
    }
}
