<?php /** @var array $grouped */ ?>
<form method="post" action="<?= base_url('admin/settings/save') ?>">
    <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
    <?php foreach ($grouped as $group => $rows): ?>
        <div class="vp-card vp-card-pad mb-4">
            <h2 class="font-bold mb-3"><?= vp_safe_html($group) ?></h2>
            <?php foreach ($rows as $s): ?>
                <div class="vp-form-row">
                    <label><?= vp_safe_html($s['key']) ?></label>
                    <input type="hidden" name="key[]" value="<?= vp_safe_html($s['key']) ?>">
                    <input type="hidden" name="type[]" value="<?= vp_safe_html($s['type']) ?>">
                    <input type="hidden" name="group[]" value="<?= vp_safe_html($s['group']) ?>">
                    <?php if (in_array($s['type'], ['JSON', 'TEXT'])): ?>
                        <textarea class="vp-textarea" name="value[]" rows="3"><?= vp_safe_html($s['value']) ?></textarea>
                    <?php elseif ($s['type'] === 'BOOL'): ?>
                        <select class="vp-select" name="value[]">
                            <option value="1" <?= $s['value'] == '1' ? 'selected' : '' ?>>On</option>
                            <option value="0" <?= $s['value'] == '0' ? 'selected' : '' ?>>Off</option>
                        </select>
                    <?php elseif ($s['type'] === 'INT'): ?>
                        <input class="vp-input" type="number" name="value[]" value="<?= vp_safe_html($s['value']) ?>">
                    <?php else: ?>
                        <input class="vp-input" name="value[]" value="<?= vp_safe_html($s['value']) ?>">
                    <?php endif; ?>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endforeach; ?>
    <div class="flex items-center gap-2">
        <button class="vp-btn vp-btn-primary" type="submit">Save all settings</button>
    </div>
</form>
