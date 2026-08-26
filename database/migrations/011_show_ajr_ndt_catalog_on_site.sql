-- =============================================================================
-- Show the AJR NDT catalog on the public site (homepage + listings).
-- =============================================================================
-- Existing installs already have homepage sections with {"limit":6}. Those
-- six slots are filled by the original valve/pump categories (sortOrder 1–6),
-- so the 13 AJR NDT categories (sortOrder 10–130) never appeared on the home
-- page even after migration 010 was imported. This update is safe to re-run.

UPDATE `page_sections`
   SET `settings` = '{"limit":24}',
       `subtitle` = 'From industrial process equipment to AJR NDT inspection instruments, every category is engineered to the same standard.'
 WHERE `pageKey` = 'home' AND `type` = 'categories';

UPDATE `page_sections`
   SET `settings` = '{"limit":8}',
       `subtitle` = 'Our most-requested process equipment and AJR NDT inspection instruments.'
 WHERE `pageKey` = 'home' AND `type` = 'products';
