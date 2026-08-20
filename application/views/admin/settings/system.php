<?php $this->load->view('admin/settings/_tabs', ['tabs' => $tabs, 'tab' => $tab]); ?>
<div class="max-w-4xl space-y-6">
    <div class="bg-amber-50 border border-amber-200 text-amber-900 rounded-xl px-4 py-3 text-sm flex gap-2">
        <i class="ri-shield-star-line text-lg"></i>
        <span><strong>Super Admin area.</strong> These switches affect the whole application.</span>
    </div>

    <?= vp_admin_card_open('Outgoing email', 'Transport currently used for quotes, contact forms and password resets', 'ri-mail-send-line') ?>
        <table class="text-sm w-full">
            <tr><td class="py-1 font-semibold w-40">Transport</td><td><?= vp_safe_html($email['transport'] ?? 'unknown') ?></td></tr>
            <tr><td class="py-1 font-semibold">Status</td>
                <td>
                    <span class="vp-pill <?= !empty($email['ok']) ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800' ?>">
                        <?= !empty($email['ok']) ? 'Configured' : 'Needs attention' ?>
                    </span>
                </td></tr>
            <?php if (!empty($email['message'])): ?>
                <tr><td class="py-1 font-semibold align-top">Detail</td><td class="text-ink-800/70"><?= vp_safe_html($email['message']) ?></td></tr>
            <?php endif; ?>
        </table>
        <p class="text-xs text-ink-800/60">Mail credentials live in the server environment (.env) and are never editable from the browser.</p>
    <?= vp_admin_card_close() ?>

    <form method="post" action="<?= base_url('admin/settings/save_system') ?>" class="space-y-6">
        <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
        <?= vp_admin_card_open('Maintenance mode', 'Visitors see a maintenance page; signed-in staff still see the site', 'ri-tools-line') ?>
            <?= vp_toggle_field('maintenance_mode', $values['maintenance_mode'] === '1', 'Enable maintenance mode') ?>
            <?= vp_textarea_field('maintenance_message', $values['maintenance_message'], 'Message shown to visitors', 3) ?>
        <?= vp_admin_card_close() ?>

        <?= vp_admin_card_open('Features', '', 'ri-toggle-line') ?>
            <?= vp_toggle_field('chat_enabled', $values['chat_enabled'] === '1', 'Enable the website chat assistant') ?>
            <?= vp_toggle_field('rfq_enabled', $values['rfq_enabled'] === '1', 'Accept quote requests (RFQ form)') ?>
            <div class="grid md:grid-cols-2 gap-4">
                <?= vp_text_field('rfq_admin_email', $values['rfq_admin_email'], 'Send new quote alerts to', ['type' => 'email']) ?>
                <?= vp_text_field('rfq_rate_limit_per_hour', $values['rfq_rate_limit_per_hour'], 'Quote requests allowed per hour / IP', ['type' => 'number']) ?>
            </div>
        <?= vp_admin_card_close() ?>

        <button class="vp-btn vp-btn-primary" type="submit"><i class="ri-save-3-line"></i> Save system settings</button>
    </form>
</div>
