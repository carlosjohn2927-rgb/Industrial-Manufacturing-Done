<?php
/**
 * Vortex Precision - public layout.
 * Receives: $content, $page_title, $page_description, $site_name, $site_tagline,
 *           $contact, $social, $current_user, $is_admin, $flash, $csrf_token_name,
 *           $csrf_token, $vp_settings, $unread_notifications
 */
?><!doctype html>
<html lang="<?= vp_safe_html(vp_site('language', 'en')) ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <?= vp_seo_head($page_title, $page_description, null, $csp_nonce ?? '') ?>

    <!-- Favicon + touch icon come from Dashboard → Website → Logo & branding -->
    <link rel="icon" href="<?= vp_safe_html(vp_favicon_url()) ?>">
    <link rel="apple-touch-icon" href="<?= vp_safe_html(vp_logo_url('light')) ?>">
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

<?php if (!empty($admin_edit)): ?>
<div class="bg-ink-900 text-white border-b border-white/10" role="region" aria-label="Administrator page tools">
    <div class="container mx-auto px-4 py-2 flex flex-wrap items-center gap-3 text-sm">
        <span class="inline-flex items-center gap-2 text-white/90">
            <i class="ri-shield-user-line text-amber-400"></i>
            You are viewing the live website as <?= vp_is_super_admin() ? 'Super Admin' : 'Admin' ?>.
        </span>
        <div class="ml-auto flex items-center gap-2">
            <a href="<?= vp_safe_html($admin_edit['url']) ?>"
               class="inline-flex items-center gap-2 rounded-lg bg-brand-600 hover:bg-brand-500 px-3 py-1.5 font-semibold text-white">
                <i class="ri-edit-line"></i> <?= vp_safe_html($admin_edit['label']) ?>
            </a>
            <a href="<?= base_url('admin') ?>"
               class="inline-flex items-center gap-2 rounded-lg border border-white/30 hover:bg-white/10 px-3 py-1.5 font-semibold text-white">
                <i class="ri-dashboard-line"></i> Dashboard
            </a>
        </div>
    </div>
</div>
<?php endif; ?>

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
