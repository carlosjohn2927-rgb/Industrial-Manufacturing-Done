<?php
/** @var array $featured  Featured products (4) */
/** @var array $industries  Active industries (6) */
/** @var array $testimonials Active testimonials */
/** @var array $partners Active partners */
/** @var array $vp_settings  All settings key/value */
/** @var array $categories  All active categories */

$heroTitle    = $vp_settings['hero_title']    ?? 'Precision-engineered for the most demanding industries';
$heroSubtitle = $vp_settings['hero_subtitle'] ?? (($site_name ?? 'Halyk Petroleum') . ' designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems trusted by operators worldwide.');
$ctaPrimary   = $vp_settings['hero_cta_primary']   ?? 'Request a Quote';
$ctaSecondary = $vp_settings['hero_cta_secondary'] ?? 'Explore Products';
$stats = [
    ['value' => ($vp_settings['stats_years']    ?? '35')    . '+', 'label' => 'Years of experience'],
    ['value' => ($vp_settings['stats_countries'] ?? '60')   . '+', 'label' => 'Countries served'],
    ['value' => ($vp_settings['stats_projects'] ?? '4200') . '+', 'label' => 'Projects delivered'],
    ['value' => ($vp_settings['stats_clients']  ?? '850')  . '+', 'label' => 'Satisfied clients'],
];
?>
<!-- Hero -->
<section class="relative overflow-hidden bg-ink-900 text-white min-h-[560px] flex items-center">
    <img src="<?= IMG_URL ?>hero-industrial.jpg" alt="Modern oil and gas processing facility" class="absolute inset-0 w-full h-full object-cover" fetchpriority="high" decoding="async">
    <div class="absolute inset-0 bg-gradient-to-r from-ink-900 via-ink-900/90 to-ink-900/20"></div>
    <div class="absolute inset-0 bg-gradient-to-t from-ink-900/70 via-transparent to-transparent"></div>
    <div class="container mx-auto px-4 py-20 lg:py-28 relative">
        <div class="max-w-2xl">
            <span class="inline-block text-xs font-semibold tracking-widest uppercase text-brand-200 bg-white/10 backdrop-blur px-3 py-1 rounded-full border border-white/10">Industrial manufacturing</span>
            <h1 class="text-4xl lg:text-6xl font-extrabold mt-4 leading-tight"><?= vp_safe_html($heroTitle) ?></h1>
            <p class="text-lg text-white mt-5 max-w-xl"><?= vp_safe_html($heroSubtitle) ?></p>
            <div class="mt-8 flex flex-wrap gap-3">
                <a href="<?= base_url('rfq') ?>" class="bg-brand-500 hover:bg-brand-400 text-white font-semibold px-6 py-3 rounded-lg"><?= vp_safe_html($ctaPrimary) ?></a>
                <a href="<?= base_url('products') ?>" class="bg-white/10 hover:bg-white/20 text-white font-semibold px-6 py-3 rounded-lg border border-white/20 backdrop-blur"><?= vp_safe_html($ctaSecondary) ?></a>
            </div>
            <div class="mt-10 flex flex-wrap gap-x-6 gap-y-2 text-sm text-white">
                <span><i class="ri-shield-check-line text-brand-300 mr-1"></i> ASME certified</span>
                <span><i class="ri-medal-line text-brand-300 mr-1"></i> ISO 9001:2015</span>
                <span><i class="ri-earth-line text-brand-300 mr-1"></i> Global support</span>
            </div>
        </div>
    </div>
</section>

<!-- Stats -->
<section class="bg-white border-b">
    <div class="container mx-auto px-4 py-10 grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
        <?php foreach ($stats as $s): ?>
            <div>
                <div class="text-3xl md:text-4xl font-extrabold text-brand-600"><?= vp_safe_html($s['value']) ?></div>
                <div class="text-sm text-ink-800 mt-1"><?= vp_safe_html($s['label']) ?></div>
            </div>
        <?php endforeach; ?>
    </div>
</section>

<!-- Categories -->
<section class="container mx-auto px-4 py-16">
    <div class="text-center max-w-2xl mx-auto mb-10">
        <h2 class="text-3xl font-extrabold text-ink-900">Our product categories</h2>
        <p class="text-ink-800 mt-3">From precision-machined valves to ASME-coded pressure vessels, every category is engineered to the same standard.</p>
    </div>
    <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
        <?php foreach ($categories as $c): ?>
            <a href="<?= base_url('products?category=' . urlencode($c['slug'])) ?>" class="group bg-white border rounded-2xl overflow-hidden hover:shadow-lg hover:border-brand-300 transition">
                <div class="aspect-[16/9] bg-gray-100 overflow-hidden">
                    <img src="<?= IMG_URL ?>products/<?= vp_safe_html($c['slug']) ?>.jpg" alt="<?= vp_safe_html($c['name']) ?> equipment" class="w-full h-full object-cover group-hover:scale-105 transition duration-500" loading="lazy" decoding="async" onerror="this.onerror=null;this.src='<?= IMG_URL ?>products/default.jpg'">
                </div>
                <div class="p-5">
                    <h3 class="font-bold text-lg text-ink-900"><?= vp_safe_html($c['name']) ?></h3>
                    <p class="text-sm text-ink-800 mt-2"><?= vp_safe_html(vp_truncate($c['description'] ?? '', 120)) ?></p>
                    <span class="text-brand-600 text-sm font-semibold mt-3 inline-block">Browse &rarr;</span>
                </div>
            </a>
        <?php endforeach; ?>
    </div>
</section>

<!-- Featured products -->
<?php if (!empty($featured)): ?>
<section class="bg-gray-50">
    <div class="container mx-auto px-4 py-16">
        <div class="flex items-end justify-between mb-8">
            <div>
                <h2 class="text-3xl font-extrabold text-ink-900">Featured products</h2>
                <p class="text-ink-800 mt-2">Our most-requested, in-stock equipment.</p>
            </div>
            <a href="<?= base_url('products') ?>" class="text-brand-600 font-semibold hidden sm:inline">View all &rarr;</a>
        </div>
        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <?php foreach ($featured as $p): ?>
                <a href="<?= base_url('products/' . $p['slug']) ?>" class="group bg-white rounded-2xl border overflow-hidden hover:shadow-lg transition flex flex-col">
                    <div class="aspect-[4/3] bg-gray-100 overflow-hidden">
                        <?= vp_product_image_tag($p, 'w-full h-full object-cover group-hover:scale-105 transition duration-300', null, 'eager') ?>
                    </div>
                    <div class="p-4 flex-1 flex flex-col">
                        <div class="text-xs text-ink-800 font-mono font-semibold"><?= vp_safe_html($p['sku']) ?></div>
                        <h3 class="font-bold text-ink-900 mt-1"><?= vp_safe_html($p['name']) ?></h3>
                        <p class="text-sm text-ink-900 mt-2 flex-1 leading-relaxed"><?= vp_safe_html(vp_truncate($p['shortDescription'] ?? $p['description'], 90)) ?></p>
                        <div class="mt-3 text-brand-600 text-sm font-semibold">View details &rarr;</div>
                    </div>
                </a>
            <?php endforeach; ?>
        </div>
    </div>
</section>
<?php endif; ?>

<!-- Industries -->
<section class="container mx-auto px-4 py-16">
    <div class="text-center max-w-2xl mx-auto mb-10">
        <h2 class="text-3xl font-extrabold text-ink-900">Industries we serve</h2>
        <p class="text-ink-800 mt-3">Engineered for the requirements of the world's most demanding sectors.</p>
    </div>
    <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
        <?php foreach ($industries as $i): ?>
            <a href="<?= base_url('industries/' . $i['slug']) ?>" class="group relative bg-white border rounded-2xl p-6 hover:shadow-lg hover:border-brand-300 transition overflow-hidden">
                <div class="absolute -right-6 -top-6 w-24 h-24 rounded-full bg-brand-50 group-hover:bg-brand-100 transition"></div>
                <div class="relative">
                    <i class="ri-government-line text-3xl text-brand-600"></i>
                    <h3 class="font-bold text-lg text-ink-900 mt-3"><?= vp_safe_html($i['name']) ?></h3>
                    <p class="text-sm text-ink-800 mt-2"><?= vp_safe_html(vp_truncate($i['description'], 110)) ?></p>
                </div>
            </a>
        <?php endforeach; ?>
    </div>
</section>

<!-- Testimonials -->
<?php if (!empty($testimonials)): ?>
<section class="bg-white">
    <div class="container mx-auto px-4 py-16">
        <div class="text-center max-w-2xl mx-auto mb-10">
            <h2 class="text-3xl font-extrabold text-ink-900">What our customers say</h2>
            <p class="text-ink-800 mt-3">Operators across oil and gas, chemicals, water and food processing trust our equipment and field teams.</p>
        </div>
        <div class="grid md:grid-cols-2 gap-5">
            <?php foreach ($testimonials as $t): ?>
                <blockquote class="vp-review bg-white border rounded-2xl p-6 shadow-sm">
                    <div class="flex items-center gap-4 mb-4">
                        <img src="<?= vp_safe_html(vp_testimonial_image($t)) ?>" alt="<?= vp_safe_html($t['name']) ?>" class="w-16 h-16 rounded-full object-cover border border-gray-200" width="128" height="128" loading="lazy" decoding="async">
                        <div>
                            <div class="font-bold text-ink-900"><?= vp_safe_html($t['name']) ?></div>
                            <div class="text-sm text-ink-800"><?= vp_safe_html($t['title']) ?>, <?= vp_safe_html($t['company']) ?></div>
                        </div>
                    </div>
                    <div class="text-yellow-500 mb-2"><?= str_repeat('<i class="ri-star-fill"></i>', max(0, (int)($t['rating'] ?? 5))) ?></div>
                    <p class="text-ink-900 leading-relaxed">&ldquo;<?= vp_safe_html($t['content']) ?>&rdquo;</p>
                </blockquote>
            <?php endforeach; ?>
        </div>
    </div>
</section>
<?php endif; ?>

<!-- Partners -->
<?php if (!empty($partners)): ?>
<section class="bg-white border-t">
    <div class="container mx-auto px-4 py-12">
        <p class="text-center text-xs uppercase tracking-widest text-ink-800 mb-6">Trusted by world-class operators</p>
        <div class="flex flex-wrap items-center justify-center gap-x-10 gap-y-6 opacity-80">
            <?php foreach ($partners as $p): ?>
                <a href="<?= vp_safe_html($p['website'] ?? '#') ?>" class="h-9 max-w-[150px]" target="_blank" rel="noopener" aria-label="<?= vp_safe_html($p['name']) ?>">
                    <img src="<?= vp_safe_html($p['logo']) ?>" alt="<?= vp_safe_html($p['name']) ?>" class="h-full w-auto max-w-full object-contain grayscale" loading="lazy" decoding="async">
                </a>
            <?php endforeach; ?>
        </div>
    </div>
</section>
<?php endif; ?>

<!-- CTA -->
<section class="bg-gradient-to-r from-brand-600 to-brand-800 text-white">
    <div class="container mx-auto px-4 py-14 text-center">
        <h2 class="text-3xl font-extrabold">Have a project in mind?</h2>
        <p class="text-white mt-2 max-w-2xl mx-auto">Submit your specifications and our engineering team will respond with a formal quote within 2 business days.</p>
        <a href="<?= base_url('rfq') ?>" class="mt-6 inline-block bg-white text-brand-700 font-bold px-6 py-3 rounded-lg">Request a Quote</a>
    </div>
</section>
