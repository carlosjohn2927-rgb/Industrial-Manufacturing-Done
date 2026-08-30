-- =====================================================================
-- Category artwork
-- =====================================================================
-- The base install schema includes this column, but older installations
-- created before category artwork was added do not. Keep the admin editor
-- and the public category grid compatible with both schemas.
ALTER TABLE `categories`
    ADD COLUMN `image` VARCHAR(255) DEFAULT NULL AFTER `icon`;
