<?php
/**
 * Product search section — a prominent search bar that lets visitors find
 * products by name, SKU, or keyword. Supports live AJAX suggestions.
 *
 * @var array $section
 */
$this->load->view('partials/sections/_helpers');

$title    = !empty($section['title'])    ? $section['title']    : 'Find the right product';
$subtitle = !empty($section['subtitle']) ? $section['subtitle'] : 'Search our full catalog by product name, SKU, material or application.';
$button   = !empty($section['buttonText']) ? $section['buttonText'] : 'Search products';
$btn_url  = !empty($section['buttonUrl']) ? vp_section_link($section['buttonUrl']) : base_url('products');
?>
<section class="vp-product-search-section bg-gray-50"<?= vp_section_style_attr($section) ?>>
    <div class="container mx-auto px-4 py-16">
        <div class="max-w-3xl mx-auto text-center">
            <?php if ($title): ?>
                <h2 class="text-3xl lg:text-4xl font-extrabold text-ink-900"><?= vp_safe_html($title) ?></h2>
            <?php endif; ?>
            <?php if ($subtitle): ?>
                <p class="text-ink-800 mt-3 text-lg"><?= vp_safe_html($subtitle) ?></p>
            <?php endif; ?>

            <form method="get" action="<?= base_url('products') ?>" class="vp-section-search-form mt-8" role="search">
                <div class="flex flex-col sm:flex-row gap-3 items-stretch">
                    <div class="relative flex-1">
                        <i class="ri-search-line absolute left-4 top-1/2 -translate-y-1/2 text-ink-800 text-lg pointer-events-none"></i>
                        <input type="search"
                               name="q"
                               class="vp-input vp-section-search-input pl-11 pr-4 py-4 text-base"
                               placeholder="Search by product name, SKU, or keyword…"
                               autocomplete="off"
                               aria-label="Search products">
                    </div>
                    <button type="submit" class="vp-btn vp-btn-primary px-8 py-4 text-base whitespace-nowrap justify-center">
                        <i class="ri-search-line"></i> <?= vp_safe_html($button) ?>
                    </button>
                </div>
            </form>

            <div class="mt-5 flex flex-wrap justify-center gap-2">
                <span class="text-sm text-ink-800">Popular:</span>
                <a href="<?= base_url('products?q=valve') ?>" class="vp-search-tag">Valves</a>
                <a href="<?= base_url('products?q=pump') ?>" class="vp-search-tag">Pumps</a>
                <a href="<?= base_url('products?q=heat+exchanger') ?>" class="vp-search-tag">Heat Exchangers</a>
                <a href="<?= base_url('products?q=pressure+vessel') ?>" class="vp-search-tag">Pressure Vessels</a>
                <a href="<?= base_url('products?q=filtration') ?>" class="vp-search-tag">Filtration</a>
            </div>

            <?php if (!empty($section['buttonText']) && $section['buttonUrl']): ?>
                <div class="mt-6">
                    <a href="<?= vp_safe_html($btn_url) ?>" class="text-brand-600 font-semibold hover:underline">
                        <?= vp_safe_html($section['buttonText']) ?> &rarr;
                    </a>
                </div>
            <?php endif; ?>
        </div>
    </div>
</section>
