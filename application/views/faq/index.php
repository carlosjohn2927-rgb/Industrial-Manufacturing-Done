<?php /** @var array $grouped */ ?>
<section class="relative bg-ink-900 text-white overflow-hidden min-h-[380px] flex items-end">
    <img src="<?= IMG_URL ?>faq-engineer.jpg" alt="Application engineer answering a customer's technical question" class="absolute inset-0 w-full h-full object-cover" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-gradient-to-r from-ink-900 via-ink-900/85 to-transparent"></div>
    <div class="container mx-auto px-4 py-14 relative">
        <span class="text-xs font-semibold tracking-widest uppercase text-brand-200">Expert answers</span>
        <h1 class="text-4xl lg:text-5xl font-extrabold mt-3">FAQ</h1>
        <p class="text-white mt-3 max-w-2xl text-lg">Common questions about lead times, engineering, quality and more.</p>
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
