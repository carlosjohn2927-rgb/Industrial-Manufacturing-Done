<?php /** @var array $services */ ?>
<section class="relative bg-ink-900 text-white overflow-hidden min-h-[400px] flex items-center">
    <img src="<?= IMG_URL ?>services-engineering.jpg" alt="Field engineer commissioning industrial equipment" class="absolute inset-0 w-full h-full object-cover object-center" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-gradient-to-r from-ink-900 via-ink-900/85 to-transparent"></div>
    <div class="container mx-auto px-4 py-16 relative">
        <div class="max-w-2xl">
            <span class="text-xs font-semibold tracking-widest uppercase text-brand-200">Lifecycle support</span>
            <h1 class="text-4xl lg:text-5xl font-extrabold mt-3">Services</h1>
            <p class="text-white mt-3 text-lg">From concept to commissioning, <?= vp_safe_html($site_name ?? 'Halyk Petroleum') ?> partners with you at every stage of the equipment lifecycle.</p>
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
