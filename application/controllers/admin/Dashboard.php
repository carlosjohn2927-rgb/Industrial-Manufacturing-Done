<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Dashboard extends Admin_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model(['Quote_model', 'Product_model', 'Contact_model', 'User_model']);
    }

    public function index()
    {
        $this->page_title = 'Dashboard';

        // Quote counts by status
        $quote_by_status = [];
        $rows = $this->db->select('status, COUNT(*) AS c')
                         ->group_by('status')
                         ->get('quotes')->result_array();
        foreach ($rows as $r) $quote_by_status[$r['status']] = (int) $r['c'];

        // Last 30 days of submissions
        $since = date('Y-m-d H:i:s', strtotime('-30 days'));
        $recent_quotes = $this->db->where('createdAt >=', $since)
                                  ->order_by('createdAt', 'DESC')
                                  ->limit(10)
                                  ->get('quotes')->result_array();

        // Recent activity
        $recent_activity = $this->db->order_by('createdAt', 'DESC')
                                    ->limit(15)
                                    ->get('audit_logs')->result_array();

        // Open contacts
        $open_contacts = (int) $this->db->where('status', 'NEW')->count_all_results('contacts');

        $data = [
            'counts' => [
                'quotes_total'   => (int) $this->db->count_all('quotes'),
                'quotes_new'     => (int) ($quote_by_status[QUOTE_NEW] ?? 0),
                'products'       => (int) $this->db->where('isActive', 1)->count_all_results('products'),
                'contacts'       => (int) $this->db->count_all('contacts'),
                'contacts_new'   => $open_contacts,
                'users'          => (int) $this->db->count_all('users'),
                'blog'           => (int) $this->db->count_all('blog_posts'),
                'careers'        => (int) $this->db->where('isActive', 1)->count_all_results('careers'),
            ],
            'quote_by_status' => $quote_by_status,
            'recent_quotes'   => $recent_quotes,
            'recent_activity' => $recent_activity,
            // Outgoing-mail health: surfaces silently-broken transports
            // (e.g. VP_SMTP_PASS empty) the moment an admin signs in.
            'email_health'    => $this->mailer->health(),
        ];

        $this->render('admin/dashboard', $data);
    }
}
