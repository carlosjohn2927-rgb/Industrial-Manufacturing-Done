<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/** Consent-gated Meta configuration and conversion delivery. */
class Meta_pixel
{
    const EVENTS = ['PageView', 'ViewContent', 'Search', 'AddToCart', 'InitiateCheckout', 'AddPaymentInfo', 'Purchase', 'Contact', 'Lead'];
    private $ci;
    public function __construct() { $this->ci =& get_instance(); }
    public function id() { return trim((string) $this->ci->settings->get('meta_pixel_id', '')); }
    public function enabled() { return (bool) $this->ci->settings->get('meta_pixel_enabled', false) && (bool) preg_match('/^\d{5,25}$/', $this->id()); }
    public function event_enabled($name) { return in_array($name, self::EVENTS, true) && (bool) $this->ci->settings->get('meta_event_' . strtolower($name), true); }
    public function consent() { return isset($_COOKIE['vp_meta_consent']) && $_COOKIE['vp_meta_consent'] === 'yes'; }
    /** Allow an opaque Meta click ID alone; arbitrary query data may be personal. */
    public function safe_query($query)
    {
        return $query === '' || (bool) preg_match('/^fbclid=[A-Za-z0-9_-]{16,512}$/D', $query);
    }

    // The token is encrypted at rest and never included in settings->all(), the
    // raw settings editor, audit logs, or the browser configuration.
    public function token()
    {
        $row = $this->ci->db->get_where('settings', ['key' => 'meta_capi_secret'])->row_array();
        $raw = base64_decode($row['value'] ?? '', true);
        if ($raw && strlen($raw) > 28 && function_exists('openssl_decrypt')) {
            $key = hash('sha256', $this->ci->config->item('encryption_key'), true);
            $token = openssl_decrypt(substr($raw, 28), 'aes-256-gcm', $key, OPENSSL_RAW_DATA, substr($raw, 0, 12), substr($raw, 12, 16));
            if ($token !== false) return $token;
        }
        return (string) vp_config_env('VP_META_CAPI_TOKEN');
    }
    public function save_token($token)
    {
        if ($token === '') { $this->ci->settings->set('meta_capi_secret', '', 'STRING', 'META'); return true; }
        if (!function_exists('openssl_encrypt')) return false;
        $iv = random_bytes(12); $tag = '';
        $key = hash('sha256', $this->ci->config->item('encryption_key'), true);
        $encrypted = openssl_encrypt($token, 'aes-256-gcm', $key, OPENSSL_RAW_DATA, $iv, $tag);
        if ($encrypted === false) return false;
        $this->ci->settings->set('meta_capi_secret', base64_encode($iv . $tag . $encrypted), 'STRING', 'META');
        return true;
    }

    /** Discard queued browser events when consent or the integration is off. */
    public function clear_unconsented()
    {
        if (!$this->consent() || !$this->enabled()) $this->ci->session->unset_userdata('meta_pending');
    }

    /**
     * Consume only events for this success destination. A short-lived session
     * queue avoids unrelated requests or another tab stealing a conversion.
     */
    public function pending($destination)
    {
        $queue = $this->ci->session->userdata('meta_pending');
        if (!is_array($queue)) return [];
        $keep = []; $ready = []; $now = time();
        foreach ($queue as $item) {
            if (!is_array($item) || empty($item['created']) || $item['created'] < $now - 1800) continue;
            if (!$this->consent() || !$this->enabled() || !$this->event_enabled($item['name'] ?? '')) continue;
            if (($item['destination'] ?? '') === $destination) {
                $ready[] = ['name' => $item['name'], 'data' => (object) [], 'id' => $item['id']];
            } else {
                $keep[] = $item;
            }
        }
        if ($keep) $this->ci->session->set_userdata('meta_pending', $keep);
        else $this->ci->session->unset_userdata('meta_pending');
        return $ready;
    }

    /** Called only after the database has accepted the conversion. */
    public function conversion($name, $source, $destination)
    {
        if (!$this->enabled() || !$this->event_enabled($name) || !$this->consent()) return;
        $eventId = bin2hex(random_bytes(16));
        $queue = $this->ci->session->userdata('meta_pending');
        if (!is_array($queue)) $queue = [];
        $queue[] = ['name' => $name, 'id' => $eventId, 'destination' => $destination, 'created' => time()];
        $this->ci->session->set_userdata('meta_pending', array_slice($queue, -20));
        $token = $this->token();
        if (!$token || !function_exists('curl_init')) return;
        $user = ['client_ip_address' => $this->ci->input->ip_address(), 'client_user_agent' => substr((string) $this->ci->input->user_agent(), 0, 512)];
        $fbp = (string) ($_COOKIE['_fbp'] ?? '');
        if (preg_match('/^fb\.1\.\d+\.\d+$/', $fbp)) $user['fbp'] = $fbp;
        $fbc = (string) ($_COOKIE['_fbc'] ?? '');
        if (preg_match('/^fb\.1\.\d+\.[A-Za-z0-9_-]{16,512}$/D', $fbc)) $user['fbc'] = $fbc;
        // Do not pass form contents, email, phone, query strings or order/quote identifiers.
        $payload = ['data' => [[
            'event_name' => $name, 'event_time' => time(), 'event_id' => $eventId,
            'action_source' => 'website', 'event_source_url' => base_url($source), 'user_data' => $user,
        ]]];
        $testCode = (string) vp_config_env('VP_META_TEST_EVENT_CODE');
        if (preg_match('/^TEST[0-9]{1,20}$/', $testCode)) $payload['test_event_code'] = $testCode;
        try {
            $this->deliver($token, $payload);
        } catch (\Throwable $e) {
            log_message('error', 'Meta CAPI delivery failed.');
        }
    }

    protected function deliver($token, array $payload)
    {
        $ch = curl_init('https://graph.facebook.com/v24.0/' . $this->id() . '/events');
        $post = ['access_token' => $token, 'data' => json_encode($payload['data'])];
        if (isset($payload['test_event_code'])) $post['test_event_code'] = $payload['test_event_code'];
        curl_setopt_array($ch, [CURLOPT_POST => true, CURLOPT_POSTFIELDS => http_build_query($post), CURLOPT_RETURNTRANSFER => true, CURLOPT_CONNECTTIMEOUT => 2, CURLOPT_TIMEOUT => 3]);
        $response = curl_exec($ch); $status = curl_getinfo($ch, CURLINFO_HTTP_CODE); curl_close($ch);
        if ($response === false || $status < 200 || $status >= 300) log_message('error', 'Meta CAPI delivery failed (HTTP ' . (int) $status . ').');
    }
}
