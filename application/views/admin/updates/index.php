<?php /** @var array $updates */ /** @var int $pending */ /** @var string $driver */ /** @var bool $can_run */ /** @var bool $table_ok */ ?>
<div class="flex flex-wrap items-start gap-4 mb-6">
    <div>
        <h1 class="text-2xl font-bold">Database updates</h1>
        <p class="text-sm text-ink-800/60 mt-1 max-w-3xl">
            New products, categories and other catalog data live in the <strong>database</strong>, not in the PHP code —
            uploading or merging new files never adds them by itself. The SQL files shipped in
            <code>database/migrations/</code> must be applied to the database; this screen does that for you
            (no phpMyAdmin or terminal needed).
        </p>
    </div>
    <div class="ml-auto flex flex-wrap items-center gap-2">
        <?php if ($pending && $can_run && $table_ok): ?>
        <form method="post" action="<?= base_url('admin/updates/apply_all') ?>"
              data-confirm="Apply <?= (int) $pending ?> pending database update(s)? They are safe to re-run; updates that are already in place are skipped.">
            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
            <button class="vp-btn vp-btn-primary" type="submit"><i class="ri-play-circle-line"></i> Apply all pending (<?= (int) $pending ?>)</button>
        </form>
        <?php endif; ?>
        <?php if ($pending): ?>
        <form method="post" action="<?= base_url('admin/updates/mark_all') ?>"
              data-confirm="Mark every untracked update as applied WITHOUT running it? Only use this if you already imported the files by hand.">
            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
            <button class="vp-btn vp-btn-secondary" type="submit"><i class="ri-check-double-line"></i> Mark all as applied</button>
        </form>
        <?php endif; ?>
    </div>
</div>

<?php if (empty($table_ok)): ?>
<div class="rounded-lg px-4 py-3 border bg-red-50 border-red-200 text-red-800 text-sm mb-4">
    <strong>Could not create the <code>schema_migrations</code> tracking table.</strong>
    The database user needs CREATE permission, or the table must be created once by hand
    (see the schema in <code>application/models/Schema_update_model.php</code>).
    Until then this screen can still tell you what is missing, but it cannot record what has run.
</div>
<?php endif; ?>

<?php if ($driver === 'sqlite3'): ?>
<div class="rounded-lg px-4 py-3 border bg-blue-50 border-blue-200 text-blue-900 text-sm mb-4">
    <strong>Development SQLite database.</strong>
    The shipped SQL files use MySQL syntax and cannot be applied here — rebuild with
    <code>php install/dev-sqlite.php</code> instead. On the live MySQL/MariaDB site this screen works normally.
</div>
<?php endif; ?>

<div class="overflow-x-auto">
    <table class="vp-admin-table">
        <thead>
            <tr>
                <th>Version</th>
                <th>Update</th>
                <th>Status</th>
                <th>Applied</th>
                <th class="text-right">Statements</th>
                <th class="text-right">Actions</th>
            </tr>
        </thead>
        <tbody>
        <?php foreach ($updates as $u): ?>
            <tr>
                <td class="font-mono text-xs whitespace-nowrap"><?= vp_safe_html($u['version']) ?></td>
                <td>
                    <span class="font-semibold"><?= vp_safe_html($u['title']) ?></span>
                    <span class="block text-[11px] text-ink-800/50 font-mono"><?= vp_safe_html($u['file']) ?></span>
                    <?php if ($u['description']): ?>
                        <span class="block text-xs text-ink-800/60 mt-1 max-w-xl"><?= vp_safe_html($u['description']) ?></span>
                    <?php endif; ?>
                </td>
                <td>
                    <?php if ($u['state'] === 'applied'): ?>
                        <span class="vp-pill bg-green-100 text-green-800">
                            <?= $u['source'] === 'runner' ? 'Applied' : ($u['source'] === 'manual' ? 'Marked applied' : 'Applied (detected)') ?>
                        </span>
                    <?php elseif ($u['state'] === 'pending'): ?>
                        <span class="vp-pill bg-amber-100 text-amber-800">Pending</span>
                    <?php else: ?>
                        <span class="vp-pill bg-gray-100 text-gray-700">Not tracked</span>
                    <?php endif; ?>
                </td>
                <td class="text-xs text-ink-800/60 whitespace-nowrap">
                    <?php if ($u['appliedAt']): ?>
                        <?= vp_safe_html($u['appliedAt']) ?>
                        <?php if ($u['statements'] !== null && $u['source'] === 'runner'): ?>
                            <span class="block text-[11px] text-ink-800/40"><?= (int) $u['statements'] ?> ran<?php if ($u['skipped']): ?>, <?= (int) $u['skipped'] ?> skipped<?php endif; ?></span>
                        <?php endif; ?>
                    <?php else: ?>
                        —
                    <?php endif; ?>
                </td>
                <td class="text-right text-xs text-ink-800/60"><?= (int) $u['stmt_total'] ?></td>
                <td class="text-right whitespace-nowrap">
                    <?php if ($u['state'] !== 'applied'): ?>
                        <?php if ($can_run && $table_ok): ?>
                        <form class="inline" method="post" action="<?= base_url('admin/updates/apply/' . $u['version']) ?>"
                              data-confirm="Apply database update <?= vp_safe_html($u['version']) ?> (<?= vp_safe_html($u['title']) ?>)?">
                            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                            <button class="vp-btn vp-btn-primary vp-btn-sm" type="submit"><i class="ri-play-line"></i> Apply</button>
                        </form>
                        <?php endif; ?>
                        <form class="inline" method="post" action="<?= base_url('admin/updates/mark/' . $u['version']) ?>"
                              data-confirm="Mark <?= vp_safe_html($u['version']) ?> as applied WITHOUT running it?">
                            <input type="hidden" name="<?= $csrf_token_name ?>" value="<?= $csrf_token ?>">
                            <button class="vp-btn vp-btn-secondary vp-btn-sm" type="submit"><i class="ri-check-line"></i> Mark applied</button>
                        </form>
                    <?php else: ?>
                        <span class="text-xs text-ink-800/40">—</span>
                    <?php endif; ?>
                </td>
            </tr>
        <?php endforeach; ?>
        <?php if (!$updates): ?>
            <tr><td colspan="6" class="text-center text-ink-800/50 py-8">No SQL files found in <code>database/migrations/</code>.</td></tr>
        <?php endif; ?>
        </tbody>
    </table>
</div>

<div class="rounded-lg px-4 py-3 border bg-white text-sm text-ink-800/70 mt-6">
    <strong class="text-ink-900">Manual alternative.</strong>
    Every file in <code>database/migrations/</code> can still be imported the old way:
    cPanel → phpMyAdmin → select the database → <em>Import</em> → choose the file → <em>Go</em>.
    All shipped updates are safe to re-run, and files already applied by hand can be recorded here with
    <em>Mark applied</em>. After importing new code to the server, open this page — anything the release
    needs will show as <em>Pending</em> until it is applied.
</div>
