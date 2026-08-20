<?php
/**
 * Vortex Precision - public layout.
 * Receives: $content, $page_title, $page_description, $site_name, $site_tagline,
 *           $contact, $social, $current_user, $is_admin, $flash, $csrf_token_name,
 *           $csrf_token, $vp_settings, $unread_notifications
 */
?><!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <?= vp_seo_head($page_title, $page_description, null, $csp_nonce ?? '') ?>

    <link rel="icon" href="<?= IMG_URL ?>favicon.ico" sizes="any">
    <link rel="icon" href="<?= IMG_URL ?>favicon-32.png" type="image/png" sizes="32x32">
    <link rel="icon" href="<?= IMG_URL ?>favicon-16.png" type="image/png" sizes="16x16">
    <link rel="apple-touch-icon" href="<?= IMG_URL ?>apple-touch-icon.png" sizes="180x180">
    <link rel="manifest" href="<?= base_url('site.webmanifest') ?>">
    <meta name="theme-color" content="#0b1424">

    <!-- Tailwind via CDN (no build step, shared-hosting friendly) -->
    <script src="<?= JS_URL ?>tailwind-config.js?v=<?= VP_ASSET_VERSION ?>"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="<?= CSS_URL ?>app.css">
    <link rel="stylesheet" href="<?= CSS_URL ?>chat.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.0.0/fonts/remixicon.css" rel="stylesheet">

</head>
<body class="font-sans bg-white text-ink-800 antialiased flex flex-col min-h-screen">

<?php $this->load->view('partials/header', get_defined_vars()); ?>

<?php if ($flash): ?>
<div class="container mx-auto px-4 mt-4">
    <div class="rounded-lg px-4 py-3 border <?= $flash['type']==='error'?'bg-red-50 border-red-200 text-red-800':($flash['type']==='success'?'bg-green-50 border-green-200 text-green-800':'bg-blue-50 border-blue-200 text-blue-800') ?>">
        <?= vp_safe_html($flash['message']) ?>
    </div>
</div>
<?php endif; ?>

<main class="flex-1">
    <?= $content ?>
</main>

<?php $this->load->view('partials/footer', get_defined_vars()); ?>

<?php if (!empty($chat['enabled'])): ?>
    <?php $this->load->view('partials/chat_widget', get_defined_vars()); ?>
<?php endif; ?>

<script src="<?= JS_URL ?>app.js?v=<?= VP_ASSET_VERSION ?>"></script>
<script src="<?= JS_URL ?>chat.js?v=<?= VP_ASSET_VERSION ?>"></script>
<style id="vp-contrast-lock">
/* Last-in-document lock so Tailwind CDN cannot wash write-up back to grey. */
body { color: #0b1424; }
.vp-prose, .vp-prose p, .vp-prose li, .vp-card p, .vp-card li, .vp-review p, .vp-review {
    color: #0b1424;
}
.text-ink-800 { color: #101b2e !important; }
.text-ink-900 { color: #0b1424 !important; }
.text-white { color: #ffffff !important; }
.bg-ink-900 p, .bg-ink-800 p, .from-ink-900 p, .from-brand-600 p,
.bg-ink-900 li, .from-ink-900 li, .from-brand-600 li, footer p, footer li {
    color: #ffffff;
}
.bg-ink-900 .text-ink-800, .from-ink-900 .text-ink-800,
.bg-ink-900 .text-ink-900, .from-ink-900 .text-ink-900,
.from-brand-600 .text-ink-800, footer .text-ink-800, footer .text-ink-900 {
    color: #ffffff !important;
}
</style>
</body>
</html>
