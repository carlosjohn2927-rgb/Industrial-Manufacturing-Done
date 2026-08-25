-- Testimonials admin access repair
-- Run this once in cPanel → phpMyAdmin if the Testimonials item is missing
-- from an existing site's admin dashboard. It does not change testimonial data.

INSERT IGNORE INTO `permissions` (`id`, `key`, `label`, `groupName`, `superOnly`, `sortOrder`)
VALUES (UUID(), 'testimonials.manage', 'Manage testimonials', 'Content', 0, 14);

-- Give the standard Editor role access. Super Admin already has wildcard access.
INSERT INTO `role_permissions` (`id`, `role`, `resource`, `actions`)
VALUES (UUID(), 'EDITOR', 'testimonials', JSON_ARRAY('manage', 'read', 'create', 'update', 'delete'))
ON DUPLICATE KEY UPDATE `actions` = VALUES(`actions`);
