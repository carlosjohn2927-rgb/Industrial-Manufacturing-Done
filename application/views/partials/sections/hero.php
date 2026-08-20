<?php
/** Hero banner section. @var array $section */
$this->load->view('partials/sections/_helpers');
$img     = vp_asset_url($section['image'] ?? '', IMG_URL . 'hero-industrial.jpg');
$eyebrow = vp_section_option($section, 'eyebrow');
$badges  = (array) vp_section_option($section, 'badges', []);
?>
<section class="relative overflow-hidden bg-ink-900 text-white min-h-[520px] flex items-center"<?= vp_section_style_attr($section) ?>>
    <img src="<?= vp_safe_html($img) ?>" alt="<?= vp_safe_html($section['title'] ?? '') ?>" class="absolute inset-0 w-full h-full object-cover" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-gradient-to-r from-ink-900 via-ink-900/90 to-ink-900/20"></div>
    <div class="container mx-auto px-4 py-20 lg:py-28 relative">
        <div class="max-w-2xl">
            <?php if ($eyebrow): ?>
                <span class="inline-block text-xs font-semibold tracking-widest uppercase text-brand-200 bg-white/10 backdrop-blur px-3 py-1 rounded-full border border-white/10"><?= vp_safe_html($eyebrow) ?></span>
            <?php endif; ?>
            <?php if (!empty($section['title'])): ?>
                <h1 class="text-4xl lg:text-6xl font-extrabold mt-4 leading-tight"><?= vp_safe_html($section['title']) ?></h1>
            <?php endif; ?>
            <?php if (!empty($section['subtitle'])): ?>
                <p class="text-lg text-white mt-5 max-w-xl"><?= vp_safe_html($section['subtitle']) ?></p>
            <?php endif; ?>
            <?php if (!empty($section['body'])): ?>
                <div class="mt-4 text-white/90"><?= $section['body'] ?></div>
            <?php endif; ?>

            <div class="mt-8 flex flex-wrap gap-3">
                <?php if (!empty($section['buttonText'])): ?>
                    <a href="<?= vp_safe_html(vp_section_link($section['buttonUrl'])) ?>" class="bg-brand-500 hover:bg-brand-400 text-white font-semibold px-6 py-3 rounded-lg"><?= vp_safe_html($section['buttonText']) ?></a>
                <?php endif; ?>
                <?php if (!empty($section['buttonText2'])): ?>
                    <a href="<?= vp_safe_html(vp_section_link($section['buttonUrl2'])) ?>" class="bg-white/10 hover:bg-white/20 text-white font-semibold px-6 py-3 rounded-lg border border-white/20 backdrop-blur"><?= vp_safe_html($section['buttonText2']) ?></a>
                <?php endif; ?>
            </div>

            <?php if ($badges): ?>
                <div class="mt-10 flex flex-wrap gap-x-6 gap-y-2 text-sm text-white">
                    <?php foreach ($badges as $b): ?>
                        <span><i class="ri-checkbox-circle-line text-brand-300 mr-1"></i> <?= vp_safe_html($b) ?></span>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>
</section>
