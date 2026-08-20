<?php /** @var array $rows */ ?>
<section class="relative bg-ink-900 text-white overflow-hidden min-h-[420px] flex items-end">
    <img src="<?= IMG_URL ?>careers-team.jpg" alt="Engineering and fabrication team collaborating" class="absolute inset-0 w-full h-full object-cover" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-gradient-to-r from-ink-900 via-ink-900/80 to-transparent"></div>
    <div class="absolute inset-0 bg-gradient-to-t from-ink-900/70 to-transparent"></div>
    <div class="container mx-auto px-4 py-14 relative">
        <span class="text-xs font-semibold tracking-widest uppercase text-brand-200">Build what matters</span>
        <?= vp_inline_text('careers_hero_title', 'Careers', 'h1', 'text-4xl lg:text-5xl font-extrabold mt-3') ?>
        <?= vp_inline_text('careers_hero_subtitle', 'Join a team that designs and builds the industrial equipment the world depends on.', 'p', 'text-white mt-3 max-w-2xl text-lg') ?>
    </div>
</section>
<section class="container mx-auto px-4 py-12 max-w-3xl">
    <?php if (empty($rows)): ?>
        <p class="text-ink-800 text-center py-12">No open positions right now. Please check back soon.</p>
    <?php else: ?>
        <div class="space-y-3">
        <?php foreach ($rows as $j): ?>
            <a href="<?= base_url('careers/' . $j['slug']) ?>" class="vp-card vp-card-pad block hover:shadow hover:border-brand-300">
                <div class="flex items-center justify-between flex-wrap gap-2">
                    <div>
                        <h3 class="font-bold text-lg"><?= vp_safe_html($j['title']) ?></h3>
                        <p class="text-xs text-ink-800"><?= vp_safe_html($j['department']) ?> &middot; <?= vp_safe_html($j['location']) ?> &middot; <?= vp_safe_html($j['type']) ?> <?= $j['experience'] ? ' &middot; ' . vp_safe_html($j['experience']) : '' ?></p>
                    </div>
                    <span class="text-brand-600 text-sm font-semibold">View role &rarr;</span>
                </div>
            </a>
        <?php endforeach; ?>
        </div>
    <?php endif; ?>
</section>
