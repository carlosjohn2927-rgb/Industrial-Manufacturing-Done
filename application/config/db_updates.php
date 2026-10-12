<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision IT — shipped SQL database updates registry.
 *
 * Every file in database/migrations/ is listed here with:
 *   - title / description  shown on the admin "Database updates" screen
 *   - probe                cheap SQL used to detect whether the update is
 *                          ALREADY present in a database that predates the
 *                          in-dashboard runner (sites that imported the file
 *                          by hand in phpMyAdmin, or fresh installs from
 *                          database/production.sql)
 *
 * Probe semantics ('probe' => [type, sql]):
 *   'exists'   applied when the query succeeds (any row count)
 *   'positive' applied when the first column of the first row is > 0
 *   'zero'     applied when the first column of the first row is 0
 *   null       no probe: the update shows as "Not tracked" until it is run
 *              from the dashboard or marked as applied by hand
 *
 * Probes are best-effort heuristics for LEGACY detection only. Once an
 * update runs from the dashboard it is recorded in `schema_migrations` and
 * the probe is no longer consulted. Every shipped update is safe to re-run,
 * so a probe that wrongly reports "not applied" merely re-applies a no-op.
 */

$config['db_updates'] = [
    '001' => [
        'title'       => 'CMS + permissions tables',
        'description' => 'Adds the dashboard foundation: permissions, user_permissions, pages, page_sections, menu_items and the extended media table.',
        'probe'       => ['exists', 'SELECT COUNT(*) AS c FROM page_sections'],
    ],
    '002' => [
        'title'       => 'CMS + permission seed data',
        'description' => 'Seeds the permission catalogue, role defaults and the starter CMS pages. INSERT IGNORE: never overwrites edited content.',
        'probe'       => ['positive', 'SELECT COUNT(*) AS c FROM permissions'],
    ],
    '003' => [
        'title'       => 'Administrator full website-editing access',
        'description' => 'Gives the ADMIN role edit access to every website section.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM role_permissions WHERE role = 'ADMIN' AND resource = 'pages'"],
    ],
    '004' => [
        'title'       => 'Black write-up theme colours',
        'description' => 'Sets the light-surface text colour to pure black and the page background to white.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM settings WHERE `key` = 'theme_writeup'"],
    ],
    '005' => [
        'title'       => 'Testimonials admin access',
        'description' => 'Restores the Testimonials dashboard item (permissions + EDITOR role grant).',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM permissions WHERE `key` = 'testimonials.manage'"],
    ],
    '006' => [
        'title'       => 'Administrator full-dashboard access',
        'description' => 'Grants the ADMIN role the full dashboard wildcard. The SUPER_ADMIN account stays protected in code.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM role_permissions WHERE role = 'ADMIN' AND resource = '*'"],
    ],
    '007' => [
        'title'       => 'Vortex Precision IT rebrand',
        'description' => 'Replaces legacy "Halyk Petroleum" branding in settings, homepage sections and testimonials.',
        'probe'       => ['zero', "SELECT COUNT(*) AS c FROM settings WHERE `value` LIKE '%Halyk Petroleum%' OR `value` LIKE '%HALYK PETROLEUM%' OR `value` LIKE '%halykpetroleum-kz.com%'"],
    ],
    '008' => [
        'title'       => 'Additional catalog products (VortexPro range)',
        'description' => 'Adds ten VortexPro catalog products (valves, pumps, exchangers, filters, instruments). SKU-guarded: no duplicates.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM products WHERE sku = 'VP-VLV-GV300'"],
    ],
    '009' => [
        'title'       => 'Catalog prices',
        'description' => 'Publishes starting prices (USD 500–5,000) for the VortexPro range.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM products WHERE sku = 'VP-INS-PT400' AND price = 500"],
    ],
    '010' => [
        'title'       => 'AJR NDT product range',
        'description' => 'Adds the 93-product AJR NDT non-destructive-testing catalog (13 categories, images and specs).',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM products WHERE sku = 'AJR-AFD-100'"],
    ],
    '011' => [
        'title'       => 'Show the AJR NDT catalog on the site',
        'description' => 'Raises the homepage category/product limits so the AJR NDT categories are visible.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM page_sections WHERE pageKey = 'home' AND `type` = 'categories' AND subtitle LIKE '%AJR NDT%'"],
    ],
    '012' => [
        'title'       => 'Remove duplicate products',
        'description' => 'Deletes duplicate products (keeping photos, specs, downloads and quote lines) and re-creates the unique SKU/slug indexes.',
        'probe'       => ['zero', 'SELECT COUNT(*) AS c FROM (SELECT 1 AS x FROM products GROUP BY LOWER(TRIM(slug)) HAVING COUNT(*) > 1) d'],
    ],
    '013' => [
        'title'       => 'Category image column',
        'description' => 'Adds categories.image for per-category artwork (older databases only).',
        'probe'       => ['exists', 'SELECT `image` FROM categories LIMIT 1'],
    ],
    '014' => [
        'title'       => 'Category artwork',
        'description' => 'Points every seeded category at curated artwork so category cards never render blank.',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM categories WHERE image IS NOT NULL AND image <> ''"],
    ],
    '015' => [
        'title'       => 'Refteck product range',
        'description' => 'Adds the 107-product Refteck industrial catalog (10 new categories: drilling, rotary, process, electrical, MRO, oil & lubricants, HVAC, heavy plant, safety and valves).',
        'probe'       => ['positive', "SELECT COUNT(*) AS c FROM products WHERE sku LIKE 'RF-%'"],
    ],
];
