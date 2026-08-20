<?php
/** Call-to-action band. @var array $section */
$this->load->view('partials/sections/_helpers');
?>
<section class="bg-gradient-to-r from-brand-600 to-brand-800 text-white">
    <div class="container mx-auto px-4 py-14 text-center">
        <?php if (!empty($section['title'])): ?><h2 class="text-3xl font-extrabold"><?= vp_safe_html($section['title']) ?></h2><?php endif; ?>
        <?php if (!empty($section['subtitle'])): ?><p class="text-white mt-2 max-w-2xl mx-auto"><?= vp_safe_html($section['subtitle']) ?></p><?php endif; ?>
        <?php if (!empty($section['body'])): ?><div class="mt-3 text-white/90 max-w-2xl mx-auto"><?= $section['body'] ?></div><?php endif; ?>
        <div class="mt-6 flex flex-wrap gap-3 justify-center">
            <?php if (!empty($section['buttonText'])): ?>
                <a href="<?= vp_safe_html(vp_section_link($section['buttonUrl'])) ?>" class="inline-block bg-white text-brand-700 font-bold px-6 py-3 rounded-lg"><?= vp_safe_html($section['buttonText']) ?></a>
            <?php endif; ?>
            <?php if (!empty($section['buttonText2'])): ?>
                <a href="<?= vp_safe_html(vp_section_link($section['buttonUrl2'])) ?>" class="inline-block bg-white/10 border border-white/30 text-white font-bold px-6 py-3 rounded-lg"><?= vp_safe_html($section['buttonText2']) ?></a>
            <?php endif; ?>
        </div>
    </div>
</section>
