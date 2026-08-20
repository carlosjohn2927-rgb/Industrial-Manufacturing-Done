<?php /** @var array $rows */ /** @var array $users */ ?>
<form method="get" class="vp-card vp-card-pad mb-4 flex flex-wrap items-end gap-3">
    <div>
        <label class="text-xs font-semibold text-gray-500 uppercase">User</label>
        <select class="vp-select" name="userId">
            <option value="">All</option>
            <?php foreach ($users as $u): ?>
                <option value="<?= $u['id'] ?>" <?= $user === $u['id'] ? 'selected' : '' ?>><?= vp_safe_html(trim($u['firstName'].' '.$u['lastName'])) ?></option>
            <?php endforeach; ?>
        </select>
    </div>
    <div>
        <label class="text-xs font-semibold text-gray-500 uppercase">Action</label>
        <input class="vp-input" name="action" value="<?= vp_safe_html($action) ?>" placeholder="LOGIN, CREATE, UPDATE…">
    </div>
    <div>
        <label class="text-xs font-semibold text-gray-500 uppercase">Resource</label>
        <input class="vp-input" name="resource" value="<?= vp_safe_html($resource) ?>" placeholder="quote, product, user…">
    </div>
    <button class="vp-btn vp-btn-secondary" type="submit">Filter</button>
</form>
<div class="overflow-x-auto">
    <table class="vp-admin-table">
        <thead><tr><th>When</th><th>User</th><th>Action</th><th>Resource</th><th>ID</th><th>Details</th><th>IP</th></tr></thead>
        <tbody>
        <?php foreach ($rows as $r): ?>
            <tr>
                <td class="text-xs text-gray-500"><?= vp_time_ago($r['createdAt']) ?></td>
                <td class="text-xs"><?= vp_safe_html($r['userId'] ?? '—') ?></td>
                <td><span class="vp-pill bg-gray-100 text-gray-700"><?= vp_safe_html($r['action']) ?></span></td>
                <td class="text-xs"><?= vp_safe_html($r['resource']) ?></td>
                <td class="text-[10px] font-mono text-gray-500"><?= vp_safe_html(substr($r['resourceId'] ?? '', 0, 8)) ?></td>
                <td class="text-xs text-gray-600 max-w-md truncate"><?= vp_safe_html($r['details'] ?? '') ?></td>
                <td class="text-[10px] text-gray-500"><?= vp_safe_html($r['ipAddress'] ?? '') ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</div>
<div class="mt-4 flex justify-center"><?= vp_pagination_links($total_pages, $page, $base_url) ?></div>
