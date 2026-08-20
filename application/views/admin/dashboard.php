<?php
/** @var array $counts */
/** @var array $quote_by_status */
/** @var array $recent_quotes */
/** @var array $recent_activity */
/** @var array|null $email_health */
?>
<?php
// Outgoing-mail health banner. Shown whenever the transport looks broken or
// recent sends have failed - this is the page an admin sees right after
// "my outgoing email does not send" reports.
$eh = $email_health ?? null;
$ehBadTransport = $eh && !empty($eh['transport']['misconfigured']);
$ehHasFailures  = $eh && (int) ($eh['failed_7d'] ?? 0) > 0;
?>
<?php if ($ehBadTransport || $ehHasFailures): ?>
<div class="rounded-lg px-4 py-3 mb-6 border <?= ($ehHasFailures || $ehBadTransport) ? 'bg-red-50 border-red-200 text-red-800' : '' ?>">
    <div class="font-bold">&#9888; Outgoing email needs attention</div>
    <ul class="list-disc ml-5 mt-1 text-sm space-y-1">
        <?php if ($ehBadTransport): ?>
            <li><?= vp_safe_html($eh['transport']['reason']) ?></li>
        <?php endif; ?>
        <?php if ($ehHasFailures): ?>
            <li><?= (int) $eh['failed_7d'] ?> email(s) failed to send in the last 7 days<?= (int) ($eh['sent_7d'] ?? 0) > 0 ? ' (' . (int) $eh['sent_7d'] . ' succeeded)' : '' ?>.
                <?php if (!empty($eh['last_error'])): ?>Last error: <code><?= vp_safe_html(substr((string) $eh['last_error'], 0, 200)) ?></code><?php endif; ?>
            </li>
        <?php endif; ?>
        <li>Diagnose from cPanel Terminal/SSH: <code>php install/test-mail.php --to=you@example.com</code></li>
    </ul>
</div>
<?php endif; ?>
<div class="grid md:grid-cols-4 gap-4 mb-6">
    <div class="vp-card vp-card-pad">
        <div class="text-xs uppercase text-gray-500">New RFQs</div>
        <div class="text-3xl font-extrabold text-ink-900 mt-1"><?= (int) $counts['quotes_new'] ?></div>
        <a href="<?= base_url('admin/quotes') ?>" class="text-xs text-brand-600 hover:underline">View all &rarr;</a>
    </div>
    <div class="vp-card vp-card-pad">
        <div class="text-xs uppercase text-gray-500">Products</div>
        <div class="text-3xl font-extrabold text-ink-900 mt-1"><?= (int) $counts['products'] ?></div>
        <a href="<?= base_url('admin/products') ?>" class="text-xs text-brand-600 hover:underline">Manage &rarr;</a>
    </div>
    <div class="vp-card vp-card-pad">
        <div class="text-xs uppercase text-gray-500">Open contacts</div>
        <div class="text-3xl font-extrabold text-ink-900 mt-1"><?= (int) $counts['contacts_new'] ?></div>
        <a href="<?= base_url('admin/contacts') ?>" class="text-xs text-brand-600 hover:underline">View &rarr;</a>
    </div>
    <div class="vp-card vp-card-pad">
        <div class="text-xs uppercase text-gray-500">Users</div>
        <div class="text-3xl font-extrabold text-ink-900 mt-1"><?= (int) $counts['users'] ?></div>
        <a href="<?= base_url('admin/users') ?>" class="text-xs text-brand-600 hover:underline">Manage &rarr;</a>
    </div>
</div>

<div class="grid lg:grid-cols-2 gap-4">
    <div class="vp-card">
        <div class="vp-card-pad border-b">
            <h2 class="font-bold">Quotes by status</h2>
        </div>
        <div class="vp-card-pad">
            <canvas id="vp-quotes-chart" height="200" data-quotes="<?= vp_safe_html(json_encode($quote_by_status)) ?>"></canvas>
        </div>
    </div>

    <div class="vp-card">
        <div class="vp-card-pad border-b flex items-center justify-between">
            <h2 class="font-bold">Recent RFQs</h2>
            <a href="<?= base_url('admin/quotes') ?>" class="text-xs text-brand-600 hover:underline">View all</a>
        </div>
        <div class="overflow-x-auto">
            <table class="vp-admin-table">
                <thead><tr><th>Quote #</th><th>Company</th><th>Status</th><th>Created</th></tr></thead>
                <tbody>
                <?php if (empty($recent_quotes)): ?>
                    <tr><td colspan="4" class="text-center text-gray-500">No quotes yet.</td></tr>
                <?php else: foreach ($recent_quotes as $q):
                    $st = vp_quote_status_label($q['status']); ?>
                    <tr>
                        <td><a class="text-brand-600 hover:underline font-semibold" href="<?= base_url('admin/quotes/' . $q['id']) ?>"><?= vp_safe_html($q['quoteNumber']) ?></a></td>
                        <td><?= vp_safe_html($q['companyName']) ?></td>
                        <td><span class="vp-pill <?= $st['class'] ?>"><?= $st['label'] ?></span></td>
                        <td class="text-xs text-gray-500"><?= vp_time_ago($q['createdAt']) ?></td>
                    </tr>
                <?php endforeach; endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="vp-card mt-4">
    <div class="vp-card-pad border-b">
        <h2 class="font-bold">Recent activity</h2>
    </div>
    <div class="vp-card-pad">
        <?php if (empty($recent_activity)): ?>
            <p class="text-gray-500 text-sm">No activity recorded yet.</p>
        <?php else: ?>
            <ul class="divide-y">
            <?php foreach ($recent_activity as $a): ?>
                <li class="py-2 flex items-center gap-3 text-sm">
                    <span class="vp-pill bg-gray-100 text-gray-700"><?= vp_safe_html($a['action']) ?></span>
                    <span class="font-mono text-xs text-gray-500"><?= vp_safe_html($a['resource']) ?></span>
                    <span class="text-gray-500 ml-auto"><?= vp_time_ago($a['createdAt']) ?></span>
                </li>
            <?php endforeach; ?>
            </ul>
        <?php endif; ?>
    </div>
</div>

<?php /* Chart is initialised by assets/js/admin.js reading the canvas'
         data-quotes attribute (inline scripts are blocked by the CSP). */ ?>
