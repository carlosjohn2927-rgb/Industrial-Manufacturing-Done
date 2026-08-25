<?php
/**
 * Public site header — logo, product-search button, navigation, contact CTA.
 * Every element is managed from the dashboard:
 *   logo      → Website → Logo & branding
 *   menu      → Website → Navigation (header)
 *   CTA/topbar→ Website → Header & footer
 * The search button sits immediately after the logo, before the first menu
 * item; the overlay it opens lives at the bottom of this partial.
 */
$site  = vp_site();
$user  = $current_user ?? null;
$menu  = vp_menu('header');

// Built-in fallback so the site is still navigable if the menu table is empty.
if (empty($menu)) {
    foreach ([['Products', 'products'], ['Industries', 'industries'], ['Services', 'services'],
              ['About', 'about'], ['Blog', 'blog'], ['Careers', 'careers'], ['FAQ', 'faq'],
              ['Downloads', 'downloads'], ['Contact', 'contact']] as $m) {
        $menu[] = ['label' => $m[0], 'href' => base_url($m[1]), 'target' => '_self', 'icon' => null];
    }
}
?>
<?php if ($site['topbar_enabled'] && $site['topbar_text']): ?>
    <div class="vp-announcement-bar bg-white text-black text-sm border-b border-gray-200" role="region" aria-label="Announcement">
        <div class="container mx-auto px-4 py-2 flex items-center gap-3">
            <div class="vp-announcement-viewport">
                <div class="vp-announcement-track">
                    <div class="vp-announcement-item">
                        <span class="text-black font-medium"><?= vp_safe_html($site['topbar_text']) ?></span>
                    </div>
                    <div class="vp-announcement-item" aria-hidden="true">
                        <span class="text-black font-medium"><?= vp_safe_html($site['topbar_text']) ?></span>
                    </div>
                </div>
            </div>
            <?php if ($site['phone']): ?>
                <a class="vp-announcement-phone text-black hover:underline" href="tel:<?= vp_safe_html(preg_replace('/[^0-9+]/', '', $site['phone'])) ?>"><i class="ri-phone-line"></i> <?= vp_safe_html($site['phone']) ?></a>
            <?php endif; ?>
        </div>
    </div>
<?php endif; ?>

<header class="bg-white border-b sticky top-0 z-40">
    <div class="container mx-auto px-4 py-3 flex items-center gap-6">
        <a href="<?= base_url() ?>" class="flex items-center flex-shrink-0" aria-label="<?= vp_safe_html($site['name']) ?> home">
            <img src="<?= vp_safe_html(vp_logo_url('light')) ?>" alt="<?= vp_safe_html($site['logo_alt']) ?>"
                 class="w-auto object-contain max-w-[190px] md:max-w-[220px]"
                 style="height: <?= (int) $site['logo_height'] ?>px" decoding="async">
        </a>

        <!-- Product search button — placed immediately after the logo, before the menu -->
        <button type="button" id="vp-search-toggle" class="inline-flex items-center gap-1 text-sm font-medium text-ink-900 hover:text-brand-600 p-2 rounded-lg hover:bg-gray-100 transition flex-shrink-0" aria-label="Search products" aria-haspopup="dialog" title="Search products">
            <i class="ri-search-line text-lg"></i>
            <span class="hidden md:inline">Search</span>
        </button>

        <nav class="hidden lg:flex items-center gap-5 text-sm font-medium text-ink-900">
            <?php foreach ($menu as $item): ?>
                <a class="hover:text-brand-600 <?= vp_menu_is_active($item) ? 'text-brand-600' : '' ?>"
                   href="<?= vp_safe_html($item['href']) ?>" <?= ($item['target'] ?? '_self') === '_blank' ? 'target="_blank" rel="noopener"' : '' ?>>
                    <?php if (!empty($item['icon'])): ?><i class="<?= vp_safe_html($item['icon']) ?>"></i> <?php endif; ?>
                    <?= vp_safe_html($item['label']) ?>
                </a>
            <?php endforeach; ?>
        </nav>

        <div class="ml-auto flex items-center gap-3">
            <?php if ($site['header_cta_enabled'] && $site['header_cta_label']): ?>
                <a href="<?= vp_safe_html(preg_match('~^https?://~i', (string) $site['header_cta_url']) ? $site['header_cta_url'] : base_url(ltrim((string) $site['header_cta_url'], '/'))) ?>"
                   class="hidden sm:inline-flex items-center gap-1 bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold px-4 py-2 rounded-lg">
                    <i class="ri-quote-text"></i> <?= vp_safe_html($site['header_cta_label']) ?>
                </a>
            <?php endif; ?>

            <?php if ($user): ?>
                <?php if (!empty($is_admin)): ?>
                    <a href="<?= base_url('admin') ?>" class="text-sm font-medium text-ink-900 hover:text-brand-600"><i class="ri-dashboard-line"></i> Dashboard</a>
                <?php endif; ?>
                <a href="<?= base_url('logout') ?>" class="text-sm text-ink-800 hover:text-red-600">Sign out</a>
            <?php else: ?>
                <a href="<?= base_url('login') ?>" class="text-sm font-medium text-ink-900 hover:text-brand-600">Sign in</a>
            <?php endif; ?>

            <button class="lg:hidden p-2" id="vp-mobile-toggle" aria-label="Menu"><i class="ri-menu-line text-2xl"></i></button>
        </div>
    </div>

    <div class="lg:hidden hidden border-t bg-white" id="vp-mobile-menu">
        <nav class="px-4 py-3 flex flex-col gap-2 text-sm font-medium">
            <?php foreach ($menu as $item): ?>
                <a href="<?= vp_safe_html($item['href']) ?>" <?= ($item['target'] ?? '_self') === '_blank' ? 'target="_blank" rel="noopener"' : '' ?>><?= vp_safe_html($item['label']) ?></a>
            <?php endforeach; ?>
            <?php if ($site['header_cta_enabled'] && $site['header_cta_label']): ?>
                <a class="text-brand-600 font-semibold" href="<?= base_url(ltrim((string) $site['header_cta_url'], '/')) ?>"><?= vp_safe_html($site['header_cta_label']) ?></a>
            <?php endif; ?>
        </nav>
    </div>
</header>

<!-- Product search overlay -->
<div id="vp-search-overlay" class="vp-search-overlay" role="dialog" aria-label="Product search" aria-modal="true" hidden>
    <div class="vp-search-backdrop" data-vp-search-close></div>
    <div class="vp-search-dialog">
        <form id="vp-search-form" method="get" action="<?= base_url('products') ?>" class="vp-search-input-row" role="search">
            <i class="ri-search-line vp-search-icon"></i>
            <input id="vp-search-input" type="search" name="q" class="vp-search-input"
                   placeholder="Search products by name, SKU, or keyword…"
                   autocomplete="off" aria-label="Search products">
            <button type="button" class="vp-search-close-btn" data-vp-search-close aria-label="Close search">
                <i class="ri-close-line text-xl"></i>
            </button>
            <button type="submit" class="vp-btn vp-btn-primary vp-search-submit">
                <i class="ri-search-line"></i> Search
            </button>
        </form>
        <div id="vp-search-results" class="vp-search-results" aria-live="polite"></div>
        <div class="vp-search-footer">
            <span class="vp-search-hint"><kbd>/</kbd> to open &middot; <kbd>Esc</kbd> to close &middot; <kbd>Enter</kbd> to search all products</span>
        </div>
    </div>
</div>
