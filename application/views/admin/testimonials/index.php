<?php /** @var array $rows */ ?>
<div class="flex items-center justify-between mb-4">
    <form method="get" class="flex items-center gap-2">
        <input class="vp-input" type="search" name="q" value="<?= vp_safe_html($search ?? '') ?>" placeholder="Search testimonials…">
        <button class="vp-btn vp-btn-secondary" type="submit">Search</button>
    </form>
    <a class="vp-btn vp-btn-primary" href="<?= base_url('admin/testimonials/create') ?>"><i class="ri-add-line"></i> New testimonial</a>
</div>

<div class="overflow-x-auto">
    <table class="vp-admin-table">
        <thead><tr><th>Customer</th><th>Testimonial</th><th>Rating</th><th>Featured</th><th>Status</th><th></th></tr></thead>
        <tbody>
        <?php if (empty($rows)): ?>
            <tr><td colspan="6" class="text-center text-gray-500">No testimonials found.</td></tr>
        <?php else: foreach ($rows as $row): ?>
            <tr>
                <td><strong><?= vp_safe_html($row['name']) ?></strong><br><span class="text-xs text-gray-500"><?= vp_safe_html($row['title']) ?>, <?= vp_safe_html($row['company']) ?></span></td>
                <td><?= vp_safe_html(vp_truncate($row['content'], 100)) ?></td>
                <td><?= str_repeat('★', max(0, min(5, (int) $row['rating']))) ?></td>
                <td><?= !empty($row['featured']) ? '<span class="vp-pill bg-blue-100 text-blue-800">Featured</span>' : '—' ?></td>
                <td><?= !empty($row['isActive']) ? '<span class="vp-pill bg-green-100 text-green-800">Active</span>' : '<span class="vp-pill bg-gray-200 text-gray-700">Hidden</span>' ?></td>
                <td class="text-right whitespace-nowrap">
                    <a class="text-brand-600 hover:underline text-xs" href="<?= base_url('admin/testimonials/edit/' . $row['id']) ?>">Edit</a>
                    <form action="<?= base_url('admin/testimonials/delete/' . $row['id']) ?>" method="post" class="inline" data-confirm="Delete this testimonial?">
                        <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                        <button class="text-red-600 hover:underline text-xs ml-2" type="submit">Delete</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; endif; ?>
        </tbody>
    </table>
</div>
<div class="mt-4 flex justify-center"><?= vp_pagination_links($total_pages, $page, $base_url) ?></div>
