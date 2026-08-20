<?php
/** @var array $row */
/** @var array $permissions */
/** @var array $catalog */
$is_super = ($row['role'] ?? '') === ROLE_SUPER_ADMIN;
?>
<div class="max-w-4xl space-y-6">
    <div class="bg-white border rounded-2xl p-5 flex flex-wrap items-center gap-4">
        <img class="w-14 h-14 rounded-full bg-gray-200" src="<?= vp_avatar_url($row['email'], 112) ?>" alt="">
        <div>
            <div class="font-bold text-lg text-ink-900"><?= vp_safe_html(trim($row['firstName'] . ' ' . $row['lastName'])) ?></div>
            <div class="text-sm text-ink-800/70"><?= vp_safe_html($row['email']) ?></div>
            <span class="vp-pill <?= $is_super ? 'bg-amber-100 text-amber-800' : 'bg-blue-100 text-blue-800' ?> mt-1 inline-block"><?= vp_role_label($row['role']) ?></span>
        </div>
        <div class="ml-auto text-right text-xs text-ink-800/60">
            Last sign-in<br><strong><?= $row['lastLoginAt'] ? vp_human_date($row['lastLoginAt']) : 'never' ?></strong>
        </div>
    </div>

    <?php if (!empty($row['mustChangePassword'])): ?>
        <div class="bg-amber-50 border border-amber-300 text-amber-900 rounded-xl px-4 py-3 text-sm">
            <strong>Temporary password.</strong> Choose a new password below before you can use the rest of the dashboard.
        </div>
    <?php endif; ?>

    <form method="post" action="<?= base_url('admin/profile/save') ?>" class="space-y-4">
        <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
        <?= vp_admin_card_open('My details', '', 'ri-user-settings-line') ?>
            <div class="grid md:grid-cols-2 gap-4">
                <?= vp_text_field('firstName', $row['firstName'], 'First name', ['required' => true]) ?>
                <?= vp_text_field('lastName', $row['lastName'], 'Last name', ['required' => true]) ?>
                <?= vp_text_field('email', $row['email'], 'Email address', ['type' => 'email', 'required' => true]) ?>
                <?= vp_text_field('phone', $row['phone'] ?? '', 'Phone') ?>
            </div>
            <p class="text-xs text-ink-800/60">Your role and permissions can only be changed by the Super Admin.</p>
            <button class="vp-btn vp-btn-primary" type="submit"><i class="ri-save-3-line"></i> Save profile</button>
        <?= vp_admin_card_close() ?>
    </form>

    <form method="post" action="<?= base_url('admin/profile/password') ?>" id="password" class="space-y-4">
        <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
        <?= vp_admin_card_open('Change password', 'Minimum 10 characters', 'ri-lock-password-line') ?>
            <div class="grid md:grid-cols-3 gap-4">
                <?= vp_text_field('current_password', '', 'Current password', ['type' => 'password', 'required' => true]) ?>
                <?= vp_text_field('new_password', '', 'New password', ['type' => 'password', 'required' => true]) ?>
                <?= vp_text_field('confirm_password', '', 'Confirm new password', ['type' => 'password', 'required' => true]) ?>
            </div>
            <button class="vp-btn vp-btn-primary" type="submit"><i class="ri-key-2-line"></i> Change password</button>
        <?= vp_admin_card_close() ?>
    </form>

    <?= vp_admin_card_open('What I can access', 'Granted by the Super Admin', 'ri-shield-check-line') ?>
        <?php if ($is_super): ?>
            <p class="text-sm"><i class="ri-shield-star-line text-amber-600"></i> <strong>Full access</strong> — the Super Admin controls the entire application.</p>
        <?php else: ?>
            <div class="flex flex-wrap gap-2">
                <?php foreach ($permissions as $p): ?>
                    <span class="vp-pill bg-green-100 text-green-800"><?= vp_safe_html($catalog[$p]['label'] ?? $p) ?></span>
                <?php endforeach; ?>
                <?php if (empty($permissions)): ?><span class="text-sm text-ink-800/60">No sections granted yet.</span><?php endif; ?>
            </div>
        <?php endif; ?>
    <?= vp_admin_card_close() ?>

    <?= vp_admin_card_open('My recent activity', '', 'ri-history-line') ?>
        <ul class="space-y-2 text-xs">
            <?php foreach ($activity as $a): ?>
                <li class="flex gap-2">
                    <span class="vp-pill bg-gray-100 text-gray-700"><?= vp_safe_html($a['action']) ?></span>
                    <span class="text-ink-800/70"><?= vp_safe_html($a['resource']) ?></span>
                    <span class="ml-auto text-ink-800/50"><?= vp_time_ago($a['createdAt']) ?></span>
                </li>
            <?php endforeach; ?>
            <?php if (empty($activity)): ?><li class="text-ink-800/60">Nothing recorded yet.</li><?php endif; ?>
        </ul>
    <?= vp_admin_card_close() ?>
</div>
