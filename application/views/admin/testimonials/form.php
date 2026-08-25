<?php /** @var array|null $row */ $is_create = empty($row); ?>
<form method="post" action="<?= base_url('admin/testimonials/save') ?>" class="space-y-4 max-w-3xl">
    <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
    <?php if (!$is_create): ?><input type="hidden" name="id" value="<?= vp_safe_html($row['id']) ?>"><?php endif; ?>

    <div class="vp-grid-2">
        <div class="vp-form-row"><label>Customer name *</label><input class="vp-input" name="name" required maxlength="190" value="<?= vp_safe_html($row['name'] ?? '') ?>"></div>
        <div class="vp-form-row"><label>Job title *</label><input class="vp-input" name="title" required maxlength="190" value="<?= vp_safe_html($row['title'] ?? '') ?>"></div>
        <div class="vp-form-row"><label>Company *</label><input class="vp-input" name="company" required maxlength="190" value="<?= vp_safe_html($row['company'] ?? '') ?>"></div>
        <div class="vp-form-row"><label>Industry</label><input class="vp-input" name="industry" maxlength="100" value="<?= vp_safe_html($row['industry'] ?? '') ?>"></div>
    </div>

    <div class="vp-form-row"><label>Testimonial *</label><textarea class="vp-textarea" name="content" rows="7" required><?= vp_safe_html($row['content'] ?? '') ?></textarea></div>

    <div class="vp-grid-2">
        <div class="vp-form-row">
            <label>Rating *</label>
            <select class="vp-input" name="rating" required>
                <?php $rating = (int) ($row['rating'] ?? 5); for ($i = 5; $i >= 1; $i--): ?>
                    <option value="<?= $i ?>" <?= $rating === $i ? 'selected' : '' ?>><?= $i ?> star<?= $i === 1 ? '' : 's' ?></option>
                <?php endfor; ?>
            </select>
        </div>
        <div class="vp-form-row"><label>Photo URL <span class="text-xs text-gray-500">(optional)</span></label><input class="vp-input" type="url" name="avatar" value="<?= vp_safe_html($row['avatar'] ?? '') ?>" placeholder="/assets/uploads/customer.jpg"></div>
    </div>

    <div class="flex flex-wrap gap-5">
        <label class="inline-flex items-center gap-2"><input type="hidden" name="isActive" value="0"><input type="checkbox" name="isActive" value="1" <?= ($is_create || !empty($row['isActive'])) ? 'checked' : '' ?>> Show on website</label>
        <label class="inline-flex items-center gap-2"><input type="hidden" name="featured" value="0"><input type="checkbox" name="featured" value="1" <?= !empty($row['featured']) ? 'checked' : '' ?>> Featured</label>
    </div>

    <div class="flex items-center gap-2">
        <button class="vp-btn vp-btn-primary" type="submit"><?= $is_create ? 'Create testimonial' : 'Save testimonial' ?></button>
        <a class="vp-btn vp-btn-secondary" href="<?= base_url('admin/testimonials') ?>">Cancel</a>
    </div>
</form>
