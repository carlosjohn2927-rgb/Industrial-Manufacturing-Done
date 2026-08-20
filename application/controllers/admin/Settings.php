<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Halyk Petroleum — website settings.
 *
 * One central place for every site-wide value (identity, contact details,
 * social links, email, system/maintenance) so nothing is scattered through
 * the source code. Values are stored in `settings` and read by the public
 * theme through the CMS helper.
 *
 * The System tab (email transport, maintenance mode, security) is Super
 * Admin only and enforced per-method, not just hidden.
 */
class Settings extends Admin_Controller
{
    protected $required_permission = 'settings.manage';
    protected $method_permissions  = [
        'system'      => 'system.manage',
        'save_system' => 'system.manage',
    ];

    /** Tabs rendered by the settings screen. */
    private $tabs = [
        'general'  => ['General',    'ri-global-line'],
        'contact'  => ['Contact',    'ri-phone-line'],
        'social'   => ['Social',     'ri-share-line'],
        'system'   => ['System',     'ri-server-line'],
        'advanced' => ['All values', 'ri-code-s-slash-line'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->load->model('Setting_model');
        $this->load->library('form_validation');
        $this->load->helper(['form', 'url', 'security_helper']);
    }

    /* ---------------- General ------------------------------------------ */

    public function index()
    {
        $this->page_title = 'Website settings';
        $this->render('admin/settings/general', [
            'tabs'    => $this->_tabs(),
            'tab'     => 'general',
            'site'    => vp_site(),
        ]);
    }

    public function save()
    {
        if ($this->input->method() !== 'post') show_404();

        $this->settings->set('site_name', trim((string) $this->input->post('site_name')), 'STRING', 'WEBSITE');
        $this->settings->set('site_title', trim((string) $this->input->post('site_title')), 'STRING', 'WEBSITE');
        $this->settings->set('site_tagline', trim((string) $this->input->post('site_tagline')), 'STRING', 'WEBSITE');
        $this->settings->set('site_description', trim((string) $this->input->post('site_description')), 'TEXT', 'WEBSITE');
        $this->settings->set('site_url', rtrim(trim((string) $this->input->post('site_url')), '/'), 'STRING', 'WEBSITE');
        $this->settings->set('site_language', trim((string) $this->input->post('site_language')) ?: 'en', 'STRING', 'WEBSITE');

        $this->settings->clear_cache();
        $this->audit->log(AUDIT_UPDATE, 'settings', null, ['group' => 'WEBSITE']);
        $this->flash('success', 'Website settings saved.');
        redirect('admin/settings');
    }

    /* ---------------- Contact ------------------------------------------ */

    public function contact()
    {
        $this->page_title = 'Contact settings';
        $this->render('admin/settings/contact', [
            'tabs' => $this->_tabs(),
            'tab'  => 'contact',
            'site' => vp_site(),
        ]);
    }

    public function save_contact()
    {
        if ($this->input->method() !== 'post') show_404();

        foreach ([
            'contact_email' => 'STRING',
            'support_email' => 'STRING',
            'rfq_email'     => 'STRING',
            'phone'         => 'STRING',
            'address'       => 'STRING',
            'contact_hours' => 'STRING',
        ] as $key => $type) {
            $this->settings->set($key, trim((string) $this->input->post($key)), $type, 'CONTACT');
        }

        $this->settings->clear_cache();
        $this->audit->log(AUDIT_UPDATE, 'settings', null, ['group' => 'CONTACT']);
        $this->flash('success', 'Contact information saved — the website footer is updated.');
        redirect('admin/settings/contact');
    }

    /* ---------------- Social ------------------------------------------- */

    public function social()
    {
        $this->page_title = 'Social links';
        $this->render('admin/settings/social', [
            'tabs'   => $this->_tabs(),
            'tab'    => 'social',
            'social' => vp_social_links(),
        ]);
    }

    public function save_social()
    {
        if ($this->input->method() !== 'post') show_404();
        $networks = ['linkedin', 'twitter', 'facebook', 'youtube', 'instagram', 'telegram', 'whatsapp'];
        $combined = [];
        foreach ($networks as $n) {
            $val = trim((string) $this->input->post('social_' . $n));
            $this->settings->set('social_' . $n, $val, 'STRING', 'SOCIAL');
            if ($val !== '') $combined[$n] = $val;
        }
        // Keep the legacy JSON blob in sync for anything still reading it.
        $this->settings->set('social', json_encode($combined, JSON_UNESCAPED_SLASHES), 'JSON', 'CONTACT');

        $this->settings->clear_cache();
        $this->audit->log(AUDIT_UPDATE, 'settings', null, ['group' => 'SOCIAL']);
        $this->flash('success', 'Social links saved.');
        redirect('admin/settings/social');
    }

    /* ---------------- System (Super Admin) ------------------------------ */

    public function system()
    {
        $this->page_title = 'System settings';
        $this->render('admin/settings/system', [
            'tabs'   => $this->_tabs(),
            'tab'    => 'system',
            'site'   => vp_site(),
            'email'  => vp_email_health(),
            'values' => [
                'maintenance_mode'    => (string) $this->settings->get('maintenance_mode', '0'),
                'maintenance_message' => (string) $this->settings->get('maintenance_message', ''),
                'chat_enabled'        => (string) $this->settings->get('chat_enabled', '0'),
                'rfq_enabled'         => (string) $this->settings->get('rfq_enabled', '1'),
                'rfq_admin_email'     => (string) $this->settings->get('rfq_admin_email', ''),
                'rfq_rate_limit_per_hour' => (string) $this->settings->get('rfq_rate_limit_per_hour', '5'),
                'mail_from_email'     => (string) $this->settings->get('mail_from_email', ''),
                'mail_from_name'      => (string) $this->settings->get('mail_from_name', ''),
                'mail_reply_to'       => (string) $this->settings->get('mail_reply_to', ''),
            ],
        ]);
    }

    public function save_system()
    {
        if ($this->input->method() !== 'post') show_404();

        $this->settings->set('maintenance_mode', $this->input->post('maintenance_mode') ? '1' : '0', 'BOOL', 'SYSTEM');
        $this->settings->set('maintenance_message', trim((string) $this->input->post('maintenance_message')), 'TEXT', 'SYSTEM');
        $this->settings->set('chat_enabled', $this->input->post('chat_enabled') ? '1' : '0', 'BOOL', 'CHAT');
        $this->settings->set('rfq_enabled', $this->input->post('rfq_enabled') ? '1' : '0', 'BOOL', 'RFQ');
        $this->settings->set('rfq_admin_email', trim((string) $this->input->post('rfq_admin_email')), 'STRING', 'RFQ');
        $this->settings->set('rfq_rate_limit_per_hour', (int) $this->input->post('rfq_rate_limit_per_hour'), 'INT', 'RFQ');

        // Outgoing email identity (credentials stay in .env)
        $this->settings->set('mail_from_email', trim((string) $this->input->post('mail_from_email')), 'STRING', 'EMAIL');
        $this->settings->set('mail_from_name', trim((string) $this->input->post('mail_from_name')), 'STRING', 'EMAIL');
        $this->settings->set('mail_reply_to', trim((string) $this->input->post('mail_reply_to')), 'STRING', 'EMAIL');

        $this->settings->clear_cache();
        $this->audit->log(AUDIT_UPDATE, 'settings', null, ['group' => 'SYSTEM']);
        $this->flash('success', 'System settings saved.');
        redirect('admin/settings/system');
    }

    /* ---------------- Advanced key/value -------------------------------- */

    public function advanced()
    {
        $this->page_title = 'All settings';
        $rows = $this->db->order_by('group', 'ASC')->order_by('sortOrder', 'ASC')->order_by('key', 'ASC')
                         ->get('settings')->result_array();
        $grouped = [];
        foreach ($rows as $r) $grouped[$r['group']][] = $r;

        $this->render('admin/settings/index', [
            'tabs'    => $this->_tabs(),
            'tab'     => 'advanced',
            'grouped' => $grouped,
        ]);
    }

    /**
     * Bulk save of the raw key/value editor.
     */
    public function save_advanced()
    {
        if ($this->input->method() !== 'post') show_404();
        $keys   = (array) $this->input->post('key');
        $values = (array) $this->input->post('value');
        $types  = (array) $this->input->post('type');
        $groups = (array) $this->input->post('group');

        $protected = ['maintenance_mode'];   // needs system.manage
        $count = 0;
        foreach ($keys as $i => $k) {
            $k = trim((string) $k);
            if ($k === '') continue;
            if (in_array($k, $protected, true) && !$this->has_permission('system.manage')) continue;
            $this->settings->set($k, $values[$i] ?? '', $types[$i] ?? 'STRING', $groups[$i] ?? 'GENERAL');
            $count++;
        }
        $this->settings->clear_cache();
        $this->audit->log(AUDIT_UPDATE, 'settings', null, ['count' => $count, 'via' => 'advanced']);
        $this->flash('success', "Saved {$count} settings.");
        redirect('admin/settings/advanced');
    }

    /** Add a brand new setting key from the advanced tab. */
    public function add()
    {
        if ($this->input->method() !== 'post') show_404();
        $key = trim((string) $this->input->post('new_key'));
        if ($key === '' || !preg_match('/^[a-z0-9_\.]+$/i', $key)) {
            $this->flash('error', 'Use letters, numbers, dots and underscores for the key.');
            return redirect('admin/settings/advanced');
        }
        $this->settings->set($key, (string) $this->input->post('new_value'),
            (string) ($this->input->post('new_type') ?: 'STRING'),
            strtoupper((string) ($this->input->post('new_group') ?: 'GENERAL')));
        $this->settings->clear_cache();
        $this->audit->log(AUDIT_CREATE, 'settings', null, ['key' => $key]);
        $this->flash('success', 'Setting added.');
        redirect('admin/settings/advanced');
    }

    public function delete()
    {
        if ($this->input->method() !== 'post') show_404();
        if (!$this->is_super_admin()) {
            $this->_deny('Only the Super Admin can delete settings.');
        }
        $key = trim((string) $this->input->post('key'));
        if ($key === '') show_404();
        $this->db->delete('settings', ['key' => $key]);
        $this->settings->clear_cache();
        $this->audit->log(AUDIT_DELETE, 'settings', null, ['key' => $key]);
        $this->flash('success', 'Setting deleted.');
        redirect('admin/settings/advanced');
    }

    /* -------------------------------------------------------------------- */

    private function _tabs()
    {
        $out = [];
        foreach ($this->tabs as $key => $def) {
            if ($key === 'system' && !$this->has_permission('system.manage')) continue;
            $out[$key] = [
                'label' => $def[0],
                'icon'  => $def[1],
                'url'   => $key === 'general' ? 'admin/settings' : 'admin/settings/' . $key,
            ];
        }
        return $out;
    }
}
