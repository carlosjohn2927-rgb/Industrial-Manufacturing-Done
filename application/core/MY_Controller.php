<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - base controller.
 * - Loads shared view data (site_name, meta, user, etc).
 * - Provides render() to wrap content in a layout.
 */
class MY_Controller extends CI_Controller
{
    /** @var string Page title set by child controllers */
    protected $page_title = '';

    /** @var string Page meta description */
    protected $page_description = '';

    /** @var string Layout name ('public' or 'admin') */
    protected $layout = 'public';

    /** @var array Body class hooks for the layout */
    protected $body_class = '';

    /** @var array Data bag passed to views */
    protected $data = [];

    public function __construct()
    {
        parent::__construct();

        // Always have the language file loaded
        $this->lang->load('app_lang');

        // Per-request CSP nonce so JSON-LD structured data (and any future
        // inline script) can be allowed without opening up 'unsafe-inline'.
        $csp_nonce = bin2hex(random_bytes(16));
        $this->_set_security_headers($csp_nonce);

        // Global view data
        $this->data = [
            'site_name'        => $this->config->item('site_name') ?: 'Halyk Petroleum',
            'site_tagline'     => $this->config->item('site_tagline'),
            'contact'          => [
                'email'   => $this->config->item('contact_email'),
                'phone'   => $this->config->item('phone'),
                'address' => $this->config->item('address'),
            ],
            'social'           => $this->config->item('social'),
            'current_user'     => $this->vp_auth->user(),
            'is_admin'         => $this->vp_auth->check() && $this->vp_auth->is_staff(),
            'page_title'       => '',
            'page_description' => '',
            'body_class'       => '',
            'flash'            => $this->_get_flash(),
            'csrf_token_name'  => $this->config->item('csrf_token_name'),
            'csrf_token'       => $this->security->get_csrf_hash(),
            'current_url'      => current_url(),
            'vp_settings'      => $this->settings ? $this->settings->all() : [],
            'seo'              => vp_seo_config(),
            'chat'             => vp_chat_config(),
            'csp_nonce'        => $csp_nonce,
            'unread_notifications' => 0,
        ];

        if ($this->vp_auth->check() && $this->vp_auth->is_staff()) {
            $this->data['unread_notifications'] = $this->_count_unread();
        }
    }

    /**
     * Emit the Content-Security-Policy header (moved here from .htaccess so we
     * can include a per-request nonce for JSON-LD structured data). Mirrors the
     * original policy; inline scripts are only allowed when they carry the nonce.
     */
    private function _set_security_headers($nonce)
    {
        $csp = "default-src 'self'; base-uri 'self'; object-src 'none'; form-action 'self'; "
             . "img-src 'self' data: blob: https:; font-src 'self' data: https://fonts.gstatic.com https:; "
             . "script-src 'self' 'nonce-{$nonce}' https://cdn.tailwindcss.com https://cdn.jsdelivr.net https://code.jquery.com; "
             . "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; "
             . "connect-src 'self' https:; frame-src https://www.youtube.com";
        $this->output->set_header('Content-Security-Policy: ' . $csp);
    }

    /**
     * Render a view inside a layout.
     *
     * @param string $view   View path relative to application/views (without .php)
     * @param array  $data   Extra data to merge into the view scope
     * @param string $layout Layout name: 'public', 'admin', or '' for none
     */
    protected function render($view, $data = [], $layout = null)
    {
        $data = array_merge($this->data, $data);
        $data['page_title']       = $data['page_title'] ?: $this->page_title;
        $data['page_description'] = $data['page_description'] ?: $this->page_description;
        $data['body_class']       = $data['body_class'] ?: $this->body_class;

        $layout = $layout !== null ? $layout : $this->layout;
        $content = $this->load->view($view, $data, TRUE);

        if ($layout === '' || $layout === null) {
            $this->output->set_output($content);
            return;
        }

        $data['content'] = $content;
        $this->load->view('layouts/' . $layout, $data);
    }

    /**
     * Render JSON response and exit.
     */
    protected function json($payload, $status = 200)
    {
        $this->output
            ->set_status_header($status)
            ->set_content_type('application/json', 'utf-8')
            ->set_output(json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE));
    }

    /**
     * Set a flash message visible on the next request.
     */
    protected function flash($type, $message)
    {
        $this->session->set_flashdata('vp_flash', ['type' => $type, 'message' => $message]);
    }

    /**
     * Get and clear the current flash message.
     */
    private function _get_flash()
    {
        $f = $this->session->flashdata('vp_flash');
        return $f ?: null;
    }

    /**
     * Count unread admin notifications.
     */
    private function _count_unread()
    {
        if (!$this->db->table_exists('notifications')) return 0;
        return (int) $this->db->where('userId', $this->vp_auth->id())
                              ->where('read', 0)
                              ->count_all_results('notifications');
    }

    /**
     * Send a notification to every staff user, or to a single userId.
     *
     * @param string $type      Short type tag, e.g. 'rfq_new', 'rfq_assigned'
     * @param string $title
     * @param string $message
     * @param array  $data      Extra context (e.g. ['quoteId' => '...'])
     * @param string|null $userId  Null = broadcast to all staff. Else single user.
     * @return int  Number of notifications created.
     */
    protected function notify($type, $title, $message, array $data = [], $userId = null)
    {
        if (!$this->db->table_exists('notifications')) return 0;
        $now = date('Y-m-d H:i:s');
        if ($userId) {
            $users = [['id' => $userId]];
        } else {
            $users = $this->db->where_in('role', [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_SALES])
                              ->where('isActive', 1)
                              ->get('users')->result_array();
        }
        $count = 0;
        foreach ($users as $u) {
            $this->db->insert('notifications', [
                'id'        => MY_Model::uuid(),
                'userId'    => $u['id'],
                'type'      => $type,
                'title'     => $title,
                'message'   => $message,
                'data'      => json_encode($data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE),
                'read'      => 0,
                'createdAt' => $now,
            ]);
            $count++;
        }
        return $count;
    }
}
