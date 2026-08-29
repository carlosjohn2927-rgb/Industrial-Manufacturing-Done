<?php
/**
 * System modules & status view.
 * Receives: $cs_title, $cs_intro
 */
$cs_title = $cs_title ?? 'Platform Modules';
$cs_intro = $cs_intro ?? 'All core system modules, catalog management, CMS page builder, RFQ pipeline, and admin controls are active.';
?>
<section class="vp-writeup-band bg-white border-b">
    <div class="container mx-auto px-4 py-16">
        <span class="text-xs font-semibold tracking-widest uppercase text-white bg-white/15 px-3 py-1 rounded-full">System Status</span>
        <h1 class="text-4xl font-extrabold mt-3"><?= vp_safe_html($cs_title) ?></h1>
        <p class="mt-3 max-w-2xl"><?= vp_safe_html($cs_intro) ?></p>
    </div>
</section>
<section class="container mx-auto px-4 py-16">
    <div class="vp-card vp-card-pad max-w-2xl">
        <h2 class="text-xl font-bold">Active System Modules</h2>
        <p class="text-ink-800 mt-2">The architecture, layouts, CSS/JS, database schema, security layers (Auth, RBAC, Settings, Mailer, Audit, Rate Limiter, Upload), and all functional modules are fully operational.</p>
        <h3 class="font-bold mt-6">Core Modules</h3>
        <ol class="list-decimal pl-5 mt-2 text-ink-900 space-y-1">
            <li><strong>Auth + Users + RBAC:</strong> Sign in, registration, password resets, session management, and granular permission controls.</li>
            <li><strong>Catalog &amp; Taxonomy:</strong> Products, Categories, Industries, and Downloads (public listing, filtering, and admin CRUD).</li>
            <li><strong>CMS &amp; Page Builder:</strong> Homepage block builder, live inline editor, and custom CMS pages.</li>
            <li><strong>RFQ Pipeline:</strong> Public quote submission, automated confirmation, status progression, staff assignment, PDF generation, and CSV export.</li>
            <li><strong>Content &amp; Editorial:</strong> Blog, Careers &amp; Applications, Inquiries, FAQs, News, Testimonials, and Partners.</li>
            <li><strong>Administration &amp; System:</strong> KPI Dashboard, Audit Logging, Staff Notifications, Media Library, and Branding controls.</li>
        </ol>
        <div class="mt-6 flex flex-wrap gap-2">
            <a href="<?= base_url() ?>" class="vp-btn vp-btn-primary">Back to home</a>
            <a href="<?= base_url('products') ?>" class="vp-btn vp-btn-secondary">Products</a>
            <a href="<?= base_url('rfq') ?>" class="vp-btn vp-btn-secondary">Request a Quote</a>
            <a href="<?= base_url('admin') ?>" class="vp-btn vp-btn-secondary">Dashboard</a>
        </div>
    </div>
</section>
