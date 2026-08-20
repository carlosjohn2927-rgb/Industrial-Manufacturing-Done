<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - public AI chat endpoint.
 *
 * Serves the floating chat widget available to every site visitor. Replies are
 * produced by the Vp_assistant library (local knowledge base by default, or an
 * external LLM when configured).
 */
class Chat extends MY_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->library(['vp_assistant', 'rate_limiter']);
        $this->load->helper('security_helper');
    }

    /**
     * POST chat/message  →  { reply, csrf_token }
     */
    public function message()
    {
        // Only accept POSTs (CSRF is verified globally by CI on every POST).
        if ($this->input->method() !== 'post') {
            show_404();
        }

        $config = vp_chat_config();
        if (empty($config['enabled'])) {
            return $this->json([
                'reply'      => 'Chat is currently unavailable. Please contact our team directly.',
                'csrf_token' => $this->security->get_csrf_hash(),
            ]);
        }

        // Per-IP rate limit.
        $ip = vp_get_client_ip();
        $limit = (int) vp_setting('chat_rate_limit_per_hour', 60);
        if ($this->rate_limiter->too_many('chat:' . $ip, $limit, 3600)) {
            return $this->json([
                'reply'      => 'You have sent a lot of messages recently. Please try again in a little while, or reach us by email or phone.',
                'csrf_token' => $this->security->get_csrf_hash(),
            ], 429);
        }

        $message = trim((string) $this->input->post('message'));
        if ($message === '') {
            return $this->json([
                'reply'      => 'Please type a message and I will do my best to help.',
                'csrf_token' => $this->security->get_csrf_hash(),
            ]);
        }
        if (mb_strlen($message) > 1000) {
            $message = mb_substr($message, 0, 1000);
        }

        try {
            $reply = $this->vp_assistant->reply($message);
        } catch (Throwable $e) {
            log_message('error', 'Chat: assistant failed - ' . $e->getMessage());
            $reply = 'Sorry, I ran into a problem answering that. Please contact our team directly and we will help right away.';
        }

        $this->json([
            'reply'      => $reply,
            'csrf_token' => $this->security->get_csrf_hash(),
        ]);
    }
}
