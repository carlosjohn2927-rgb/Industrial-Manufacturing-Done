<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - requires login + staff role (admin/sales/etc).
 * Subclasses set $allowed_roles to further restrict.
 */
class Admin_Controller extends Auth_Controller
{
    /** @var array Roles allowed to access the controller. Empty = any staff role. */
    protected $allowed_roles = [];

    public function __construct()
    {
        parent::__construct();

        $this->layout = 'admin';
        $this->body_class = 'admin';

        if (!$this->vp_auth->is_staff()) {
            show_error('You do not have permission to access the admin area.', 403);
        }

        // Temporary passwords (created by install/install.php without
        // VP_ADMIN_PASSWORD) must be changed before anything else.
        // users/edit + users/save are the only pages allowed so the user
        // can actually perform the change (plus logout).
        //
        // This check MUST run before the allowed_roles gate: otherwise a
        // SALES/EDITOR/ENGINEER account with a temporary password gets a 403
        // on the very page it is redirected to and can never get in at all.
        if ($this->vp_auth->must_change_password()) {
            $uri = strtolower((string) $this->uri->ruri_string());
            $allowed = strpos($uri, 'admin/users/edit/' . $this->vp_auth->id()) === 0
                || strpos($uri, 'admin/users/save') === 0
                || strpos($uri, 'auth/admin_logout') !== false
                || strpos($uri, 'auth/logout') !== false;
            if (!$allowed) {
                $this->flash('warning', 'You must change your temporary password before continuing.');
                redirect('admin/users/edit/' . $this->vp_auth->id());
            }
            return; // skip role gating for the forced password change itself
        }

        if (!empty($this->allowed_roles) && !$this->vp_auth->has_any_role($this->allowed_roles)) {
            show_error('You do not have permission to access this section.', 403);
        }
    }
}
