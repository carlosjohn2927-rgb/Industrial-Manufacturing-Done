<?php /** @var array $grouped */ ?>
<section class="relative bg-ink-900 overflow-hidden min-h-[380px] flex items-end">
    <img src="<?= IMG_URL ?>faq-engineer.jpg" alt="Application engineer answering a customer's technical question" class="absolute inset-0 w-full h-full object-cover" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-black/25"></div>
    <div class="container mx-auto px-4 py-14 relative">
        <div class="vp-writeup-band max-w-2xl rounded-2xl shadow-xl p-6 md:p-8">
            <span class="text-xs font-semibold tracking-widest uppercase text-brand-700">Expert answers</span>
            <?= vp_inline_text('faq_hero_title', 'FAQ', 'h1', 'text-4xl lg:text-5xl font-extrabold mt-3') ?>
            <?= vp_inline_text('faq_hero_subtitle', 'Common questions about lead times, engineering, quality and more.', 'p', 'mt-3 max-w-2xl text-lg') ?>
        </div>
    </div>
</section>
<section class="container mx-auto px-4 py-10 max-w-3xl">
    <?php foreach ($grouped as $cat => $rows): ?>
        <h2 class="text-xl font-bold mt-6 mb-3 text-ink-900"><?= vp_safe_html($cat) ?></h2>
        <div class="space-y-2">
        <?php foreach ($rows as $f): ?>
            <details class="vp-card vp-card-pad group">
                <summary class="cursor-pointer font-semibold flex items-center justify-between">
                    <?= vp_safe_html($f['question']) ?>
                    <i class="ri-arrow-down-s-line text-xl text-ink-800 group-open:rotate-180 transition"></i>
                </summary>
                <p class="mt-3 text-sm text-ink-900"><?= nl2br(vp_safe_html($f['answer'])) ?></p>
            </details>
        <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
</section>
