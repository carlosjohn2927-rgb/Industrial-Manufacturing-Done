<?php
$site = $site_name ?? 'Halyk Petroleum';
$contact = $contact ?? [];
$social  = $social ?? [];
$vp_settings = $vp_settings ?? [];
?>
<footer class="bg-black text-white mt-16">
    <div class="container mx-auto px-4 py-12 grid md:grid-cols-4 gap-8">
        <div>
            <a href="<?= base_url() ?>" class="inline-block mb-4" aria-label="<?= vp_safe_html($site) ?> home">
                <img src="<?= IMG_URL ?>logo-footer.png" alt="<?= vp_safe_html($site) ?>" class="h-11 w-auto max-w-[240px] object-contain" width="900" height="210" loading="lazy" decoding="async">
            </a>
            <p class="text-sm text-white"><?= vp_safe_html($vp_settings['site_tagline'] ?? 'Industrial manufacturing excellence.') ?></p>
        </div>

        <div>
            <h4 class="text-white font-semibold mb-3">Solutions</h4>
            <ul class="space-y-2 text-sm">
                <li><a class="hover:text-white" href="<?= base_url('products') ?>">Products</a></li>
                <li><a class="hover:text-white" href="<?= base_url('industries') ?>">Industries</a></li>
                <li><a class="hover:text-white" href="<?= base_url('services') ?>">Services</a></li>
                <li><a class="hover:text-white" href="<?= base_url('rfq') ?>">Request a Quote</a></li>
            </ul>
        </div>

        <div>
            <h4 class="text-white font-semibold mb-3">Company</h4>
            <ul class="space-y-2 text-sm">
                <li><a class="hover:text-white" href="<?= base_url('about') ?>">About</a></li>
                <li><a class="hover:text-white" href="<?= base_url('blog') ?>">Blog</a></li>
                <li><a class="hover:text-white" href="<?= base_url('careers') ?>">Careers</a></li>
                <li><a class="hover:text-white" href="<?= base_url('contact') ?>">Contact</a></li>
            </ul>
        </div>

        <div>
            <h4 class="text-white font-semibold mb-3">Contact</h4>
            <ul class="space-y-2 text-sm">
                <li><i class="ri-map-pin-line"></i> <?= vp_safe_html($contact['address'] ?? '') ?></li>
                <li><i class="ri-phone-line"></i> <?= vp_safe_html($contact['phone'] ?? '') ?></li>
                <li><i class="ri-mail-line"></i> <a class="hover:text-white" href="mailto:<?= vp_safe_html($contact['email'] ?? '') ?>"><?= vp_safe_html($contact['email'] ?? '') ?></a></li>
            </ul>
            <div class="mt-4 flex gap-2 text-lg">
                <?php if (!empty($social['linkedin'])): ?><a class="hover:text-white" href="<?= vp_safe_html($social['linkedin']) ?>" rel="noopener" target="_blank"><i class="ri-linkedin-box-fill"></i></a><?php endif; ?>
                <?php if (!empty($social['twitter'])):  ?><a class="hover:text-white" href="<?= vp_safe_html($social['twitter']) ?>"  rel="noopener" target="_blank"><i class="ri-twitter-x-fill"></i></a><?php endif; ?>
                <?php if (!empty($social['facebook'])): ?><a class="hover:text-white" href="<?= vp_safe_html($social['facebook']) ?>" rel="noopener" target="_blank"><i class="ri-facebook-box-fill"></i></a><?php endif; ?>
                <?php if (!empty($social['youtube'])):  ?><a class="hover:text-white" href="<?= vp_safe_html($social['youtube']) ?>"  rel="noopener" target="_blank"><i class="ri-youtube-fill"></i></a><?php endif; ?>
            </div>
        </div>
    </div>
    <div class="border-t border-white/20">
        <div class="container mx-auto px-4 py-4 text-xs text-white flex flex-col md:flex-row justify-between gap-2">
            <div>&copy; <?= date('Y') ?> <?= vp_safe_html($site) ?>. All rights reserved.</div>
            <div>Built on CodeIgniter 3 + PHP + MariaDB.</div>
        </div>
    </div>
</footer>
