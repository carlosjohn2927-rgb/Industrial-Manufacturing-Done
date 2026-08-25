-- Vortex Precision IT rebrand for existing cPanel databases.
-- Run in cPanel → phpMyAdmin → select the site database → SQL after deploying.
-- Fresh installations already receive these values through the seed files.

UPDATE `settings`
SET `value` = REPLACE(REPLACE(REPLACE(`value`, 'Halyk Petroleum', 'Vortex Precision IT'), 'HALYK PETROLEUM', 'VORTEX PRECISION IT'), 'halykpetroleum-kz.com', 'vortexprecisionit.com')
WHERE `value` LIKE '%Halyk Petroleum%'
   OR `value` LIKE '%HALYK PETROLEUM%'
   OR `value` LIKE '%halykpetroleum-kz.com%';

UPDATE `page_sections`
SET `title`    = REPLACE(`title`, 'Halyk Petroleum', 'Vortex Precision IT'),
    `subtitle` = REPLACE(`subtitle`, 'Halyk Petroleum', 'Vortex Precision IT'),
    `body`     = REPLACE(`body`, 'Halyk Petroleum', 'Vortex Precision IT')
WHERE `title` LIKE '%Halyk Petroleum%'
   OR `subtitle` LIKE '%Halyk Petroleum%'
   OR `body` LIKE '%Halyk Petroleum%';

UPDATE `testimonials`
SET `content` = REPLACE(`content`, 'Halyk Petroleum', 'Vortex Precision IT')
WHERE `content` LIKE '%Halyk Petroleum%';

UPDATE `faqs`
SET `answer` = REPLACE(REPLACE(`answer`, 'Halyk Petroleum', 'Vortex Precision IT'), 'halykpetroleum-kz.com', 'vortexprecisionit.com')
WHERE `answer` LIKE '%Halyk Petroleum%'
   OR `answer` LIKE '%halykpetroleum-kz.com%';
