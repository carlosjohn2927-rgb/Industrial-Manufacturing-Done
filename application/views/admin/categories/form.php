<?php
/** @var array|null $row */
/** @var array $parent_options */
/** @var string $form_url */
/** @var string $redirect_url */
$is_create = empty($row);
$parent_options = $parent_options ?? [];
?>
<form method="post" action="<?= vp_safe_html($form_url) ?>" class="space-y-4 max-w-3xl">
    <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
    <?php if (!$is_create): ?><input type="hidden" name="id" value="<?= vp_safe_html($row['id']) ?>"><?php endif; ?>

    <div class="vp-form-row"><label>Name *</label><input class="vp-input" name="name" required maxlength="190" value="<?= vp_safe_html($row['name'] ?? '') ?>"></div>

    <div class="vp-grid-2">
        <div class="vp-form-row">
            <label>Slug</label>
            <input class="vp-input" name="slug" maxlength="190" value="<?= vp_safe_html($row['slug'] ?? '') ?>" placeholder="auto from name">
        </div>
        <div class="vp-form-row">
            <label>Parent category</label>
            <select class="vp-select" name="parentId">
                <option value="">— Top level —</option>
                <?php foreach ($parent_options as $c): ?>
                    <option value="<?= vp_safe_html($c['id']) ?>" <?= (($row['parentId'] ?? '') === $c['id'] ? 'selected' : '') ?>>
                        <?= vp_safe_html($c['name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>
    </div>

    <div class="vp-form-row">
        <label>Description</label>
        <textarea class="vp-textarea" name="description" rows="4" placeholder="Shown on the category's product listing page"><?= vp_safe_html($row['description'] ?? '') ?></textarea>
    </div>

    <div class="vp-grid-2">
        <div class="vp-form-row">
            <label>Icon</label>
            <input class="vp-input" name="icon" maxlength="190" value="<?= vp_safe_html($row['icon'] ?? '') ?>" placeholder="ri-settings-3-line (Remix Icon class)">
        </div>
        <div class="vp-form-row">
            <label>Sort order</label>
            <input class="vp-input" type="number" name="sortOrder" value="<?= (int) ($row['sortOrder'] ?? 0) ?>">
        </div>
    </div>

    <?= vp_media_field('image', $row['image'] ?? '', 'Image') ?>

    <div class="vp-form-row">
        <label>Meta title <span class="text-xs text-gray-400">(SEO)</span></label>
        <input class="vp-input" name="metaTitle" maxlength="255" value="<?= vp_safe_html($row['metaTitle'] ?? '') ?>">
    </div>
    <div class="vp-form-row">
        <label>Meta description <span class="text-xs text-gray-400">(SEO)</span></label>
        <textarea class="vp-textarea" name="metaDescription" rows="2" maxlength="500"><?= vp_safe_html($row['metaDescription'] ?? '') ?></textarea>
    </div>

    <div class="vp-form-row">
        <label class="inline-flex items-center gap-2">
            <input type="hidden" name="isActive" value="0">
            <input type="checkbox" name="isActive" value="1" <?= (!$is_create || !empty($row['isActive'])) ? 'checked' : '' ?>> Active
        </label>
    </div>

    <div class="flex items-center gap-2">
        <button class="vp-btn vp-btn-primary" type="submit"><?= $is_create ? 'Create' : 'Save' ?></button>
        <a class="vp-btn vp-btn-secondary" href="<?= base_url($redirect_url ?: 'admin/categories') ?>">Cancel</a>
    </div>
</form>
