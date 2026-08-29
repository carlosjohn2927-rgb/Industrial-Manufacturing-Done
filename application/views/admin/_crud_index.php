<?php
/** @var array $rows */
/** @var array $columns */

/*
 * Base URL of this CRUD section, e.g. "admin/categories".
 *
 * IMPORTANT: inside a CodeIgniter 3 view $this is the CI_Loader object, NOT
 * the controller — get_class($this) returns "CI_Loader", which used to produce
 * broken links like admin/ci_loader/edit/{id} (404 on every Edit / Delete /
 * New). Admin_Crud::index() passes $redirect_url for exactly this reason; the
 * router-based fallback below only exists as a safety net for other callers.
 */
$crud_url = $redirect_url ?? null;
if (!$crud_url) {
    $crud_url = strtolower(trim((string) $this->router->fetch_directory(), '/') . '/'
        . (string) $this->router->fetch_class());
    $crud_url = trim($crud_url, '/');
}
?>
<div class="flex items-center justify-between mb-4">
    <form method="get" class="flex items-center gap-2">
        <input class="vp-input" type="search" name="q" value="<?= vp_safe_html($search ?? '') ?>" placeholder="Search…">
        <button class="vp-btn vp-btn-secondary" type="submit">Search</button>
    </form>
    <a class="vp-btn vp-btn-primary" href="<?= base_url($crud_url) . '/create' ?>"><i class="ri-add-line"></i> New</a>
</div>

<div class="overflow-x-auto">
    <table class="vp-admin-table">
        <thead>
            <tr>
                <?php foreach ($columns as $label => $col): ?>
                    <th><?= vp_safe_html($label) ?></th>
                <?php endforeach; ?>
                <th></th>
            </tr>
        </thead>
        <tbody>
        <?php if (empty($rows)): ?>
            <tr><td colspan="<?= count($columns) + 1 ?>" class="text-center text-gray-500">No records.</td></tr>
        <?php else: foreach ($rows as $r): ?>
            <tr>
                <?php foreach ($columns as $label => $col): ?>
                    <td>
                        <?php
                        $v = $r[$col] ?? '';
                        if (in_array($col, ['name', 'title'], true)) {
                            echo '<a class="font-semibold text-brand-600 hover:underline" href="' . base_url($crud_url) . '/edit/' . $r['id'] . '">' . vp_safe_html($v) . '</a>';
                        } elseif (in_array($col, ['isActive', 'active'], true)) {
                            echo (int)$v ? '<span class="vp-pill bg-green-100 text-green-800">Active</span>' : '<span class="vp-pill bg-gray-200 text-gray-700">Off</span>';
                        } elseif (in_array($col, ['featured'], true)) {
                            echo (int)$v ? '<span class="vp-pill bg-blue-100 text-blue-800">★</span>' : '';
                        } elseif (in_array($col, ['createdAt','updatedAt','postedAt','publishedAt'], true)) {
                            echo '<span class="text-xs text-gray-500">' . vp_human_date($v) . '</span>';
                        } elseif (strlen((string)$v) > 80) {
                            echo vp_safe_html(vp_truncate($v, 80));
                        } else {
                            echo vp_safe_html($v);
                        }
                        ?>
                    </td>
                <?php endforeach; ?>
                <td class="text-right whitespace-nowrap">
                    <a class="text-brand-600 hover:underline text-xs" href="<?= base_url($crud_url) . '/edit/' . $r['id'] ?>">Edit</a>
                    <form action="<?= base_url($crud_url) . '/delete/' . $r['id'] ?>" method="post" class="inline" data-confirm="Delete this record?">
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
