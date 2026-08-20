<?php
/**
 * Vortex Precision - admin layout.
 * Receives: same as public, plus $current_user (with role), $is_admin, $unread_notifications.
 */
?><!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title><?= vp_safe_html($page_title ?: 'Admin') ?> | <?= vp_safe_html($site_name) ?> Admin</title>
    <link rel="icon" href="<?= IMG_URL ?>favicon.ico" sizes="any">
    <link rel="icon" href="<?= IMG_URL ?>favicon-32.png" type="image/png" sizes="32x32">
    <link rel="icon" href="<?= IMG_URL ?>favicon-16.png" type="image/png" sizes="16x16">
    <link rel="apple-touch-icon" href="<?= IMG_URL ?>apple-touch-icon.png" sizes="180x180">
    <link rel="manifest" href="<?= base_url('site.webmanifest') ?>">
    <meta name="theme-color" content="#0b1424">

    <script src="<?= JS_URL ?>tailwind-config.js?v=<?= VP_ASSET_VERSION ?>"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="<?= CSS_URL ?>app.css">
    <link rel="stylesheet" href="<?= CSS_URL ?>admin.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.0.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

</head>
<body class="admin font-sans bg-gray-50 text-ink-800 antialiased">

<div class="flex min-h-screen">
    <?php $this->load->view('partials/admin_sidebar', get_defined_vars()); ?>

    <div class="flex-1 flex flex-col min-w-0">
        <?php $this->load->view('partials/admin_nav', get_defined_vars()); ?>

        <?php if ($flash): ?>
        <div class="px-6 mt-4">
            <div class="rounded-lg px-4 py-3 border <?= $flash['type']==='error'?'bg-red-50 border-red-200 text-red-800':($flash['type']==='success'?'bg-green-50 border-green-200 text-green-800':'bg-blue-50 border-blue-200 text-blue-800') ?>">
                <?= vp_safe_html($flash['message']) ?>
            </div>
        </div>
        <?php endif; ?>

        <main class="flex-1 p-6">
            <?= $content ?>
        </main>

        <footer class="px-6 py-4 text-sm text-ink-800 border-t bg-white">
            <?= vp_safe_html($site_name ?? 'Halyk Petroleum') ?> Admin &middot; <?= date('Y') ?> &middot; <a class="hover:underline" href="<?= base_url() ?>" target="_blank">View public site</a>
        </footer>
    </div>
</div>

<script src="<?= JS_URL ?>app.js?v=<?= VP_ASSET_VERSION ?>"></script>
<script src="<?= JS_URL ?>admin.js?v=<?= VP_ASSET_VERSION ?>"></script>
</body>
</html>
