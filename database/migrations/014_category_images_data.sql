-- =====================================================================
-- Give every seeded category its own image (migration 014)
-- =====================================================================
-- The `categories.image` column exists since 013, but the category seed
-- rows were inserted without image values, so every public category card
-- fell back to /assets/img/products/<slug>.jpg which does not exist for
-- most slugs -> blank/broken cards.
--
-- This migration points every seeded category at curated artwork that
-- ships with the theme (assets/img/products/*.jpg), so the public
-- category grid always shows the right image for each category.
-- Safe to import more than once (UPDATE ... WHERE slug = ...).
-- =====================================================================

-- Vortex Precision process equipment
UPDATE `categories` SET `image` = '/assets/img/products/valves.jpg'            WHERE `slug` = 'valves';
UPDATE `categories` SET `image` = '/assets/img/products/pumps.jpg'             WHERE `slug` = 'pumps';
UPDATE `categories` SET `image` = '/assets/img/products/heat-exchangers.jpg'   WHERE `slug` = 'heat-exchangers';
UPDATE `categories` SET `image` = '/assets/img/products/pressure-vessels.jpg'  WHERE `slug` = 'pressure-vessels';
UPDATE `categories` SET `image` = '/assets/img/products/filtration.jpg'        WHERE `slug` = 'filtration';
UPDATE `categories` SET `image` = '/assets/img/products/instrumentation.jpg'   WHERE `slug` = 'instrumentation';

-- AJR NDT range — one image per category
UPDATE `categories` SET `image` = '/assets/img/products/ultrasonic-flaw-detection.jpg'     WHERE `slug` = 'ultrasonic-flaw-detection';
UPDATE `categories` SET `image` = '/assets/img/products/thickness-coating-gauges.jpg'      WHERE `slug` = 'thickness-coating-gauges';
UPDATE `categories` SET `image` = '/assets/img/products/hardness-testing.jpg'              WHERE `slug` = 'hardness-testing';
UPDATE `categories` SET `image` = '/assets/img/products/surface-roughness-testing.jpg'     WHERE `slug` = 'surface-roughness-testing';
UPDATE `categories` SET `image` = '/assets/img/products/magnetic-particle-inspection.jpg'  WHERE `slug` = 'magnetic-particle-inspection';
UPDATE `categories` SET `image` = '/assets/img/products/radiography-testing.jpg'           WHERE `slug` = 'radiography-testing';
UPDATE `categories` SET `image` = '/assets/img/products/eddy-current-testing.jpg'          WHERE `slug` = 'eddy-current-testing';
UPDATE `categories` SET `image` = '/assets/img/products/visual-inspection-videoscopes.jpg' WHERE `slug` = 'visual-inspection-videoscopes';
UPDATE `categories` SET `image` = '/assets/img/products/ndt-uv-lamps.jpg'                  WHERE `slug` = 'ndt-uv-lamps';
UPDATE `categories` SET `image` = '/assets/img/products/holiday-wire-rope-testing.jpg'     WHERE `slug` = 'holiday-wire-rope-testing';
UPDATE `categories` SET `image` = '/assets/img/products/photometers-radiometers.jpg'       WHERE `slug` = 'photometers-radiometers';
UPDATE `categories` SET `image` = '/assets/img/products/calibration-blocks.jpg'            WHERE `slug` = 'calibration-blocks';
UPDATE `categories` SET `image` = '/assets/img/products/ultrasonic-probes-cables.jpg'      WHERE `slug` = 'ultrasonic-probes-cables';
