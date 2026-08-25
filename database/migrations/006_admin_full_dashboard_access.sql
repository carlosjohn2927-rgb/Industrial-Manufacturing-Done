-- Administrator full-dashboard access
-- Run once in cPanel → phpMyAdmin → SQL after deploying this update.
-- This upgrades every account with the ADMIN role; it does not change users
-- with SALES, ENGINEER or EDITOR roles and does not change the SUPER_ADMIN.

UPDATE `permissions`
SET `superOnly` = 0
WHERE `key` IN ('admins.manage', 'system.manage');

-- The wildcard gives the ADMIN role every current dashboard permission.
-- Application code still protects the SUPER_ADMIN account itself from edits,
-- deletion, disabling and promotion by other administrators.
INSERT INTO `role_permissions` (`id`, `role`, `resource`, `actions`)
VALUES (UUID(), 'ADMIN', '*', JSON_ARRAY('*'))
ON DUPLICATE KEY UPDATE `actions` = VALUES(`actions`);
