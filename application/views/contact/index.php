<?php /** @var array $contact */ ?>
<section class="bg-gradient-to-br from-ink-900 via-ink-800 to-brand-900 text-white">
    <div class="container mx-auto px-4 py-12">
        <?= vp_inline_text('contact_hero_title', 'Contact us', 'h1', 'text-4xl font-extrabold') ?>
        <?= vp_inline_text('contact_hero_subtitle', 'Sales, service, careers and general enquiries - we respond within 1 business day.', 'p', 'text-white mt-2 max-w-2xl') ?>
    </div>
</section>
<section class="container mx-auto px-4 py-12 grid lg:grid-cols-3 gap-8">
    <div class="lg:col-span-2 vp-card vp-card-pad">
        <form method="post" action="<?= base_url('contact/submit') ?>" class="space-y-4">
            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
            <div class="vp-grid-2">
                <div class="vp-form-row"><label>Name *</label><input class="vp-input" name="name" required value="<?= vp_safe_html($this->input->post('name')) ?>"></div>
                <div class="vp-form-row"><label>Email *</label><input class="vp-input" type="email" name="email" required value="<?= vp_safe_html($this->input->post('email')) ?>"></div>
            </div>
            <div class="vp-grid-2">
                <div class="vp-form-row"><label>Company</label><input class="vp-input" name="company" value="<?= vp_safe_html($this->input->post('company')) ?>"></div>
                <div class="vp-form-row"><label>Phone</label><input class="vp-input" name="phone" value="<?= vp_safe_html($this->input->post('phone')) ?>"></div>
            </div>
            <div class="vp-grid-2">
                <div class="vp-form-row"><label>Department</label>
                    <select class="vp-select" name="department">
                        <option value="">General</option>
                        <option>Sales</option>
                        <option>Engineering</option>
                        <option>Service / Spares</option>
                        <option>Careers</option>
                    </select>
                </div>
                <div class="vp-form-row"><label>Subject *</label><input class="vp-input" name="subject" required value="<?= vp_safe_html($this->input->post('subject')) ?>"></div>
            </div>
            <div class="vp-form-row"><label>Message *</label><textarea class="vp-textarea" name="message" rows="6" required><?= vp_safe_html($this->input->post('message')) ?></textarea></div>
            <button class="vp-btn vp-btn-primary" type="submit"><i class="ri-send-plane-line"></i> Send message</button>
        </form>
    </div>
    <aside class="space-y-4">
        <div class="vp-card overflow-hidden">
            <img src="<?= IMG_URL ?>contact-engineer.jpg" alt="Industrial engineer discussing a customer project" class="w-full aspect-[4/3] object-cover" loading="lazy" decoding="async">
            <div class="p-5"><p class="text-sm text-ink-800">Talk directly with an engineer who understands your process and specifications.</p></div>
        </div>
        <div class="vp-card vp-card-pad">
            <h3 class="font-bold mb-2">Headquarters</h3>
            <p class="text-sm text-ink-800"><?= vp_safe_html($contact['address'] ?? '') ?></p>
        </div>
        <div class="vp-card vp-card-pad">
            <h3 class="font-bold mb-2">Sales</h3>
            <p class="text-sm"><a class="text-brand-600" href="mailto:<?= vp_safe_html($contact['email'] ?? '') ?>"><?= vp_safe_html($contact['email'] ?? '') ?></a></p>
            <p class="text-sm"><?= vp_safe_html($contact['phone'] ?? '') ?></p>
        </div>
        <div class="vp-card vp-card-pad">
            <h3 class="font-bold mb-2">RFQ</h3>
            <p class="text-sm text-ink-800">Use the <a class="text-brand-600 hover:underline" href="<?= base_url('rfq') ?>">Request a Quote</a> form for project enquiries.</p>
        </div>
    </aside>
</section>

<section class="container mx-auto px-4 pb-12">
    <div class="vp-card vp-card-pad">
        <h2 class="text-2xl font-bold mb-4">Find us</h2>
        <div class="overflow-hidden rounded-xl border">
            <iframe
                src="<?= vp_safe_html(vp_map_embed_url($contact['address'] ?? '')) ?>"
                width="100%" height="420" style="border:0; display:block;"
                allowfullscreen="" loading="lazy"
                referrerpolicy="no-referrer-when-downgrade"
                title="Map of our location"></iframe>
        </div>
    </div>
</section>
