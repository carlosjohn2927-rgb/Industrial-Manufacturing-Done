<?php
// Isolated tests of the real library and public partial without Meta credentials.
define('BASEPATH', __DIR__);
define('JS_URL', '/assets/js/');
define('VP_ASSET_VERSION', 'test');
function &get_instance() { return $GLOBALS['ci']; }
function base_url($path = '') { return 'https://example.test/' . $path; }
function vp_config_env($name, $default = '') { return $_ENV[$name] ?? (getenv($name) ?: $default); }
function log_message($level, $message) { $GLOBALS['logs'][] = $message; }
class FakeSettings {
    public $values = [];
    function get($k, $d = null) { return $this->values[$k] ?? $d; }
    function set($k, $v, $type = 'STRING', $group = '') { $this->values[$k] = $v; }
}
class FakeDb {
    public $key;
    function get_where($table, $where) { $this->key = $where['key']; return $this; }
    function row_array() { global $ci; return isset($ci->settings->values[$this->key]) ? ['value'=>$ci->settings->values[$this->key]] : []; }
}
class FakeConfig { function item($k) { return str_repeat('secret-key', 4); } }
class FakeInput { function ip_address() { return '192.0.2.1'; } function user_agent() { return 'test browser'; } }
class FakeSession {
    public $values = [];
    function set_userdata($key, $value) { $this->values[$key] = $value; }
    function unset_userdata($key) { unset($this->values[$key]); }
    function userdata($key) { return $this->values[$key] ?? null; }
}
class FakeUri { public $path = 'products/test'; function uri_string() { return $this->path; } }
class FakeRouter { public $class = 'products'; function fetch_class() { return $this->class; } }
class FakeLoad { function library($name) {} }
require __DIR__ . '/../application/libraries/Meta_pixel.php';
class TestPixel extends Meta_pixel {
    public $calls = [];
    public $fail = false;
    protected function deliver($token, array $payload) { if ($this->fail) throw new RuntimeException('do not log secrets'); $this->calls[] = [$token, $payload]; }
}
$ci = (object) ['settings'=>new FakeSettings(), 'db'=>new FakeDb(), 'config'=>new FakeConfig(), 'input'=>new FakeInput(), 'session'=>new FakeSession()];
$ci->settings->values = ['meta_pixel_enabled'=>1, 'meta_pixel_id'=>'123456'];
$p = new TestPixel();
function check($condition, $message) { if (!$condition) { fwrite(STDERR, "FAIL: $message\n"); exit(1); } echo "PASS: $message\n"; }
check($p->save_token('secret-token') && $p->token() === 'secret-token', 'encrypted token round trip');
check(strpos($ci->settings->values['meta_capi_secret'], 'secret-token') === false, 'token not stored in plaintext');
$_COOKIE = []; $p->conversion('Contact', 'contact', 'contact');
check(!$p->calls && !$ci->session->values, 'no conversion before consent');
$_COOKIE = ['vp_meta_consent'=>'yes', '_fbp'=>'fb.1.123456.789', '_fbc'=>'fb.1.123456.abcdefghijklmnop'];
$p->conversion('Contact', 'contact', 'contact');
$event = $p->calls[0][1]['data'][0]; $flash = $ci->session->values['meta_pending'][0];
check($event['event_name'] === 'Contact' && $event['event_id'] === $flash['id'], 'browser/server share event name and ID');
check($event['user_data']['fbp'] === 'fb.1.123456.789' && $event['user_data']['fbc'] === 'fb.1.123456.abcdefghijklmnop' && $event['event_source_url'] === 'https://example.test/contact', 'matching cookie and clean source URL');
check(!isset($event['user_data']['em']) && !isset($event['custom_data']), 'no form data sent');
$ci->settings->values['meta_event_lead'] = 0; $p->conversion('Lead', 'rfq', 'rfq/thanks/123');
check(count($p->calls) === 1, 'disabled event does not send');
$ci->settings->values['meta_event_lead'] = 1; $p->conversion('Lead', 'rfq', 'rfq/thanks/123');
check(count($p->calls) === 2 && $p->calls[1][1]['data'][0]['event_name'] === 'Lead', 'RFQ lead sent when enabled');
$ci->settings->values['meta_pixel_enabled'] = 0; $p->conversion('Contact', 'contact', 'contact');
check(count($p->calls) === 2, 'global disable blocks conversion');
$ci->settings->values['meta_pixel_enabled'] = 1;
class ViewHarness {
    public $load, $router, $meta_pixel, $session, $uri;
    function render($vars) { extract($vars); ob_start(); include __DIR__ . '/../application/views/partials/meta_pixel.php'; return ob_get_clean(); }
}
$v = new ViewHarness(); $v->load = new FakeLoad(); $v->router = new FakeRouter(); $v->meta_pixel = $p; $v->session = $ci->session; $v->uri = new FakeUri(); $v->uri->path = 'rfq/thanks/123';
$view = $v->render(['meta_product'=>['id'=>'p1','name'=>'Valve','price'=>'50.00'], 'meta_category'=>['name'=>'Pumps']]);
preg_match('~<script type="application/json" id="vp-meta-config">(.*?)</script>~s', $view, $matches);
$config = json_decode($matches[1], true); $events = $config['events'];
check(array_column($events, 'name') === ['PageView','ViewContent','Lead'], 'page, product and one-shot conversion rendered once');
check($events[1]['data']['content_ids'] === ['p1'] && $events[1]['data']['value'] === 50 && $events[1]['data']['currency'] === 'USD' && $events[1]['data']['content_category'] === 'Pumps' && $events[1]['data']['contents'][0]['quantity'] === 1 && $events[1]['data']['contents'][0]['item_price'] === 50, 'product fields from database data');
check($events[2]['id'] === $p->calls[1][1]['data'][0]['event_id'], 'rendered conversion matches CAPI ID');
$view = $v->render([]); check(strpos($view, '"Lead"') === false, 'refresh does not replay conversion');
check(count($ci->session->values['meta_pending']) === 1, 'unrelated page did not steal contact event');
$v->uri->path = 'contact'; $view = $v->render([]);
check(strpos($view, '"Contact"') !== false && empty($ci->session->values['meta_pending']), 'contact destination consumes its own event');
$p->conversion('Contact', 'contact', 'contact');
$_COOKIE['vp_meta_consent'] = 'no'; $p->clear_unconsented();
check(empty($ci->session->values['meta_pending']), 'withdrawal clears pending events');
$_COOKIE['vp_meta_consent'] = 'yes';
$ci->session->set_userdata('meta_pending', [
    ['name' => 'Contact', 'id' => 'old', 'destination' => 'contact', 'created' => time() - 1801],
    ['name' => 'Lead', 'id' => 'other', 'destination' => 'rfq/thanks/other', 'created' => time()],
    ['name' => 'Contact', 'id' => 'fresh', 'destination' => 'contact', 'created' => time()],
]);
$ready = $p->pending('contact');
check(count($ready) === 1 && $ready[0]['id'] === 'fresh', 'expired conversion discarded; correct destination consumed');
check(count($ci->session->values['meta_pending']) === 1 && $ci->session->values['meta_pending'][0]['id'] === 'other', 'other destination remains queued');
$ci->settings->values['meta_event_lead'] = 0;
check($p->pending('rfq/thanks/other') === [] && empty($ci->session->values['meta_pending']), 'disabling event discards its pending conversion');
$ci->settings->values['meta_event_lead'] = 1;
$_ENV['VP_META_TEST_EVENT_CODE'] = 'TEST12345';
$p->conversion('Contact', 'contact', 'contact');
check(end($p->calls)[1]['test_event_code'] === 'TEST12345', 'test event code included server-side');
$_ENV['VP_META_TEST_EVENT_CODE'] = 'invalid';
$p->conversion('Contact', 'contact', 'contact');
check(!isset(end($p->calls)[1]['test_event_code']), 'invalid test event code omitted');
unset($_ENV['VP_META_TEST_EVENT_CODE']);
$p->fail = true;
$p->conversion('Contact', 'contact', 'contact');
check(!empty($GLOBALS['logs']) && end($GLOBALS['logs']) === 'Meta CAPI delivery failed.', 'CAPI failure is contained and does not log exception details');
$p->fail = false;
$p->save_token(''); $_ENV['VP_META_CAPI_TOKEN'] = 'fallback-token';
check($p->token() === 'fallback-token', 'environment fallback works without getenv');
unset($_ENV['VP_META_CAPI_TOKEN']);
$_SERVER['QUERY_STRING'] = 'fbclid=abcdefghijklmnop'; check(strpos($v->render([]), 'vp-meta-config') !== false, 'standalone valid Meta click ID permits Pixel');
$_SERVER['QUERY_STRING'] = 'fbclid=abcdefghijklmnop&q=private'; check(strpos($v->render([]), 'vp-meta-config') === false, 'additional query parameters suppress Pixel');
$_SERVER['QUERY_STRING'] = 'q=private'; check(strpos($v->render([]), 'vp-meta-config') === false, 'query-bearing pages do not load Pixel'); unset($_SERVER['QUERY_STRING']);
$v->router->class = 'auth'; check(strpos($v->render([]), 'vp-meta-config') === false, 'auth pages do not load Pixel');
