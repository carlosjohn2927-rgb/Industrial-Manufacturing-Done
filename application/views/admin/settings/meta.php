<?php $this->load->view('admin/settings/_tabs', ['tabs' => $tabs, 'tab' => $tab]); ?>
<form method="post" action="<?= base_url('admin/settings/save_meta') ?>" class="max-w-4xl space-y-6">
<input type="hidden" name="<?= vp_safe_html($csrf_token_name) ?>" value="<?= vp_safe_html($csrf_token) ?>">
<?= vp_admin_card_open('Meta Pixel & Conversions API', 'Marketing tracking requires visitor consent.', 'ri-facebook-circle-line') ?>
<p class="mb-4">Status: <strong><?= $pixel_enabled ? 'Enabled (waiting for visitor consent)' : 'Disabled or missing Pixel ID' ?></strong>. CAPI: <?= $has_token ? ($has_curl ? 'token configured; delivery not verified' : 'token configured, PHP cURL missing') : 'not configured' ?>.</p>
<label class="block mb-4"><input type="checkbox" name="enabled" value="1" <?= $pixel_enabled ? 'checked' : '' ?>> Enable Meta Pixel</label>
<?= vp_text_field('pixel_id', $pixel_id, 'Pixel ID', ['placeholder' => 'Numeric Meta Pixel ID']) ?>
<?= vp_text_field('capi_token', '', 'Conversions API access token', ['type' => 'password', 'placeholder' => $has_token ? 'Configured — leave blank to keep' : 'Optional token']) ?>
<label class="block mb-4"><input type="checkbox" name="clear_token" value="1"> Clear saved token</label>
<p class="text-sm mb-4">The token is encrypted at rest. Alternatively set VP_META_CAPI_TOKEN on the server; removing the saved token falls back to that environment variable. Never put the token in client code. Keep the application encryption key stable.</p>
<fieldset><legend class="font-semibold mb-2">Enabled events</legend>
<?php foreach ($events as $name => $enabled): ?>
<label class="block"><input type="checkbox" name="events[]" value="<?= vp_safe_html($name) ?>" <?= $enabled ? 'checked' : '' ?>> <?= vp_safe_html($name) ?></label>
<?php endforeach; ?></fieldset>
<p class="text-sm mt-4"><strong>Privacy review required:</strong> Meta may receive page URLs including RFQ references. Most query-string and all fragment URLs are excluded; a valid standalone Meta click ID is allowed. This limits search and some campaign attribution. See docs/META_PIXEL.md before enabling.</p>
<p class="text-sm mt-4">This site currently supports product views, searches, contact submissions and RFQ leads. Cart, checkout, payment and purchase events are reserved for future commerce functionality; they do not fire.</p>
<?= vp_admin_card_close() ?>
<button type="submit" class="vp-btn vp-btn-primary">Save Meta settings</button>
</form>
