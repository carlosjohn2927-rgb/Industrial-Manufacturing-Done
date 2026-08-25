-- =============================================================================
-- Vortex Precision / Vortex Precision IT — COMPLETE PRODUCTION DATABASE
-- =============================================================================
-- This single file contains everything needed for the application to run:
--   • All tables, columns, indexes, and foreign keys
--   • All seed/reference data (categories, industries, products, FAQs, etc.)
--   • All application settings
--   • An initial SUPER_ADMIN administrator account
--   • Sample blog posts, news, careers, and downloads
--
-- HOW TO USE:
--   1. In cPanel, go to phpMyAdmin.
--   2. Select your newly-created (empty) database.
--   3. Click the "Import" tab.
--   4. Choose this file (database/production.sql) and click "Go".
--   5. Wait for the import to complete.
--   6. The database is now fully initialized — no further CLI steps needed.
--
-- The admin account credentials are:
--   Email:    admin@vortexprecisionit.com
--   Password: Nigeria1234@
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'TRADITIONAL';

-- #############################################################################
-- 1. SCHEMA — all tables
-- #############################################################################

-- ---------------------------------------------------------------------------
-- Users + sessions + permissions
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id`              CHAR(36)     NOT NULL,
  `email`           VARCHAR(190) NOT NULL,
  `password`        VARCHAR(255) NOT NULL,
  `firstName`       VARCHAR(100) NOT NULL DEFAULT '',
  `lastName`        VARCHAR(100) NOT NULL DEFAULT '',
  `role`            ENUM('SUPER_ADMIN','ADMIN','SALES','ENGINEER','EDITOR','CUSTOMER') NOT NULL DEFAULT 'CUSTOMER',
  `phone`           VARCHAR(50)  DEFAULT NULL,
  `company`         VARCHAR(190) DEFAULT NULL,
  `avatar`          VARCHAR(255) DEFAULT NULL,
  `isActive`        TINYINT(1)   NOT NULL DEFAULT 1,
  `mustChangePassword` TINYINT(1) NOT NULL DEFAULT 0,
  `emailVerified`   TINYINT(1)   NOT NULL DEFAULT 0,
  `twoFactorEnabled` TINYINT(1)  NOT NULL DEFAULT 0,
  `lastLoginAt`     DATETIME     DEFAULT NULL,
  `createdAt`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `role_permissions` (
  `id`        CHAR(36)     NOT NULL,
  `role`      VARCHAR(40)  NOT NULL,
  `resource`  VARCHAR(100) NOT NULL,
  `actions`   JSON         NOT NULL,
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_resource` (`role`,`resource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sessions` (
  `id`         VARCHAR(128) NOT NULL,
  `user_id`    CHAR(36)     DEFAULT NULL,
  `ip_address` VARCHAR(45)  DEFAULT NULL,
  `user_agent` VARCHAR(255) DEFAULT NULL,
  `payload`    TEXT         NOT NULL,
  `last_activity` INT        NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sessions_user_id` (`user_id`),
  KEY `idx_sessions_last_activity` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CI3 native session table (for sess_driver=database)
CREATE TABLE IF NOT EXISTS `ci_sessions` (
  `id`            VARCHAR(128) NOT NULL,
  `ip_address`    VARCHAR(45)  NOT NULL,
  `timestamp`     INT UNSIGNED NOT NULL DEFAULT 0,
  `data`          BLOB        NOT NULL,
  `primary_key`   VARCHAR(64)  NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`ip_address`),
  KEY `ci_sessions_timestamp` (`timestamp`),
  KEY `ci_sessions_primary_key` (`primary_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Password reset tokens (single-use, time-limited)
CREATE TABLE IF NOT EXISTS `password_resets` (
  `id`         CHAR(36)     NOT NULL,
  `userId`     CHAR(36)     NOT NULL,
  `email`      VARCHAR(190) NOT NULL,
  `token`      VARCHAR(128) NOT NULL,
  `expiresAt`  DATETIME     NOT NULL,
  `usedAt`     DATETIME     DEFAULT NULL,
  `ipAddress`  VARCHAR(45)  DEFAULT NULL,
  `createdAt`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_password_resets_token` (`token`),
  KEY `idx_password_resets_email` (`email`),
  KEY `idx_password_resets_expires` (`expiresAt`),
  CONSTRAINT `fk_password_resets_user` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Catalog
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `categories` (
  `id`              CHAR(36)     NOT NULL,
  `name`            VARCHAR(190) NOT NULL,
  `slug`            VARCHAR(190) NOT NULL,
  `description`     TEXT         DEFAULT NULL,
  `icon`            VARCHAR(190) DEFAULT NULL,
  `image`           VARCHAR(255) DEFAULT NULL,
  `parentId`        CHAR(36)     DEFAULT NULL,
  `sortOrder`       INT          NOT NULL DEFAULT 0,
  `isActive`        TINYINT(1)   NOT NULL DEFAULT 1,
  `metaTitle`       VARCHAR(255) DEFAULT NULL,
  `metaDescription` VARCHAR(500) DEFAULT NULL,
  `createdAt`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_categories_slug` (`slug`),
  KEY `idx_categories_parent` (`parentId`),
  KEY `idx_categories_order` (`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `products` (
  `id`               CHAR(36)     NOT NULL,
  `name`             VARCHAR(255) NOT NULL,
  `slug`             VARCHAR(255) NOT NULL,
  `sku`              VARCHAR(100) NOT NULL,
  `description`      TEXT         NOT NULL,
  `shortDescription` VARCHAR(500) DEFAULT NULL,
  `price`            DECIMAL(12,2) DEFAULT NULL,
  `categoryId`       CHAR(36)     DEFAULT NULL,
  `industryIds`      JSON         DEFAULT NULL,
  `material`         VARCHAR(190) DEFAULT NULL,
  `pressure`         VARCHAR(100) DEFAULT NULL,
  `temperature`      VARCHAR(100) DEFAULT NULL,
  `voltage`          VARCHAR(100) DEFAULT NULL,
  `dimensions`       VARCHAR(190) DEFAULT NULL,
  `weight`           VARCHAR(100) DEFAULT NULL,
  `certifications`   JSON         DEFAULT NULL,
  `availability`     VARCHAR(40)  NOT NULL DEFAULT 'IN_STOCK',
  `featured`         TINYINT(1)   NOT NULL DEFAULT 0,
  `isActive`         TINYINT(1)   NOT NULL DEFAULT 1,
  `views`            INT          NOT NULL DEFAULT 0,
  `metaTitle`        VARCHAR(255) DEFAULT NULL,
  `metaDescription`  VARCHAR(500) DEFAULT NULL,
  `metaKeywords`     JSON         DEFAULT NULL,
  `createdAt`        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_products_slug` (`slug`),
  UNIQUE KEY `uk_products_sku` (`sku`),
  KEY `idx_products_category` (`categoryId`),
  KEY `idx_products_featured` (`featured`),
  KEY `idx_products_isActive` (`isActive`),
  KEY `idx_products_created` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_images` (
  `id`        CHAR(36)     NOT NULL,
  `productId` CHAR(36)     NOT NULL,
  `url`       VARCHAR(500) NOT NULL,
  `alt`       VARCHAR(255) DEFAULT NULL,
  `caption`   VARCHAR(500) DEFAULT NULL,
  `sortOrder` INT          NOT NULL DEFAULT 0,
  `isPrimary` TINYINT(1)   NOT NULL DEFAULT 0,
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_images_product` (`productId`),
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`productId`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `specifications` (
  `id`        CHAR(36) NOT NULL,
  `productId` CHAR(36) NOT NULL,
  `key`       VARCHAR(190) NOT NULL,
  `value`     VARCHAR(500) NOT NULL,
  `unit`      VARCHAR(40)  DEFAULT NULL,
  `sortOrder` INT          NOT NULL DEFAULT 0,
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_specifications_product` (`productId`),
  CONSTRAINT `fk_specifications_product` FOREIGN KEY (`productId`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `product_downloads` (
  `id`        CHAR(36)     NOT NULL,
  `productId` CHAR(36)     NOT NULL,
  `title`     VARCHAR(255) NOT NULL,
  `url`       VARCHAR(500) NOT NULL,
  `type`      VARCHAR(40)  NOT NULL DEFAULT 'PDF',
  `size`      VARCHAR(40)  DEFAULT NULL,
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_downloads_product` (`productId`),
  CONSTRAINT `fk_product_downloads_product` FOREIGN KEY (`productId`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `related_products` (
  `id`        CHAR(36) NOT NULL,
  `productId` CHAR(36) NOT NULL,
  `relatedId` CHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_related` (`productId`,`relatedId`),
  CONSTRAINT `fk_related_product`  FOREIGN KEY (`productId`) REFERENCES `products`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_related_related`  FOREIGN KEY (`relatedId`) REFERENCES `products`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Quotes / RFQ
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `quotes` (
  `id`              CHAR(36)      NOT NULL,
  `quoteNumber`     VARCHAR(40)   NOT NULL,
  `userId`          CHAR(36)      DEFAULT NULL,
  `companyName`     VARCHAR(255)  NOT NULL,
  `contactPerson`   VARCHAR(255)  NOT NULL,
  `email`           VARCHAR(190)  NOT NULL,
  `phone`           VARCHAR(50)   DEFAULT NULL,
  `country`         VARCHAR(100)  NOT NULL,
  `address`         VARCHAR(500)  DEFAULT NULL,
  `industry`        VARCHAR(190)  DEFAULT NULL,
  `status`          ENUM('NEW','REVIEWING','QUOTED','APPROVED','REJECTED','COMPLETED') NOT NULL DEFAULT 'NEW',
  `deadline`        DATE          DEFAULT NULL,
  `totalAmount`     DECIMAL(14,2) DEFAULT NULL,
  `notes`           TEXT          DEFAULT NULL,
  `internalNotes`   TEXT          DEFAULT NULL,
  `pdfUrl`          VARCHAR(500)  DEFAULT NULL,
  `assignedTo`      CHAR(36)      DEFAULT NULL,
  `statusUpdatedAt` DATETIME      DEFAULT NULL,
  `lastNotifiedAt`  DATETIME      DEFAULT NULL,
  `version`         INT           NOT NULL DEFAULT 1,
  `createdAt`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_quotes_number` (`quoteNumber`),
  KEY `idx_quotes_status` (`status`),
  KEY `idx_quotes_user` (`userId`),
  KEY `idx_quotes_assigned` (`assignedTo`),
  KEY `idx_quotes_created` (`createdAt`),
  CONSTRAINT `fk_quotes_user`     FOREIGN KEY (`userId`)     REFERENCES `users`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_quotes_assigned` FOREIGN KEY (`assignedTo`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quote_items` (
  `id`             CHAR(36) NOT NULL,
  `quoteId`        CHAR(36) NOT NULL,
  `productId`      CHAR(36) DEFAULT NULL,
  `productName`    VARCHAR(255) NOT NULL,
  `quantity`       INT NOT NULL DEFAULT 1,
  `specifications` TEXT DEFAULT NULL,
  `unitPrice`      DECIMAL(12,2) DEFAULT NULL,
  `total`          DECIMAL(14,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_quote_items_quote` (`quoteId`),
  KEY `idx_quote_items_product` (`productId`),
  CONSTRAINT `fk_quote_items_quote`   FOREIGN KEY (`quoteId`)   REFERENCES `quotes`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_quote_items_product` FOREIGN KEY (`productId`) REFERENCES `products`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quote_attachments` (
  `id`        CHAR(36) NOT NULL,
  `quoteId`   CHAR(36) NOT NULL,
  `filename`  VARCHAR(255) NOT NULL,
  `url`       VARCHAR(500) NOT NULL,
  `size`      INT DEFAULT NULL,
  `mimeType`  VARCHAR(100) DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_quote_attachments_quote` (`quoteId`),
  CONSTRAINT `fk_quote_attachments_quote` FOREIGN KEY (`quoteId`) REFERENCES `quotes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quote_status_history` (
  `id`         CHAR(36) NOT NULL,
  `quoteId`    CHAR(36) NOT NULL,
  `fromStatus` ENUM('NEW','REVIEWING','QUOTED','APPROVED','REJECTED','COMPLETED') DEFAULT NULL,
  `toStatus`   ENUM('NEW','REVIEWING','QUOTED','APPROVED','REJECTED','COMPLETED') NOT NULL,
  `changedBy`  CHAR(36) DEFAULT NULL,
  `notes`      TEXT DEFAULT NULL,
  `createdAt`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_qsh_quote_created` (`quoteId`,`createdAt`),
  CONSTRAINT `fk_qsh_quote` FOREIGN KEY (`quoteId`) REFERENCES `quotes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quote_activities` (
  `id`          CHAR(36) NOT NULL,
  `quoteId`     CHAR(36) NOT NULL,
  `actorId`     CHAR(36) DEFAULT NULL,
  `action`      ENUM('QUOTE_CREATED','ASSIGNED','STATUS_CHANGED','INTERNAL_NOTE_ADDED','QUOTE_UPDATED','PDF_GENERATED','EMAIL_QUEUED','EMAIL_SENT') NOT NULL,
  `description` VARCHAR(500) DEFAULT NULL,
  `metadata`    JSON DEFAULT NULL,
  `ipAddress`   VARCHAR(45) DEFAULT NULL,
  `userAgent`   VARCHAR(255) DEFAULT NULL,
  `createdAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_qa_quote_created` (`quoteId`,`createdAt`),
  CONSTRAINT `fk_qa_quote` FOREIGN KEY (`quoteId`) REFERENCES `quotes`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_qa_actor` FOREIGN KEY (`actorId`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `email_logs` (
  `id`             CHAR(36) NOT NULL,
  `to`             VARCHAR(190) NOT NULL,
  `subject`        VARCHAR(500) NOT NULL,
  `template`       VARCHAR(100) NOT NULL,
  `status`         ENUM('PENDING','SENT','FAILED','RETRYING') NOT NULL DEFAULT 'PENDING',
  `providerId`     VARCHAR(255) DEFAULT NULL,
  `dedupeKey`      VARCHAR(255) DEFAULT NULL,
  `errorMessage`   TEXT DEFAULT NULL,
  `sentAt`         DATETIME DEFAULT NULL,
  `retryCount`     INT NOT NULL DEFAULT 0,
  `relatedQuoteId` CHAR(36) DEFAULT NULL,
  `createdAt`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email_dedupe` (`dedupeKey`),
  KEY `idx_email_to_created` (`to`,`createdAt`),
  KEY `idx_email_quote` (`relatedQuoteId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Other content
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `contacts` (
  `id`        CHAR(36) NOT NULL,
  `userId`    CHAR(36) DEFAULT NULL,
  `name`      VARCHAR(190) NOT NULL,
  `email`     VARCHAR(190) NOT NULL,
  `phone`     VARCHAR(50)  DEFAULT NULL,
  `company`   VARCHAR(190) DEFAULT NULL,
  `subject`   VARCHAR(255) NOT NULL,
  `message`   TEXT NOT NULL,
  `department` VARCHAR(100) DEFAULT NULL,
  `status`    VARCHAR(40) NOT NULL DEFAULT 'NEW',
  `assignedTo` CHAR(36) DEFAULT NULL,
  `repliedAt` DATETIME DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_contacts_status` (`status`),
  KEY `idx_contacts_user` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `blog_posts` (
  `id`            CHAR(36) NOT NULL,
  `title`         VARCHAR(255) NOT NULL,
  `slug`          VARCHAR(255) NOT NULL,
  `excerpt`       TEXT DEFAULT NULL,
  `content`       LONGTEXT NOT NULL,
  `featuredImage` VARCHAR(500) DEFAULT NULL,
  `authorId`      CHAR(36) NOT NULL,
  `category`      VARCHAR(100) DEFAULT NULL,
  `tags`          JSON DEFAULT NULL,
  `status`        VARCHAR(40) NOT NULL DEFAULT 'DRAFT',
  `publishedAt`   DATETIME DEFAULT NULL,
  `views`         INT NOT NULL DEFAULT 0,
  `metaTitle`     VARCHAR(255) DEFAULT NULL,
  `metaDescription` VARCHAR(500) DEFAULT NULL,
  `createdAt`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_blog_slug` (`slug`),
  KEY `idx_blog_status_pub` (`status`,`publishedAt`),
  KEY `idx_blog_author` (`authorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `careers` (
  `id`          CHAR(36) NOT NULL,
  `title`       VARCHAR(255) NOT NULL,
  `slug`        VARCHAR(255) NOT NULL,
  `department`  VARCHAR(100) NOT NULL,
  `location`    VARCHAR(190) NOT NULL,
  `type`        VARCHAR(40)  NOT NULL DEFAULT 'Full-time',
  `experience`  VARCHAR(100) DEFAULT NULL,
  `salary`      VARCHAR(100) DEFAULT NULL,
  `description` LONGTEXT NOT NULL,
  `requirements` LONGTEXT NOT NULL,
  `benefits`    TEXT DEFAULT NULL,
  `isActive`    TINYINT(1) NOT NULL DEFAULT 1,
  `postedAt`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `closingAt`   DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_careers_slug` (`slug`),
  KEY `idx_careers_active` (`isActive`,`postedAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `applications` (
  `id`          CHAR(36) NOT NULL,
  `careerId`    CHAR(36) NOT NULL,
  `userId`      CHAR(36) DEFAULT NULL,
  `name`        VARCHAR(190) NOT NULL,
  `email`       VARCHAR(190) NOT NULL,
  `phone`       VARCHAR(50)  DEFAULT NULL,
  `coverLetter` TEXT DEFAULT NULL,
  `resumeUrl`   VARCHAR(500) NOT NULL,
  `linkedin`    VARCHAR(255) DEFAULT NULL,
  `status`      VARCHAR(40) NOT NULL DEFAULT 'RECEIVED',
  `notes`       TEXT DEFAULT NULL,
  `createdAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_applications_career` (`careerId`),
  KEY `idx_applications_status` (`status`),
  CONSTRAINT `fk_applications_career` FOREIGN KEY (`careerId`) REFERENCES `careers`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `testimonials` (
  `id`        CHAR(36) NOT NULL,
  `name`      VARCHAR(190) NOT NULL,
  `title`     VARCHAR(190) NOT NULL,
  `company`   VARCHAR(190) NOT NULL,
  `content`   TEXT NOT NULL,
  `rating`    INT NOT NULL DEFAULT 5,
  `avatar`    VARCHAR(500) DEFAULT NULL,
  `industry`  VARCHAR(100) DEFAULT NULL,
  `isActive`  TINYINT(1) NOT NULL DEFAULT 1,
  `featured`  TINYINT(1) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_testimonials_active` (`isActive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `partners` (
  `id`        CHAR(36) NOT NULL,
  `name`      VARCHAR(190) NOT NULL,
  `logo`      VARCHAR(500) NOT NULL,
  `website`   VARCHAR(500) DEFAULT NULL,
  `category`  VARCHAR(100) DEFAULT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive`  TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_partners_order` (`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `news` (
  `id`          CHAR(36) NOT NULL,
  `title`       VARCHAR(255) NOT NULL,
  `slug`        VARCHAR(255) NOT NULL,
  `summary`     TEXT DEFAULT NULL,
  `content`     LONGTEXT NOT NULL,
  `image`       VARCHAR(500) DEFAULT NULL,
  `category`    VARCHAR(100) DEFAULT NULL,
  `publishedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isActive`    TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_news_slug` (`slug`),
  KEY `idx_news_active_pub` (`isActive`,`publishedAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `downloads` (
  `id`          CHAR(36) NOT NULL,
  `title`       VARCHAR(255) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `fileUrl`     VARCHAR(500) NOT NULL,
  `type`        VARCHAR(40) NOT NULL DEFAULT 'PDF',
  `category`    VARCHAR(100) DEFAULT NULL,
  `fileSize`    VARCHAR(40) DEFAULT NULL,
  `downloads`   INT NOT NULL DEFAULT 0,
  `isActive`    TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_downloads_active` (`isActive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `faqs` (
  `id`        CHAR(36) NOT NULL,
  `question`  VARCHAR(500) NOT NULL,
  `answer`    TEXT NOT NULL,
  `category`  VARCHAR(100) NOT NULL,
  `sortOrder` INT NOT NULL DEFAULT 0,
  `isActive`  TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_faqs_active_order` (`isActive`,`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `industries` (
  `id`            CHAR(36) NOT NULL,
  `name`          VARCHAR(190) NOT NULL,
  `slug`          VARCHAR(190) NOT NULL,
  `description`   TEXT NOT NULL,
  `image`         VARCHAR(500) DEFAULT NULL,
  `icon`          VARCHAR(190) DEFAULT NULL,
  `capabilities`  JSON DEFAULT NULL,
  `metaTitle`     VARCHAR(255) DEFAULT NULL,
  `metaDescription` VARCHAR(500) DEFAULT NULL,
  `sortOrder`     INT NOT NULL DEFAULT 0,
  `isActive`      TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_industries_slug` (`slug`),
  KEY `idx_industries_order` (`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `settings` (
  `id`         CHAR(36) NOT NULL,
  `key`        VARCHAR(190) NOT NULL,
  `value`      LONGTEXT NOT NULL,
  `type`       VARCHAR(40) NOT NULL DEFAULT 'STRING',
  `group`      VARCHAR(40) NOT NULL DEFAULT 'GENERAL',
  `version`    INT NOT NULL DEFAULT 1,
  `enabled`    TINYINT(1) NOT NULL DEFAULT 1,
  `sortOrder`  INT NOT NULL DEFAULT 0,
  `updatedBy`  CHAR(36) DEFAULT NULL,
  `createdAt`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_settings_key` (`key`),
  KEY `idx_settings_group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `media` (
  `id`           CHAR(36) NOT NULL,
  `filename`     VARCHAR(255) NOT NULL,
  `originalName` VARCHAR(255) NOT NULL,
  `url`          VARCHAR(500) NOT NULL,
  `mimeType`     VARCHAR(100) NOT NULL,
  `size`         INT NOT NULL,
  `folder`       VARCHAR(100) DEFAULT 'general',
  `alt`          VARCHAR(255) DEFAULT NULL,
  `title`        VARCHAR(255) DEFAULT NULL,
  `uploadedBy`   CHAR(36) DEFAULT NULL,
  `isProtected`  TINYINT(1) NOT NULL DEFAULT 0,
  `createdAt`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_media_folder` (`folder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id`         CHAR(36) NOT NULL,
  `userId`     CHAR(36) DEFAULT NULL,
  `action`     VARCHAR(40) NOT NULL,
  `resource`   VARCHAR(100) NOT NULL,
  `resourceId` CHAR(36) DEFAULT NULL,
  `details`    JSON DEFAULT NULL,
  `ipAddress`  VARCHAR(45) DEFAULT NULL,
  `userAgent`  VARCHAR(255) DEFAULT NULL,
  `createdAt`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_user` (`userId`),
  KEY `idx_audit_resource` (`resource`,`resourceId`),
  KEY `idx_audit_created` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `notifications` (
  `id`        CHAR(36) NOT NULL,
  `userId`    CHAR(36) NOT NULL,
  `type`      VARCHAR(40) NOT NULL,
  `title`     VARCHAR(255) NOT NULL,
  `message`   TEXT NOT NULL,
  `data`      JSON DEFAULT NULL,
  `read`      TINYINT(1) NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notif_user_read` (`userId`,`read`),
  CONSTRAINT `fk_notif_user` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- #############################################################################
-- 2. ADMINISTRATOR ACCOUNT (fixed UUID so blog posts can reference it)
-- #############################################################################
-- Email:    admin@vortexprecisionit.com
-- Password: Nigeria1234@
--
-- The password is bcrypt-hashed (cost 12). To change it, either:
--   • Log into the admin panel → Users → edit your account
--   • Or hash a new password and UPDATE this row
-- #############################################################################

INSERT INTO `users` (`id`, `email`, `password`, `firstName`, `lastName`, `role`, `company`, `isActive`, `mustChangePassword`, `emailVerified`, `createdAt`, `updatedAt`)
VALUES (
  'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
  'admin@vortexprecisionit.com',
  '$2b$12$XlT9QtIvi44/HE9Pf84ElOoDnG/GBvn5gxRM8fvOxU69j065wwwuS',
  'Admin',
  'User',
  'SUPER_ADMIN',
  'Vortex Precision IT',
  1,
  0,
  1,
  NOW(),
  NOW()
) ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`),
  `isActive` = VALUES(`isActive`),
  `mustChangePassword` = VALUES(`mustChangePassword`),
  `role` = VALUES(`role`),
  `updatedAt` = NOW();

-- #############################################################################
-- 3. DEFAULT ROLE PERMISSIONS
-- #############################################################################
INSERT INTO `role_permissions` (`id`,`role`,`resource`,`actions`) VALUES
(UUID(),'SUPER_ADMIN','*',JSON_ARRAY('*')),
(UUID(),'ADMIN','products',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','categories',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','quotes',JSON_ARRAY('read','create','update','delete','export','status')),
(UUID(),'ADMIN','contacts',JSON_ARRAY('read','update','delete')),
(UUID(),'ADMIN','blog',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','careers',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','faqs',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','downloads',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','industries',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','news',JSON_ARRAY('read','create','update','delete')),
(UUID(),'ADMIN','users',JSON_ARRAY('read','update')),
(UUID(),'ADMIN','settings',JSON_ARRAY('read','update')),
(UUID(),'ADMIN','homepage',JSON_ARRAY('read','create','update','delete','manage')),
(UUID(),'ADMIN','pages',JSON_ARRAY('read','create','update','delete','manage')),
(UUID(),'ADMIN','menus',JSON_ARRAY('read','create','update','delete','manage')),
(UUID(),'ADMIN','appearance',JSON_ARRAY('read','update','manage')),
(UUID(),'ADMIN','media',JSON_ARRAY('read','create','delete')),
(UUID(),'ADMIN','audit',JSON_ARRAY('read')),
(UUID(),'SALES','products',JSON_ARRAY('read')),
(UUID(),'SALES','categories',JSON_ARRAY('read')),
(UUID(),'SALES','quotes',JSON_ARRAY('read','create','update','status','export')),
(UUID(),'SALES','contacts',JSON_ARRAY('read','update')),
(UUID(),'ENGINEER','products',JSON_ARRAY('read','update')),
(UUID(),'ENGINEER','quotes',JSON_ARRAY('read','update')),
(UUID(),'EDITOR','blog',JSON_ARRAY('read','create','update','delete')),
(UUID(),'EDITOR','news',JSON_ARRAY('read','create','update','delete')),
(UUID(),'EDITOR','faqs',JSON_ARRAY('read','create','update','delete')),
(UUID(),'EDITOR','downloads',JSON_ARRAY('read','create','update','delete')),
(UUID(),'EDITOR','industries',JSON_ARRAY('read','create','update','delete'))
ON DUPLICATE KEY UPDATE `actions`=VALUES(`actions`);

-- #############################################################################
-- 4. CATEGORIES
-- #############################################################################
INSERT INTO `categories` (`id`,`name`,`slug`,`description`,`icon`,`sortOrder`,`isActive`,`metaTitle`) VALUES
(UUID(),'Valves','valves','Industrial valves for flow control in demanding applications.','valve',1,1,'Industrial Valves - Vortex Precision IT'),
(UUID(),'Pumps','pumps','Centrifugal, positive displacement and specialty pumps.','pump',2,1,'Industrial Pumps - Vortex Precision IT'),
(UUID(),'Heat Exchangers','heat-exchangers','Shell-and-tube, plate and brazed heat exchangers.','heater',3,1,'Heat Exchangers - Vortex Precision IT'),
(UUID(),'Pressure Vessels','pressure-vessels','ASME-coded pressure vessels for process industries.','vessel',4,1,'Pressure Vessels - Vortex Precision IT'),
(UUID(),'Filtration','filtration','Industrial filtration systems and cartridges.','filter',5,1,'Filtration Systems - Vortex Precision IT'),
(UUID(),'Instrumentation','instrumentation','Process measurement, gauges and sensors.','gauge',6,1,'Instrumentation - Vortex Precision IT');

-- #############################################################################
-- 5. INDUSTRIES
-- #############################################################################
INSERT INTO `industries` (`id`,`name`,`slug`,`description`,`icon`,`sortOrder`,`isActive`,`metaTitle`,`capabilities`) VALUES
(UUID(),'Oil & Gas','oil-gas','Upstream, midstream and downstream solutions engineered for the most demanding hydrocarbon environments.','oil',1,1,'Oil & Gas Solutions - Vortex Precision IT', JSON_ARRAY('ASME B31.3 piping','API 610 pumps','API 600 valves','NACE MR0175 compliance')),
(UUID(),'Chemical Processing','chemical-processing','Corrosion-resistant equipment for aggressive chemistries and continuous-duty plants.','flask',2,1,'Chemical Processing - Vortex Precision IT', JSON_ARRAY('Hastelloy / Duplex fabrication','PTFE linings','ATEX compliance','CIP capability')),
(UUID(),'Power Generation','power-generation','High-pressure and high-temperature equipment for thermal, nuclear and renewable power.','bolt',3,1,'Power Generation - Vortex Precision IT', JSON_ARRAY('ASME Section I boilers','ASME Section VIII vessels','N-stamp nuclear','High-temp alloys')),
(UUID(),'Water & Wastewater','water-wastewater','Treatment plant equipment for municipal and industrial water and wastewater.','droplet',4,1,'Water & Wastewater - Vortex Precision IT', JSON_ARRAY('NSF/ANSI 61 potable water','AWWA standards','Lift stations','Membrane skids')),
(UUID(),'Pharmaceutical','pharmaceutical','Sanitary process equipment for pharma, biotech and life-sciences.','pill',5,1,'Pharmaceutical - Vortex Precision IT', JSON_ARRAY('3-A sanitary standards','Electropolish','FDA-compliant seals','Clean-in-place')),
(UUID(),'Food & Beverage','food-beverage','Hygienic equipment for dairy, brewing, beverage and food processing.','utensils',6,1,'Food & Beverage - Vortex Precision IT', JSON_ARRAY('3-A sanitary','CIP/SIP','EHEDG hygienic design','Stainless 304/316L'));

-- #############################################################################
-- 6. PRODUCTS
-- #############################################################################
INSERT INTO `products`
  (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,
   `industryIds`,`material`,`pressure`,`temperature`,`voltage`,`dimensions`,`weight`,
   `certifications`,`availability`,`featured`,`isActive`,`views`,`metaTitle`)
SELECT
  UUID(),
  'VortexPro Ball Valve VP-150',
  'vortexpro-ball-valve-vp150',
  'VP-VLV-150',
  'Three-piece full-port stainless steel ball valve rated for 150 PSI saturated steam. Fire-safe API 607 certified. Blowout-proof stem. ISO 5211 direct-mount actuator pad. Replaceable seats and seals without special tools.',
  'Full-port stainless ball valve, fire-safe, ISO 5211 mount pad.',
  (SELECT `id` FROM `categories` WHERE `slug`='valves' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='chemical-processing')),
  '316L Stainless Steel','150 PSI','-20 to 400 °F','N/A','1/2\" to 4\"','3.2 lb',
  JSON_ARRAY('API 607','API 598','ISO 5211','CRN'),
  'IN_STOCK',1,1,128,'VortexPro Ball Valve VP-150'
UNION ALL SELECT
  UUID(),'VortexPro Gate Valve VP-GS','vortexpro-gate-valve-vgs','VP-VLV-GS',
  'Rising-stainless gate valve with flexible wedge and graphite packing. Suitable for high-temperature steam and hydrocarbon service. Body and bonnet in forged ASTM A182 F316L.',
  'High-temperature gate valve for steam and hydrocarbon service.',
  (SELECT `id` FROM `categories` WHERE `slug`='valves' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='power-generation')),
  'A182 F316L','Class 800','-50 to 1100 °F','N/A','2\" to 24\"','78 lb',
  JSON_ARRAY('API 600','API 602','ASME B16.34'),
  'IN_STOCK',1,1,87,'VortexPro Gate Valve VP-GS'
UNION ALL SELECT
  UUID(),'VortexPro Centrifugal Pump VP-CP-220','vortexpro-centrifugal-pump-vp220','VP-PMP-220',
  'End-suction centrifugal pump with back-pull-out design. ANSI / API process duty. 316L wetted parts, suitable for light hydrocarbons, solvents and clean water service.',
  'End-suction ANSI centrifugal pump, back-pull-out design.',
  (SELECT `id` FROM `categories` WHERE `slug`='pumps' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='chemical-processing'),(SELECT `id` FROM `industries` WHERE `slug`='water-wastewater')),
  '316L Stainless','Class 150','-40 to 300 °F','460V 3ph','6x4x10','320 lb',
  JSON_ARRAY('ANSI B73.1','API 610 (optional)'),
  'IN_STOCK',1,1,212,'VortexPro Centrifugal Pump VP-CP-220'
UNION ALL SELECT
  UUID(),'VortexPro Positive-Displacement Pump VP-PD','vortexpro-pd-pump-vppd','VP-PMP-PD',
  'Heavy-duty rotary lobe pump for viscous and shear-sensitive fluids. Hygienic EHEDG design available for food and pharma service.',
  'Rotary lobe pump for viscous and sanitary fluids.',
  (SELECT `id` FROM `categories` WHERE `slug`='pumps' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='pharmaceutical'),(SELECT `id` FROM `industries` WHERE `slug`='food-beverage')),
  '316L Stainless','Class 150','-20 to 250 °F','460V 3ph','2\" to 6\"','190 lb',
  JSON_ARRAY('EHEDG','3-A','ATEX'),
  'IN_STOCK',0,1,54,'VortexPro PD Pump VP-PD'
UNION ALL SELECT
  UUID(),'VortexPro Plate Heat Exchanger VP-PHE','vortexpro-phe-vpphe','VP-HX-PHE',
  'Gasketed plate heat exchanger for district heating, HVAC and process duties. 316L plates with EPDM or NBR gaskets. Frames in carbon steel painted, stainless available.',
  'Gasketed plate heat exchanger for HVAC and process duty.',
  (SELECT `id` FROM `categories` WHERE `slug`='heat-exchangers' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='power-generation'),(SELECT `id` FROM `industries` WHERE `slug`='water-wastewater')),
  '316L / EPDM','232 PSI','-35 to 180 °C','N/A','0.5 to 4 m²','varies',
  JSON_ARRAY('PED','ASME UM','CRN'),
  'IN_STOCK',1,1,143,'VortexPro Plate Heat Exchanger VP-PHE'
UNION ALL SELECT
  UUID(),'VortexPro Shell & Tube HX VP-SH','vortexpro-sh-vpsh','VP-HX-SH',
  'TEMA-class shell-and-tube heat exchanger for high-pressure process duty. Available in BEM, AES and BEU configurations.',
  'TEMA shell-and-tube heat exchanger, customisable.',
  (SELECT `id` FROM `categories` WHERE `slug`='heat-exchangers' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='power-generation'),(SELECT `id` FROM `industries` WHERE `slug`='oil-gas')),
  'SA-516-70 / 304L','600 PSI','-50 to 400 °C','N/A','12\" to 48\" dia','1,200+ lb',
  JSON_ARRAY('ASME Section VIII','TEMA','PED'),
  'MADE_TO_ORDER',0,1,62,'VortexPro Shell & Tube HX VP-SH'
UNION ALL SELECT
  UUID(),'VortexPro Pressure Vessel VP-PV','vortexpro-pv-vppv','VP-PV-PV',
  'ASME Section VIII pressure vessel, custom engineered for any process duty. U-stamp, U2-stamp and National Board registered.',
  'Custom ASME pressure vessel, U-stamp registered.',
  (SELECT `id` FROM `categories` WHERE `slug`='pressure-vessels' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='chemical-processing'),(SELECT `id` FROM `industries` WHERE `slug`='power-generation')),
  'SA-516-70 / 304L','Class 300','-50 to 500 °F','N/A','Custom','Custom',
  JSON_ARRAY('ASME U','U2','NB'),
  'MADE_TO_ORDER',0,1,77,'VortexPro Pressure Vessel VP-PV'
UNION ALL SELECT
  UUID(),'VortexPro Bag Filter VP-BF','vortexpro-bf-vpbf','VP-FIL-BF',
  'Stainless multi-bag filter housing for high-flow process streams. Quick-opening cover, swing-bolt closure, 2 to 24 bags per vessel.',
  'Multi-bag stainless filter housing, quick-opening cover.',
  (SELECT `id` FROM `categories` WHERE `slug`='filtration' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='water-wastewater'),(SELECT `id` FROM `industries` WHERE `slug`='chemical-processing')),
  '304L Stainless','150 PSI','-20 to 250 °F','N/A','2 to 24 bags','160 lb',
  JSON_ARRAY('ASME BPE','CRN'),
  'IN_STOCK',0,1,42,'VortexPro Bag Filter VP-BF'
UNION ALL SELECT
  UUID(),'VortexPro Cartridge Filter VP-CF','vortexpro-cf-vpcf','VP-FIL-CF',
  'Sanitary cartridge filter housing for pharmaceutical and food applications. 222 O-ring code 7 or code 3 sanitary connections.',
  'Sanitary cartridge filter for pharma and food.',
  (SELECT `id` FROM `categories` WHERE `slug`='filtration' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='pharmaceutical'),(SELECT `id` FROM `industries` WHERE `slug`='food-beverage')),
  '316L Stainless','100 PSI','-20 to 200 °F','N/A','5\" to 30\"','28 lb',
  JSON_ARRAY('3-A','EHEDG','CRN'),
  'IN_STOCK',0,1,33,'VortexPro Cartridge Filter VP-CF'
UNION ALL SELECT
  UUID(),'VortexPro Pressure Gauge VP-PG','vortexpro-pg-vppg','VP-INS-PG',
  'Bourdon tube pressure gauge, dry or liquid-filled, stainless case, 4" dial. ±1% full-scale accuracy, IP65 enclosure.',
  'Stainless case Bourdon pressure gauge, 4" dial, IP65.',
  (SELECT `id` FROM `categories` WHERE `slug`='instrumentation' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='power-generation')),
  '316L Stainless','10,000 PSI','-40 to 400 °F','N/A','4\" dial','1.5 lb',
  JSON_ARRAY('ASME B40.100','EN 837-1'),
  'IN_STOCK',0,1,57,'VortexPro Pressure Gauge VP-PG'
UNION ALL SELECT
  UUID(),'VortexPro Level Transmitter VP-LT','vortexpro-lt-vplt','VP-INS-LT',
  'Guided-wave radar level transmitter for liquids and bulk solids. 24V DC loop-powered, HART, 4-20 mA output. Stainless process connection.',
  'Guided-wave radar level transmitter, HART + 4-20 mA.',
  (SELECT `id` FROM `categories` WHERE `slug`='instrumentation' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='water-wastewater'),(SELECT `id` FROM `industries` WHERE `slug`='chemical-processing')),
  '316L Stainless','Class 300','-40 to 400 °F','24V DC','1/2\" to 4\"','4.2 lb',
  JSON_ARRAY('ATEX','IECEx','CRN'),
  'IN_STOCK',1,1,91,'VortexPro Level Transmitter VP-LT'
UNION ALL SELECT
  UUID(),'VortexPro Check Valve VP-CV','vortexpro-cv-vpcv','VP-VLV-CV',
  'Stainless swing check valve, 316L body, suitable for horizontal and vertical installations. Resilient seat, low cracking pressure.',
  '316L swing check valve, low cracking pressure.',
  (SELECT `id` FROM `categories` WHERE `slug`='valves' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='water-wastewater')),
  '316L Stainless','Class 300','-50 to 600 °F','N/A','1/2\" to 12\"','22 lb',
  JSON_ARRAY('API 594','API 598'),
  'IN_STOCK',0,1,68,'VortexPro Check Valve VP-CV';

-- #############################################################################
-- 7. FAQs
-- #############################################################################
INSERT INTO `faqs` (`id`,`question`,`answer`,`category`,`sortOrder`,`isActive`) VALUES
(UUID(),'What is your typical lead time?','Standard catalog items ship within 5-7 business days. Custom-engineered equipment is typically 6-12 weeks depending on complexity and certification requirements.','Lead Times',1,1),
(UUID(),'Do you offer custom engineering?','Yes — we have a full in-house engineering team for custom pressure vessels, heat exchangers and skidded systems. We work to ASME, PED, CRN and other codes as required.','Engineering',2,1),
(UUID(),'Which quality standards do you follow?','We are ISO 9001:2015 certified. Equipment can be supplied to ASME (U, U2, S, NB), PED (CE), CRN, ATEX, 3-A and EHEDG depending on the application.','Quality',3,1),
(UUID(),'Do you provide installation and commissioning?','Yes, we offer global field service including installation supervision, commissioning, operator training and ongoing maintenance contracts.','Service',4,1),
(UUID(),'What is the warranty on your products?','All catalog products carry a standard 12-month warranty from shipment. Engineered equipment warranty is typically 18-24 months and clearly stated on the quotation.','Warranty',5,1),
(UUID(),'Do you ship internationally?','We ship worldwide. We handle export documentation, certificates of origin and can ship FOB, CIF or DDP depending on your preference.','Logistics',6,1),
(UUID(),'How do I get a quote?','Use the RFQ form on our site, or email sale@vortexprecisionit.com with your requirements, drawings and quantity. Most quotes are returned within 48 hours.','Quoting',7,1),
(UUID(),'Can I get a sample before ordering?','For selected catalog items, sample or evaluation units can be supplied at a nominal cost that is credited back on the first production order.','Samples',8,1);

-- #############################################################################
-- 8. TESTIMONIALS
-- #############################################################################
INSERT INTO `testimonials` (`id`,`name`,`title`,`company`,`content`,`rating`,`avatar`,`industry`,`isActive`,`featured`) VALUES
(UUID(),'Mark Henderson','Process Engineering Lead','DeltaChem Industries','Vortex Precision IT delivered our custom heat exchanger skids on time and below budget. Their engineering team was responsive throughout the project.',5,'/assets/img/reviews/mark-henderson.jpg','Chemical Processing',1,1),
(UUID(),'Linda Park','Plant Manager','NorthStar Refining','We have standardised on Vortex Precision IT ball valves across our refinery. The quality is consistent, lead times are predictable, and their field service team is excellent.',5,'/assets/img/reviews/linda-park.jpg','Oil & Gas',1,1),
(UUID(),'Akhil Raman','Director of Operations','BlueRiver Water Authority','The plate heat exchangers supplied for our district heating upgrade have performed flawlessly through three full heating seasons.',5,'/assets/img/reviews/akhil-raman.jpg','Water & Wastewater',1,1),
(UUID(),'Jonas Weber','Head of Engineering','Brewmaster GmbH','Their sanitary pumps and filters meet the strictest EHEDG requirements. Vortex Precision IT understands hygienic process design.',5,'/assets/img/reviews/jonas-weber.jpg','Food & Beverage',1,0);

-- #############################################################################
-- 9. PARTNERS
-- #############################################################################
INSERT INTO `partners` (`id`,`name`,`logo`,`website`,`category`,`sortOrder`,`isActive`) VALUES
(UUID(),'Siemens Energy','/assets/img/partners/siemens.svg','https://www.siemens-energy.com','OEM',1,1),
(UUID(),'Emerson Automation','/assets/img/partners/emerson.svg','https://www.emerson.com','Automation',2,1),
(UUID(),'Flowserve','/assets/img/partners/flowserve.svg','https://www.flowserve.com','OEM',3,1),
(UUID(),'KSB Group','/assets/img/partners/ksb.svg','https://www.ksb.com','OEM',4,1),
(UUID(),'Sulzer','/assets/img/partners/sulzer.svg','https://www.sulzer.com','OEM',5,1),
(UUID(),'Pentair','/assets/img/partners/pentair.svg','https://www.pentair.com','Filtration',6,1);

-- #############################################################################
-- 10. APPLICATION SETTINGS
-- #############################################################################
INSERT INTO `settings` (`id`,`key`,`value`,`type`,`group`,`sortOrder`) VALUES
(UUID(),'site_name','Vortex Precision IT','STRING','GENERAL',1),
(UUID(),'site_tagline','Industrial Manufacturing Excellence','STRING','GENERAL',2),
(UUID(),'hero_title','Precision-engineered for the most demanding industries','STRING','HERO',1),
(UUID(),'hero_subtitle','Vortex Precision IT designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems trusted by operators worldwide.','STRING','HERO',2),
(UUID(),'hero_cta_primary','Request a Quote','STRING','HERO',3),
(UUID(),'hero_cta_secondary','Explore Products','STRING','HERO',4),
(UUID(),'about_intro','Vortex Precision IT has been a trusted partner to industrial operators for over three decades. From our headquarters in Houston, Texas, we design, manufacture and service equipment for the most demanding applications in oil & gas, chemical processing, power generation, water, pharmaceutical and food & beverage.','TEXT','ABOUT',1),
(UUID(),'stats_years','35','INT','STATS',1),
(UUID(),'stats_countries','60','INT','STATS',2),
(UUID(),'stats_projects','4200','INT','STATS',3),
(UUID(),'stats_clients','850','INT','STATS',4),
(UUID(),'contact_email','sale@vortexprecisionit.com','STRING','CONTACT',1),
(UUID(),'support_email','support@vortexprecisionit.com','STRING','CONTACT',2),
(UUID(),'rfq_email','sale@vortexprecisionit.com','STRING','CONTACT',3),
(UUID(),'phone','+1 (555) 123-4567','STRING','CONTACT',4),
(UUID(),'address','1234 Industrial Way, Houston, TX 77001, USA','STRING','CONTACT',5),
(UUID(),'social','{\"linkedin\":\"https://linkedin.com/company/vortexprecisionit\",\"twitter\":\"https://twitter.com/vortexprecisionit\",\"facebook\":\"https://facebook.com/vortexprecisionit\",\"youtube\":\"https://youtube.com/@vortexprecisionit\"}','JSON','CONTACT',6),
(UUID(),'rfq_enabled','1','BOOL','RFQ',1),
(UUID(),'rfq_rate_limit_per_hour','5','INT','RFQ',2),
(UUID(),'rfq_admin_email','admin@vortexprecisionit.com','STRING','RFQ',3),
(UUID(),'seo_default_title','Vortex Precision IT — Industrial Manufacturing','STRING','SEO',1),
(UUID(),'seo_default_description','Vortex Precision IT designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems for oil & gas, chemical, power, water, pharmaceutical and food & beverage operators worldwide.','TEXT','SEO',2),
(UUID(),'seo_keywords','industrial valves, centrifugal pumps, heat exchangers, pressure vessels, filtration systems, oil and gas equipment, process equipment manufacturer','STRING','SEO',3),
(UUID(),'seo_robots','index, follow','STRING','SEO',4),
(UUID(),'seo_og_image','/assets/img/hero-industrial.jpg','STRING','SEO',5),
(UUID(),'seo_enable_jsonld','1','BOOL','SEO',6),
(UUID(),'seo_schema_type','Organization','STRING','SEO',7),
(UUID(),'seo_schema_name','Vortex Precision IT','STRING','SEO',8),
(UUID(),'seo_schema_logo','/assets/img/logo.png','STRING','SEO',9),
(UUID(),'chat_enabled','1','BOOL','CHAT',1),
(UUID(),'chat_title','Vortex Precision IT Assistant','STRING','CHAT',2),
(UUID(),'chat_bot_name','Vortex Precision IT','STRING','CHAT',3),
(UUID(),'chat_avatar','/assets/img/chat-bot-avatar.png','STRING','CHAT',8),
(UUID(),'chat_welcome','Hi there! 👋 I can help you with our products, industries, pricing, delivery times and quotes. What would you like to know?','TEXT','CHAT',4),
(UUID(),'chat_ai_provider','local','STRING','CHAT',5),
(UUID(),'chat_rate_limit_per_hour','60','INT','CHAT',6),
(UUID(),'chat_quick_replies','[\"Products\",\"Request a quote\",\"Delivery times\",\"Contact\"]','JSON','CHAT',7),
(UUID(),'theme_bg','#ffffff','STRING','THEME',1),
(UUID(),'theme_writeup','#000000','STRING','THEME',2)
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- #############################################################################
-- 11. CAREERS
-- #############################################################################
INSERT INTO `careers` (`id`,`title`,`slug`,`department`,`location`,`type`,`experience`,`salary`,`description`,`requirements`,`benefits`,`isActive`) VALUES
(UUID(),'Senior Mechanical Engineer','senior-mechanical-engineer','Engineering','Houston, TX','Full-time','7+ years','Competitive','Lead the design and analysis of pressure vessels and heat exchangers for our oil & gas and chemical processing clients.', 'Bachelor or Master in Mechanical Engineering, ASME Section VIII experience, PE preferred.', 'Health, dental, vision, 401(k) match, profit share', 1),
(UUID(),'Process Engineer','process-engineer','Engineering','Houston, TX','Full-time','3+ years','Competitive','Support process design and commissioning of skidded systems, including pumps, heat exchangers and filtration.', 'Bachelor in Chemical or Mechanical Engineering, P&ID literacy, field commissioning experience a plus.', 'Health, dental, vision, 401(k) match', 1),
(UUID(),'Quality Control Inspector','quality-control-inspector','Quality','Houston, TX','Full-time','5+ years','Competitive','Perform dimensional and NDE inspection of fabricated equipment to ASME, EN and customer-specific requirements.', 'CWI required, ASNT Level II PT/MT preferred, experience with ASME U/U2.', 'Health, dental, vision, 401(k) match', 1),
(UUID(),'Sales Engineer - Process','sales-engineer-process','Sales','Remote (US Southeast)','Full-time','5+ years','Base + Commission','Drive technical sales of valves, pumps and heat exchangers to EPCs, end users and channel partners.', 'Bachelor in Engineering, 5+ years industrial sales, technical fluency in pumps and valves.', 'Uncapped commission, health, 401(k) match, company vehicle', 1);

-- #############################################################################
-- 12. NEWS
-- #############################################################################
INSERT INTO `news` (`id`,`title`,`slug`,`summary`,`content`,`publishedAt`,`isActive`) VALUES
(UUID(),'Vortex Precision IT completes delivery of 18 skidded heat exchanger packages to Gulf Coast chemical plant','skid-delivery-gulf-coast','A milestone order demonstrating our ability to deliver turnkey process skids to tight schedules.','Vortex Precision IT has successfully delivered 18 custom-engineered heat exchanger skids to a major Gulf Coast chemical complex. The packages, which include plate heat exchangers, instrumentation and structural steel, were delivered on a 14-week accelerated schedule and are now in commissioning.','2026-07-12 09:00:00',1),
(UUID(),'New EHEDG-certified sanitary pump line launched','sanitary-pump-launch','Our new PD pump line brings hygienic fluid handling to dairy, brewing and pharmaceutical customers.','Vortex Precision IT has launched a new line of rotary lobe positive-displacement pumps for sanitary service. The line is EHEDG-certified, available in 316L stainless with EHEDG-compliant elastomers.','2026-05-30 09:00:00',1),
(UUID(),'Vortex Precision IT achieves ISO 9001:2015 recertification','iso-9001-recert','Quality system recertification reflects our continued commitment to customer satisfaction.','We are pleased to announce the successful completion of our ISO 9001:2015 surveillance audit, with zero non-conformances raised by the lead auditor.','2026-03-04 09:00:00',1);

-- #############################################################################
-- 13. DOWNLOADS
-- #############################################################################
INSERT INTO `downloads` (`id`,`title`,`description`,`fileUrl`,`type`,`category`,`fileSize`,`downloads`,`isActive`) VALUES
(UUID(),'Company Brochure 2026','Full-line overview of Vortex Precision IT capabilities and reference projects.','/assets/files/company-brochure-2026.pdf','PDF','General','3.2 MB',0,1),
(UUID(),'Valve Selection Guide','Engineering guide for selecting the right valve for your service.','/assets/files/valve-selection-guide.pdf','PDF','Valves','1.4 MB',0,1),
(UUID(),'Pump Selection Guide','Engineering guide for centrifugal and positive-displacement pumps.','/assets/files/pump-selection-guide.pdf','PDF','Pumps','1.8 MB',0,1),
(UUID(),'Heat Exchanger Sizing Worksheet','Excel worksheet to size plate or shell-and-tube exchangers.','/assets/files/hx-sizing.xlsx','XLSX','Heat Exchangers','85 KB',0,1);

-- #############################################################################
-- 14. BLOG POSTS (references the fixed admin account UUID)
-- #############################################################################
INSERT INTO `blog_posts` (`id`,`title`,`slug`,`excerpt`,`content`,`authorId`,`category`,`tags`,`status`,`publishedAt`,`views`,`metaTitle`) VALUES
(UUID(),
 'Choosing the right ball valve for your process',
 'choosing-the-right-ball-valve',
 'A practical guide to selecting full-port vs reduced-port, fire-safe vs standard, and floating vs trunnion.',
 '<p>Ball valves are the workhorse of industrial fluid handling. Choosing the right one is about understanding your service, not just line size. In this guide we walk through the three most important decisions...</p><p><strong>Full-port vs reduced-port:</strong> Full-port valves have an unobstructed bore equal to the pipe ID. They minimise pressure drop and are required for pigging...</p>',
 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
 'Engineering',
 JSON_ARRAY('valves','selection','engineering'),
 'PUBLISHED',
 '2026-06-15 09:00:00',
 412,
 'Choosing the right ball valve - Vortex Precision IT'),
(UUID(),
 'Understanding ASME Section VIII pressure vessel design',
 'understanding-asme-section-viii',
 'A non-lawyer introduction to the U-stamp code, mandatory appendices, and how to read a Manufacturer''s Data Report.',
 '<p>ASME Section VIII governs the design and manufacture of unfired pressure vessels in the United States and much of the world. Whether you are specifying a storage tank or a custom reactor, the code is large but approachable...</p>',
 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
 'Engineering',
 JSON_ARRAY('pressure-vessels','asme','engineering'),
 'PUBLISHED',
 '2026-04-22 09:00:00',
 289,
 'Understanding ASME Section VIII - Vortex Precision IT');


-- =====================================================================
-- CMS + role/permission tables (dashboard control centre)
-- Mirrors database/migrations/001_cms_and_permissions.sql
-- =====================================================================
-- =====================================================================
-- Vortex Precision IT — CMS + Role/Permission upgrade (migration 001)
-- =====================================================================
-- Adds the tables required by the Super Admin / Admin dashboards:
--   permissions        catalogue of every grantable permission
--   user_permissions   per-administrator grant / deny overrides
--   pages              CMS pages published on the public website
--   page_sections      homepage (and other page) content sections
--   menu_items         header / footer / legal navigation
--   media (extended)   alt text, ownership, protection flag
--
-- Safe to run more than once (CREATE TABLE IF NOT EXISTS). The ALTER
-- statements at the bottom fail harmlessly with "duplicate column" if the
-- migration has already been applied.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Permission catalogue
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `permissions` (
  `id`          CHAR(36)     NOT NULL,
  `key`         VARCHAR(100) NOT NULL,
  `label`       VARCHAR(190) NOT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  `groupName`   VARCHAR(80)  NOT NULL DEFAULT 'General',
  `superOnly`   TINYINT(1)   NOT NULL DEFAULT 0,
  `sortOrder`   INT          NOT NULL DEFAULT 0,
  `createdAt`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permissions_key` (`key`),
  KEY `idx_permissions_group` (`groupName`,`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Per-user permission overrides (grant = 1, explicit deny = 0)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_permissions` (
  `id`          CHAR(36)     NOT NULL,
  `userId`      CHAR(36)     NOT NULL,
  `permission`  VARCHAR(100) NOT NULL,
  `granted`     TINYINT(1)   NOT NULL DEFAULT 1,
  `grantedBy`   CHAR(36)     DEFAULT NULL,
  `createdAt`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_permission` (`userId`,`permission`),
  KEY `idx_user_permissions_user` (`userId`),
  CONSTRAINT `fk_user_permissions_user` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- CMS pages
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pages` (
  `id`              CHAR(36)     NOT NULL,
  `title`           VARCHAR(190) NOT NULL,
  `slug`            VARCHAR(190) NOT NULL,
  `excerpt`         TEXT         DEFAULT NULL,
  `content`         LONGTEXT     DEFAULT NULL,
  `featuredImage`   VARCHAR(500) DEFAULT NULL,
  `template`        VARCHAR(40)  NOT NULL DEFAULT 'default',
  `metaTitle`       VARCHAR(255) DEFAULT NULL,
  `metaDescription` VARCHAR(500) DEFAULT NULL,
  `status`          ENUM('DRAFT','PUBLISHED') NOT NULL DEFAULT 'DRAFT',
  `visibility`      ENUM('PUBLIC','PRIVATE')  NOT NULL DEFAULT 'PUBLIC',
  `publishedAt`     DATETIME     DEFAULT NULL,
  `showInMenu`      TINYINT(1)   NOT NULL DEFAULT 0,
  `sortOrder`       INT          NOT NULL DEFAULT 0,
  `isSystem`        TINYINT(1)   NOT NULL DEFAULT 0,
  `authorId`        CHAR(36)     DEFAULT NULL,
  `createdAt`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pages_slug` (`slug`),
  KEY `idx_pages_status` (`status`,`publishedAt`),
  KEY `idx_pages_menu` (`showInMenu`,`sortOrder`),
  CONSTRAINT `fk_pages_author` FOREIGN KEY (`authorId`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Homepage / page content sections
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `page_sections` (
  `id`          CHAR(36)     NOT NULL,
  `pageKey`     VARCHAR(60)  NOT NULL DEFAULT 'home',
  `type`        VARCHAR(40)  NOT NULL DEFAULT 'richtext',
  `name`        VARCHAR(190) NOT NULL DEFAULT '',
  `title`       VARCHAR(255) DEFAULT NULL,
  `subtitle`    VARCHAR(500) DEFAULT NULL,
  `body`        LONGTEXT     DEFAULT NULL,
  `image`       VARCHAR(500) DEFAULT NULL,
  `buttonText`  VARCHAR(120) DEFAULT NULL,
  `buttonUrl`   VARCHAR(500) DEFAULT NULL,
  `buttonText2` VARCHAR(120) DEFAULT NULL,
  `buttonUrl2`  VARCHAR(500) DEFAULT NULL,
  `settings`    JSON         DEFAULT NULL,
  `sortOrder`   INT          NOT NULL DEFAULT 0,
  `isActive`    TINYINT(1)   NOT NULL DEFAULT 1,
  `isSystem`    TINYINT(1)   NOT NULL DEFAULT 0,
  `createdAt`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sections_page_order` (`pageKey`,`sortOrder`),
  KEY `idx_sections_active` (`isActive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Navigation / menu items
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `menu_items` (
  `id`        CHAR(36)     NOT NULL,
  `menu`      VARCHAR(40)  NOT NULL DEFAULT 'header',
  `label`     VARCHAR(120) NOT NULL,
  `type`      ENUM('INTERNAL','PAGE','EXTERNAL') NOT NULL DEFAULT 'INTERNAL',
  `url`       VARCHAR(500) DEFAULT NULL,
  `pageId`    CHAR(36)     DEFAULT NULL,
  `target`    VARCHAR(10)  NOT NULL DEFAULT '_self',
  `icon`      VARCHAR(60)  DEFAULT NULL,
  `parentId`  CHAR(36)     DEFAULT NULL,
  `sortOrder` INT          NOT NULL DEFAULT 0,
  `isActive`  TINYINT(1)   NOT NULL DEFAULT 1,
  `createdAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_menu_items_menu` (`menu`,`sortOrder`),
  KEY `idx_menu_items_active` (`isActive`),
  CONSTRAINT `fk_menu_items_page` FOREIGN KEY (`pageId`) REFERENCES `pages`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- END OF PRODUCTION DATABASE
-- After import, verify with:
--   SELECT COUNT(*) FROM users;
--   SELECT COUNT(*) FROM categories;
--   SELECT COUNT(*) FROM products;
--   SELECT COUNT(*) FROM settings;
-- =============================================================================

-- =====================================================================
-- CMS + permission seed data
-- Mirrors database/migrations/002_cms_seed.sql
-- =====================================================================
-- =====================================================================
-- Vortex Precision IT — CMS + permissions seed data (migration 002)
-- =====================================================================
-- Idempotent: uses INSERT IGNORE so re-running never overwrites content
-- that an administrator has since edited in the dashboard.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Permission catalogue (mirrors application/config/permissions.php)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `permissions` (`id`,`key`,`label`,`groupName`,`superOnly`,`sortOrder`) VALUES
(UUID(),'dashboard.view','View dashboard','Overview',0,1),
(UUID(),'reports.view','View reports and analytics','Overview',0,2),
(UUID(),'quotes.manage','Manage quote requests (RFQ)','Sales',0,4),
(UUID(),'contacts.manage','Manage contact messages','Sales',0,5),
(UUID(),'products.manage','Manage products','Catalog',0,6),
(UUID(),'categories.manage','Manage categories','Catalog',0,7),
(UUID(),'industries.manage','Manage industries','Catalog',0,8),
(UUID(),'downloads.manage','Manage downloads','Catalog',0,9),
(UUID(),'blog.manage','Manage blog posts','Content',0,10),
(UUID(),'news.manage','Manage news','Content',0,11),
(UUID(),'faqs.manage','Manage FAQs','Content',0,12),
(UUID(),'careers.manage','Manage careers and applications','Content',0,13),
(UUID(),'testimonials.manage','Manage testimonials','Content',0,14),
(UUID(),'partners.manage','Manage partners','Content',0,15),
(UUID(),'homepage.manage','Manage homepage sections','Website',0,16),
(UUID(),'pages.manage','Manage website pages','Website',0,17),
(UUID(),'menus.manage','Manage navigation menus','Website',0,18),
(UUID(),'appearance.manage','Manage logo, favicon, header and footer','Website',0,19),
(UUID(),'media.manage','Manage the media library','Website',0,20),
(UUID(),'seo.manage','Manage SEO settings','Website',0,21),
(UUID(),'customers.manage','Manage customer accounts','People',0,22),
(UUID(),'admins.manage','Manage administrators and permissions','People',1,23),
(UUID(),'settings.manage','Manage website settings','System',0,24),
(UUID(),'audit.view','View the activity / audit log','System',0,25),
(UUID(),'system.manage','Manage system, email and security settings','System',1,26);

-- ---------------------------------------------------------------------
-- Role defaults. SUPER_ADMIN keeps the wildcard row; ADMIN gets a sane
-- starting set that the Super Admin can widen or narrow per account.
-- ---------------------------------------------------------------------
INSERT INTO `role_permissions` (`id`,`role`,`resource`,`actions`) VALUES
(UUID(),'SUPER_ADMIN','*',JSON_ARRAY('*')),
(UUID(),'ADMIN','dashboard',JSON_ARRAY('view','read')),
(UUID(),'ADMIN','reports',JSON_ARRAY('view','read')),
(UUID(),'ADMIN','quotes',JSON_ARRAY('manage','read','create','update','delete','export','status')),
(UUID(),'ADMIN','contacts',JSON_ARRAY('manage','read','update','delete')),
(UUID(),'ADMIN','products',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','categories',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','homepage',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','pages',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','menus',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','appearance',JSON_ARRAY('manage','read','update')),
(UUID(),'ADMIN','media',JSON_ARRAY('manage','read','create','delete')),
(UUID(),'ADMIN','industries',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','downloads',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','blog',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','news',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','faqs',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','careers',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','testimonials',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','partners',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'ADMIN','seo',JSON_ARRAY('manage','read','update')),
(UUID(),'ADMIN','settings',JSON_ARRAY('manage','read','update')),
(UUID(),'SALES','dashboard',JSON_ARRAY('view','read')),
(UUID(),'SALES','quotes',JSON_ARRAY('manage','read','create','update','status','export')),
(UUID(),'SALES','contacts',JSON_ARRAY('manage','read','update')),
(UUID(),'ENGINEER','dashboard',JSON_ARRAY('view','read')),
(UUID(),'ENGINEER','products',JSON_ARRAY('manage','read','update')),
(UUID(),'ENGINEER','downloads',JSON_ARRAY('manage','read','update','create')),
(UUID(),'EDITOR','dashboard',JSON_ARRAY('view','read')),
(UUID(),'EDITOR','blog',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'EDITOR','news',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'EDITOR','faqs',JSON_ARRAY('manage','read','create','update','delete')),
(UUID(),'EDITOR','pages',JSON_ARRAY('manage','read','create','update')),
(UUID(),'EDITOR','media',JSON_ARRAY('manage','read','create'))
ON DUPLICATE KEY UPDATE `actions`=VALUES(`actions`);

-- ---------------------------------------------------------------------
-- Website settings managed from Dashboard → Settings / Appearance
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `settings` (`id`,`key`,`value`,`type`,`group`,`sortOrder`) VALUES
(UUID(),'site_title','Vortex Precision IT — Industrial Manufacturing','STRING','WEBSITE',1),
(UUID(),'site_description','Vortex Precision IT designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems for demanding operators worldwide.','TEXT','WEBSITE',2),
(UUID(),'site_url','','STRING','WEBSITE',3),
(UUID(),'site_language','en','STRING','WEBSITE',4),

(UUID(),'logo_light','/assets/img/logo-header.png','STRING','BRANDING',1),
(UUID(),'logo_dark','/assets/img/logo-footer.png','STRING','BRANDING',2),
(UUID(),'logo_footer','/assets/img/logo-footer.png','STRING','BRANDING',3),
(UUID(),'logo_alt','Vortex Precision IT','STRING','BRANDING',4),
(UUID(),'logo_height','44','INT','BRANDING',5),
(UUID(),'favicon','/assets/img/favicon.ico','STRING','BRANDING',6),

(UUID(),'contact_hours','Mon–Fri, 08:00–18:00','STRING','CONTACT',7),

(UUID(),'social_linkedin','','STRING','SOCIAL',1),
(UUID(),'social_twitter','','STRING','SOCIAL',2),
(UUID(),'social_facebook','','STRING','SOCIAL',3),
(UUID(),'social_youtube','','STRING','SOCIAL',4),
(UUID(),'social_instagram','','STRING','SOCIAL',5),
(UUID(),'social_telegram','','STRING','SOCIAL',6),
(UUID(),'social_whatsapp','','STRING','SOCIAL',7),

(UUID(),'header_cta_enabled','1','BOOL','HEADER',1),
(UUID(),'header_cta_label','Request a Quote','STRING','HEADER',2),
(UUID(),'header_cta_url','rfq','STRING','HEADER',3),
(UUID(),'header_topbar_enabled','0','BOOL','HEADER',4),
(UUID(),'header_topbar_text','','STRING','HEADER',5),

(UUID(),'footer_about','Industrial manufacturing excellence — engineered, tested and delivered worldwide.','TEXT','FOOTER',1),
(UUID(),'footer_copyright','','STRING','FOOTER',2),
(UUID(),'footer_note','','STRING','FOOTER',3),
(UUID(),'footer_newsletter_enabled','0','BOOL','FOOTER',4),

(UUID(),'mail_from_email','','STRING','EMAIL',1),
(UUID(),'mail_from_name','','STRING','EMAIL',2),
(UUID(),'mail_reply_to','','STRING','EMAIL',3),
(UUID(),'smtp_host','','STRING','EMAIL',4),
(UUID(),'smtp_port','465','INT','EMAIL',5),
(UUID(),'smtp_user','','STRING','EMAIL',6),
(UUID(),'smtp_pass','','STRING','EMAIL',7),
(UUID(),'smtp_crypto','ssl','STRING','EMAIL',8),

(UUID(),'maintenance_mode','0','BOOL','SYSTEM',1),
(UUID(),'maintenance_message','We are performing scheduled maintenance. Please check back shortly.','TEXT','SYSTEM',2);

-- ---------------------------------------------------------------------
-- Navigation (header, footer columns, legal)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `menu_items` (`id`,`menu`,`label`,`type`,`url`,`target`,`sortOrder`,`isActive`) VALUES
(UUID(),'header','Products','INTERNAL','products','_self',10,1),
(UUID(),'header','Industries','INTERNAL','industries','_self',20,1),
(UUID(),'header','Services','INTERNAL','services','_self',30,1),
(UUID(),'header','About','INTERNAL','about','_self',40,1),
(UUID(),'header','Blog','INTERNAL','blog','_self',50,1),
(UUID(),'header','Careers','INTERNAL','careers','_self',60,1),
(UUID(),'header','FAQ','INTERNAL','faq','_self',70,1),
(UUID(),'header','Downloads','INTERNAL','downloads','_self',80,1),
(UUID(),'header','Contact','INTERNAL','contact','_self',90,1),

(UUID(),'footer_solutions','Products','INTERNAL','products','_self',10,1),
(UUID(),'footer_solutions','Industries','INTERNAL','industries','_self',20,1),
(UUID(),'footer_solutions','Services','INTERNAL','services','_self',30,1),
(UUID(),'footer_solutions','Request a Quote','INTERNAL','rfq','_self',40,1),

(UUID(),'footer_company','About','INTERNAL','about','_self',10,1),
(UUID(),'footer_company','Blog','INTERNAL','blog','_self',20,1),
(UUID(),'footer_company','News','INTERNAL','news','_self',30,1),
(UUID(),'footer_company','Careers','INTERNAL','careers','_self',40,1),
(UUID(),'footer_company','Contact','INTERNAL','contact','_self',50,1),

(UUID(),'footer_legal','Privacy Policy','INTERNAL','privacy-policy','_self',10,1),
(UUID(),'footer_legal','Terms of Service','INTERNAL','terms-of-service','_self',20,1);

-- ---------------------------------------------------------------------
-- Homepage sections (the public homepage renders exactly these rows)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `page_sections`
(`id`,`pageKey`,`type`,`name`,`title`,`subtitle`,`body`,`image`,`buttonText`,`buttonUrl`,`buttonText2`,`buttonUrl2`,`settings`,`sortOrder`,`isActive`,`isSystem`) VALUES
(UUID(),'home','hero','Hero banner',
 'Precision-engineered for the most demanding industries',
 'Vortex Precision IT designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems trusted by operators worldwide.',
 NULL,'/assets/img/hero-industrial.jpg','Request a Quote','rfq','Explore Products','products',
 '{"eyebrow":"Industrial manufacturing","badges":["ASME certified","ISO 9001:2015","Global support"]}',10,1,1),

(UUID(),'home','stats','Key numbers',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 '{"items":[{"value":"35+","label":"Years of experience"},{"value":"60+","label":"Countries served"},{"value":"4200+","label":"Projects delivered"},{"value":"850+","label":"Satisfied clients"}]}',20,1,0),

(UUID(),'home','categories','Product categories',
 'Our product categories',
 'From precision-machined valves to ASME-coded pressure vessels, every category is engineered to the same standard.',
 NULL,NULL,NULL,NULL,NULL,NULL,'{"limit":6}',30,1,0),

(UUID(),'home','products','Featured products',
 'Featured products','Our most-requested, in-stock equipment.',NULL,NULL,'View all','products',NULL,NULL,
 '{"limit":4}',40,1,0),

(UUID(),'home','industries','Industries',
 'Industries we serve','Engineered for the requirements of the world''s most demanding sectors.',
 NULL,NULL,NULL,NULL,NULL,NULL,'{"limit":6}',50,1,0),

(UUID(),'home','testimonials','Testimonials',
 'What our customers say','Operators across oil and gas, chemicals, water and food processing trust our equipment and field teams.',
 NULL,NULL,NULL,NULL,NULL,NULL,'{"limit":4}',60,1,0),

(UUID(),'home','partners','Partners',
 'Trusted by world-class operators',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{"limit":12}',70,1,0),

(UUID(),'home','cta','Closing call to action',
 'Have a project in mind?','Submit your specifications and our engineering team will respond with a formal quote within 2 business days.',
 NULL,NULL,'Request a Quote','rfq',NULL,NULL,NULL,80,1,0);

-- ---------------------------------------------------------------------
-- Starter CMS pages
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `pages`
(`id`,`title`,`slug`,`excerpt`,`content`,`template`,`metaTitle`,`metaDescription`,`status`,`visibility`,`publishedAt`,`showInMenu`,`sortOrder`,`isSystem`) VALUES
(UUID(),'Privacy Policy','privacy-policy','How we collect, use and protect your personal information.',
'<h2>Privacy Policy</h2><p>This policy explains what information we collect when you use our website, how it is used and the choices you have. Edit this page from <strong>Dashboard → Website → Pages</strong>.</p><h3>Information we collect</h3><p>We collect the details you submit through our contact and quote request forms: your name, company, email address, phone number and the content of your enquiry.</p><h3>How we use it</h3><p>Your information is used solely to respond to your enquiry, prepare quotations and provide after-sales support.</p><h3>Contact</h3><p>Questions about this policy can be sent to our contact address listed in the website footer.</p>',
'default','Privacy Policy','How we collect, use and protect your personal information.','PUBLISHED','PUBLIC',NOW(),0,10,0),

(UUID(),'Terms of Service','terms-of-service','The terms that apply to the use of this website.',
'<h2>Terms of Service</h2><p>By using this website you agree to the terms below. Edit this page from <strong>Dashboard → Website → Pages</strong>.</p><h3>Use of the website</h3><p>Content published here is provided for information purposes. Specifications may change without notice; a written quotation is the only binding offer.</p><h3>Intellectual property</h3><p>All trademarks, drawings and documentation remain the property of their respective owners.</p>',
'default','Terms of Service','The terms that apply to the use of this website.','PUBLISHED','PUBLIC',NOW(),0,20,0);


-- =============================================================================
-- Additional catalog range (migration 008)
-- =============================================================================
-- Ten additional Vortex Precision IT catalog products.
-- Safe to run once in cPanel → phpMyAdmin → SQL; SKU checks prevent duplicates.

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Globe Valve VP-GV-300','vortexpro-globe-valve-vp-gv-300','VP-VLV-GV300','A forged-steel globe valve for precise throttling and isolation in steam, condensate and high-temperature process lines. The bolted bonnet, graphite packing and hard-faced trim support dependable maintenance intervals.','Forged-steel globe valve for controlled steam and process service.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'power-generation' LIMIT 1),(SELECT id FROM industries WHERE slug = 'oil-gas' LIMIT 1)),'ASTM A105 / 13Cr trim','Class 300','-29 to 425 °C','N/A','1/2 in to 8 in','18 kg',JSON_ARRAY('ASME B16.34','API 623','API 598'),'IN_STOCK',0,1,0,'VortexPro Globe Valve VP-GV-300','Forged-steel globe valve for controlled steam and process service.' FROM categories c WHERE c.slug='valves' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-VLV-GV300');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Butterfly Valve VP-BF-150','vortexpro-butterfly-valve-vp-bf-150','VP-VLV-BF150','A resilient-seated butterfly valve with a wafer body and ISO 5211 actuator pad. Designed for compact shutoff on water, utility and low-pressure process systems.','Resilient-seated wafer butterfly valve for utility and water service.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'water-wastewater' LIMIT 1),(SELECT id FROM industries WHERE slug = 'food-beverage' LIMIT 1)),'Ductile iron body / EPDM seat','PN16 / Class 150','-10 to 120 °C','N/A','2 in to 24 in','12 kg',JSON_ARRAY('API 609','ISO 5211','EN 593'),'IN_STOCK',0,1,0,'VortexPro Butterfly Valve VP-BF-150','Compact resilient-seated butterfly valve for utility and water systems.' FROM categories c WHERE c.slug='valves' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-VLV-BF150');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro API Process Pump VP-AP-610','vortexpro-api-process-pump-vp-ap-610','VP-PMP-AP610','A centerline-mounted process pump engineered for refinery and chemical duties. The heavy-duty bearing frame, API seal chamber and back-pull-out construction simplify planned service.','API 610 process pump for refinery and chemical plant duties.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'oil-gas' LIMIT 1),(SELECT id FROM industries WHERE slug = 'chemical-processing' LIMIT 1)),'Carbon steel casing / 316 stainless wetted parts','25 bar','-40 to 400 °C','400 / 460 V 3ph','3x2x13 in','410 kg',JSON_ARRAY('API 610','API 682','ISO 5199'),'MADE_TO_ORDER',1,1,0,'VortexPro API Process Pump VP-AP-610','Centerline-mounted API process pump for demanding hydrocarbon service.' FROM categories c WHERE c.slug='pumps' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-PMP-AP610');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Vertical Turbine Pump VP-VT-90','vortexpro-vertical-turbine-pump-vp-vt-90','VP-PMP-VT90','A multistage vertical turbine pump for raw-water intake, cooling-water and municipal lift applications. Bowl assemblies are configured to match required flow, head and installation depth.','Multistage vertical turbine pump for water intake and lift stations.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'water-wastewater' LIMIT 1),(SELECT id FROM industries WHERE slug = 'power-generation' LIMIT 1)),'Cast iron / 316 stainless options','16 bar','0 to 85 °C','400 / 460 V 3ph','Up to 18 m bowl assembly','680 kg',JSON_ARRAY('API 610','AWWA E101'),'MADE_TO_ORDER',0,1,0,'VortexPro Vertical Turbine Pump VP-VT-90','Configured vertical turbine pump for water intake and cooling-water service.' FROM categories c WHERE c.slug='pumps' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-PMP-VT90');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Shell & Tube Exchanger VP-ST-500','vortexpro-shell-tube-exchanger-vp-st-500','VP-HX-ST500','A TEMA-style shell-and-tube heat exchanger with removable bundle, thermal expansion allowance and configurable tube metallurgy. Built for reliable heat recovery, cooling and condensing duties.','TEMA-style shell-and-tube exchanger with removable bundle.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'oil-gas' LIMIT 1),(SELECT id FROM industries WHERE slug = 'chemical-processing' LIMIT 1)),'Carbon steel shell / 316L tube bundle','30 bar shell / 20 bar tube','-40 to 400 °C','N/A','Up to 1200 mm shell diameter','1,850 kg',JSON_ARRAY('ASME Section VIII','TEMA','PED 2014/68/EU'),'MADE_TO_ORDER',1,1,0,'VortexPro Shell & Tube Exchanger VP-ST-500','Custom TEMA shell-and-tube exchanger for heat recovery and process cooling.' FROM categories c WHERE c.slug='heat-exchangers' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-HX-ST500');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Brazed Plate Exchanger VP-BP-40','vortexpro-brazed-plate-exchanger-vp-bp-40','VP-HX-BP40','A compact copper-brazed plate heat exchanger that provides high thermal efficiency in a small footprint. Suitable for hydraulic oil cooling, heat-pump loops and secondary glycol circuits.','Compact brazed plate exchanger for hydraulic and glycol circuits.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'food-beverage' LIMIT 1),(SELECT id FROM industries WHERE slug = 'water-wastewater' LIMIT 1)),'316 stainless steel / copper braze','30 bar','-196 to 225 °C','N/A','120 to 300 mm plate pack','8 kg',JSON_ARRAY('PED 2014/68/EU','UL'),'IN_STOCK',0,1,0,'VortexPro Brazed Plate Exchanger VP-BP-40','High-efficiency compact plate heat exchanger for hydraulic and glycol duty.' FROM categories c WHERE c.slug='heat-exchangers' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-HX-BP40');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Filter Separator VP-FS-800','vortexpro-filter-separator-vp-fs-800','VP-FLT-FS800','A two-stage filter separator for removing particulates and free water from hydrocarbon streams. Replaceable elements and a quick-opening closure reduce turnaround time.','Two-stage hydrocarbon filter separator with quick-opening closure.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'oil-gas' LIMIT 1),(SELECT id FROM industries WHERE slug = 'chemical-processing' LIMIT 1)),'Carbon steel / stainless internals','20 bar','-20 to 120 °C','N/A','800 mm diameter','940 kg',JSON_ARRAY('ASME Section VIII','API 1581'),'MADE_TO_ORDER',0,1,0,'VortexPro Filter Separator VP-FS-800','Two-stage filter separator for particulate and free-water removal.' FROM categories c WHERE c.slug='filtration' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-FLT-FS800');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Self-Cleaning Filter VP-SC-100','vortexpro-self-cleaning-filter-vp-sc-100','VP-FLT-SC100','An automatic self-cleaning screen filter that protects pumps, membranes and nozzles without frequent manual intervention. Differential-pressure control initiates the flush cycle.','Automatic self-cleaning screen filter for continuous water treatment.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'water-wastewater' LIMIT 1),(SELECT id FROM industries WHERE slug = 'food-beverage' LIMIT 1)),'316L stainless steel','10 bar','5 to 80 °C','230 / 400 V','DN50 to DN200','95 kg',JSON_ARRAY('CE','NSF/ANSI 61 option'),'IN_STOCK',0,1,0,'VortexPro Self-Cleaning Filter VP-SC-100','Automatic screen filter for continuous water and process protection.' FROM categories c WHERE c.slug='filtration' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-FLT-SC100');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Coriolis Flowmeter VP-CF-25','vortexpro-coriolis-flowmeter-vp-cf-25','VP-INS-CF25','A precision Coriolis mass flowmeter providing mass flow, density and temperature measurements for batching, custody transfer and process control. Local display and digital communications are included.','Coriolis mass flowmeter for precision batching and process measurement.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'chemical-processing' LIMIT 1),(SELECT id FROM industries WHERE slug = 'pharmaceutical' LIMIT 1)),'316L stainless measuring tubes','100 bar','-50 to 180 °C','24 VDC','DN15 to DN80','22 kg',JSON_ARRAY('MID','OIML R117','3-A option'),'MADE_TO_ORDER',1,1,0,'VortexPro Coriolis Flowmeter VP-CF-25','Precision Coriolis meter for mass flow, density and batching control.' FROM categories c WHERE c.slug='instrumentation' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-INS-CF25');

INSERT INTO products (id,name,slug,sku,description,shortDescription,categoryId,industryIds,material,pressure,temperature,voltage,dimensions,weight,certifications,availability,featured,isActive,views,metaTitle,metaDescription)
SELECT UUID(),'VortexPro Smart Pressure Transmitter VP-PT-400','vortexpro-smart-pressure-transmitter-vp-pt-400','VP-INS-PT400','A smart pressure transmitter with 4–20 mA HART output, local configuration buttons and remote seal options. It delivers stable pressure measurement for hazardous and general process areas.','Smart HART pressure transmitter for reliable process measurement.',c.id,JSON_ARRAY((SELECT id FROM industries WHERE slug = 'oil-gas' LIMIT 1),(SELECT id FROM industries WHERE slug = 'power-generation' LIMIT 1)),'316L stainless steel','Up to 600 bar','-40 to 125 °C','10.5 to 42 VDC','1/2 in NPT process connection','1.4 kg',JSON_ARRAY('ATEX','IECEx','SIL 2'),'IN_STOCK',0,1,0,'VortexPro Smart Pressure Transmitter VP-PT-400','Smart HART transmitter for hazardous and general process areas.' FROM categories c WHERE c.slug='instrumentation' AND NOT EXISTS (SELECT 1 FROM products WHERE sku='VP-INS-PT400');

-- Dedicated product artwork for every new catalog item.
INSERT INTO product_images (id,productId,url,alt,caption,sortOrder,isPrimary)
SELECT UUID(), p.id,
       CONCAT('/assets/img/products/', CASE p.sku
           WHEN 'VP-VLV-GV300' THEN 'vortexpro-globe-valve-vp-gv-300.jpg'
           WHEN 'VP-VLV-BF150' THEN 'vortexpro-butterfly-valve-vp-bf-150.jpg'
           WHEN 'VP-PMP-AP610' THEN 'vortexpro-api-process-pump-vp-ap-610.jpg'
           WHEN 'VP-PMP-VT90' THEN 'vortexpro-vertical-turbine-pump-vp-vt-90.jpg'
           WHEN 'VP-HX-ST500' THEN 'vortexpro-shell-tube-exchanger-vp-st-500.jpg'
           WHEN 'VP-HX-BP40' THEN 'vortexpro-brazed-plate-exchanger-vp-bp-40.jpg'
           WHEN 'VP-FLT-FS800' THEN 'vortexpro-filter-separator-vp-fs-800.jpg'
           WHEN 'VP-FLT-SC100' THEN 'vortexpro-self-cleaning-filter-vp-sc-100.jpg'
           WHEN 'VP-INS-CF25' THEN 'vortexpro-coriolis-flowmeter-vp-cf-25.jpg'
           WHEN 'VP-INS-PT400' THEN 'vortexpro-smart-pressure-transmitter-vp-pt-400.jpg'
       END), p.name, 'Product image', 0, 1
FROM products p
WHERE p.sku IN ('VP-VLV-GV300','VP-VLV-BF150','VP-PMP-AP610','VP-PMP-VT90','VP-HX-ST500','VP-HX-BP40','VP-FLT-FS800','VP-FLT-SC100','VP-INS-CF25','VP-INS-PT400')
  AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);


-- =============================================================================
-- Catalog prices (migration 009)
-- =============================================================================
-- Publish pricing for the additional catalog range (USD).
-- Prices are starting prices; final configuration and freight are quoted separately.

UPDATE products
SET price = CASE sku
    WHEN 'VP-INS-PT400' THEN 500.00
    WHEN 'VP-VLV-BF150' THEN 850.00
    WHEN 'VP-INS-CF25'  THEN 1200.00
    WHEN 'VP-VLV-GV300' THEN 1600.00
    WHEN 'VP-FLT-SC100' THEN 2200.00
    WHEN 'VP-HX-BP40'   THEN 2800.00
    WHEN 'VP-PMP-VT90'  THEN 3500.00
    WHEN 'VP-PMP-AP610' THEN 4000.00
    WHEN 'VP-FLT-FS800' THEN 4500.00
    WHEN 'VP-HX-ST500'  THEN 5000.00
END
WHERE sku IN ('VP-INS-PT400','VP-VLV-BF150','VP-INS-CF25','VP-VLV-GV300','VP-FLT-SC100','VP-HX-BP40','VP-PMP-VT90','VP-PMP-AP610','VP-FLT-FS800','VP-HX-ST500');
