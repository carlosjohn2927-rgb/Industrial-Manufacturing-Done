<?php /** @var array $rows */ ?>
<form method="post" action="<?= base_url('admin/media/upload') ?>" enctype="multipart/form-data" class="vp-card vp-card-pad mb-4 flex items-center gap-2 flex-wrap">
    <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
    <input class="vp-input w-auto" name="folder" value="<?= vp_safe_html($folder) ?>" placeholder="folder (e.g. products)">
    <input class="vp-input" type="file" name="file" required>
    <button class="vp-btn vp-btn-primary" type="submit"><i class="ri-upload-line"></i> Upload</button>
</form>

<div class="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-6 gap-3">
    <?php foreach ($rows as $m): ?>
        <div class="vp-card overflow-hidden">
            <div class="aspect-square bg-gray-100 flex items-center justify-center text-gray-400 text-2xl">
                <?php if (strpos($m['mimeType'], 'image/') === 0): ?>
                    <img src="<?= base_url($m['url']) ?>" alt="" class="w-full h-full object-cover">
                <?php else: ?>
                    <i class="ri-file-3-line"></i>
                <?php endif; ?>
            </div>
            <div class="p-2">
                <div class="text-xs truncate" title="<?= vp_safe_html($m['originalName']) ?>"><?= vp_safe_html($m['originalName']) ?></div>
                <div class="text-[10px] text-gray-500"><?= vp_format_bytes($m['size']) ?></div>
                <div class="flex items-center justify-between mt-1">
                    <a class="text-[10px] text-brand-600 hover:underline" href="<?= base_url($m['url']) ?>" target="_blank">View</a>
                    <form action="<?= base_url('admin/media/delete/' . $m['id']) ?>" method="post" data-confirm="Delete this file?">
                        <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                        <button class="text-[10px] text-red-600 hover:underline" type="submit">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
</div>

<div class="mt-4 flex justify-center"><?= vp_pagination_links($total_pages, $page, $base_url) ?></div>
