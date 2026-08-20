<?php /** @var array $services */ ?>
<section class="relative bg-ink-900 overflow-hidden min-h-[400px] flex items-center">
    <img src="<?= IMG_URL ?>services-engineering.jpg" alt="Field engineer commissioning industrial equipment" class="absolute inset-0 w-full h-full object-cover object-center" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-black/25"></div>
    <div class="container mx-auto px-4 py-16 relative">
        <div class="vp-writeup-band max-w-2xl rounded-2xl shadow-xl p-6 md:p-8">
            <span class="text-xs font-semibold tracking-widest uppercase text-brand-700">Lifecycle support</span>
            <?= vp_inline_text('services_hero_title', 'Services', 'h1', 'text-4xl lg:text-5xl font-extrabold mt-3') ?>
            <?= vp_inline_text('services_hero_subtitle', 'From concept to commissioning, ' . ($site_name ?? 'Halyk Petroleum') . ' partners with you at every stage of the equipment lifecycle.', 'p', 'mt-3 text-lg') ?>
        </div>
    </div>
</section>
<section class="container mx-auto px-4 py-12">
    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
        <?php foreach ($services as $s): ?>
            <div class="vp-card vp-card-pad">
                <i class="<?= vp_safe_html($s['icon']) ?> text-3xl text-brand-600"></i>
                <h3 class="font-bold text-lg mt-3"><?= $s['title'] /* contains safe HTML */ ?></h3>
                <p class="text-sm text-ink-800 mt-2"><?= vp_safe_html($s['desc']) ?></p>
            </div>
        <?php endforeach; ?>
    </div>
    <div class="text-center mt-12">
        <a class="vp-btn vp-btn-primary" href="<?= base_url('rfq') ?>">Discuss your project with us</a>
    </div>
</section>
