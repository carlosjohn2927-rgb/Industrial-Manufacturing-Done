<?php
/** Public site header */
$site = $site_name ?? 'Halyk Petroleum';
$tag  = $site_tagline ?? '';
$user = $current_user ?? null;
?>
<header class="bg-white border-b sticky top-0 z-40">
    <div class="container mx-auto px-4 py-3 flex items-center gap-6">
        <a href="<?= base_url() ?>" class="flex items-center flex-shrink-0" aria-label="<?= vp_safe_html($site) ?> home">
            <img src="<?= IMG_URL ?>logo-header.png" alt="<?= vp_safe_html($site) ?>" class="h-10 md:h-11 w-auto max-w-[190px] md:max-w-[220px] object-contain" width="900" height="258" decoding="async">
        </a>

        <nav class="hidden md:flex items-center gap-6 text-sm font-medium text-ink-900 ml-6">
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='products'?'text-brand-600':'' ?>" href="<?= base_url('products') ?>">Products</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='industries'?'text-brand-600':'' ?>" href="<?= base_url('industries') ?>">Industries</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='services'?'text-brand-600':'' ?>" href="<?= base_url('services') ?>">Services</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='about'?'text-brand-600':'' ?>" href="<?= base_url('about') ?>">About</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='blog'?'text-brand-600':'' ?>" href="<?= base_url('blog') ?>">Blog</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='careers'?'text-brand-600':'' ?>" href="<?= base_url('careers') ?>">Careers</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='faq'?'text-brand-600':'' ?>" href="<?= base_url('faq') ?>">FAQ</a>
            <a class="hover:text-brand-600 <?= $this->uri->segment(1)==='downloads'?'text-brand-600':'' ?>" href="<?= base_url('downloads') ?>">Downloads</a>
        </nav>

        <div class="ml-auto flex items-center gap-3">
            <a href="<?= base_url('rfq') ?>" class="hidden sm:inline-flex items-center gap-1 bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold px-4 py-2 rounded-lg">
                <i class="ri-quote-text"></i> Request a Quote
            </a>
            <?php if ($user): ?>
                <?php if (!empty($is_admin)): ?>
                    <a href="<?= base_url('admin') ?>" class="text-sm font-medium text-ink-900 hover:text-brand-600">Admin</a>
                <?php endif; ?>
                <a href="<?= base_url('logout') ?>" class="text-sm text-ink-800 hover:text-red-600">Sign out</a>
            <?php else: ?>
                <a href="<?= base_url('login') ?>" class="text-sm font-medium text-ink-900 hover:text-brand-600">Sign in</a>
            <?php endif; ?>
            <button class="md:hidden p-2" id="vp-mobile-toggle" aria-label="Menu">
                <i class="ri-menu-line text-2xl"></i>
            </button>
        </div>
    </div>

    <div class="md:hidden hidden border-t bg-white" id="vp-mobile-menu">
        <nav class="px-4 py-3 flex flex-col gap-2 text-sm font-medium">
            <a href="<?= base_url('products') ?>">Products</a>
            <a href="<?= base_url('industries') ?>">Industries</a>
            <a href="<?= base_url('services') ?>">Services</a>
            <a href="<?= base_url('about') ?>">About</a>
            <a href="<?= base_url('blog') ?>">Blog</a>
            <a href="<?= base_url('careers') ?>">Careers</a>
            <a href="<?= base_url('faq') ?>">FAQ</a>
            <a href="<?= base_url('downloads') ?>">Downloads</a>
            <a href="<?= base_url('contact') ?>">Contact</a>
            <a href="<?= base_url('rfq') ?>" class="text-brand-600 font-semibold">Request a Quote</a>
        </nav>
    </div>
</header>
