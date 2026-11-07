<?php if ($this->meta_pixel->enabled() || isset($_COOKIE['vp_meta_consent'])): ?>
<div id="vp-meta-preferences" hidden role="region" aria-label="Advertising cookie preferences" style="position:fixed;bottom:1rem;left:1rem;right:1rem;z-index:9999;max-width:32rem;padding:1rem;background:#fff;color:#111;border:1px solid #777;border-radius:.5rem;box-shadow:0 4px 18px #0003">
    <p>May we use Meta Pixel advertising cookies to measure visits and enquiries? Meta receives information about your browser and activity. You can change your choice at any time using Tracking preferences. <a href="<?= vp_safe_html(base_url('privacy-policy')) ?>" style="text-decoration:underline">Privacy policy</a>.</p>
    <div style="display:flex;flex-wrap:wrap;gap:.5rem;margin-top:.75rem">
        <button type="button" data-meta-choice="yes" class="vp-btn vp-btn-primary">Allow advertising tracking</button>
        <button type="button" data-meta-choice="no" class="vp-btn vp-btn-secondary">Reject advertising tracking</button>
    </div>
</div>
<button type="button" id="vp-meta-manage" style="position:fixed;bottom:.25rem;right:.5rem;z-index:1000;background:#fff;color:#111;border:1px solid #777;border-radius:.25rem;padding:.25rem .5rem;font-size:.75rem">Tracking preferences</button>
<script src="<?= JS_URL ?>meta-pixel.js?v=<?= VP_ASSET_VERSION ?>" defer></script>
<?php endif; ?>
