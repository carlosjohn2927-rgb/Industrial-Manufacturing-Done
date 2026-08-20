<?php
$user = $current_user ?? null;
$seg1 = $this->uri->segment(2) ?: 'dashboard';
$notif = (int) ($unread_notifications ?? 0);
?>
<aside class="bg-ink-900 text-white w-64 flex-shrink-0 hidden md:flex md:flex-col">
    <div class="p-4 border-b border-gray-800">
        <img src="<?= IMG_URL ?>logo-footer.png" alt="<?= vp_safe_html($site_name) ?>" class="h-8 w-auto max-w-[210px] object-contain" width="900" height="210" decoding="async">
        <div class="text-[10px] uppercase tracking-widest text-white mt-2">Administration</div>
    </div>

    <nav class="flex-1 overflow-y-auto p-3 space-y-1 text-sm">
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='dashboard'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin') ?>"><i class="ri-dashboard-line"></i> Dashboard</a>

        <div class="pt-3 pb-1 text-[10px] uppercase tracking-widest text-white">RFQ</div>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='quotes'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/quotes') ?>"><i class="ri-file-list-3-line"></i> Quotes</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='contacts'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/contacts') ?>"><i class="ri-mail-line"></i> Contacts</a>

        <div class="pt-3 pb-1 text-[10px] uppercase tracking-widest text-white">Catalog</div>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='products'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/products') ?>"><i class="ri-box-3-line"></i> Products</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='categories'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/categories') ?>"><i class="ri-price-tag-3-line"></i> Categories</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='industries'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/industries') ?>"><i class="ri-building-2-line"></i> Industries</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='downloads'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/downloads') ?>"><i class="ri-download-2-line"></i> Downloads</a>

        <div class="pt-3 pb-1 text-[10px] uppercase tracking-widest text-white">Content</div>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='blog'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/blog') ?>"><i class="ri-article-line"></i> Blog</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='news'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/news') ?>"><i class="ri-newspaper-line"></i> News</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='faqs'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/faqs') ?>"><i class="ri-question-line"></i> FAQs</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='careers'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/careers') ?>"><i class="ri-briefcase-line"></i> Careers</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='testimonials'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/testimonials') ?>"><i class="ri-star-smile-line"></i> Testimonials</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='partners'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/partners') ?>"><i class="ri-shake-hands-line"></i> Partners</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='media'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/media') ?>"><i class="ri-image-line"></i> Media</a>

        <div class="pt-3 pb-1 text-[10px] uppercase tracking-widest text-white">System</div>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='users'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/users') ?>"><i class="ri-user-line"></i> Users</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='seo'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/seo') ?>"><i class="ri-search-eye-line"></i> SEO</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='settings'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/settings') ?>"><i class="ri-settings-3-line"></i> Settings</a>
        <a class="flex items-center gap-2 px-3 py-2 rounded-lg <?= $seg1==='audit'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/audit') ?>"><i class="ri-shield-keyhole-line"></i> Audit Log</a>
        <a class="flex items-center justify-between px-3 py-2 rounded-lg <?= $seg1==='notifications'?'bg-brand-600 text-white':'hover:bg-gray-800' ?>" href="<?= base_url('admin/notifications') ?>">
            <span><i class="ri-notification-3-line"></i> Notifications</span>
            <?php if ($notif > 0): ?><span class="bg-red-500 text-white text-[10px] font-bold rounded-full px-2"><?= $notif ?></span><?php endif; ?>
        </a>
    </nav>

    <div class="p-3 border-t border-gray-800 text-xs">
        <a href="<?= base_url('admin/logout') ?>" class="block text-center py-2 rounded bg-gray-800 hover:bg-red-600">Sign out</a>
    </div>
</aside>
