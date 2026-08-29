-- =============================================================================
-- REMOVE EVERY DUPLICATE PRODUCT
-- =============================================================================
-- What this does
--   1. Normalises obviously broken slugs/SKUs (empty, or padded with spaces).
--   2. Deletes duplicate products in three passes:
--        Pass A  same slug   (case/whitespace-insensitive)
--        Pass B  same SKU    (case/whitespace-insensitive)
--        Pass C  same name   (case/whitespace-insensitive; see note below)
--   3. Before deleting a duplicate, its photos (product_images), technical
--      specs (specifications), downloads (product_downloads), related-product
--      links (related_products) and quote line items (quote_items) are moved
--      to the product that is kept, so nothing is orphaned or lost.
--   4. Finally it (re-)creates the unique indexes on products.slug and
--      products.sku so duplicate products can never be inserted again.
--
-- Which copy is kept
--   Passes A and B (same slug or SKU = the same record imported twice):
--     the EARLIEST-CREATED row is kept (its id wins a tie).
--   Pass C (same name only): the MOST RECENTLY UPDATED row is kept, since a
--     name-only match is usually a manual re-entry of an existing product.
--
-- How to run
--   cPanel -> phpMyAdmin -> select the database -> Import -> choose this file
--   -> Go. Import the WHOLE file at once (the passes use temporary tables
--   that live for the duration of the import).
--
-- Safe to re-run
--   Yes. Every pass is a no-op once no duplicates are left. The two ALTER
--   TABLE statements at the very end report "Duplicate key name ..." when the
--   indexes already exist (exactly like migration 001's media ALTERs) - that
--   message is safe to ignore. If the import stops on the first ALTER, the
--   cleanup above it has already completed; just run the second ALTER by hand
--   if your database is missing it.
--
-- NOTE on Pass C: if your catalogue deliberately contains two different
-- products that share an exact name, delete the "PASS C" block below before
-- importing (or re-import after removing it) - only Passes A and B will run.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- STEP 0 - Preflight: trim padded values and give empty slugs/SKUs a unique
-- fallback value, so the unique indexes at the end can always be created.
-- -----------------------------------------------------------------------------
UPDATE `products`
   SET `slug` = TRIM(`slug`)
 WHERE `slug` IS NOT NULL AND `slug` <> TRIM(`slug`);

UPDATE `products`
   SET `sku` = TRIM(`sku`)
 WHERE `sku` IS NOT NULL AND `sku` <> TRIM(`sku`);

UPDATE `products`
   SET `slug` = CONCAT('product-', LOWER(REPLACE(`id`, '-', '')))
 WHERE `slug` IS NULL OR TRIM(`slug`) = '';

UPDATE `products`
   SET `sku` = CONCAT('SKU-', UPPER(REPLACE(`id`, '-', '')))
 WHERE `sku` IS NULL OR TRIM(`sku`) = '';

-- =============================================================================
-- PASS A - remove products that share the same SLUG
-- (the earliest-created row of each slug group is kept)
-- =============================================================================
DROP TEMPORARY TABLE IF EXISTS `tmp_keep`;
CREATE TEMPORARY TABLE `tmp_keep` (
  `gkey`     VARCHAR(255) NOT NULL PRIMARY KEY,
  `keep_key` VARCHAR(80)  NOT NULL
) ENGINE=InnoDB;

INSERT INTO `tmp_keep` (`gkey`, `keep_key`)
SELECT LOWER(TRIM(`slug`)), MIN(CONCAT(`createdAt`, '|', `id`))
  FROM `products`
 GROUP BY LOWER(TRIM(`slug`))
HAVING COUNT(*) > 1;

DROP TEMPORARY TABLE IF EXISTS `tmp_dup_map`;
CREATE TEMPORARY TABLE `tmp_dup_map` (
  `loser_id` CHAR(36) NOT NULL PRIMARY KEY,
  `keep_id`  CHAR(36) NOT NULL,
  KEY `idx_dup_keep` (`keep_id`)
) ENGINE=InnoDB;

INSERT INTO `tmp_dup_map` (`loser_id`, `keep_id`)
SELECT p.`id`, SUBSTRING_INDEX(k.`keep_key`, '|', -1)
  FROM `products` p
  JOIN `tmp_keep` k ON k.`gkey` = LOWER(TRIM(p.`slug`))
 WHERE CONCAT(p.`createdAt`, '|', p.`id`) <> k.`keep_key`;

-- Photos: move them to the kept product unless it already has that image.
UPDATE `product_images` pi
  JOIN `tmp_dup_map` m  ON m.`loser_id` = pi.`productId`
  LEFT JOIN `product_images` dup ON dup.`productId` = m.`keep_id` AND dup.`url` = pi.`url`
   SET pi.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

-- Technical specs: move them unless the kept product has the same spec key.
UPDATE `specifications` s
  JOIN `tmp_dup_map` m  ON m.`loser_id` = s.`productId`
  LEFT JOIN `specifications` dup ON dup.`productId` = m.`keep_id` AND dup.`key` = s.`key`
   SET s.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

-- Downloads: move them unless the kept product already has that file URL.
UPDATE `product_downloads` d
  JOIN `tmp_dup_map` m  ON m.`loser_id` = d.`productId`
  LEFT JOIN `product_downloads` dup ON dup.`productId` = m.`keep_id` AND dup.`url` = d.`url`
   SET d.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

-- Related-product links: copy them to the kept product (both directions),
-- skipping pairs the kept product already has; the old rows disappear with
-- the duplicate via the foreign-key cascade.
INSERT IGNORE INTO `related_products` (`id`, `productId`, `relatedId`)
SELECT UUID(), m.`keep_id`, rp.`relatedId`
  FROM `related_products` rp
  JOIN `tmp_dup_map` m ON m.`loser_id` = rp.`productId`
 WHERE rp.`relatedId` <> m.`keep_id`;

INSERT IGNORE INTO `related_products` (`id`, `productId`, `relatedId`)
SELECT UUID(), rp.`productId`, m.`keep_id`
  FROM `related_products` rp
  JOIN `tmp_dup_map` m ON m.`loser_id` = rp.`relatedId`
 WHERE rp.`productId` <> m.`keep_id`;

-- Quote line items: point them at the kept product unless the quote already
-- references it (the rest become NULL productId when the duplicate is
-- deleted - the product name stays stored on the line item).
UPDATE `quote_items` qi
  JOIN `tmp_dup_map` m ON m.`loser_id` = qi.`productId`
  LEFT JOIN `quote_items` dup ON dup.`quoteId` = qi.`quoteId` AND dup.`productId` = m.`keep_id`
   SET qi.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

-- Delete the duplicates (children still pointing at them are removed or
-- nulled automatically by the foreign keys).
DELETE p FROM `products` p
  JOIN `tmp_dup_map` m ON m.`loser_id` = p.`id`;

DROP TEMPORARY TABLE IF EXISTS `tmp_dup_map`;
DROP TEMPORARY TABLE IF EXISTS `tmp_keep`;

-- =============================================================================
-- PASS B - remove products that share the same SKU
-- (the earliest-created row of each SKU group is kept)
-- =============================================================================
DROP TEMPORARY TABLE IF EXISTS `tmp_keep`;
CREATE TEMPORARY TABLE `tmp_keep` (
  `gkey`     VARCHAR(255) NOT NULL PRIMARY KEY,
  `keep_key` VARCHAR(80)  NOT NULL
) ENGINE=InnoDB;

INSERT INTO `tmp_keep` (`gkey`, `keep_key`)
SELECT UPPER(TRIM(`sku`)), MIN(CONCAT(`createdAt`, '|', `id`))
  FROM `products`
 GROUP BY UPPER(TRIM(`sku`))
HAVING COUNT(*) > 1;

DROP TEMPORARY TABLE IF EXISTS `tmp_dup_map`;
CREATE TEMPORARY TABLE `tmp_dup_map` (
  `loser_id` CHAR(36) NOT NULL PRIMARY KEY,
  `keep_id`  CHAR(36) NOT NULL,
  KEY `idx_dup_keep` (`keep_id`)
) ENGINE=InnoDB;

INSERT INTO `tmp_dup_map` (`loser_id`, `keep_id`)
SELECT p.`id`, SUBSTRING_INDEX(k.`keep_key`, '|', -1)
  FROM `products` p
  JOIN `tmp_keep` k ON k.`gkey` = UPPER(TRIM(p.`sku`))
 WHERE CONCAT(p.`createdAt`, '|', p.`id`) <> k.`keep_key`;

UPDATE `product_images` pi
  JOIN `tmp_dup_map` m  ON m.`loser_id` = pi.`productId`
  LEFT JOIN `product_images` dup ON dup.`productId` = m.`keep_id` AND dup.`url` = pi.`url`
   SET pi.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

UPDATE `specifications` s
  JOIN `tmp_dup_map` m  ON m.`loser_id` = s.`productId`
  LEFT JOIN `specifications` dup ON dup.`productId` = m.`keep_id` AND dup.`key` = s.`key`
   SET s.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

UPDATE `product_downloads` d
  JOIN `tmp_dup_map` m  ON m.`loser_id` = d.`productId`
  LEFT JOIN `product_downloads` dup ON dup.`productId` = m.`keep_id` AND dup.`url` = d.`url`
   SET d.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

INSERT IGNORE INTO `related_products` (`id`, `productId`, `relatedId`)
SELECT UUID(), m.`keep_id`, rp.`relatedId`
  FROM `related_products` rp
  JOIN `tmp_dup_map` m ON m.`loser_id` = rp.`productId`
 WHERE rp.`relatedId` <> m.`keep_id`;

INSERT IGNORE INTO `related_products` (`id`, `productId`, `relatedId`)
SELECT UUID(), rp.`productId`, m.`keep_id`
  FROM `related_products` rp
  JOIN `tmp_dup_map` m ON m.`loser_id` = rp.`relatedId`
 WHERE rp.`productId` <> m.`keep_id`;

UPDATE `quote_items` qi
  JOIN `tmp_dup_map` m ON m.`loser_id` = qi.`productId`
  LEFT JOIN `quote_items` dup ON dup.`quoteId` = qi.`quoteId` AND dup.`productId` = m.`keep_id`
   SET qi.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

DELETE p FROM `products` p
  JOIN `tmp_dup_map` m ON m.`loser_id` = p.`id`;

DROP TEMPORARY TABLE IF EXISTS `tmp_dup_map`;
DROP TEMPORARY TABLE IF EXISTS `tmp_keep`;

-- =============================================================================
-- PASS C - remove products that share the same NAME
-- (different slug AND SKU but the same product re-entered by hand; the most
--  recently updated row of each name group is kept)
-- =============================================================================
DROP TEMPORARY TABLE IF EXISTS `tmp_keep`;
CREATE TEMPORARY TABLE `tmp_keep` (
  `gkey`     VARCHAR(255) NOT NULL PRIMARY KEY,
  `keep_key` VARCHAR(80)  NOT NULL
) ENGINE=InnoDB;

INSERT INTO `tmp_keep` (`gkey`, `keep_key`)
SELECT LOWER(TRIM(REPLACE(REPLACE(`name`, '  ', ' '), '  ', ' '))),
       MAX(CONCAT(`updatedAt`, '|', `createdAt`, '|', `id`))
  FROM `products`
 GROUP BY LOWER(TRIM(REPLACE(REPLACE(`name`, '  ', ' '), '  ', ' ')))
HAVING COUNT(*) > 1;

DROP TEMPORARY TABLE IF EXISTS `tmp_dup_map`;
CREATE TEMPORARY TABLE `tmp_dup_map` (
  `loser_id` CHAR(36) NOT NULL PRIMARY KEY,
  `keep_id`  CHAR(36) NOT NULL,
  KEY `idx_dup_keep` (`keep_id`)
) ENGINE=InnoDB;

INSERT INTO `tmp_dup_map` (`loser_id`, `keep_id`)
SELECT p.`id`, SUBSTRING_INDEX(k.`keep_key`, '|', -1)
  FROM `products` p
  JOIN `tmp_keep` k
    ON k.`gkey` = LOWER(TRIM(REPLACE(REPLACE(p.`name`, '  ', ' '), '  ', ' ')))
 WHERE CONCAT(p.`updatedAt`, '|', p.`createdAt`, '|', p.`id`) <> k.`keep_key`;

UPDATE `product_images` pi
  JOIN `tmp_dup_map` m  ON m.`loser_id` = pi.`productId`
  LEFT JOIN `product_images` dup ON dup.`productId` = m.`keep_id` AND dup.`url` = pi.`url`
   SET pi.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

UPDATE `specifications` s
  JOIN `tmp_dup_map` m  ON m.`loser_id` = s.`productId`
  LEFT JOIN `specifications` dup ON dup.`productId` = m.`keep_id` AND dup.`key` = s.`key`
   SET s.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

UPDATE `product_downloads` d
  JOIN `tmp_dup_map` m  ON m.`loser_id` = d.`productId`
  LEFT JOIN `product_downloads` dup ON dup.`productId` = m.`keep_id` AND dup.`url` = d.`url`
   SET d.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

INSERT IGNORE INTO `related_products` (`id`, `productId`, `relatedId`)
SELECT UUID(), m.`keep_id`, rp.`relatedId`
  FROM `related_products` rp
  JOIN `tmp_dup_map` m ON m.`loser_id` = rp.`productId`
 WHERE rp.`relatedId` <> m.`keep_id`;

INSERT IGNORE INTO `related_products` (`id`, `productId`, `relatedId`)
SELECT UUID(), rp.`productId`, m.`keep_id`
  FROM `related_products` rp
  JOIN `tmp_dup_map` m ON m.`loser_id` = rp.`relatedId`
 WHERE rp.`productId` <> m.`keep_id`;

UPDATE `quote_items` qi
  JOIN `tmp_dup_map` m ON m.`loser_id` = qi.`productId`
  LEFT JOIN `quote_items` dup ON dup.`quoteId` = qi.`quoteId` AND dup.`productId` = m.`keep_id`
   SET qi.`productId` = m.`keep_id`
 WHERE dup.`id` IS NULL;

DELETE p FROM `products` p
  JOIN `tmp_dup_map` m ON m.`loser_id` = p.`id`;

DROP TEMPORARY TABLE IF EXISTS `tmp_dup_map`;
DROP TEMPORARY TABLE IF EXISTS `tmp_keep`;

-- -----------------------------------------------------------------------------
-- Verification - each of these should return an empty result set.
-- -----------------------------------------------------------------------------
SELECT LOWER(TRIM(`slug`)) AS `slug`, COUNT(*) AS `copies`
  FROM `products`
 GROUP BY LOWER(TRIM(`slug`))
HAVING COUNT(*) > 1;

SELECT UPPER(TRIM(`sku`)) AS `sku`, COUNT(*) AS `copies`
  FROM `products`
 GROUP BY UPPER(TRIM(`sku`))
HAVING COUNT(*) > 1;

SELECT LOWER(TRIM(REPLACE(REPLACE(`name`, '  ', ' '), '  ', ' '))) AS `name`, COUNT(*) AS `copies`
  FROM `products`
 GROUP BY LOWER(TRIM(REPLACE(REPLACE(`name`, '  ', ' '), '  ', ' ')))
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS `remaining_products` FROM `products`;

-- -----------------------------------------------------------------------------
-- Finally, make duplicates impossible in the future.
-- On databases that already have these indexes MySQL reports
-- "Duplicate key name uk_products_slug / uk_products_sku" - safe to ignore.
-- -----------------------------------------------------------------------------
ALTER TABLE `products` ADD UNIQUE KEY `uk_products_slug` (`slug`);
ALTER TABLE `products` ADD UNIQUE KEY `uk_products_sku` (`sku`);
