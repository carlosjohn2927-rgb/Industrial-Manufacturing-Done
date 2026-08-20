<?php /** @var array $grouped */ ?>
<section class="relative bg-ink-900 text-white overflow-hidden min-h-[360px] flex items-end">
    <img src="<?= IMG_URL ?>downloads-library.jpg" alt="Industrial engineering guides and technical resources" class="absolute inset-0 w-full h-full object-cover" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-gradient-to-r from-ink-900 via-ink-900/85 to-transparent"></div>
    <div class="container mx-auto px-4 py-14 relative">
        <span class="text-xs font-semibold tracking-widest uppercase text-brand-200">Engineering resources</span>
        <h1 class="text-4xl lg:text-5xl font-extrabold mt-3">Downloads</h1>
        <p class="text-white mt-3 max-w-2xl text-lg">Brochures, selection guides, datasheets and engineering tools.</p>
    </div>
</section>
<section class="container mx-auto px-4 py-10 max-w-4xl">
    <?php foreach ($grouped as $cat => $rows): ?>
        <h2 class="text-xl font-bold mt-6 mb-3"><?= vp_safe_html($cat) ?></h2>
        <div class="grid sm:grid-cols-2 gap-3">
        <?php foreach ($rows as $d): ?>
            <a href="<?= base_url('downloads/file/' . $d['id']) ?>" class="vp-card vp-card-pad flex items-center gap-3 hover:shadow hover:border-brand-300">
                <i class="ri-file-download-line text-3xl text-brand-600"></i>
                <div class="flex-1">
                    <div class="font-semibold"><?= vp_safe_html($d['title']) ?></div>
                    <div class="text-xs text-ink-800"><?= vp_safe_html($d['type']) ?> &middot; <?= vp_safe_html($d['fileSize'] ?? '') ?> &middot; <?= (int) $d['downloads'] ?> downloads</div>
                </div>
            </a>
        <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
</section>
