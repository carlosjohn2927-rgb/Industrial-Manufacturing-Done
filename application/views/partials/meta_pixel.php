<?php
// Auth and password-reset URLs may contain secrets; never load Meta there.
$meta_active = $this->meta_pixel->enabled() && strtolower($this->router->fetch_class()) !== 'auth'
    && $this->meta_pixel->safe_query((string) ($_SERVER['QUERY_STRING'] ?? ''));
$meta_events = [];
if ($meta_active) {
    if ($this->meta_pixel->event_enabled('PageView')) $meta_events[] = ['name' => 'PageView', 'data' => (object) []];
    if (!empty($meta_product) && $this->meta_pixel->event_enabled('ViewContent')) {
        $p = $meta_product;
        $params = ['content_ids' => [(string) $p['id']], 'content_name' => (string) $p['name'], 'content_type' => 'product'];
        $params['contents'] = [['id' => (string) $p['id'], 'quantity' => 1]];
        if (!empty($meta_category['name'])) $params['content_category'] = $meta_category['name'];
        if (isset($p['price']) && $p['price'] !== '' && is_numeric($p['price'])) {
            $params['value'] = (float) $p['price']; $params['currency'] = 'USD';
            $params['contents'][0]['item_price'] = (float) $p['price'];
        }
        $meta_events[] = ['name' => 'ViewContent', 'data' => $params];
    }
    $meta_events = array_merge($meta_events, $this->meta_pixel->pending($this->uri->uri_string()));
}
?>
<?php if ($meta_active): ?>
<script type="application/json" id="vp-meta-config"><?= json_encode(['id' => $this->meta_pixel->id(), 'events' => $meta_events, 'searchEnabled' => $this->meta_pixel->event_enabled('Search'), 'searchPaths' => [parse_url(base_url('products'), PHP_URL_PATH), parse_url(base_url('search'), PHP_URL_PATH)]], JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT) ?></script>
<?php endif; ?>
