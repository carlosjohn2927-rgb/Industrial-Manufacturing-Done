<?php
$user = $current_user ?? null;
?>
<header class="bg-white border-b px-6 py-3 flex items-center gap-4">
    <button class="md:hidden p-2" id="vp-admin-toggle"><i class="ri-menu-line text-2xl"></i></button>
    <h1 class="text-xl font-bold text-ink-900"><?= vp_safe_html($page_title ?: 'Admin') ?></h1>

    <div class="ml-auto flex items-center gap-4">
        <a href="<?= base_url('admin/notifications') ?>" class="relative p-2 rounded hover:bg-gray-100" title="Notifications">
            <i class="ri-notification-3-line text-xl"></i>
            <?php if (!empty($unread_notifications) && $unread_notifications > 0): ?>
                <span class="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] font-bold rounded-full px-1.5"><?= (int) $unread_notifications ?></span>
            <?php endif; ?>
        </a>
        <div class="flex items-center gap-2 text-sm">
            <img class="w-8 h-8 rounded-full bg-gray-200" src="<?= vp_avatar_url($user['email'] ?? 'admin@example.com', 64) ?>" alt="">
            <div class="hidden md:block">
                <div class="font-semibold leading-tight"><?= vp_safe_html(trim(($user['firstName'] ?? '') . ' ' . ($user['lastName'] ?? ''))) ?: 'Admin' ?></div>
                <div class="text-xs text-ink-800"><?= vp_safe_html(vp_role_label($user['role'] ?? '')) ?></div>
            </div>
        </div>
    </div>
</header>
