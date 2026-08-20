<?php
/** @var array $sections */
/** @var array $types */
/** @var string $pageKey */
?>
<div class="max-w-6xl space-y-5">

    <div class="bg-white border rounded-2xl p-4 flex flex-wrap items-center gap-3">
        <div class="flex items-center gap-2">
            <?php foreach ($page_keys as $key => $label): ?>
                <a class="vp-tab <?= $key === $pageKey ? 'vp-tab-active' : '' ?>" href="<?= base_url('admin/homepage/index/' . $key) ?>"><?= vp_safe_html($label) ?></a>
            <?php endforeach; ?>
        </div>
        <div class="ml-auto flex items-center gap-2">
            <a class="vp-btn vp-btn-secondary" href="<?= base_url($pageKey === 'home' ? '' : $pageKey) ?>" target="_blank" rel="noopener">
                <i class="ri-external-link-line"></i> Preview page
            </a>
        </div>
    </div>

    <!-- Add a section -->
    <section class="bg-white border rounded-2xl">
        <header class="px-5 py-4 border-b flex items-center gap-3">
            <i class="ri-add-box-line text-xl text-brand-600"></i>
            <div>
                <h2 class="font-bold text-ink-900">Add a section</h2>
                <p class="text-xs text-ink-800/60">Pick a block type — it is appended to the bottom of the page and can be reordered.</p>
            </div>
        </header>
        <div class="p-5 grid sm:grid-cols-2 lg:grid-cols-4 gap-3">
            <?php foreach ($types as $key => $t): ?>
                <a href="<?= base_url('admin/homepage/create/' . $pageKey . '?type=' . $key) ?>"
                   class="border rounded-xl px-4 py-3 hover:border-brand-400 hover:bg-brand-50/40 transition">
                    <div class="flex items-center gap-2 font-semibold text-sm text-ink-900"><i class="<?= vp_safe_html($t[1]) ?> text-brand-600"></i> <?= vp_safe_html($t[0]) ?></div>
                    <p class="text-[11px] text-ink-800/60 mt-1"><?= vp_safe_html($t[2]) ?></p>
                </a>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- Existing sections -->
    <section class="bg-white border rounded-2xl">
        <header class="px-5 py-4 border-b flex items-center gap-3">
            <i class="ri-stack-line text-xl text-brand-600"></i>
            <div>
                <h2 class="font-bold text-ink-900">Sections on this page</h2>
                <p class="text-xs text-ink-800/60">Order here is the order visitors see. Disabled sections are not rendered at all.</p>
            </div>
            <span class="ml-auto text-xs text-ink-800/60"><?= count($sections) ?> section(s)</span>
        </header>

        <div class="divide-y">
            <?php if (empty($sections)): ?>
                <p class="p-8 text-center text-sm text-ink-800/60">No sections yet — add one above.</p>
            <?php endif; ?>

            <?php foreach ($sections as $i => $s): $t = $types[$s['type']] ?? ['Section', 'ri-layout-line', '']; ?>
                <div class="vp-section-row px-5 py-4 flex flex-wrap items-center gap-4">
                    <div class="w-10 h-10 rounded-lg bg-brand-50 text-brand-700 flex items-center justify-center">
                        <i class="<?= vp_safe_html($t[1]) ?> text-xl"></i>
                    </div>
                    <div class="min-w-0 flex-1">
                        <div class="font-semibold text-ink-900 flex items-center gap-2">
                            <?= vp_safe_html($s['name'] ?: $t[0]) ?>
                            <?php if (!empty($s['isSystem'])): ?><span class="vp-pill bg-amber-100 text-amber-800">core</span><?php endif; ?>
                            <?php if (empty($s['isActive'])): ?><span class="vp-pill bg-gray-200 text-gray-700">hidden</span><?php endif; ?>
                        </div>
                        <div class="text-xs text-ink-800/60 truncate">
                            <?= vp_safe_html($t[0]) ?><?= $s['title'] ? ' · ' . vp_safe_html(vp_truncate($s['title'], 70)) : '' ?>
                        </div>
                    </div>

                    <div class="flex items-center gap-1">
                        <form method="post" action="<?= base_url('admin/homepage/move/' . $s['id'] . '/up') ?>">
                            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                            <button class="p-2 rounded hover:bg-gray-100 <?= $i === 0 ? 'opacity-30 pointer-events-none' : '' ?>" title="Move up"><i class="ri-arrow-up-line"></i></button>
                        </form>
                        <form method="post" action="<?= base_url('admin/homepage/move/' . $s['id'] . '/down') ?>">
                            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                            <button class="p-2 rounded hover:bg-gray-100 <?= $i === count($sections) - 1 ? 'opacity-30 pointer-events-none' : '' ?>" title="Move down"><i class="ri-arrow-down-line"></i></button>
                        </form>
                        <form method="post" action="<?= base_url('admin/homepage/toggle/' . $s['id']) ?>">
                            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                            <button class="vp-btn vp-btn-secondary vp-btn-sm" title="Show/hide on the website">
                                <i class="<?= empty($s['isActive']) ? 'ri-eye-off-line' : 'ri-eye-line' ?>"></i>
                                <?= empty($s['isActive']) ? 'Show' : 'Hide' ?>
                            </button>
                        </form>
                        <a class="vp-btn vp-btn-secondary vp-btn-sm" href="<?= base_url('admin/homepage/edit/' . $s['id']) ?>"><i class="ri-edit-line"></i> Edit</a>
                        <form method="post" action="<?= base_url('admin/homepage/delete/' . $s['id']) ?>" data-confirm="Delete this section from the page?">
                            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                            <button class="vp-btn vp-btn-secondary vp-btn-sm text-red-600"><i class="ri-delete-bin-line"></i></button>
                        </form>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </section>
</div>
