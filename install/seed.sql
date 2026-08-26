-- =====================================================================
-- Vortex Precision - seed data (content only - NO user accounts)
-- Run AFTER install.sql.
--
-- SECURITY: this file intentionally contains NO user accounts and NO
-- passwords. The initial administrator account is created by
--   php install/install.php
-- which either uses VP_ADMIN_PASSWORD from the environment or generates
-- a random temporary password that must be changed on first login.
--
-- Generates UUIDs inline using MySQL 8 / MariaDB 10.2+ UUID() function.
-- =====================================================================

-- ----- Default permissions (all resources for SUPER_ADMIN, scoped for others) -----
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

-- ----- Categories -----
INSERT INTO `categories` (`id`,`name`,`slug`,`description`,`icon`,`sortOrder`,`isActive`,`metaTitle`) VALUES
(UUID(),'Valves','valves','Industrial valves for flow control in demanding applications.','valve',1,1,'Industrial Valves - Vortex Precision'),
(UUID(),'Pumps','pumps','Centrifugal, positive displacement and specialty pumps.','pump',2,1,'Industrial Pumps - Vortex Precision'),
(UUID(),'Heat Exchangers','heat-exchangers','Shell-and-tube, plate and brazed heat exchangers.','heater',3,1,'Heat Exchangers - Vortex Precision'),
(UUID(),'Pressure Vessels','pressure-vessels','ASME-coded pressure vessels for process industries.','vessel',4,1,'Pressure Vessels - Vortex Precision'),
(UUID(),'Filtration','filtration','Industrial filtration systems and cartridges.','filter',5,1,'Filtration Systems - Vortex Precision'),
(UUID(),'Instrumentation','instrumentation','Process measurement, gauges and sensors.','gauge',6,1,'Instrumentation - Vortex Precision');

-- ----- Industries -----
INSERT INTO `industries` (`id`,`name`,`slug`,`description`,`icon`,`sortOrder`,`isActive`,`metaTitle`,`capabilities`) VALUES
(UUID(),'Oil & Gas','oil-gas','Upstream, midstream and downstream solutions engineered for the most demanding hydrocarbon environments.','oil',1,1,'Oil & Gas Solutions - Vortex Precision', JSON_ARRAY('ASME B31.3 piping','API 610 pumps','API 600 valves','NACE MR0175 compliance')),
(UUID(),'Chemical Processing','chemical-processing','Corrosion-resistant equipment for aggressive chemistries and continuous-duty plants.','flask',2,1,'Chemical Processing - Vortex Precision', JSON_ARRAY('Hastelloy / Duplex fabrication','PTFE linings','ATEX compliance','CIP capability')),
(UUID(),'Power Generation','power-generation','High-pressure and high-temperature equipment for thermal, nuclear and renewable power.','bolt',3,1,'Power Generation - Vortex Precision', JSON_ARRAY('ASME Section I boilers','ASME Section VIII vessels','N-stamp nuclear','High-temp alloys')),
(UUID(),'Water & Wastewater','water-wastewater','Treatment plant equipment for municipal and industrial water and wastewater.','droplet',4,1,'Water & Wastewater - Vortex Precision', JSON_ARRAY('NSF/ANSI 61 potable water','AWWA standards','Lift stations','Membrane skids')),
(UUID(),'Pharmaceutical','pharmaceutical','Sanitary process equipment for pharma, biotech and life-sciences.','pill',5,1,'Pharmaceutical - Vortex Precision', JSON_ARRAY('3-A sanitary standards','Electropolish','FDA-compliant seals','Clean-in-place')),
(UUID(),'Food & Beverage','food-beverage','Hygienic equipment for dairy, brewing, beverage and food processing.','utensils',6,1,'Food & Beverage - Vortex Precision', JSON_ARRAY('3-A sanitary','CIP/SIP','EHEDG hygienic design','Stainless 304/316L'));

-- ----- Products (12) -----
-- Use a small helper to build id reuse; not all engines support CTE+INSERT, so we use literals.
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
  '316L Stainless Steel','150 PSI','-20 to 400 °F','N/A','1/2" to 4"','3.2 lb',
  JSON_ARRAY('API 607','API 598','ISO 5211','CRN'),
  'IN_STOCK',1,1,128,'VortexPro Ball Valve VP-150'
UNION ALL SELECT
  UUID(),'VortexPro Gate Valve VP-GS','vortexpro-gate-valve-vgs','VP-VLV-GS',
  'Rising-stainless gate valve with flexible wedge and graphite packing. Suitable for high-temperature steam and hydrocarbon service. Body and bonnet in forged ASTM A182 F316L.',
  'High-temperature gate valve for steam and hydrocarbon service.',
  (SELECT `id` FROM `categories` WHERE `slug`='valves' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='power-generation')),
  'A182 F316L','Class 800','-50 to 1100 °F','N/A','2" to 24"','78 lb',
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
  '316L Stainless','Class 150','-20 to 250 °F','460V 3ph','2" to 6"','190 lb',
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
  'SA-516-70 / 304L','600 PSI','-50 to 400 °C','N/A','12" to 48" dia','1,200+ lb',
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
  '316L Stainless','100 PSI','-20 to 200 °F','N/A','5" to 30"','28 lb',
  JSON_ARRAY('3-A','EHEDG','CRN'),
  'IN_STOCK',0,1,33,'VortexPro Cartridge Filter VP-CF'
UNION ALL SELECT
  UUID(),'VortexPro Pressure Gauge VP-PG','vortexpro-pg-vppg','VP-INS-PG',
  'Bourdon tube pressure gauge, dry or liquid-filled, stainless case, 4" dial. ±1% full-scale accuracy, IP65 enclosure.',
  'Stainless case Bourdon pressure gauge, 4" dial, IP65.',
  (SELECT `id` FROM `categories` WHERE `slug`='instrumentation' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='power-generation')),
  '316L Stainless','10,000 PSI','-40 to 400 °F','N/A','4" dial','1.5 lb',
  JSON_ARRAY('ASME B40.100','EN 837-1'),
  'IN_STOCK',0,1,57,'VortexPro Pressure Gauge VP-PG'
UNION ALL SELECT
  UUID(),'VortexPro Level Transmitter VP-LT','vortexpro-lt-vplt','VP-INS-LT',
  'Guided-wave radar level transmitter for liquids and bulk solids. 24V DC loop-powered, HART, 4-20 mA output. Stainless process connection.',
  'Guided-wave radar level transmitter, HART + 4-20 mA.',
  (SELECT `id` FROM `categories` WHERE `slug`='instrumentation' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='water-wastewater'),(SELECT `id` FROM `industries` WHERE `slug`='chemical-processing')),
  '316L Stainless','Class 300','-40 to 400 °F','24V DC','1/2" to 4"','4.2 lb',
  JSON_ARRAY('ATEX','IECEx','CRN'),
  'IN_STOCK',1,1,91,'VortexPro Level Transmitter VP-LT'
UNION ALL SELECT
  UUID(),'VortexPro Check Valve VP-CV','vortexpro-cv-vpcv','VP-VLV-CV',
  'Stainless swing check valve, 316L body, suitable for horizontal and vertical installations. Resilient seat, low cracking pressure.',
  '316L swing check valve, low cracking pressure.',
  (SELECT `id` FROM `categories` WHERE `slug`='valves' LIMIT 1),
  JSON_ARRAY((SELECT `id` FROM `industries` WHERE `slug`='oil-gas'),(SELECT `id` FROM `industries` WHERE `slug`='water-wastewater')),
  '316L Stainless','Class 300','-50 to 600 °F','N/A','1/2" to 12"','22 lb',
  JSON_ARRAY('API 594','API 598'),
  'IN_STOCK',0,1,68,'VortexPro Check Valve VP-CV';

-- ----- FAQs -----
INSERT INTO `faqs` (`id`,`question`,`answer`,`category`,`sortOrder`,`isActive`) VALUES
(UUID(),'What is your typical lead time?','Standard catalog items ship within 5-7 business days. Custom-engineered equipment is typically 6-12 weeks depending on complexity and certification requirements.','Lead Times',1,1),
(UUID(),'Do you offer custom engineering?','Yes - we have a full in-house engineering team for custom pressure vessels, heat exchangers and skidded systems. We work to ASME, PED, CRN and other codes as required.','Engineering',2,1),
(UUID(),'Which quality standards do you follow?','We are ISO 9001:2015 certified. Equipment can be supplied to ASME (U, U2, S, NB), PED (CE), CRN, ATEX, 3-A and EHEDG depending on the application.','Quality',3,1),
(UUID(),'Do you provide installation and commissioning?','Yes, we offer global field service including installation supervision, commissioning, operator training and ongoing maintenance contracts.','Service',4,1),
(UUID(),'What is the warranty on your products?','All catalog products carry a standard 12-month warranty from shipment. Engineered equipment warranty is typically 18-24 months and clearly stated on the quotation.','Warranty',5,1),
(UUID(),'Do you ship internationally?','We ship worldwide. We handle export documentation, certificates of origin and can ship FOB, CIF or DDP depending on your preference.','Logistics',6,1),
(UUID(),'How do I get a quote?','Use the RFQ form on our site, or email sales@vortexprecision.com with your requirements, drawings and quantity. Most quotes are returned within 48 hours.','Quoting',7,1),
(UUID(),'Can I get a sample before ordering?','For selected catalog items, sample or evaluation units can be supplied at a nominal cost that is credited back on the first production order.','Samples',8,1);

-- ----- Testimonials -----
INSERT INTO `testimonials` (`id`,`name`,`title`,`company`,`content`,`rating`,`avatar`,`industry`,`isActive`,`featured`) VALUES
(UUID(),'Mark Henderson','Process Engineering Lead','DeltaChem Industries','Vortex delivered our custom heat exchanger skids on time and below budget. Their engineering team was responsive throughout the project.','5','/assets/img/reviews/mark-henderson.jpg','Chemical Processing',1,1),
(UUID(),'Linda Park','Plant Manager','NorthStar Refining','We have standardised on Vortex ball valves across our refinery. The quality is consistent, lead times are predictable, and their field service team is excellent.','5','/assets/img/reviews/linda-park.jpg','Oil & Gas',1,1),
(UUID(),'Akhil Raman','Director of Operations','BlueRiver Water Authority','The plate heat exchangers Vortex supplied for our district heating upgrade have performed flawlessly through three full heating seasons.','5','/assets/img/reviews/akhil-raman.jpg','Water & Wastewater',1,1),
(UUID(),'Jonas Weber','Head of Engineering','Brewmaster GmbH','Their sanitary pumps and filters meet the strictest EHEDG requirements. Vortex understands hygienic process design.','5','/assets/img/reviews/jonas-weber.jpg','Food & Beverage',1,0);

-- ----- Partners -----
INSERT INTO `partners` (`id`,`name`,`logo`,`website`,`category`,`sortOrder`,`isActive`) VALUES
(UUID(),'Siemens Energy','/assets/img/partners/siemens.svg','https://www.siemens-energy.com','OEM',1,1),
(UUID(),'Emerson Automation','/assets/img/partners/emerson.svg','https://www.emerson.com','Automation',2,1),
(UUID(),'Flowserve','/assets/img/partners/flowserve.svg','https://www.flowserve.com','OEM',3,1),
(UUID(),'KSB Group','/assets/img/partners/ksb.svg','https://www.ksb.com','OEM',4,1),
(UUID(),'Sulzer','/assets/img/partners/sulzer.svg','https://www.sulzer.com','OEM',5,1),
(UUID(),'Pentair','/assets/img/partners/pentair.svg','https://www.pentair.com','Filtration',6,1);

-- ----- Settings -----
INSERT INTO `settings` (`id`,`key`,`value`,`type`,`group`,`sortOrder`) VALUES
(UUID(),'site_name','Vortex Precision','STRING','GENERAL',1),
(UUID(),'site_tagline','Industrial Manufacturing Excellence','STRING','GENERAL',2),
(UUID(),'hero_title','Precision-engineered for the most demanding industries','STRING','HERO',1),
(UUID(),'hero_subtitle','Vortex Precision designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems trusted by operators worldwide.','STRING','HERO',2),
(UUID(),'hero_cta_primary','Request a Quote','STRING','HERO',3),
(UUID(),'hero_cta_secondary','Explore Products','STRING','HERO',4),
(UUID(),'about_intro','Vortex Precision has been a trusted partner to industrial operators for over three decades. From our headquarters in Houston, Texas, we design, manufacture and service equipment for the most demanding applications in oil & gas, chemical processing, power generation, water, pharmaceutical and food & beverage.','TEXT','ABOUT',1),
(UUID(),'stats_years','35','INT','STATS',1),
(UUID(),'stats_countries','60','INT','STATS',2),
(UUID(),'stats_projects','4200','INT','STATS',3),
(UUID(),'stats_clients','850','INT','STATS',4),
(UUID(),'contact_email','sales@vortexprecision.com','STRING','CONTACT',1),
(UUID(),'support_email','support@vortexprecision.com','STRING','CONTACT',2),
(UUID(),'rfq_email','rfq@vortexprecision.com','STRING','CONTACT',3),
(UUID(),'phone','+1 (555) 123-4567','STRING','CONTACT',4),
(UUID(),'address','1234 Industrial Way, Houston, TX 77001, USA','STRING','CONTACT',5),
(UUID(),'social','{"linkedin":"https://linkedin.com/company/vortexprecision","twitter":"https://twitter.com/vortexprecision","facebook":"https://facebook.com/vortexprecision","youtube":"https://youtube.com/@vortexprecision"}','JSON','CONTACT',6),
(UUID(),'rfq_enabled','1','BOOL','RFQ',1),
(UUID(),'rfq_rate_limit_per_hour','5','INT','RFQ',2),
(UUID(),'rfq_admin_email','admin@vortexprecision.com','STRING','RFQ',3),

-- ----- SEO -----
(UUID(),'seo_default_title','Vortex Precision — Industrial Manufacturing','STRING','SEO',1),
(UUID(),'seo_default_description','Vortex Precision designs and manufactures industrial valves, pumps, heat exchangers, pressure vessels and filtration systems for oil & gas, chemical, power, water, pharmaceutical and food & beverage operators worldwide.','TEXT','SEO',2),
(UUID(),'seo_keywords','industrial valves, centrifugal pumps, heat exchangers, pressure vessels, filtration systems, oil and gas equipment, process equipment manufacturer','STRING','SEO',3),
(UUID(),'seo_robots','index, follow','STRING','SEO',4),
(UUID(),'seo_og_image','/assets/img/hero-industrial.jpg','STRING','SEO',5),
(UUID(),'seo_enable_jsonld','1','BOOL','SEO',6),
(UUID(),'seo_schema_type','Organization','STRING','SEO',7),
(UUID(),'seo_schema_name','Vortex Precision','STRING','SEO',8),
(UUID(),'seo_schema_logo','/assets/img/logo-vortex-precision.png','STRING','SEO',9),

-- ----- AI Chat -----
(UUID(),'chat_enabled','1','BOOL','CHAT',1),
(UUID(),'chat_title','Vortex Precision IT Assistant','STRING','CHAT',2),
(UUID(),'chat_bot_name','Vortex Precision IT','STRING','CHAT',3),
(UUID(),'chat_avatar','/assets/img/chat-bot-avatar.png','STRING','CHAT',8),
(UUID(),'chat_welcome','Hi there! 👋 I can help you with our products, industries, pricing, delivery times and quotes. What would you like to know?','TEXT','CHAT',4),
(UUID(),'chat_ai_provider','local','STRING','CHAT',5),
(UUID(),'chat_rate_limit_per_hour','60','INT','CHAT',6),
(UUID(),'chat_quick_replies','["Products","Request a quote","Delivery times","Contact"]','JSON','CHAT',7)
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- ----- Careers -----
INSERT INTO `careers` (`id`,`title`,`slug`,`department`,`location`,`type`,`experience`,`salary`,`description`,`requirements`,`benefits`,`isActive`) VALUES
(UUID(),'Senior Mechanical Engineer','senior-mechanical-engineer','Engineering','Houston, TX','Full-time','7+ years','Competitive','Lead the design and analysis of pressure vessels and heat exchangers for our oil & gas and chemical processing clients.', 'Bachelor or Master in Mechanical Engineering, ASME Section VIII experience, PE preferred.', 'Health, dental, vision, 401(k) match, profit share', 1),
(UUID(),'Process Engineer','process-engineer','Engineering','Houston, TX','Full-time','3+ years','Competitive','Support process design and commissioning of skidded systems, including pumps, heat exchangers and filtration.', 'Bachelor in Chemical or Mechanical Engineering, P&ID literacy, field commissioning experience a plus.', 'Health, dental, vision, 401(k) match', 1),
(UUID(),'Quality Control Inspector','quality-control-inspector','Quality','Houston, TX','Full-time','5+ years','Competitive','Perform dimensional and NDE inspection of fabricated equipment to ASME, EN and customer-specific requirements.', 'CWI required, ASNT Level II PT/MT preferred, experience with ASME U/U2.', 'Health, dental, vision, 401(k) match', 1),
(UUID(),'Sales Engineer - Process','sales-engineer-process','Sales','Remote (US Southeast)','Full-time','5+ years','Base + Commission','Drive technical sales of valves, pumps and heat exchangers to EPCs, end users and channel partners.', 'Bachelor in Engineering, 5+ years industrial sales, technical fluency in pumps and valves.', 'Uncapped commission, health, 401(k) match, company vehicle', 1);

-- ----- News (3 sample) -----
INSERT INTO `news` (`id`,`title`,`slug`,`summary`,`content`,`publishedAt`,`isActive`) VALUES
(UUID(),'Vortex Precision completes delivery of 18 skidded heat exchanger packages to Gulf Coast chemical plant','skid-delivery-gulf-coast','A milestone order demonstrating our ability to deliver turnkey process skids to tight schedules.','Vortex Precision has successfully delivered 18 custom-engineered heat exchanger skids to a major Gulf Coast chemical complex. The packages, which include plate heat exchangers, instrumentation and structural steel, were delivered on a 14-week accelerated schedule and are now in commissioning.','2026-07-12 09:00:00',1),
(UUID(),'New EHEDG-certified sanitary pump line launched','sanitary-pump-launch','Our new PD pump line brings hygienic fluid handling to dairy, brewing and pharmaceutical customers.','Vortex Precision has launched a new line of rotary lobe positive-displacement pumps for sanitary service. The line is EHEDG-certified, available in 316L stainless with EHEDG-compliant elastomers.','2026-05-30 09:00:00',1),
(UUID(),'Vortex achieves ISO 9001:2015 recertification','iso-9001-recert','Quality system recertification reflects our continued commitment to customer satisfaction.','We are pleased to announce the successful completion of our ISO 9001:2015 surveillance audit, with zero non-conformances raised by the lead auditor.','2026-03-04 09:00:00',1);

-- ----- Downloads -----
INSERT INTO `downloads` (`id`,`title`,`description`,`fileUrl`,`type`,`category`,`fileSize`,`downloads`,`isActive`) VALUES
(UUID(),'Company Brochure 2026','Full-line overview of Vortex Precision capabilities and reference projects.','/assets/files/vortex-brochure-2026.pdf','PDF','General','3.2 MB',0,1),
(UUID(),'Valve Selection Guide','Engineering guide for selecting the right Vortex valve for your service.','/assets/files/valve-selection-guide.pdf','PDF','Valves','1.4 MB',0,1),
(UUID(),'Pump Selection Guide','Engineering guide for Vortex centrifugal and positive-displacement pumps.','/assets/files/pump-selection-guide.pdf','PDF','Pumps','1.8 MB',0,1),
(UUID(),'Heat Exchanger Sizing Worksheet','Excel worksheet to size plate or shell-and-tube exchangers.','/assets/files/hx-sizing.xlsx','XLSX','Heat Exchangers','85 KB',0,1);

-- ----- Blog posts (2 sample) -----
-- Only inserted when at least one author account exists. install/install.php
-- creates the admin BEFORE running this file; in the manual phpMyAdmin flow
-- (install.sql + seed.sql with no users yet) these are simply skipped.
INSERT INTO `blog_posts` (`id`,`title`,`slug`,`excerpt`,`content`,`authorId`,`category`,`tags`,`status`,`publishedAt`,`views`,`metaTitle`)
SELECT UUID(),
 'Choosing the right ball valve for your process',
 'choosing-the-right-ball-valve',
 'A practical guide to selecting full-port vs reduced-port, fire-safe vs standard, and floating vs trunnion.',
 '<p>Ball valves are the workhorse of industrial fluid handling. Choosing the right one is about understanding your service, not just line size. In this guide we walk through the three most important decisions...</p><p><strong>Full-port vs reduced-port:</strong> Full-port valves have an unobstructed bore equal to the pipe ID. They minimise pressure drop and are required for pigging...</p>',
 (SELECT `id` FROM `users` ORDER BY `createdAt` LIMIT 1),
 'Engineering',
 JSON_ARRAY('valves','selection','engineering'),
 'PUBLISHED',
 '2026-06-15 09:00:00',
 412,
 'Choosing the right ball valve - Vortex Precision'
WHERE EXISTS (SELECT 1 FROM `users`)
UNION ALL SELECT UUID(),
 'Understanding ASME Section VIII pressure vessel design',
 'understanding-asme-section-viii',
 'A non-lawyer introduction to the U-stamp code, mandatory appendices, and how to read a Manufacturer''s Data Report.',
 '<p>ASME Section VIII governs the design and manufacture of unfired pressure vessels in the United States and much of the world. Whether you are specifying a storage tank or a custom reactor, the code is large but approachable...</p>',
 (SELECT `id` FROM `users` ORDER BY `createdAt` LIMIT 1),
 'Engineering',
 JSON_ARRAY('pressure-vessels','asme','engineering'),
 'PUBLISHED',
 '2026-04-22 09:00:00',
 289,
 'Understanding ASME Section VIII - Vortex Precision'
WHERE EXISTS (SELECT 1 FROM `users`);

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
(UUID(),'ADMIN','media',JSON_ARRAY('manage','read','create','delete')),
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
 NULL,NULL,NULL,NULL,NULL,NULL,'{"limit":24}',30,1,0),

(UUID(),'home','products','Featured products',
 'Featured products','Our most-requested, in-stock equipment.',NULL,NULL,'View all','products',NULL,NULL,
 '{"limit":8}',40,1,0),

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

-- =============================================================================
-- AJR NDT product range (same as database/migrations/010)
-- =============================================================================
-- =============================================================================
-- AJR NDT PRODUCTS SEED SCRIPT
-- Imports all 13 Categories, 93 Products, Images & Specifications
-- Compatible with Vortex Precision IT schema (MySQL 5.7+ / 8.0+ / MariaDB 10.3+)
-- =============================================================================
SET FOREIGN_KEY_CHECKS=0;

-- 1. INSERT CATEGORIES
INSERT INTO `categories` (`id`,`name`,`slug`,`description`,`icon`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`) VALUES
('c0010001-0000-4000-8000-000000000001', 'Ultrasonic Flaw Detection', 'ultrasonic-flaw-detection', 'High-resolution digital ultrasonic testing (UT) equipment designed for locating, evaluating, and diagnosing internal cracks, inclusions, and discontinuities in welds, forgings, and composite structures.', 'activity', 10, 1, 'Ultrasonic Flaw Detectors | AJR NDT', 'Explore AJR NDT advanced digital ultrasonic flaw detectors including AFD100, AFD800, AFD856, and AFD860.'),
('c0010001-0000-4000-8000-000000000002', 'Thickness & Coating Gauges', 'thickness-coating-gauges', 'Digital ultrasonic thickness gauges and coating thickness meters for wall thinning, corrosion monitoring, and dry film thickness (DFT) measurement on ferrous and non-ferrous substrates.', 'layers', 20, 1, 'Thickness Gauges & Coating Thickness Meters | AJR NDT', 'High-precision ultrasonic thickness gauges and Bluetooth coating thickness testers for industrial QA/QC.'),
('c0010001-0000-4000-8000-000000000003', 'Hardness Testers', 'hardness-testing', 'Portable Leeb rebound hardness testers and Ultrasonic Contact Impedance (UCI) testers for rapid hardness inspection of heavy machinery, heat-treated parts, and weld heat-affected zones.', 'shield', 30, 1, 'Portable Leeb & UCI Hardness Testers | AJR NDT', 'Industrial portable hardness testers including AJH300, AJH410, AJH580, AJH720, and AUH-III UCI tester.'),
('c0010001-0000-4000-8000-000000000004', 'Surface Roughness & Profile Testers', 'surface-roughness-testing', 'Handheld surface roughness testers and digital surface profile gauges for blast-cleaned steel and machined surfaces compliant with ISO and ASTM standards.', 'sliders', 40, 1, 'Surface Roughness & Profile Gauges | AJR NDT', 'Measure Ra, Rz, Rq, Rt and blasted peak-to-valley profile heights with ART380, ART300, ART100, and ART90.'),
('c0010001-0000-4000-8000-000000000005', 'Magnetic Particle Inspection', 'magnetic-particle-inspection', 'Electromagnetic AC/DC yokes, permanent magnet yokes, and magnetic charging coils for detecting surface and near-surface cracks in ferromagnetic welds, forgings, and castings.', 'compass', 50, 1, 'Magnetic Particle Inspection Equipment | AJR NDT', 'Reliable AC/DC magnetic yokes, battery-powered MT flaw detectors, and coils for magnetic particle testing.'),
('c0010001-0000-4000-8000-000000000006', 'Radiography Testing & Pipeline Crawlers', 'radiography-testing', 'Industrial directional/panoramic X-ray flaw detectors, motorized pipeline crawlers (5100-5500 series), and high-luminance LED film viewers with integrated digital densitometers.', 'camera', 60, 1, 'Radiography Testing & Pipeline Crawlers | AJR NDT', 'Industrial X-ray systems, pipeline internal weld crawlers, and high-brightness LED radiograph viewers.'),
('c0010001-0000-4000-8000-000000000007', 'Eddy Current Testing', 'eddy-current-testing', 'Multi-frequency eddy current flaw detectors and electrical conductivity meters for flaw detection, alloy sorting, and heat treatment verification without stripping paint.', 'cpu', 70, 1, 'Eddy Current Flaw Detectors & Conductivity Meters | AJR NDT', 'AEC640, AEC620 eddy current flaw detectors and AEC670, AEC660 conductivity meters (% IACS).'),
('c0010001-0000-4000-8000-000000000008', 'Visual Inspection & Videoscopes', 'visual-inspection-videoscopes', 'High-definition articulating industrial videoscopes, borescopes, and long-reach push-rod pipeline inspection camera systems for remote visual inspection (RVI).', 'eye', 80, 1, 'Industrial Videoscopes & Borescopes | AJR NDT', 'Remote visual inspection systems including AJR 90 pipeline cameras and 50039/50060 articulating endoscopes.'),
('c0010001-0000-4000-8000-000000000009', 'NDT UV LED Lamps & Black Lights', 'ndt-uv-lamps', 'High-intensity 365 nm UV-A LED blacklights, handheld torches, helmet-mounted lamps, and overhead stationary flood lights for fluorescent penetrant (FPI) and magnetic particle (MPI) testing.', 'sun', 90, 1, 'NDT UV LED Black Lights & Lamps | AJR NDT', 'High-output 365nm UV LED inspection lamps compliant with ASTM E3022 and Rolls-Royce RRES 90061.'),
('c0010001-0000-4000-8000-000000000010', 'Holiday Detectors & Wire Rope Testers', 'holiday-wire-rope-testing', 'High-voltage spark testers and low-voltage wet sponge holiday detectors for tank and pipeline lining flaw inspection, alongside electromagnetic wire rope testers.', 'zap', 100, 1, 'Holiday Detectors & Wire Rope Testers | AJR NDT', 'AHD810, AHD820, AHD860 holiday detectors and ART-11S electromagnetic wire rope flaw tester.'),
('c0010001-0000-4000-8000-000000000011', 'Photometers & Radiometers', 'photometers-radiometers', 'Digital visible lux meters and UV-A radiometers designed for verifying ambient illumination and black light intensity in NDT inspection booths per ASTM and ISO standards.', 'sun', 110, 1, 'Digital Lux Meters & UV-A Radiometers | AJR NDT', 'LX1010B, LX1020BS, LX1330B lux meters and UVA365 UV-A radiometer for NDT quality standards.'),
('c0010001-0000-4000-8000-000000000012', 'Calibration Blocks & Reference Standards', 'calibration-blocks', 'Precision-machined standard ultrasonic calibration blocks including IIW Type 1 (V1), V2, ASME, AWS DS, DSC, SC, RC, DC, PAUT, and step wedges in certified carbon steel, stainless steel, and aluminum.', 'box', 120, 1, 'Ultrasonic Calibration Blocks & Standards | AJR NDT', 'Comprehensive calibration test blocks compliant with EN ISO 2400, ASTM E164, and ASME Section V.'),
('c0010001-0000-4000-8000-000000000013', 'Ultrasonic Probes, Transducers & Cables', 'ultrasonic-probes-cables', 'Straight beam longitudinal wave probes, angle beam shear wave probes, dual element TR probes, low-profile snail probes with contoured wedges, and RF coaxial cables (BNC/LEMO).', 'link', 130, 1, 'Ultrasonic Transducers, Probes & Cables | AJR NDT', 'Industrial ultrasonic testing probes, wedges, and low-noise LEMO/BNC cables for flaw detection.')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`), `icon`=VALUES(`icon`);

-- 2. INSERT PRODUCTS
INSERT INTO `products` (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`material`,`dimensions`,`weight`,`certifications`,`availability`,`featured`,`isActive`,`views`,`metaTitle`) VALUES
('p0010001-0000-4000-8000-000000000001', 'AFD100 UT Flaw Detector', 'afd100-ut-flaw-detector', 'AJR-AFD-100', 'The AFD100 is AJR\'s flagship digital ultrasonic flaw detector for non-destructive testing (NDT). It offers a 0-6000 mm measuring range in steel, automated calibration of velocity/zero point/probe angle, 500 channel setups, 500 A-scan waveform memories, video capture to USB, and automated report export to Excel. Meets AWS D1.1 structural welding standards and EN 12668-1.', 'Flagship digital portable ultrasonic flaw detector with DAC/AVG/TCG, AWS D1.1, and 12-hour Li-ion battery.', 'c0010001-0000-4000-8000-000000000001', 'High-impact polymer & aluminum', 'N/A', '1.0 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AFD100 UT Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000002', 'AFD800 Portable Flaw Detector', 'afd800-portable-flaw-detector', 'AJR-AFD-800', 'The AFD800 Portable Ultrasonic Flaw Detector delivers high pulse repetition rates, vivid sunlight-readable display, and robust flaw gating for field inspectors evaluating structural welds, forgings, and piping.', 'Compact field digital UT flaw detector for rapid on-site weld and crack evaluation.', 'c0010001-0000-4000-8000-000000000001', 'Rugged industrial casing', 'N/A', '1.1 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AFD800 Portable Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000003', 'AFD856 Multi Channel Ultrasonic Flaw Detector', 'afd856-multi-channel-ultrasonic-flaw-detector', 'AJR-AFD-856', 'The AFD856 is a rack/bench multi-channel ultrasonic flaw detector designed for integration into semi-automated and automated inspection systems. It provides synchronized multi-probe excitation, individual channel gating, and high-speed data acquisition.', 'Multi-channel UT flaw detector engineered for automated inline pipe, rail, and plate testing.', 'c0010001-0000-4000-8000-000000000001', 'Industrial rack chassis', 'N/A', '3.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AFD856 Multi Channel Ultrasonic Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000004', 'AFD860 NDT Flaw Detector', 'afd860-ndt-flaw-detector', 'AJR-AFD-860', 'The AFD860 features advanced narrow-band analog and digital filtering, high signal-to-noise ratio, and extended 0-10000 mm range, making it ideal for large castings, austenitic stainless steel welds, and coarse-grained materials.', 'High-dynamic-range ultrasonic flaw detector with narrow-band filtering for heavy industrial inspection.', 'c0010001-0000-4000-8000-000000000001', 'Cast aluminum / impact rubber', 'N/A', '1.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AFD860 NDT Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000005', 'ATG140 UT Thickness Gauge', 'atg140-ut-thickness-gauge', 'AJR-ATG-140', 'The ATG140 Ultrasonic Thickness Gauge is an easy-to-use precision instrument for assessing remaining wall thickness of pipelines, tanks, boiler tubes, and pressure vessels subjected to corrosion and erosion.', 'Digital ultrasonic wall thickness gauge with multi-material velocity library.', 'c0010001-0000-4000-8000-000000000002', 'ABS housing', 'N/A', '250 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'ATG140 UT Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000006', 'ATG400 Ultrasonic Through Coating Thickness Gauge', 'atg400-ultrasonic-through-coating-thickness-gauge', 'AJR-ATG-400', 'The ATG400 features Echo-Echo (E-E) through-coating measurement capability, eliminating the need to scrape or destroy paint and protective coatings to determine underlying substrate wall thickness.', 'Echo-to-echo ultrasonic thickness gauge measuring base metal through paint and protective coatings.', 'c0010001-0000-4000-8000-000000000002', 'Industrial polymer', 'N/A', '280 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'ATG400 Ultrasonic Through Coating Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000007', 'Scan-I A Scan Handheld Thickness Gauge', 'scan-i-a-scan-handheld-thickness-gauge', 'AJR-SCN-01', 'Scan-I combines precision ultrasonic thickness gauging with real-time RF / A-scan waveform verification, allowing the operator to view ultrasonic echoes and place measuring gates precisely to eliminate false readings in complex materials.', 'Precision thickness gauge featuring live A-Scan waveform display for acoustic verification.', 'c0010001-0000-4000-8000-000000000002', 'Ruggedized ABS with rubber protective case', 'N/A', '340 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Scan-I A Scan Handheld Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000008', 'Scan-II Thickness Gauge', 'scan-ii-ut-thickness-gauge', 'AJR-SCN-02', 'The Scan-II provides high-resolution ultrasonic thickness measurements with differential mode, high/low limit acoustic alarms, and probe zero automatic calibration.', 'High-accuracy ultrasonic thickness gauge with high/low alarms and differential mode.', 'c0010001-0000-4000-8000-000000000002', 'ABS casing', 'N/A', '260 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Scan-II Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000009', 'ACT2300 Bluetooth Coating Thickness Gauge', 'act2300-coating-thickness-gauge-765119', 'AJR-ACT-2300', 'The ACT2300 features integrated Bluetooth connectivity for instantaneous wireless data transfer to iOS, Android, and Windows devices. Utilizes dual magnetic induction (F) and eddy current (NF) principles for ferrous and non-ferrous substrates.', 'Bluetooth-enabled dual F/NF coating thickness gauge for paint, galvanizing, and anodizing.', 'c0010001-0000-4000-8000-000000000002', 'Polycarbonate housing with ruby probe tip', 'N/A', '120 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'ACT2300 Bluetooth Coating Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000010', 'ACT2200 Digital Coating Thickness Gauge', 'act2200-digital-coating-thickness-gauge', 'AJR-ACT-2200', 'The ACT2200 Digital Coating Thickness Gauge accurately measures non-magnetic coatings on ferromagnetic substrates and non-conductive coatings on non-ferrous metals, ideal for automotive reconditioning and powder coating QA.', 'Handheld dual ferrous / non-ferrous dry film thickness (DFT) paint gauge.', 'c0010001-0000-4000-8000-000000000002', 'ABS casing', 'N/A', '110 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'ACT2200 Digital Coating Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000011', 'ACT4000 Paint Thickness Gauge', 'act4000-paint-thickness-gauge', 'AJR-ACT-4000', 'The ACT4000 is built for heavy-duty industrial coatings, asphalt coatings, epoxy linings, and fireproofing materials with an extended thickness capability up to 5000 um.', 'Heavy-duty coating thickness gauge with extended measuring range up to 5000 um.', 'c0010001-0000-4000-8000-000000000002', 'Reinforced ABS casing', 'N/A', '220 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'ACT4000 Paint Thickness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000012', 'AJH300 Portable Hardness Tester', 'ajh300-portable-hardness-tester', 'AJR-AJH-300', 'The AJH300 is a versatile Leeb rebound hardness tester equipped with a Type D impact device for testing dies, pressure vessels, bearings, and heavy structural forgings on-site.', 'Standard Leeb rebound hardness tester with multi-scale conversion (HL, HRC, HRB, HB, HV, HS).', 'c0010001-0000-4000-8000-000000000003', 'Durable polymer casing', 'N/A', '310 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJH300 Portable Hardness Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000013', 'AJH410 Metal Hardness Tester', 'ajh410-metal-hardness-tester', 'AJR-AJH-410', 'The AJH410 provides broad material presets (steel, cast steel, alloy tool steel, gray cast iron, aluminum alloys, brass, copper) with automatic test direction compensation.', 'High-precision digital metal hardness tester with wide material selection and USB data transfer.', 'c0010001-0000-4000-8000-000000000003', 'Industrial composite shell', 'N/A', '330 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJH410 Metal Hardness Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000014', 'AJH580 Leeb Hardness Tester with Mini Printer', 'ajh580-leeb-hardness-tester-with-mini-printer', 'AJR-AJH-580', 'The AJH580 includes an onboard thermal printer allowing inspectors to generate immediate physical test certificates on the shop floor or in remote field locations.', 'Portable Leeb hardness tester with integrated high-speed thermal mini-printer for instant field documentation.', 'c0010001-0000-4000-8000-000000000003', 'Rugged ABS housing', 'N/A', '420 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJH580 Leeb Hardness Tester with Mini Printer | AJR NDT'),
('p0010001-0000-4000-8000-000000000015', 'AJH720 Pen Hardness Tester', 'ajh720-pen-hardness-tester', 'AJR-AJH-720', 'The AJH720 integrates the impact device and electronics into a single ultra-compact pen form factor. Features an OLED display, USB charging, and automatic impact direction sensor.', 'All-in-one pocket pen-type Leeb hardness tester with vivid OLED screen.', 'c0010001-0000-4000-8000-000000000003', 'Anodized aluminum alloy body', 'N/A', '110 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJH720 Pen Hardness Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000016', 'AUH-III UCI Hardness Tester', 'auh-iii-uci-hardness-tester', 'AJR-AUH-3', 'The AUH-III employs Ultrasonic Contact Impedance (UCI) methodology with a Vickers diamond indenter, enabling accurate non-destructive hardness testing on thin sheets, case-hardened teeth, chrome plating, and heat-affected zones where rebound testing is unsuitable.', 'Ultrasonic Contact Impedance (UCI) hardness tester for thin-walled parts, coatings, and weld HAZ.', 'c0010001-0000-4000-8000-000000000003', 'Precision machined probe with polymer console', 'N/A', '450 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AUH-III UCI Hardness Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000017', 'ART380 Roughness Tester', 'art380-roughness-tester', 'AJR-ART-380', 'The ART380 is a sophisticated surface finish gauge measuring Ra, Rz, Rq, Rt, Rp, Rv, R3z, Rmax, and Rpc. Features DSP high-speed processing, color OLED profile curve graphing, and Bluetooth PC communication.', 'Advanced surface roughness tester measuring 22 parameters with graphic profile display.', 'c0010001-0000-4000-8000-000000000004', 'Aluminum alloy body with titanium stylus arm', 'N/A', '360 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'ART380 Roughness Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000018', 'ART300 Surface Roughness Gauge', 'art300-surface-roughness-gauge', 'AJR-ART-300', 'The ART300 Surface Roughness Gauge provides rapid and accurate roughness evaluation for machine shops and manufacturing inspection lines.', 'Shop-floor surface roughness tester measuring Ra and Rz with high repeat accuracy.', 'c0010001-0000-4000-8000-000000000004', 'Durable industrial polymer', 'N/A', '280 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'ART300 Surface Roughness Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000019', 'ART100 Digital Profile Gauge', 'art100-digital-profile-gauge', 'AJR-ART-100', 'The ART100 Digital Surface Profile Gauge measures the peak-to-valley height of blast-cleaned steel surfaces prior to coating application per ASTM D4417 Method B.', 'Handheld peak-to-valley surface profile gauge for blast-cleaned steel substrates.', 'c0010001-0000-4000-8000-000000000004', 'Hardened aluminum base', 'N/A', '160 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'ART100 Digital Profile Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000020', 'ART90 Surface Profile Gauge', 'art90-surface-profile-gauge', 'AJR-ART-90', 'The ART90 is an ultra-compact electronic surface profile tester designed for paint and coating inspectors to quickly verify anchor profiles on grit-blasted or shot-blasted surfaces.', 'Compact needle-depth surface profile tester for abrasive blast profiling.', 'c0010001-0000-4000-8000-000000000004', 'Anodized metal housing', 'N/A', '140 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'ART90 Surface Profile Gauge | AJR NDT'),
('p0010001-0000-4000-8000-000000000021', 'AJE220B MT Flaw Detector', 'aje220b-mt-flaw-detector', 'AJR-AJE-220B', 'The AJE220B is a portable magnetic particle testing yoke featuring double-jointed articulating legs that conform to fillets, butt welds, curved pipes, and uneven surfaces.', 'Portable electromagnetic yoke with articulating double-jointed legs for complex weld geometries.', 'c0010001-0000-4000-8000-000000000005', 'Reinforced glass-filled nylon housing with polyurethane encapsulation', 'N/A', '3.1 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJE220B MT Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000022', 'AJE220B AC DC Magnetic Yoke Tester', 'aje220b-ac-dc-magnetic-yoke-tester', 'AJR-AJE-220B-ACDC', 'The AJE220B AC/DC offers switchable AC and pulsed DC magnetization modes. The AC mode provides skin-effect concentration for sharp surface crack indications, while DC penetration reveals sub-surface inclusions.', 'Dual-mode AC/DC electromagnetic yoke for surface and subsurface flaw detection.', 'c0010001-0000-4000-8000-000000000005', 'Molded polymer case with ergonomic handle', 'N/A', '3.3 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE220B AC DC Magnetic Yoke Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000023', 'AJE230 Permanent Yoke Tester', 'aje230-permanent-yoke-tester', 'AJR-AJE-230-PERM', 'The AJE230 Permanent Magnet Yoke contains powerful rare-earth permanent magnets, making it completely intrinsically safe for explosive atmospheres (ATEX Zone 0/1), offshore platforms, and remote underwater applications without electrical hazard.', 'Intrinsically safe permanent magnet yoke requiring no electricity or batteries.', 'c0010001-0000-4000-8000-000000000005', 'Non-sparking alloy and stainless steel', 'N/A', '2.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE230 Permanent Yoke Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000024', 'AJE220 AC DC MT Flaw Detector', 'aje220-ac-dc-mt-flaw-detector', 'AJR-AJE-220-ACDC', 'The AJE220 AC/DC Magnetic Particle Flaw Detector is a workhorse unit for fabrication yards, structural steel erection, and petrochemical turnaround inspections.', 'Heavy-duty electromagnetic AC/DC yoke with high-duty cycle.', 'c0010001-0000-4000-8000-000000000005', 'High-durability sealed casing', 'N/A', '3.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE220 AC DC MT Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000025', 'AJE220 Magnetic Particle Inspection Tester (with UV Light)', 'aje220-magnetic-flaw-detector', 'AJR-AJE-220-UV', 'Features an integrated high-intensity 365 nm UV-A LED source centered between the poles, illuminating the testing zone for fluorescent wet magnetic particle inspections without needing a separate handheld blacklight.', 'Electromagnetic yoke with built-in UV-A 365 nm LED light for fluorescent magnetic particle inspection.', 'c0010001-0000-4000-8000-000000000005', 'Sealed industrial polymer', 'N/A', '3.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE220 Magnetic Particle Inspection Tester (with UV Light) | AJR NDT'),
('p0010001-0000-4000-8000-000000000026', 'AJE220 AC Yoke Tester with White Light', 'aje220-ac-yoke-tester', 'AJR-AJE-220-WHT', 'Equipped with a built-in bright white LED beam to illuminate weld seams in dark vessels, boilers, and shadowed shop corners during visible dry/wet magnetic particle testing.', 'Electromagnetic AC yoke with built-in high-lumen white LED for dark inspection spaces.', 'c0010001-0000-4000-8000-000000000005', 'Rugged encapsulated body', 'N/A', '3.1 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE220 AC Yoke Tester with White Light | AJR NDT'),
('p0010001-0000-4000-8000-000000000027', 'AJE220 Mt Yoke Tester', 'aje220-mt-yoke-tester', 'AJR-AJE-220-STD', 'Standard industrial AC magnetic particle inspection yoke compliant with all major international boiler, vessel, and structural fabrication codes.', 'Standard AC electromagnetic flaw detector yoke for routine MPI weld checks.', 'c0010001-0000-4000-8000-000000000005', 'Impact-resistant resin housing', 'N/A', '3.0 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE220 Mt Yoke Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000028', 'AJE110 Magnetic Flaw Detector', 'aje110-magnetic-flaw-detector', 'AJR-AJE-110', 'Compact, lightweight ergonomic yoke designed to minimize inspector fatigue during overhead piping inspection and extended structural testing shifts.', 'Lightweight ergonomic AC magnetic yoke for fatigue-free overhead inspection.', 'c0010001-0000-4000-8000-000000000005', 'Lightweight nylon casing', 'N/A', '2.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJE110 Magnetic Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000029', 'AMT Magnetic Charging Coil', 'amt-magnetic-charging-coil', 'AJR-AMT-COIL', 'The AMT Magnetic Charging Coil induces high longitudinal magnetic fields in cylindrical parts, pipes, shafts, and bolts to detect transverse surface cracks.', 'High-flux longitudinal magnetization coil for shafts, bars, and tubular components.', 'c0010001-0000-4000-8000-000000000005', 'Epoxy molded heavy copper windings', 'N/A', '6.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AMT Magnetic Charging Coil | AJR NDT'),
('p0010001-0000-4000-8000-000000000030', 'AJR NDT 120-300KV X Ray Flaw Detector', 'ajr-ndt-x-ray-flaw-detector', 'AJR-XR-300KV', 'The AJR 120-300KV industrial X-ray generator features SF6 gas insulation, ceramic tube construction, micro-computer controller, and superior penetration capacity up to 50 mm in steel.', 'High-output directional industrial X-ray generator (120-300 kV) for heavy weld radiography.', 'c0010001-0000-4000-8000-000000000006', 'SF6 gas insulated metal tube head with digital controller', 'N/A', '32 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR NDT 120-300KV X Ray Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000031', 'AJR NDT: Portable X Ray Flaw Detector', 'ajr-ndt-portable-x-ray-flaw-detector', 'AJR-XR-PORTABLE', 'Engineered for on-site field radiography of pipeline welds, pressure vessels, and aerospace assemblies. Features automated warm-up and fault diagnostic protection.', 'Portable 160-250 kV industrial X-ray flaw detector with lightweight generator head.', 'c0010001-0000-4000-8000-000000000006', 'Aviation aluminum casing', 'N/A', '24 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT: Portable X Ray Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000032', 'AJR NDT: RT X Ray Flaw Detector', 'ajr-ndt-rt-x-ray-flaw-detector', 'AJR-XR-RT-PANORAMIC', 'Features a 360-degree panoramic beam tube head allowing inspectors to radiograph an entire circumferential pipe weld in a single exposure, drastically reducing inspection time on pipeline projects.', 'Panoramic 360-degree X-ray flaw detector for one-shot circumferential pipe weld inspection.', 'c0010001-0000-4000-8000-000000000006', 'Industrial radiation-shielded tube housing', 'N/A', '33 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT: RT X Ray Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000033', 'AJR NDT 5100 X Ray Crawler', 'ajr-ndt-5100-x-ray-crawler', 'AJR-CRW-5100', 'The AJR NDT 5100 is an autonomous battery-powered crawler designed for internal circumferential weld radiography inside small-diameter transmission pipelines.', 'Internal pipeline radiography crawler for small-diameter pipelines (200 - 450 mm).', 'c0010001-0000-4000-8000-000000000006', 'High-strength stainless steel and aluminum alloy chassis', 'N/A', '55 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR NDT 5100 X Ray Crawler | AJR NDT'),
('p0010001-0000-4000-8000-000000000034', 'AJR NDT 5200 RT Pipeline Crawler', 'ajr-ndt-5200-rt-pipeline-crawler', 'AJR-CRW-5200', 'Designed for oil and natural gas pipeline construction, the 5200 series integrates safety fail-safes including reverse on loss of signal, water detection, and low battery auto-return.', 'Medium-diameter pipeline X-ray inspection crawler (400 - 800 mm).', 'c0010001-0000-4000-8000-000000000006', 'Modular alloy frame with polyurethane wheels', 'N/A', '75 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT 5200 RT Pipeline Crawler | AJR NDT'),
('p0010001-0000-4000-8000-000000000035', 'AJR NDT 5300 RT Crawler', 'ajr-ndt-5300-rt-crawler', 'AJR-CRW-5300', 'Built for rigorous cross-country transmission pipelines in desert, arctic, and mountainous terrains with high climbing capacity up to 40 degrees slope.', 'Heavy-duty pipeline crawler for 600 - 1200 mm cross-country pipelines.', 'c0010001-0000-4000-8000-000000000006', 'Heavy duty reinforced steel-aluminum chassis', 'N/A', '95 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT 5300 RT Crawler | AJR NDT'),
('p0010001-0000-4000-8000-000000000036', 'AJR NDT 5400 Series X-ray Pipeline Crawler', 'ajr-ndt-5400-pipeline-crawler', 'AJR-CRW-5400', 'The 5400 series handles heavy 300-350 kV panoramic tubeheads for thick-walled transmission gas pipelines with extended runtime batteries.', 'Large-diameter cross-country pipeline radiography crawler (800 - 1400 mm).', 'c0010001-0000-4000-8000-000000000006', 'Corrosion-resistant treated alloy structure', 'N/A', '115 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT 5400 Series X-ray Pipeline Crawler | AJR NDT'),
('p0010001-0000-4000-8000-000000000037', 'AJR NDT 5500 X Ray Pipeline Crawler', 'ajr-ndt-5500-x-ray-pipeline-crawler', 'AJR-CRW-5500', 'AJR\'s largest crawler system engineered for major trunklines and offshore spoolbases, accommodating ultra-high penetration panoramic X-ray systems.', 'Extra-large pipeline crawler system (1000 - 1600 mm) with intelligent electronic control.', 'c0010001-0000-4000-8000-000000000006', 'Stainless steel & structural aircraft alloy', 'N/A', '135 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT 5500 X Ray Pipeline Crawler | AJR NDT'),
('p0010001-0000-4000-8000-000000000038', 'AFV2131D Industrial X-Ray Film Viewer with Densitometer', 'afv2131d-led-industrial-x-ray-film-viewer-combine-with-densitometer', 'AJR-AFV-2131D', 'The AFV2131D integrates an ultra-bright uniform LED backlight (up to 130,000 cd/m2) and an optical transmission densitometer (measuring optical density D 0.00 - 5.00) in one sleek chassis.', 'High-luminance LED radiograph viewer with built-in calibrated transmission densitometer.', 'c0010001-0000-4000-8000-000000000006', 'Anodized aluminum alloy housing', 'N/A', '3.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AFV2131D Industrial X-Ray Film Viewer with Densitometer | AJR NDT'),
('p0010001-0000-4000-8000-000000000039', 'AFV2126D Film Viewer with Densitometer', 'afv2126d-film-viewer-with-densitometer', 'AJR-AFV-2126D', 'Compact footprint model for darkrooms and mobile inspection vans, offering calibrated film density reading and foot-switch illumination control.', 'Compact LED industrial film illuminator with integrated black-and-white densitometer.', 'c0010001-0000-4000-8000-000000000006', 'Aluminum alloy frame', 'N/A', '3.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AFV2126D Film Viewer with Densitometer | AJR NDT'),
('p0010001-0000-4000-8000-000000000040', 'AFV2131 LED Film Viewer', 'afv2131-led-film-viewer', 'AJR-AFV-2131', 'Features premium surface-mount LEDs providing exceptional uniformity (g >= 0.95), low surface heat, and stepless dimming for reviewing high-density industrial radiographs.', 'High-luminance uniform LED radiograph viewer with continuous dimmer and foot pedal.', 'c0010001-0000-4000-8000-000000000006', 'Extruded aluminum casing', 'N/A', '3.4 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AFV2131 LED Film Viewer | AJR NDT'),
('p0010001-0000-4000-8000-000000000041', 'AFV2128 Film Viewer', 'afv2128-film-viewer', 'AJR-AFV-2128', 'Ultra-thin portable LED film viewer designed for field inspection trucks and darkrooms.', 'Slimline LED film viewer for evaluating industrial radiographs up to 4.0D.', 'c0010001-0000-4000-8000-000000000006', 'Anodized aluminum', 'N/A', '2.9 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AFV2128 Film Viewer | AJR NDT'),
('p0010001-0000-4000-8000-000000000042', 'AFV2126 Industrial Film Viewer', 'afv2126-industrial-film-viewer', 'AJR-AFV-2126', 'Economical, rugged industrial LED film viewer providing high brightness and cold light operation for weld quality interpretation.', 'Standard compact LED radiograph illuminator for weld radiographs.', 'c0010001-0000-4000-8000-000000000006', 'Aluminum alloy', 'N/A', '2.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AFV2126 Industrial Film Viewer | AJR NDT'),
('p0010001-0000-4000-8000-000000000043', 'AJR NDT AEC640 Eddy Current Flaw Detector', 'ajr-ndt-aec640-eddy-current-flaw-detector', 'AJR-AEC-640', 'The AEC640 is a high-performance portable eddy current flaw detector covering 10 Hz to 10 MHz. Offers impedance plane display, sweep display, multi-frequency mixing to cancel support plate signals, and high sensitivity for surface cracks through non-conductive coatings.', 'Multi-frequency digital eddy current flaw detector for surface cracks and heat exchanger tubing.', 'c0010001-0000-4000-8000-000000000007', 'Rugged industrial casing', 'N/A', '1.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR NDT AEC640 Eddy Current Flaw Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000044', 'AEC620 Eddy Current Tester', 'aec620-eddy-current-tester', 'AJR-AEC-620', 'The AEC620 provides dual-frequency inspection with automated balancing, variable alarm gates, and high signal-to-noise ratio for fastener hole and surface weld inspection.', 'Handheld dual-frequency eddy current crack detector for aerospace and structural welds.', 'c0010001-0000-4000-8000-000000000007', 'Impact-resistant polymer enclosure', 'N/A', '1.3 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AEC620 Eddy Current Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000045', 'AJR NDT AEC670 Eddy Current Electrical Conductivity Meter', 'ajr-ndt-aec670-eddy-current-electrical-conductivity-meter', 'AJR-AEC-670', 'The AEC670 measures electrical conductivity of non-ferrous metals per ASTM E1004. Used for aluminum alloy heat treatment verification, precipitation hardening checks, and electrical conductor sorting.', 'Precision digital eddy current conductivity meter (% IACS / MS/m) for alloy verification.', 'c0010001-0000-4000-8000-000000000007', 'Ergonomic handheld casing with certified calibration blocks', 'N/A', '420 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR NDT AEC670 Eddy Current Electrical Conductivity Meter | AJR NDT'),
('p0010001-0000-4000-8000-000000000046', 'AEC660 Eddy Current Conductivity Tester', 'aec660-eddy-current-conductivity-tester', 'AJR-AEC-660', 'The AEC660 provides rapid metal sorting and heat treatment verification with automatic temperature compensation to 20 deg C.', 'Handheld eddy current conductivity meter with automatic temperature compensation.', 'c0010001-0000-4000-8000-000000000007', 'ABS casing', 'N/A', '390 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AEC660 Eddy Current Conductivity Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000047', 'AJR 90 Pipeline Videoscope', 'ajr-90-pipeline-videoscope', 'AJR-VID-90', 'The AJR 90 is an industrial push-rod pipe inspection camera system featuring a 360-degree pan / 180-degree tilt camera head, 50-meter fiberglass push cable, on-screen digital distance meter counter, and high-resolution DVR recording.', 'Heavy-duty push-rod pipeline inspection camera with pan/tilt head and distance counter.', 'c0010001-0000-4000-8000-000000000008', 'Stainless steel camera head, rugged reel cart', 'N/A', '16 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR 90 Pipeline Videoscope | AJR NDT'),
('p0010001-0000-4000-8000-000000000048', '50039 / 50060 Portable Video Endoscopes', 'ajr-ndt-50039-50060-videoscope', 'AJR-VID-50039-60', 'The 50039 / 50060 series industrial videoscopes feature 360-degree mechanical or joystick 4-way articulation, 3.9mm or 6.0mm insertion tube diameters, tungsten braided armor, and high-definition image capture.', 'Articulating industrial videoscope with 3.9mm / 6.0mm HD probes for turbine and engine RVI.', 'c0010001-0000-4000-8000-000000000008', 'Magnesium alloy console with tungsten braided probe', 'N/A', '1.1 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, '50039 / 50060 Portable Video Endoscopes | AJR NDT'),
('p0010001-0000-4000-8000-000000000049', 'AJR90 Series Pipe Inspection Camera', 'pipe-videoscope', 'AJR-VID-90-SERIES', 'Comprehensive pipe inspection camera system with self-leveling optics, 512 Hz sonde transmitter for underground location, and keyboard text overlay for defect annotation.', 'Self-leveling drain and industrial pipe camera system with wireless keyboard logging.', 'c0010001-0000-4000-8000-000000000008', 'Sapphire glass lens, stainless steel housing', 'N/A', '14 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR90 Series Pipe Inspection Camera | AJR NDT'),
('p0010001-0000-4000-8000-000000000050', 'AJR UV LED 6000P+ UV LED Lamp', 'ndt-lamp-black-light', 'AJR-UV-6000P-PLUS', 'The AJR UV LED 6000P+ delivers high UV-A intensity with pure 365 nm wavelength and zero UV-B/C emission, engineered specifically for fluorescent penetrant (FPI) and fluorescent magnetic particle inspection (MPI).', 'High-intensity handheld 365 nm UV-A LED black light compliant with ASTM E3022.', 'c0010001-0000-4000-8000-000000000009', 'Anodized aviation aluminum with mechanical cooling fins', 'N/A', '720 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR UV LED 6000P+ UV LED Lamp | AJR NDT'),
('p0010001-0000-4000-8000-000000000051', 'AJR UV LED 4000+ / 6000+ / 8000+ / 10000+ NDT UV LED Lamp', 'ndt-uv-led-lamp', 'AJR-UV-SERIES-PLUS', 'A modular UV inspection lamp series offering tailored UV-A outputs to meet specific aerospace (ASTM E3022) or high-intensity foundry and casting inspection requirements.', 'Configurable intensity UV-A blacklight series (4,000 to 10,000 uW/cm2).', 'c0010001-0000-4000-8000-000000000009', 'Aerospace-grade 6061-T6 aluminum', 'N/A', '790 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR UV LED 4000+ / 6000+ / 8000+ / 10000+ NDT UV LED Lamp | AJR NDT'),
('p0010001-0000-4000-8000-000000000052', 'AJR UV LED4000 / 6000 / 8000 / 10000 Model NDT UV LED Lamp', 'ajr-uv-led4000-6000-8000-10000-model-ndt-uv-led-lamp', 'AJR-UV-MODULAR', 'Features integrated black light filters (Wood\'s glass) to eliminate visible light glare and maximize contrast of fluorescent indications in non-destructive testing.', 'Field-ready UV-A inspection lamp with Wood\'s glass optical filter.', 'c0010001-0000-4000-8000-000000000009', 'Thermal dissipation alloy housing', 'N/A', '680 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR UV LED4000 / 6000 / 8000 / 10000 Model NDT UV LED Lamp | AJR NDT'),
('p0010001-0000-4000-8000-000000000053', 'AJR NDT Stationary Flood UV A Lamp', 'ajr-ndt-stationary-flood-uv-a-lamp', 'AJR-UV-FLOOD-STAT', 'The Stationary Flood UV-A Lamp provides wide-area, uniform 365 nm irradiation over wet horizontal magnetic testing benches, penetrant rinse stations, and inspection booths.', 'Overhead high-coverage stationary UV-A flood lamp for MPI benches and wash stations.', 'c0010001-0000-4000-8000-000000000009', 'Heavy duty finned aluminum enclosure', 'N/A', '4.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT Stationary Flood UV A Lamp | AJR NDT'),
('p0010001-0000-4000-8000-000000000054', 'AJR NDT UV-H Helmet Type UV LED LAMP', 'ajr-ndt-uv-ndt-mt-pt', 'AJR-UV-HELMET-H', 'Hands-free UV-A inspection light engineered for inspectors operating on climbing harnesses, rope access, tanks, and confined spaces where both hands are required.', 'Hands-free helmet-mounted UV-A headlamp for rope access and confined space inspection.', 'c0010001-0000-4000-8000-000000000009', 'Impact-resistant polymer and aluminum head', 'N/A', '260 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT UV-H Helmet Type UV LED LAMP | AJR NDT'),
('p0010001-0000-4000-8000-000000000055', 'AJR UV-T UV LED Torch with Trigger', 'ajr-uv-t-uv-led-torch-with-trigger', 'AJR-UV-TORCH-T', 'Ergonomic pistol grip UV torch allowing rapid momentary trigger activation or continuous lock for aerospace and oil & gas weld inspection.', 'Pistol-grip UV-A inspection torch with momentary/continuous trigger switch.', 'c0010001-0000-4000-8000-000000000009', 'Ergonomic rubberized grip with aluminum bezel', 'N/A', '480 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR UV-T UV LED Torch with Trigger | AJR NDT'),
('p0010001-0000-4000-8000-000000000056', 'AJR UV Flashlight, Black Floor Lamp', 'ajr-uv-led-4000p-6000p-8000p-10000p-40000p-black-light', 'AJR-UV-FLASHLIGHT-MULTI', 'Versatile UV-A luminaire usable as a handheld heavy-duty flashlight or mounted on a floor tripod stand for hands-free component inspection.', 'Multi-mode high-power blacklight flashlight and floor stand fixture.', 'c0010001-0000-4000-8000-000000000009', 'Anodized heavy aluminum', 'N/A', '950 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR UV Flashlight, Black Floor Lamp | AJR NDT'),
('p0010001-0000-4000-8000-000000000057', 'ART-11S Steel Wire Rope Tester', 'art-11s-steel-wire-rope-tester', 'AJR-ART-11S', 'The ART-11S uses Magnetic Flux Leakage (MFL) principles to quantitatively test steel wire ropes for internal and external broken wires (LF) and loss of metallic cross-sectional area (LMA) in elevators, cranes, ropeways, and mine hoists.', 'Electromagnetic wire rope tester for detecting broken wires, corrosion, and wear in crane/mining cables.', 'c0010001-0000-4000-8000-000000000010', 'Modular split-clamp sensor head with rugged console', 'N/A', '5.5 kg (head)', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'ART-11S Steel Wire Rope Tester | AJR NDT'),
('p0010001-0000-4000-8000-000000000058', 'AHD810 Pinhole Holiday Detector', 'ahd810-pinhole-holiday-detector', 'AJR-AHD-810', 'The AHD810 is a low-voltage wet sponge holiday detector designed to find holidays, pinholes, and voids in non-conductive coatings applied to conductive metal substrates per ASTM G62.', 'Low-voltage wet sponge holiday detector for pinholes in coatings under 500 um.', 'c0010001-0000-4000-8000-000000000010', 'ABS casing with ground wire clamp', 'N/A', '420 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AHD810 Pinhole Holiday Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000059', 'AHD820 Spark Holiday Detector', 'ahd820-spark-holiday-detector', 'AJR-AHD-820', 'The AHD820 generates precise high-voltage test pulses to detect microscopic pinholes, porosity, and cracks in thick protective coatings such as fusion-bonded epoxy (FBE), coal tar enamel, rubber, and glass linings.', 'High-voltage pulse spark tester (0.5 - 35 kV) for tank and pipe protective linings.', 'c0010001-0000-4000-8000-000000000010', 'High-impact polyurethane carrying case', 'N/A', '2.2 kg (console)', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AHD820 Spark Holiday Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000060', 'AHD860 Porosity Holiday Detector', 'ahd860-porosity-holiday-detector', 'AJR-AHD-860', 'The AHD860 calculates the exact required test voltage based on coating thickness and standard formulas (NACE SP0188 / ASTM D5162), preventing coating burn-through while guaranteeing detection.', 'Intelligent digital DC high-voltage porosity detector with automatic voltage calculation.', 'c0010001-0000-4000-8000-000000000010', 'Ruggedized field console with safety ground interlock', 'N/A', '2.4 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AHD860 Porosity Holiday Detector | AJR NDT'),
('p0010001-0000-4000-8000-000000000061', 'AJR NDT: LX1010B Light Meter', 'ajr-ndt-light-meter', 'AJR-LX-1010B', 'Measures ambient visible white light levels in fluorescent penetrant and magnetic particle inspection booths to verify compliance with ASTM E1444 (<20 Lux ambient) and visible inspection (>1000 Lux).', 'Digital visible light illuminance meter for NDT inspection booth compliance.', 'c0010001-0000-4000-8000-000000000011', 'Compact ABS housing', 'N/A', '160 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT: LX1010B Light Meter | AJR NDT'),
('p0010001-0000-4000-8000-000000000062', 'AJR NDT: LX1020BS Digital Lux Meter', 'ajr-ndt-digital-lux-meter', 'AJR-LX-1020BS', 'Features a remote tethered photodiode sensor on a flexible coiled cable for measuring illuminance on awkwardly oriented weld surfaces and within dark inspection chambers.', 'Precision digital lux meter with coiled probe cord and wide 100,000 Lux range.', 'c0010001-0000-4000-8000-000000000011', 'ABS casing with protective holster', 'N/A', '210 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT: LX1020BS Digital Lux Meter | AJR NDT'),
('p0010001-0000-4000-8000-000000000063', 'AJR NDT: LX1330B Digital Lux Meter', 'ajr-ndt--lux-meter', 'AJR-LX-1330B', 'Professional grade illuminometer measuring in both Lux and Foot-Candles (fc) with peak value detection, relative mode, and cosine angular correction.', 'High-accuracy lux/foot-candle meter with 200,000 Lux range and peak value memory.', 'c0010001-0000-4000-8000-000000000011', 'Heavy duty casing', 'N/A', '250 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AJR NDT: LX1330B Digital Lux Meter | AJR NDT'),
('p0010001-0000-4000-8000-000000000064', 'AJR NDT: UVA365 UV A Radiometer / Light Meter', 'ajr-ndt-uva365-uv-a-radiometer-light-meter', 'AJR-UVA-365', 'The UVA365 is a specialized ultraviolet radiometer calibrated specifically for 365 nm UV-A black light inspection sources used in FPI and MPI per ISO 3059 and ASTM E3022.', 'Calibrated UV-A radiometer for measuring 365 nm black light intensity per ASTM E3022.', 'c0010001-0000-4000-8000-000000000011', 'Shielded sensor head with precision console', 'N/A', '320 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'AJR NDT: UVA365 UV A Radiometer / Light Meter | AJR NDT'),
('p0010001-0000-4000-8000-000000000065', 'IIW Type 1 (V1) UT Test Block', 'v1-ut-block', 'AJR-BLK-V1', 'The IIW Type 1 (V1) Calibration Block is used for calibrating ultrasonic flaw detectors for shear and longitudinal wave testing: time base calibration, probe index, beam angle, and sensitivity.', 'Standard EN ISO 2400 / ASTM E164 calibration block for ultrasonic shear and normal beam probes.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel (Nickel-plated or oil protected)', 'N/A', '5.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'IIW Type 1 (V1) UT Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000066', 'V2 UT Test Block', 'v2-ut-block', 'AJR-BLK-V2', 'The V2 block is a lightweight, pocket-sized reference block for field calibration of ultrasonic angle beam probes: index point, sound path, and angle verification.', 'Compact DIN 54122 / ISO 7963 miniature calibration block for on-site angle beam checks.', 'c0010001-0000-4000-8000-000000000012', '1018 Carbon Steel / 316 Stainless', 'N/A', '0.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'V2 UT Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000067', 'Ultrasonic Thickness Step Block', 'thickness-step-block', 'AJR-BLK-STP', 'Precision machined step wedge blocks for linearity and zero calibration of ultrasonic thickness gauges and flaw detectors.', '4-step / 5-step precision thickness calibration block for ultrasonic thickness gauges.', 'c0010001-0000-4000-8000-000000000012', 'Precision ground steel / stainless', 'N/A', '0.6 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Ultrasonic Thickness Step Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000068', 'Pipe Step Block', 'pipe-step-block', 'AJR-BLK-PIP', 'Machined with specific outer radii to match pipe diameters, eliminating couplant layer errors when calibrating ultrasonic gauges on convex pipe surfaces.', 'Curved step block for calibration of curved pipe wall thickness measurements.', 'c0010001-0000-4000-8000-000000000012', 'Carbon Steel / Stainless Steel', 'N/A', '0.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Pipe Step Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000069', 'ASME 19 & 38 Test Block', 'asme-block', 'AJR-BLK-ASME', 'Manufactured strictly in accordance with ASME Section V Article 4 Section T-434.2.1, featuring side-drilled holes (SDH) and EDM surface notches at 1/4T, 1/2T, and 3/4T.', 'ASME Section V Article 4 basic calibration blocks (19mm & 38mm) for weld inspection.', 'c0010001-0000-4000-8000-000000000012', 'SA-516 Grade 70 / SA-106 / Stainless', 'N/A', '4.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'ASME 19 & 38 Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000070', 'IIW Type 2 Block', 'iiw-type-2-block', 'AJR-BLK-V2-IIW', 'Modified IIW Type 2 design for ultrasonic testing, providing additional angle beam calibration targets and notch reflections.', 'Modified IIW calibration block with 50mm radius arc and calibration side notches.', 'c0010001-0000-4000-8000-000000000012', '1018 Carbon Steel', 'N/A', '5.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'IIW Type 2 Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000071', 'Mini IIW 2 Block', 'mini-iiw-block', 'AJR-BLK-MIIW', 'Convenient compact version of the IIW Type 2 standard block, weighing under 1 kg for easy carriage during rope access or climbing structural inspections.', 'Pocket-sized mini IIW type 2 reference block for climbing and pipeline inspectors.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel', 'N/A', '0.9 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Mini IIW 2 Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000072', 'DSC UT Test Block', 'dsc-ut-test-block', 'AJR-BLK-DSC', 'The DSC block is specifically used for distance and sensitivity calibration of shear wave transducers in accordance with AWS D1.1 and ASTM E164.', 'Distance and Sensitivity Calibration (DSC) block for AWS D1.1 structural welding code.', 'c0010001-0000-4000-8000-000000000012', '1018 Carbon Steel / Stainless 304', 'N/A', '1.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'DSC UT Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000073', 'SC UT Block', 'sc-ut-block', 'AJR-BLK-SC', 'The SC Block is utilized for sensitivity calibration of angle beam search units per AWS structural welding code requirements.', 'Sensitivity Calibration block for angle beam transducers per AWS D1.1.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel', 'N/A', '0.4 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'SC UT Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000074', 'AWS DS Block', 'ds-block', 'AJR-BLK-AWS-DS', 'The AWS DS Block contains two 0.0625 in side-drilled holes at 3/8 in and 3/4 in depth for horizontal linearity and sensitivity calibration.', 'Distance and Sensitivity reference standard block for AWS D1.1 longitudinal and shear wave.', 'c0010001-0000-4000-8000-000000000012', '1018 Carbon Steel', 'N/A', '3.1 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'AWS DS Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000075', 'RC Test Block', 'rc-block', 'AJR-BLK-RC', 'The RC (Resolution Calibration) Block is used for testing the resolving power of ultrasonic angle beam transducers in compliance with AWS D1.1 Table 6.1.', 'Resolution Calibration block for evaluating resolution of angle beam transducers.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel', 'N/A', '2.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'RC Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000076', 'DC UT Test block', 'dc-block', 'AJR-BLK-DC', 'The DC (Distance Calibration) block features a curved 1.0 inch radius surface and cylindrical bore for fast time base calibration.', 'Distance Calibration block for AWS D1.1 shear-wave instrument time base setting.', 'c0010001-0000-4000-8000-000000000012', '1018 Carbon Steel', 'N/A', '0.7 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'DC UT Test block | AJR NDT'),
('p0010001-0000-4000-8000-000000000077', 'IOW UT Block', 'iow-block', 'AJR-BLK-IOW', 'Standard British Institute of Welding (IOW) beam profile reference block containing calibrated 1.5 mm diameter holes at varying depths for beam spread evaluation.', 'Institute of Welding beam index and angle verification calibration block.', 'c0010001-0000-4000-8000-000000000012', 'Normalized carbon steel', 'N/A', '6.0 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'IOW UT Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000078', 'V3 Test Block', 'v3-block', 'AJR-BLK-V3', 'The V3 block provides quick index point and timebase check for ultrasonic angle probes in tight quarters.', 'Quick-check miniature angle probe calibration block.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel', 'N/A', '0.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'V3 Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000079', 'Phased Array Block Type A', 'pa-block', 'AJR-BLK-PA-A', 'Used during phased array ultrasonic testing (PAUT) for beam steering verification, time-corrected gain (TCG) calibration, and multi-angle velocity measurement.', 'Standard phased array reference block for angle beam verification and TCG calibration.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel / 316L Stainless / Aluminum', 'N/A', '3.5 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'Phased Array Block Type A | AJR NDT'),
('p0010001-0000-4000-8000-000000000080', 'PA Type B block', 'phased-array-block', 'AJR-BLK-PA-B', 'Features multiple horizontal rows of side-drilled holes for evaluating phased array sensitivity, electronic sectorial scan focal laws, and beam exit points.', 'Phased array sensitivity and depth calibration standard block.', 'c0010001-0000-4000-8000-000000000012', '1018 Carbon Steel', 'N/A', '3.8 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'PA Type B block | AJR NDT'),
('p0010001-0000-4000-8000-000000000081', 'PAUT IIW Block', 'paut-iiw-block', 'AJR-BLK-PAUT-IIW', 'Combines classic IIW Type 1 geometry with micro-SDH phased array calibration targets for combined conventional and phased array calibration.', 'Phased Array Ultrasonic Testing block tailored with dedicated PAUT targets.', 'c0010001-0000-4000-8000-000000000012', 'Fine-grain normalized steel', 'N/A', '5.4 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'PAUT IIW Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000082', 'PACS UT Test Block', 'pacs-ut-test-block', 'AJR-BLK-PACS', 'PACS block is designed for sensitivity calibration and angle verification of both phased array and conventional ultrasonic shear wave probes.', 'Phased Array & Conventional Shear-wave reference block.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel', 'N/A', '2.1 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'PACS UT Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000083', 'K1 Calibration Block', 'k1-ultrasonic-block', 'AJR-BLK-K1', 'Standard European K1 block used extensively throughout continental Europe for calibrating ultrasonic testing systems prior to weld examination.', 'European standard DIN EN ISO 2400 K1 ultrasonic calibration test block.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel with protective wood box', 'N/A', '5.0 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'K1 Calibration Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000084', 'K2 Test Block', 'k2-test-block', 'AJR-BLK-K2', 'Compact DIN EN ISO 7963 (formerly DIN 54122) K2 test block for angle probe angle and sound path verification on the construction site.', 'European standard DIN EN ISO 7963 K2 miniature calibration test block.', 'c0010001-0000-4000-8000-000000000012', '1018 Steel', 'N/A', '0.45 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'K2 Test Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000085', 'Navyships Block', 'navyships-block', 'AJR-BLK-NAVY', 'Constructed per US Navy specifications (NAVSEA T9074-AS-GIB-010/271) for angle beam and longitudinal beam ultrasonic testing on military vessels.', 'US Naval specification reference block for ultrasonic distance and sensitivity calibration.', 'c0010001-0000-4000-8000-000000000012', 'Certified Navy grade steel', 'N/A', '2.4 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Navyships Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000086', 'API RP 2X Reference Standard Block', 'api-rp-2x-block', 'AJR-BLK-API-2X', 'Manufactured to API Recommended Practice 2X (RP 2X) for ultrasonic examination of offshore platform tubular structures, nodal joints, and member welds.', 'API RP 2X reference standard block for offshore tubular structural weld inspection.', 'c0010001-0000-4000-8000-000000000012', 'Offshore grade structural steel (A36 / 50D)', 'N/A', '4.2 kg', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'API RP 2X Reference Standard Block | AJR NDT'),
('p0010001-0000-4000-8000-000000000087', 'Straight Probe', 'straight-probe', 'AJR-PRB-STR', 'High-damped single crystal straight beam transducer for general flaw detection, delamination checks, and thickness testing of plates, bars, and forgings.', 'Single element longitudinal wave normal beam ultrasonic transducer (1 - 5 MHz).', 'c0010001-0000-4000-8000-000000000013', 'Stainless steel casing with ceramic face', 'N/A', '120 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'Straight Probe | AJR NDT'),
('p0010001-0000-4000-8000-000000000088', 'Angle Probe', 'angle-probe', 'AJR-PRB-ANG', 'Single crystal shear wave angle beam probes designed for precise weld flaw detection, sizing, and root crack identification per AWS, ASME, and EN standards.', 'Shear wave angle beam probe (45, 60, 70 degrees) for weld and crack inspection.', 'c0010001-0000-4000-8000-000000000013', 'High-durability Rexolite wedge with stainless housing', 'N/A', '90 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 1, 1, 150, 'Angle Probe | AJR NDT'),
('p0010001-0000-4000-8000-000000000089', 'Dual Straight Probe', 'dual-straight-probe', 'AJR-PRB-DUAL-STR', 'Twin crystal probe featuring acoustically isolated transmitter and receiver elements tilted toward each other, providing superior near-surface defect resolution and thin wall capability.', 'TR (Transmit-Receive) dual element normal beam probe for near-surface flaw resolution.', 'c0010001-0000-4000-8000-000000000013', 'Stainless steel body with acoustic isolation barrier', 'N/A', '130 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Dual Straight Probe | AJR NDT'),
('p0010001-0000-4000-8000-000000000090', 'Dual Angle Probe', 'dual-angle-probe', 'AJR-PRB-DUAL-ANG', 'Dual element shear wave probe designed to eliminate interface ringdown and reduce acoustic noise in coarse-grain austenitic stainless steels and thin piping welds.', 'Twin crystal shear wave angle beam transducer for thin wall pipe and austenitic welds.', 'c0010001-0000-4000-8000-000000000013', 'Rexolite wedge in stainless body', 'N/A', '110 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Dual Angle Probe | AJR NDT'),
('p0010001-0000-4000-8000-000000000091', 'Ultrasound Snail Transducer and Wedge', 'ultrasound-snail-transducer-and-wedge', 'AJR-PRB-SNAIL', 'Low-profile \'snail\' shape transducer and couplant-irrigated wedge for Time of Flight Diffraction (TOFD) and phased array weld inspection in restricted clearance areas.', 'Low-profile snail TOFD / Phased Array transducer with contoured irrigation wedge.', 'c0010001-0000-4000-8000-000000000013', 'Brass / Stainless body with low-wear Rexolite wedge', 'N/A', '95 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Ultrasound Snail Transducer and Wedge | AJR NDT'),
('p0010001-0000-4000-8000-000000000092', 'Replaceable Ultrasonic Probe', 'replaceable-ultrasonic-probe', 'AJR-PRB-REPL', 'Features threaded replaceable delay lines and flexible protective membranes to prolong crystal life when inspecting rough, abrasive cast or scale-covered surfaces.', 'Transducer with screw-on replaceable delay lines and protective contact membranes.', 'c0010001-0000-4000-8000-000000000013', 'Threaded knurled brass / stainless steel', 'N/A', '115 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'Replaceable Ultrasonic Probe | AJR NDT'),
('p0010001-0000-4000-8000-000000000093', 'NDT Ultrasonic Cable', 'ultrasonic-cable', 'AJR-CBL-NDT', 'Industrial low-noise 50-ohm RF coaxial cables for ultrasonic and eddy current flaw detection. Reinforced with strain relief boots and flexible oil-resistant jackets.', 'RG-174 low-noise high-flex RF coaxial cables with BNC, LEMO 00, and LEMO 01 connectors.', 'c0010001-0000-4000-8000-000000000013', 'Gold-plated center pins, nickel-plated brass connectors', 'N/A', '85 g', '["ISO 9001", "CE", "ASTM", "EN"]', 'IN_STOCK', 0, 1, 150, 'NDT Ultrasonic Cable | AJR NDT')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`), `categoryId`=VALUES(`categoryId`);

-- 3. INSERT PRODUCT IMAGES
INSERT INTO `product_images` (`id`,`productId`,`url`,`alt`,`isPrimary`,`sortOrder`) VALUES
('img00001-0000-4000-8000-000000000001', 'p0010001-0000-4000-8000-000000000001', 'https://image.chukouplus.com/upload/C_3791/file/20231225/d28d19aac696876af0d5ebaf4f3b7e36.jpg', 'AFD100 UT Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000002', 'p0010001-0000-4000-8000-000000000002', 'https://image.chukouplus.com/upload/C_3791/file/20231228/3e965c998321625a54ecf802ca1564ed.jpg', 'AFD800 Portable Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000003', 'p0010001-0000-4000-8000-000000000003', 'https://image.chukouplus.com/upload/C_3791/file/20231228/f3b0b8dcf15ed85b0b41a0b7ae222491.jpg', 'AFD856 Multi Channel Ultrasonic Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000004', 'p0010001-0000-4000-8000-000000000004', 'https://image.chukouplus.com/upload/C_3791/file/20231228/bee5ec61ae7cb0029d398518760c2455.jpg', 'AFD860 NDT Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000005', 'p0010001-0000-4000-8000-000000000005', 'https://image.chukouplus.com/upload/C_3791/file/20231228/926375f4954eef3df226a899867e988a.jpg', 'ATG140 UT Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000006', 'p0010001-0000-4000-8000-000000000006', 'https://image.chukouplus.com/upload/C_3791/file/20231228/35346334df2cca4bd3b2a77378e3bb47.jpg', 'ATG400 Ultrasonic Through Coating Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000007', 'p0010001-0000-4000-8000-000000000007', 'https://image.chukouplus.com/upload/C_3791/file/20240108/8f94708acb1de98aece9a481ae76978a.jpg', 'Scan-I A Scan Handheld Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000008', 'p0010001-0000-4000-8000-000000000008', 'https://image.chukouplus.com/upload/C_3791/file/20231228/91192df181093ce05dd287798a421196.jpg', 'Scan-II Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000009', 'p0010001-0000-4000-8000-000000000009', 'https://image.chukouplus.com/upload/C_3791/file/20240109/d49d4f3215a3d6ef9d619fa027ad0795.jpg', 'ACT2300 Bluetooth Coating Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000010', 'p0010001-0000-4000-8000-000000000010', 'https://image.chukouplus.com/upload/C_3791/file/20231228/cb9116b95b0f14d10b871e06730e8747.jpg', 'ACT2200 Digital Coating Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000011', 'p0010001-0000-4000-8000-000000000011', 'https://image.chukouplus.com/upload/C_3791/file/20240109/227e0dec5e8cb493641c50227e669f41.jpg', 'ACT4000 Paint Thickness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000012', 'p0010001-0000-4000-8000-000000000012', 'https://image.chukouplus.com/upload/C_3791/file/20231228/bb3ed01dffe6e9248b95cb7dd1db6fbd.jpg', 'AJH300 Portable Hardness Tester', 1, 0),
('img00001-0000-4000-8000-000000000013', 'p0010001-0000-4000-8000-000000000013', 'https://image.chukouplus.com/upload/C_3791/file/20231228/d0cc7712851c9fc2bee6757ac0dd6d32.jpg', 'AJH410 Metal Hardness Tester', 1, 0),
('img00001-0000-4000-8000-000000000014', 'p0010001-0000-4000-8000-000000000014', 'https://image.chukouplus.com/upload/C_3791/file/20231228/03fdc8dea69f9301b365c3507a8644db.jpg', 'AJH580 Leeb Hardness Tester with Mini Printer', 1, 0),
('img00001-0000-4000-8000-000000000015', 'p0010001-0000-4000-8000-000000000015', 'https://image.chukouplus.com/upload/C_3791/file/20231228/86b86092341e61ad68bcfabd2eb21eda.jpg', 'AJH720 Pen Hardness Tester', 1, 0),
('img00001-0000-4000-8000-000000000016', 'p0010001-0000-4000-8000-000000000016', 'https://image.chukouplus.com/upload/C_3791/file/20231228/54a88517ec7e659de8ed4c9435e79216.jpg', 'AUH-III UCI Hardness Tester', 1, 0),
('img00001-0000-4000-8000-000000000017', 'p0010001-0000-4000-8000-000000000017', 'https://image.chukouplus.com/upload/C_3791/file/20240109/dd80f018f868a8e6561231c7f43f00e8.jpg', 'ART380 Roughness Tester', 1, 0),
('img00001-0000-4000-8000-000000000018', 'p0010001-0000-4000-8000-000000000018', 'https://image.chukouplus.com/upload/C_3791/file/20231228/36a071c95d9a8a7a731a9706f93505f6.jpg', 'ART300 Surface Roughness Gauge', 1, 0),
('img00001-0000-4000-8000-000000000019', 'p0010001-0000-4000-8000-000000000019', 'https://image.chukouplus.com/upload/C_3791/file/20240109/ba9ed16fdc77d60d6467f3605359f4d4.jpg', 'ART100 Digital Profile Gauge', 1, 0),
('img00001-0000-4000-8000-000000000020', 'p0010001-0000-4000-8000-000000000020', 'https://image.chukouplus.com/upload/C_3791/file/20240109/48c5158b200ac310814ad0dfc6c36559.jpg', 'ART90 Surface Profile Gauge', 1, 0),
('img00001-0000-4000-8000-000000000021', 'p0010001-0000-4000-8000-000000000021', 'https://image.chukouplus.com/upload/C_3791/file/20231228/651fb6ade694f29555fe9bfba9959772.jpg', 'AJE220B MT Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000022', 'p0010001-0000-4000-8000-000000000022', 'https://image.chukouplus.com/upload/C_3791/file/20240102/c66940aeb6cafe21523c61133c573734.jpg', 'AJE220B AC DC Magnetic Yoke Tester', 1, 0),
('img00001-0000-4000-8000-000000000023', 'p0010001-0000-4000-8000-000000000023', 'https://image.chukouplus.com/upload/C_3791/file/20240122/91136efe201ff5b4a15d0fc0d8f0b489.jpg', 'AJE230 Permanent Yoke Tester', 1, 0),
('img00001-0000-4000-8000-000000000024', 'p0010001-0000-4000-8000-000000000024', 'https://image.chukouplus.com/upload/C_3791/file/20240122/c6be24b939e04682bba68755de76e115.jpg', 'AJE220 AC DC MT Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000025', 'p0010001-0000-4000-8000-000000000025', 'https://image.chukouplus.com/upload/C_3791/file/20240122/f9453bcebe79abaf59cced530b4ea62d.jpg', 'AJE220 Magnetic Particle Inspection Tester (with UV Light)', 1, 0),
('img00001-0000-4000-8000-000000000026', 'p0010001-0000-4000-8000-000000000026', 'https://image.chukouplus.com/upload/C_3791/file/20240122/9f828e3b701d017603c5b9c10c453538.jpg', 'AJE220 AC Yoke Tester with White Light', 1, 0),
('img00001-0000-4000-8000-000000000027', 'p0010001-0000-4000-8000-000000000027', 'https://image.chukouplus.com/upload/C_3791/file/20240122/3d8487f5e89f46a73523c48707498457.jpg', 'AJE220 Mt Yoke Tester', 1, 0),
('img00001-0000-4000-8000-000000000028', 'p0010001-0000-4000-8000-000000000028', 'https://image.chukouplus.com/upload/C_3791/file/20240122/1ff50d0d52a56ddbff4ca363564f3f41.jpg', 'AJE110 Magnetic Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000029', 'p0010001-0000-4000-8000-000000000029', 'https://image.chukouplus.com/upload/C_3791/file/20240122/5c02ee7170b09959b1f4b380c8e855ed.jpg', 'AMT Magnetic Charging Coil', 1, 0),
('img00001-0000-4000-8000-000000000030', 'p0010001-0000-4000-8000-000000000030', 'https://image.chukouplus.com/upload/C_3791/file/20240103/7af111ca2eac10ccdabfffa6764a55db.jpg', 'AJR NDT 120-300KV X Ray Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000031', 'p0010001-0000-4000-8000-000000000031', 'https://image.chukouplus.com/upload/C_3791/file/20240103/359b6646797f1b0f1c7c66990399bf4d.jpg', 'AJR NDT: Portable X Ray Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000032', 'p0010001-0000-4000-8000-000000000032', 'https://image.chukouplus.com/upload/C_3791/file/20240103/7a184420901668914207245c856c526b.jpg', 'AJR NDT: RT X Ray Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000033', 'p0010001-0000-4000-8000-000000000033', 'https://image.chukouplus.com/upload/C_3791/file/20240124/1111e6518c34d9adc7c21a0270ddaba0.jpg', 'AJR NDT 5100 X Ray Crawler', 1, 0),
('img00001-0000-4000-8000-000000000034', 'p0010001-0000-4000-8000-000000000034', 'https://image.chukouplus.com/upload/C_3791/file/20240124/d542d6c93902990355476d2290cb84f1.jpg', 'AJR NDT 5200 RT Pipeline Crawler', 1, 0),
('img00001-0000-4000-8000-000000000035', 'p0010001-0000-4000-8000-000000000035', 'https://image.chukouplus.com/upload/C_3791/file/20240124/63750736ce40bfc5110ff9086cffb5fb.jpg', 'AJR NDT 5300 RT Crawler', 1, 0),
('img00001-0000-4000-8000-000000000036', 'p0010001-0000-4000-8000-000000000036', 'https://image.chukouplus.com/upload/C_3791/file/20240124/dcc9ab460b453837adb4bebc21d24f64.jpg', 'AJR NDT 5400 Series X-ray Pipeline Crawler', 1, 0),
('img00001-0000-4000-8000-000000000037', 'p0010001-0000-4000-8000-000000000037', 'https://image.chukouplus.com/upload/C_3791/file/20240124/01a93ba3a883d716c79fc01b13607216.jpg', 'AJR NDT 5500 X Ray Pipeline Crawler', 1, 0),
('img00001-0000-4000-8000-000000000038', 'p0010001-0000-4000-8000-000000000038', 'https://image.chukouplus.com/upload/C_3791/file/20240103/7b4ea06456b50589926681cdfd4366f2.jpg', 'AFV2131D Industrial X-Ray Film Viewer with Densitometer', 1, 0),
('img00001-0000-4000-8000-000000000039', 'p0010001-0000-4000-8000-000000000039', 'https://image.chukouplus.com/upload/C_3791/file/20240125/cb669b5168e6eb5ab7d189aae5927ea5.jpg', 'AFV2126D Film Viewer with Densitometer', 1, 0),
('img00001-0000-4000-8000-000000000040', 'p0010001-0000-4000-8000-000000000040', 'https://image.chukouplus.com/upload/C_3791/file/20240125/b3d4896276228dbf29affae938253c73.jpg', 'AFV2131 LED Film Viewer', 1, 0),
('img00001-0000-4000-8000-000000000041', 'p0010001-0000-4000-8000-000000000041', 'https://image.chukouplus.com/upload/C_3791/file/20240103/bcf54ff8e63bbc0862c6c031c25bf923.jpg', 'AFV2128 Film Viewer', 1, 0),
('img00001-0000-4000-8000-000000000042', 'p0010001-0000-4000-8000-000000000042', 'https://image.chukouplus.com/upload/C_3791/file/20240125/fe2e33f0016f737fd4c7f69fe100e286.jpg', 'AFV2126 Industrial Film Viewer', 1, 0),
('img00001-0000-4000-8000-000000000043', 'p0010001-0000-4000-8000-000000000043', 'https://image.chukouplus.com/upload/C_3791/file/20240103/a2c273a121bae89299484d37bb386e73.jpg', 'AJR NDT AEC640 Eddy Current Flaw Detector', 1, 0),
('img00001-0000-4000-8000-000000000044', 'p0010001-0000-4000-8000-000000000044', 'https://image.chukouplus.com/upload/C_3791/file/20240122/0989dae8965c20f51b30324caf183043.jpg', 'AEC620 Eddy Current Tester', 1, 0),
('img00001-0000-4000-8000-000000000045', 'p0010001-0000-4000-8000-000000000045', 'https://image.chukouplus.com/upload/C_3791/file/20240103/3cc5d6cba28d4bb0ce1d2eb4fee0aee2.jpg', 'AJR NDT AEC670 Eddy Current Electrical Conductivity Meter', 1, 0),
('img00001-0000-4000-8000-000000000046', 'p0010001-0000-4000-8000-000000000046', 'https://image.chukouplus.com/upload/C_3791/file/20240119/de99b5c31273689a9c14009cf9097220.jpg', 'AEC660 Eddy Current Conductivity Tester', 1, 0),
('img00001-0000-4000-8000-000000000047', 'p0010001-0000-4000-8000-000000000047', 'https://image.chukouplus.com/upload/C_3791/file/20240102/b296ac9af00466f7feea4d5de1af0a92.jpg', 'AJR 90 Pipeline Videoscope', 1, 0),
('img00001-0000-4000-8000-000000000048', 'p0010001-0000-4000-8000-000000000048', 'https://image.chukouplus.com/upload/C_3791/file/20240102/25aaeeff79947018812c12f1e8f5b3d3.jpg', '50039 / 50060 Portable Video Endoscopes', 1, 0),
('img00001-0000-4000-8000-000000000049', 'p0010001-0000-4000-8000-000000000049', 'https://image.chukouplus.com/upload/C_3791/file/20240122/3aaa51ba415b57d62d6fd14884e552eb.jpg', 'AJR90 Series Pipe Inspection Camera', 1, 0),
('img00001-0000-4000-8000-000000000050', 'p0010001-0000-4000-8000-000000000050', 'https://image.chukouplus.com/upload/C_3791/file/20240109/18a0ed86bdaaf388efdac67cc45409cf.jpg', 'AJR UV LED 6000P+ UV LED Lamp', 1, 0),
('img00001-0000-4000-8000-000000000051', 'p0010001-0000-4000-8000-000000000051', 'https://image.chukouplus.com/upload/C_3791/file/20240102/a476b4391bf52a8ad8db237e10041d30.jpg', 'AJR UV LED 4000+ / 6000+ / 8000+ / 10000+ NDT UV LED Lamp', 1, 0),
('img00001-0000-4000-8000-000000000052', 'p0010001-0000-4000-8000-000000000052', 'https://image.chukouplus.com/upload/C_3791/file/20240102/f963e0b1a136606bd0799b129e667571.jpg', 'AJR UV LED4000 / 6000 / 8000 / 10000 Model NDT UV LED Lamp', 1, 0),
('img00001-0000-4000-8000-000000000053', 'p0010001-0000-4000-8000-000000000053', 'https://image.chukouplus.com/upload/C_3791/file/20240110/fb5d752d56273acf80332e9c24ef4412.jpg', 'AJR NDT Stationary Flood UV A Lamp', 1, 0),
('img00001-0000-4000-8000-000000000054', 'p0010001-0000-4000-8000-000000000054', 'https://image.chukouplus.com/upload/C_3791/file/20240110/2e74160412ab46af63c38b4af255563c.jpg', 'AJR NDT UV-H Helmet Type UV LED LAMP', 1, 0),
('img00001-0000-4000-8000-000000000055', 'p0010001-0000-4000-8000-000000000055', 'https://image.chukouplus.com/upload/C_3791/file/20240110/36b162a84552eda31acd551b6c63b8ff.jpg', 'AJR UV-T UV LED Torch with Trigger', 1, 0),
('img00001-0000-4000-8000-000000000056', 'p0010001-0000-4000-8000-000000000056', 'https://image.chukouplus.com/upload/C_3791/file/20240110/4a36e42c414862423cb62ec859a2d0d5.jpg', 'AJR UV Flashlight, Black Floor Lamp', 1, 0),
('img00001-0000-4000-8000-000000000057', 'p0010001-0000-4000-8000-000000000057', 'https://image.chukouplus.com/upload/C_3791/file/20240102/403d208cedeeaa4a1c1fe1d0c097c71d.jpg', 'ART-11S Steel Wire Rope Tester', 1, 0),
('img00001-0000-4000-8000-000000000058', 'p0010001-0000-4000-8000-000000000058', 'https://image.chukouplus.com/upload/C_3791/file/20240103/7aa54039f33009c1d2e9caab64b045dc.jpg', 'AHD810 Pinhole Holiday Detector', 1, 0),
('img00001-0000-4000-8000-000000000059', 'p0010001-0000-4000-8000-000000000059', 'https://image.chukouplus.com/upload/C_3791/file/20240103/f9cb3988e1dc9e161f574fca49856899.jpg', 'AHD820 Spark Holiday Detector', 1, 0),
('img00001-0000-4000-8000-000000000060', 'p0010001-0000-4000-8000-000000000060', 'https://image.chukouplus.com/upload/C_3791/file/20240119/023e5ca631f94551263574637ffeb6b6.jpg', 'AHD860 Porosity Holiday Detector', 1, 0),
('img00001-0000-4000-8000-000000000061', 'p0010001-0000-4000-8000-000000000061', 'https://image.chukouplus.com/upload/C_3791/file/20240109/31a7f0c3edbd8d8af6219c5d92a2cd8c.jpg', 'AJR NDT: LX1010B Light Meter', 1, 0),
('img00001-0000-4000-8000-000000000062', 'p0010001-0000-4000-8000-000000000062', 'https://image.chukouplus.com/upload/C_3791/file/20240109/7d8415fb8514524f45f24f47295eda87.jpg', 'AJR NDT: LX1020BS Digital Lux Meter', 1, 0),
('img00001-0000-4000-8000-000000000063', 'p0010001-0000-4000-8000-000000000063', 'https://image.chukouplus.com/upload/C_3791/file/20240109/3f27b6d6f005e59e1d01d962bbb46a5a.jpg', 'AJR NDT: LX1330B Digital Lux Meter', 1, 0),
('img00001-0000-4000-8000-000000000064', 'p0010001-0000-4000-8000-000000000064', 'https://image.chukouplus.com/upload/C_3791/file/20240109/3433fae0c9afcc5c4b74fc65fdbc661d.jpg', 'AJR NDT: UVA365 UV A Radiometer / Light Meter', 1, 0),
('img00001-0000-4000-8000-000000000065', 'p0010001-0000-4000-8000-000000000065', 'https://image.chukouplus.com/upload/C_3791/file/20240114/0f66f3522b8d64457cd37e7387080bd0.jpg', 'IIW Type 1 (V1) UT Test Block', 1, 0),
('img00001-0000-4000-8000-000000000066', 'p0010001-0000-4000-8000-000000000066', 'https://image.chukouplus.com/upload/C_3791/file/20240114/ad002a7ee28f956bedf1288acd2aaebd.jpg', 'V2 UT Test Block', 1, 0),
('img00001-0000-4000-8000-000000000067', 'p0010001-0000-4000-8000-000000000067', 'https://image.chukouplus.com/upload/C_3791/file/20240115/3ae47f72e755478ab92ecea326bce92b.jpg', 'Ultrasonic Thickness Step Block', 1, 0),
('img00001-0000-4000-8000-000000000068', 'p0010001-0000-4000-8000-000000000068', 'https://image.chukouplus.com/upload/C_3791/file/20240116/f1397607a652bae3a75c3050115a91bb.jpg', 'Pipe Step Block', 1, 0),
('img00001-0000-4000-8000-000000000069', 'p0010001-0000-4000-8000-000000000069', 'https://image.chukouplus.com/upload/C_3791/file/20240119/bf48f13dd0c7b436b8d56da56ff41898.jpg', 'ASME 19 & 38 Test Block', 1, 0),
('img00001-0000-4000-8000-000000000070', 'p0010001-0000-4000-8000-000000000070', 'https://image.chukouplus.com/upload/C_3791/file/20240119/654968ad09f91ba971e95270f03728f3.jpg', 'IIW Type 2 Block', 1, 0),
('img00001-0000-4000-8000-000000000071', 'p0010001-0000-4000-8000-000000000071', 'https://image.chukouplus.com/upload/C_3791/file/20240119/7947338d897d3ab17919de7215a09fb2.jpg', 'Mini IIW 2 Block', 1, 0),
('img00001-0000-4000-8000-000000000072', 'p0010001-0000-4000-8000-000000000072', 'https://image.chukouplus.com/upload/C_3791/file/20240116/5ff0e0f6cacc4818f340e2d2f9795633.jpg', 'DSC UT Test Block', 1, 0),
('img00001-0000-4000-8000-000000000073', 'p0010001-0000-4000-8000-000000000073', 'https://image.chukouplus.com/upload/C_3791/file/20240116/ed5b19a4511dd97dd478ca1fc69464b5.jpg', 'SC UT Block', 1, 0),
('img00001-0000-4000-8000-000000000074', 'p0010001-0000-4000-8000-000000000074', 'https://image.chukouplus.com/upload/C_3791/file/20240116/9964f1904c2576447743d597438f0ab6.jpg', 'AWS DS Block', 1, 0),
('img00001-0000-4000-8000-000000000075', 'p0010001-0000-4000-8000-000000000075', 'https://image.chukouplus.com/upload/C_3791/file/20240119/d55cd5fd7cd4ee0c8d06443960542e5d.jpg', 'RC Test Block', 1, 0),
('img00001-0000-4000-8000-000000000076', 'p0010001-0000-4000-8000-000000000076', 'https://image.chukouplus.com/upload/C_3791/file/20240116/2cd1a1bc36ffedd5331765726241c5bb.jpg', 'DC UT Test block', 1, 0),
('img00001-0000-4000-8000-000000000077', 'p0010001-0000-4000-8000-000000000077', 'https://image.chukouplus.com/upload/C_3791/file/20240119/440c4a019b0c9951c34573da4ec796a2.jpg', 'IOW UT Block', 1, 0),
('img00001-0000-4000-8000-000000000078', 'p0010001-0000-4000-8000-000000000078', 'https://image.chukouplus.com/upload/C_3791/file/20240119/84b25bd62aa5bc56a50966cf4de92ae7.jpg', 'V3 Test Block', 1, 0),
('img00001-0000-4000-8000-000000000079', 'p0010001-0000-4000-8000-000000000079', 'https://image.chukouplus.com/upload/C_3791/file/20240119/d81823f2446589fea5713a567961e102.jpg', 'Phased Array Block Type A', 1, 0),
('img00001-0000-4000-8000-000000000080', 'p0010001-0000-4000-8000-000000000080', 'https://image.chukouplus.com/upload/C_3791/file/20240119/c322bea5743b932a0d43df317793e783.jpg', 'PA Type B block', 1, 0),
('img00001-0000-4000-8000-000000000081', 'p0010001-0000-4000-8000-000000000081', 'https://image.chukouplus.com/upload/C_3791/file/20240119/01e3dca2b9ed238929912d56b03f13a3.jpg', 'PAUT IIW Block', 1, 0),
('img00001-0000-4000-8000-000000000082', 'p0010001-0000-4000-8000-000000000082', 'https://image.chukouplus.com/upload/C_3791/file/20240119/688323999f6042fcf470a11304adc32a.jpg', 'PACS UT Test Block', 1, 0),
('img00001-0000-4000-8000-000000000083', 'p0010001-0000-4000-8000-000000000083', 'https://image.chukouplus.com/upload/C_3791/file/20240119/e8451aaf57f1913259673711a648b0fc.jpg', 'K1 Calibration Block', 1, 0),
('img00001-0000-4000-8000-000000000084', 'p0010001-0000-4000-8000-000000000084', 'https://image.chukouplus.com/upload/C_3791/file/20240119/b115e7263bed7e9adc3416181c00e215.jpg', 'K2 Test Block', 1, 0),
('img00001-0000-4000-8000-000000000085', 'p0010001-0000-4000-8000-000000000085', 'https://image.chukouplus.com/upload/C_3791/file/20240119/a629d44660cf2402c92a1151c1736a14.jpg', 'Navyships Block', 1, 0),
('img00001-0000-4000-8000-000000000086', 'p0010001-0000-4000-8000-000000000086', 'https://image.chukouplus.com/upload/C_3791/file/20240119/a7f7249a70642818ad2b7fcb19fc027c.jpg', 'API RP 2X Reference Standard Block', 1, 0),
('img00001-0000-4000-8000-000000000087', 'p0010001-0000-4000-8000-000000000087', 'https://image.chukouplus.com/upload/C_3791/file/20240110/678898952cb2947c11c50f0697eb6ce9.jpg', 'Straight Probe', 1, 0),
('img00001-0000-4000-8000-000000000088', 'p0010001-0000-4000-8000-000000000088', 'https://image.chukouplus.com/upload/C_3791/file/20240110/e8b170f48c0f20e06a32a3db9f4e5cfa.jpg', 'Angle Probe', 1, 0),
('img00001-0000-4000-8000-000000000089', 'p0010001-0000-4000-8000-000000000089', 'https://image.chukouplus.com/upload/C_3791/file/20240110/83ac6c1affb356554c121b81aab8394c.jpg', 'Dual Straight Probe', 1, 0),
('img00001-0000-4000-8000-000000000090', 'p0010001-0000-4000-8000-000000000090', 'https://image.chukouplus.com/upload/C_3791/file/20240110/9ecab92afbd6a73ef06d25c8105bb94a.jpg', 'Dual Angle Probe', 1, 0),
('img00001-0000-4000-8000-000000000091', 'p0010001-0000-4000-8000-000000000091', 'https://image.chukouplus.com/upload/C_3791/file/20240129/451cbd2c6dd933ff6b3e9a95b7b9d5ee.jpg', 'Ultrasound Snail Transducer and Wedge', 1, 0),
('img00001-0000-4000-8000-000000000092', 'p0010001-0000-4000-8000-000000000092', 'https://image.chukouplus.com/upload/C_3791/file/20240129/b1ce83fb2e31b8c0c6cf849bd20a4802.jpg', 'Replaceable Ultrasonic Probe', 1, 0),
('img00001-0000-4000-8000-000000000093', 'p0010001-0000-4000-8000-000000000093', 'https://image.chukouplus.com/upload/C_3791/file/20240112/69db05dfe0adcf1bfdc927ec74658c1b.jpg', 'NDT Ultrasonic Cable', 1, 0)
ON DUPLICATE KEY UPDATE `url`=VALUES(`url`);

-- 4. INSERT SPECIFICATIONS
INSERT INTO `specifications` (`id`,`productId`,`key`,`value`,`sortOrder`) VALUES
('spc00001-0000-4000-8000-000000000001', 'p0010001-0000-4000-8000-000000000001', 'Measuring Range', '0 - 6000 mm (in steel)', 1),
('spc00001-0000-4000-8000-000000000002', 'p0010001-0000-4000-8000-000000000001', 'Bandwidth', '0.5 - 10 MHz', 2),
('spc00001-0000-4000-8000-000000000003', 'p0010001-0000-4000-8000-000000000001', 'Gain Range', '0 - 110 dB', 3),
('spc00001-0000-4000-8000-000000000004', 'p0010001-0000-4000-8000-000000000001', 'Dynamic Range', '>= 32 dB', 4),
('spc00001-0000-4000-8000-000000000005', 'p0010001-0000-4000-8000-000000000001', 'Vertical Linearity', '<= 3%', 5),
('spc00001-0000-4000-8000-000000000006', 'p0010001-0000-4000-8000-000000000001', 'Horizontal Linearity', '<= 0.1%', 6),
('spc00001-0000-4000-8000-000000000007', 'p0010001-0000-4000-8000-000000000001', 'Battery Life', '12 hours (Li-ion 5600mAh)', 7),
('spc00001-0000-4000-8000-000000000008', 'p0010001-0000-4000-8000-000000000001', 'Dimensions', '240 x 156 x 48 mm', 8),
('spc00001-0000-4000-8000-000000000009', 'p0010001-0000-4000-8000-000000000001', 'Weight', '1.0 kg (with battery)', 9),
('spc00001-0000-4000-8000-000000000010', 'p0010001-0000-4000-8000-000000000002', 'Measuring Range', '0 - 5000 mm', 1),
('spc00001-0000-4000-8000-000000000011', 'p0010001-0000-4000-8000-000000000002', 'Frequency Range', '0.5 - 15 MHz', 2),
('spc00001-0000-4000-8000-000000000012', 'p0010001-0000-4000-8000-000000000002', 'Gain', '0 - 110 dB', 3),
('spc00001-0000-4000-8000-000000000013', 'p0010001-0000-4000-8000-000000000002', 'Display', 'High-contrast color TFT', 4),
('spc00001-0000-4000-8000-000000000014', 'p0010001-0000-4000-8000-000000000002', 'Power', 'Rechargeable Lithium Pack, >8 hrs', 5),
('spc00001-0000-4000-8000-000000000015', 'p0010001-0000-4000-8000-000000000003', 'Channels', 'Multi-channel simultaneous acquisition', 1),
('spc00001-0000-4000-8000-000000000016', 'p0010001-0000-4000-8000-000000000003', 'Operating Frequency', '0.5 - 20 MHz', 2),
('spc00001-0000-4000-8000-000000000017', 'p0010001-0000-4000-8000-000000000003', 'Data Interface', 'TCP/IP Ethernet & High-speed USB', 3),
('spc00001-0000-4000-8000-000000000018', 'p0010001-0000-4000-8000-000000000003', 'Alarm Output', 'Optically isolated I/O relay', 4),
('spc00001-0000-4000-8000-000000000019', 'p0010001-0000-4000-8000-000000000004', 'Measuring Range', '0 - 10000 mm', 1),
('spc00001-0000-4000-8000-000000000020', 'p0010001-0000-4000-8000-000000000004', 'Dynamic Range', '>= 36 dB', 2),
('spc00001-0000-4000-8000-000000000021', 'p0010001-0000-4000-8000-000000000004', 'PRF', '20 - 1000 Hz adjustable', 3),
('spc00001-0000-4000-8000-000000000022', 'p0010001-0000-4000-8000-000000000004', 'Enclosure Rating', 'IP65 weather-resistant', 4),
('spc00001-0000-4000-8000-000000000023', 'p0010001-0000-4000-8000-000000000005', 'Range', '0.75 - 300 mm (steel)', 1),
('spc00001-0000-4000-8000-000000000024', 'p0010001-0000-4000-8000-000000000005', 'Resolution', '0.01 mm / 0.001 in', 2),
('spc00001-0000-4000-8000-000000000025', 'p0010001-0000-4000-8000-000000000005', 'Velocity Range', '1000 - 9999 m/s', 3),
('spc00001-0000-4000-8000-000000000026', 'p0010001-0000-4000-8000-000000000005', 'Battery', '2x 1.5V AA cells, ~100 operating hours', 4),
('spc00001-0000-4000-8000-000000000027', 'p0010001-0000-4000-8000-000000000006', 'Standard Mode', '0.65 - 500 mm', 1),
('spc00001-0000-4000-8000-000000000028', 'p0010001-0000-4000-8000-000000000006', 'Through Coating Mode', '3.0 - 50 mm', 2),
('spc00001-0000-4000-8000-000000000029', 'p0010001-0000-4000-8000-000000000006', 'Resolution', '0.01 mm / 0.001 mm selectable', 3),
('spc00001-0000-4000-8000-000000000030', 'p0010001-0000-4000-8000-000000000006', 'Display', 'High-contrast OLED', 4),
('spc00001-0000-4000-8000-000000000031', 'p0010001-0000-4000-8000-000000000007', 'Measuring Range', '0.5 - 508 mm', 1),
('spc00001-0000-4000-8000-000000000032', 'p0010001-0000-4000-8000-000000000007', 'Display Modes', 'RF, Full Wave, Positive Half, A-scan & B-scan', 2),
('spc00001-0000-4000-8000-000000000033', 'p0010001-0000-4000-8000-000000000007', 'Memory', '100,000 readings with A-scans', 3),
('spc00001-0000-4000-8000-000000000034', 'p0010001-0000-4000-8000-000000000007', 'Interface', 'USB 2.0 with PC software', 4),
('spc00001-0000-4000-8000-000000000035', 'p0010001-0000-4000-8000-000000000008', 'Range', '0.65 - 400 mm', 1),
('spc00001-0000-4000-8000-000000000036', 'p0010001-0000-4000-8000-000000000008', 'Accuracy', '+/-(0.5%H + 0.01) mm', 2),
('spc00001-0000-4000-8000-000000000037', 'p0010001-0000-4000-8000-000000000008', 'Units', 'mm / inch selectable', 3),
('spc00001-0000-4000-8000-000000000038', 'p0010001-0000-4000-8000-000000000008', 'Display', 'Backlit LCD screen', 4),
('spc00001-0000-4000-8000-000000000039', 'p0010001-0000-4000-8000-000000000009', 'Range', '0 - 2000 um (0 - 78.7 mils)', 1),
('spc00001-0000-4000-8000-000000000040', 'p0010001-0000-4000-8000-000000000009', 'Accuracy', '+/-(2% + 1um)', 2),
('spc00001-0000-4000-8000-000000000041', 'p0010001-0000-4000-8000-000000000009', 'Substrates', 'Ferrous (Steel/Iron) & Non-Ferrous (Aluminum/Copper/Brass)', 3),
('spc00001-0000-4000-8000-000000000042', 'p0010001-0000-4000-8000-000000000009', 'Connectivity', 'Bluetooth 5.0 + USB', 4),
('spc00001-0000-4000-8000-000000000043', 'p0010001-0000-4000-8000-000000000010', 'Measuring Range', '0 - 1500 um', 1),
('spc00001-0000-4000-8000-000000000044', 'p0010001-0000-4000-8000-000000000010', 'Resolution', '0.1 um (<100 um), 1 um (>100 um)', 2),
('spc00001-0000-4000-8000-000000000045', 'p0010001-0000-4000-8000-000000000010', 'Calibration', 'Zero point & multi-foil calibration', 3),
('spc00001-0000-4000-8000-000000000046', 'p0010001-0000-4000-8000-000000000010', 'Display', 'Backlit color LCD with rotation', 4),
('spc00001-0000-4000-8000-000000000047', 'p0010001-0000-4000-8000-000000000011', 'Measuring Range', '0 - 5000 um', 1),
('spc00001-0000-4000-8000-000000000048', 'p0010001-0000-4000-8000-000000000011', 'Accuracy', '+/-(3% + 2 um)', 2),
('spc00001-0000-4000-8000-000000000049', 'p0010001-0000-4000-8000-000000000011', 'Probe Type', 'Separate cable probe with wear-resistant tip', 3),
('spc00001-0000-4000-8000-000000000050', 'p0010001-0000-4000-8000-000000000011', 'Memory', '500 readings', 4),
('spc00001-0000-4000-8000-000000000051', 'p0010001-0000-4000-8000-000000000012', 'Hardness Scales', 'HL, HRC, HRB, HRA, HB, HV, HS', 1),
('spc00001-0000-4000-8000-000000000052', 'p0010001-0000-4000-8000-000000000012', 'Accuracy', '+/- 6 HLD (at 790 HLD)', 2),
('spc00001-0000-4000-8000-000000000053', 'p0010001-0000-4000-8000-000000000012', 'Impact Device', 'Type D standard (optional DC, D+15, C, G, DL)', 3),
('spc00001-0000-4000-8000-000000000054', 'p0010001-0000-4000-8000-000000000012', 'Memory', '100 groups', 4),
('spc00001-0000-4000-8000-000000000055', 'p0010001-0000-4000-8000-000000000013', 'Impact Direction', '360 degrees full automatic compensation', 1),
('spc00001-0000-4000-8000-000000000056', 'p0010001-0000-4000-8000-000000000013', 'Test Accuracy', '+/- 0.5% (at 800 HLD)', 2),
('spc00001-0000-4000-8000-000000000057', 'p0010001-0000-4000-8000-000000000013', 'Display', 'Large matrix LCD with backlight', 3),
('spc00001-0000-4000-8000-000000000058', 'p0010001-0000-4000-8000-000000000013', 'Output', 'USB interface to PC', 4),
('spc00001-0000-4000-8000-000000000059', 'p0010001-0000-4000-8000-000000000014', 'Printer', 'Integrated high-speed thermal printer (57mm paper)', 1),
('spc00001-0000-4000-8000-000000000060', 'p0010001-0000-4000-8000-000000000014', 'Hardness Parameters', 'HLD, HRC, HRB, HB, HV, HSD', 2),
('spc00001-0000-4000-8000-000000000061', 'p0010001-0000-4000-8000-000000000014', 'Memory', '500 test batches', 3),
('spc00001-0000-4000-8000-000000000062', 'p0010001-0000-4000-8000-000000000014', 'Battery', 'High capacity rechargeable Li-ion', 4),
('spc00001-0000-4000-8000-000000000063', 'p0010001-0000-4000-8000-000000000015', 'Design', 'Integrated cable-free pen body', 1),
('spc00001-0000-4000-8000-000000000064', 'p0010001-0000-4000-8000-000000000015', 'Display', 'High-contrast OLED', 2),
('spc00001-0000-4000-8000-000000000065', 'p0010001-0000-4000-8000-000000000015', 'Accuracy', '+/- 6 HLD', 3),
('spc00001-0000-4000-8000-000000000066', 'p0010001-0000-4000-8000-000000000015', 'Battery', 'Rechargeable Li-poly via Micro-USB', 4),
('spc00001-0000-4000-8000-000000000067', 'p0010001-0000-4000-8000-000000000015', 'Dimensions', '145 x 35 x 28 mm', 5),
('spc00001-0000-4000-8000-000000000068', 'p0010001-0000-4000-8000-000000000016', 'Method', 'Ultrasonic Contact Impedance (UCI) per ASTM A1038', 1),
('spc00001-0000-4000-8000-000000000069', 'p0010001-0000-4000-8000-000000000016', 'Test Load', '10N (1 kgf), 50N (5 kgf), or 98N (10 kgf) probe', 2),
('spc00001-0000-4000-8000-000000000070', 'p0010001-0000-4000-8000-000000000016', 'Indenter', 'Vickers diamond 136 degree', 3),
('spc00001-0000-4000-8000-000000000071', 'p0010001-0000-4000-8000-000000000016', 'Measuring Scales', 'HV, HRC, HB, HRB, MPa', 4),
('spc00001-0000-4000-8000-000000000072', 'p0010001-0000-4000-8000-000000000017', 'Parameters', 'Ra, Rz, Rq, Rt, Rp, Rv, R3z, Rsk, Rku, Rmax', 1),
('spc00001-0000-4000-8000-000000000073', 'p0010001-0000-4000-8000-000000000017', 'Traversing Length', 'Up to 17.5 mm', 2),
('spc00001-0000-4000-8000-000000000074', 'p0010001-0000-4000-8000-000000000017', 'Stylus', 'Diamond 90 degree / 5 um radius', 3),
('spc00001-0000-4000-8000-000000000075', 'p0010001-0000-4000-8000-000000000017', 'Conforms To', 'ISO 4287, DIN 4768, ANSI B46.1, JIS B601', 4),
('spc00001-0000-4000-8000-000000000076', 'p0010001-0000-4000-8000-000000000018', 'Parameters', 'Ra, Rz, Rq, Rt', 1),
('spc00001-0000-4000-8000-000000000077', 'p0010001-0000-4000-8000-000000000018', 'Measuring Range', 'Ra: 0.05 - 10.0 um, Rz: 0.1 - 50 um', 2),
('spc00001-0000-4000-8000-000000000078', 'p0010001-0000-4000-8000-000000000018', 'Cut-off Lengths', '0.25 mm, 0.8 mm, 2.5 mm', 3),
('spc00001-0000-4000-8000-000000000079', 'p0010001-0000-4000-8000-000000000018', 'Filter', 'RC, PC-RC, GAUSS, D-P', 4),
('spc00001-0000-4000-8000-000000000080', 'p0010001-0000-4000-8000-000000000019', 'Range', '0 - 1000 um (0 - 40 mils)', 1),
('spc00001-0000-4000-8000-000000000081', 'p0010001-0000-4000-8000-000000000019', 'Accuracy', '+/- 2 um', 2),
('spc00001-0000-4000-8000-000000000082', 'p0010001-0000-4000-8000-000000000019', 'Tip Angle', '60 degrees conical tungsten carbide tip', 3),
('spc00001-0000-4000-8000-000000000083', 'p0010001-0000-4000-8000-000000000019', 'Standards', 'ASTM D4417-B, SSPC-PA 17, ISO 8503-5', 4),
('spc00001-0000-4000-8000-000000000084', 'p0010001-0000-4000-8000-000000000020', 'Range', '0 - 750 um', 1),
('spc00001-0000-4000-8000-000000000085', 'p0010001-0000-4000-8000-000000000020', 'Resolution', '1 um / 0.05 mil', 2),
('spc00001-0000-4000-8000-000000000086', 'p0010001-0000-4000-8000-000000000020', 'Operating Temp', '0 to 50 deg C', 3),
('spc00001-0000-4000-8000-000000000087', 'p0010001-0000-4000-8000-000000000020', 'Calibration', 'Glass zero plate included', 4),
('spc00001-0000-4000-8000-000000000088', 'p0010001-0000-4000-8000-000000000021', 'Power Input', '220V AC 50/60Hz', 1),
('spc00001-0000-4000-8000-000000000089', 'p0010001-0000-4000-8000-000000000021', 'Lifting Power', '>= 4.5 kg (AC) / >= 18 kg (DC)', 2),
('spc00001-0000-4000-8000-000000000090', 'p0010001-0000-4000-8000-000000000021', 'Pole Spacing', '0 - 210 mm', 3),
('spc00001-0000-4000-8000-000000000091', 'p0010001-0000-4000-8000-000000000021', 'Duty Cycle', '50%', 4),
('spc00001-0000-4000-8000-000000000092', 'p0010001-0000-4000-8000-000000000022', 'Modes', 'Selectable AC / DC', 1),
('spc00001-0000-4000-8000-000000000093', 'p0010001-0000-4000-8000-000000000022', 'AC Lifting Force', '>= 4.5 kg', 2),
('spc00001-0000-4000-8000-000000000094', 'p0010001-0000-4000-8000-000000000022', 'DC Lifting Force', '>= 18.1 kg', 3),
('spc00001-0000-4000-8000-000000000095', 'p0010001-0000-4000-8000-000000000022', 'Standards', 'ASTM E709, ASTM E1444, ASME Section V', 4),
('spc00001-0000-4000-8000-000000000096', 'p0010001-0000-4000-8000-000000000023', 'Lifting Power', '>= 18 kg (exceeds ASTM requirements)', 1),
('spc00001-0000-4000-8000-000000000097', 'p0010001-0000-4000-8000-000000000023', 'Magnet Type', 'High-coercivity NdFeB permanent magnets', 2),
('spc00001-0000-4000-8000-000000000098', 'p0010001-0000-4000-8000-000000000023', 'Pole Distance', '50 - 250 mm adjustable', 3),
('spc00001-0000-4000-8000-000000000099', 'p0010001-0000-4000-8000-000000000023', 'Power Requirement', 'None (100% passive)', 4),
('spc00001-0000-4000-8000-000000000100', 'p0010001-0000-4000-8000-000000000024', 'Input Voltage', '220V 50Hz / 110V 60Hz', 1),
('spc00001-0000-4000-8000-000000000101', 'p0010001-0000-4000-8000-000000000024', 'Current', '2.8A', 2),
('spc00001-0000-4000-8000-000000000102', 'p0010001-0000-4000-8000-000000000024', 'Lifting Capacity', 'AC >= 5 kg, DC >= 18 kg', 3),
('spc00001-0000-4000-8000-000000000103', 'p0010001-0000-4000-8000-000000000024', 'Cable Length', '3.0 meters oil-resistant cord', 4),
('spc00001-0000-4000-8000-000000000104', 'p0010001-0000-4000-8000-000000000025', 'Integrated Lighting', '365 nm UV-A LED (>2000 uW/cm2 at 15cm)', 1),
('spc00001-0000-4000-8000-000000000105', 'p0010001-0000-4000-8000-000000000025', 'Lifting Power', '>= 4.5 kg', 2),
('spc00001-0000-4000-8000-000000000106', 'p0010001-0000-4000-8000-000000000025', 'Pole Center Distance', '0 - 200 mm', 3),
('spc00001-0000-4000-8000-000000000107', 'p0010001-0000-4000-8000-000000000025', 'Duty Cycle', '50%', 4),
('spc00001-0000-4000-8000-000000000108', 'p0010001-0000-4000-8000-000000000026', 'Built-in Illumination', 'White LED (>1000 Lux on test zone)', 1),
('spc00001-0000-4000-8000-000000000109', 'p0010001-0000-4000-8000-000000000026', 'Lifting Power', '>= 4.5 kg', 2),
('spc00001-0000-4000-8000-000000000110', 'p0010001-0000-4000-8000-000000000026', 'Input', 'AC 220V / 110V', 3),
('spc00001-0000-4000-8000-000000000111', 'p0010001-0000-4000-8000-000000000026', 'Leg Articulation', 'Double-jointed swivel', 4),
('spc00001-0000-4000-8000-000000000112', 'p0010001-0000-4000-8000-000000000027', 'Voltage', '220V AC 50Hz', 1),
('spc00001-0000-4000-8000-000000000113', 'p0010001-0000-4000-8000-000000000027', 'Lifting Capacity', '>= 4.5 kg (10 lbs)', 2),
('spc00001-0000-4000-8000-000000000114', 'p0010001-0000-4000-8000-000000000027', 'Pole Pitch', '25 - 230 mm', 3),
('spc00001-0000-4000-8000-000000000115', 'p0010001-0000-4000-8000-000000000027', 'Duty Cycle', '50% (2 min on / 2 min off)', 4),
('spc00001-0000-4000-8000-000000000116', 'p0010001-0000-4000-8000-000000000028', 'Power', '110V / 220V AC', 1),
('spc00001-0000-4000-8000-000000000117', 'p0010001-0000-4000-8000-000000000028', 'Lifting Power', '>= 4.5 kg', 2),
('spc00001-0000-4000-8000-000000000118', 'p0010001-0000-4000-8000-000000000028', 'Weight', '2.5 kg lightweight design', 3),
('spc00001-0000-4000-8000-000000000119', 'p0010001-0000-4000-8000-000000000028', 'Pole Spacing', '0 - 180 mm', 4),
('spc00001-0000-4000-8000-000000000120', 'p0010001-0000-4000-8000-000000000029', 'Internal Diameter', '150 mm / 200 mm / 300 mm available', 1),
('spc00001-0000-4000-8000-000000000121', 'p0010001-0000-4000-8000-000000000029', 'Ampere Turns', '>= 4500 AT', 2),
('spc00001-0000-4000-8000-000000000122', 'p0010001-0000-4000-8000-000000000029', 'Operation Mode', 'Continuous / Intermittent pulsed', 3),
('spc00001-0000-4000-8000-000000000123', 'p0010001-0000-4000-8000-000000000029', 'Duty Cycle', '25%', 4),
('spc00001-0000-4000-8000-000000000124', 'p0010001-0000-4000-8000-000000000030', 'Output Voltage', '120 - 300 kV continuously adjustable', 1),
('spc00001-0000-4000-8000-000000000125', 'p0010001-0000-4000-8000-000000000030', 'Tube Current', '5 mA', 2),
('spc00001-0000-4000-8000-000000000126', 'p0010001-0000-4000-8000-000000000030', 'Penetration (Steel)', 'Up to 50 mm (A3 steel, density >= 1.5)', 3),
('spc00001-0000-4000-8000-000000000127', 'p0010001-0000-4000-8000-000000000030', 'Focal Spot', '2.0 x 2.0 mm', 4),
('spc00001-0000-4000-8000-000000000128', 'p0010001-0000-4000-8000-000000000030', 'Beam Angle', '40 + 5 degrees directional', 5),
('spc00001-0000-4000-8000-000000000129', 'p0010001-0000-4000-8000-000000000031', 'Voltage Range', '100 - 250 kV', 1),
('spc00001-0000-4000-8000-000000000130', 'p0010001-0000-4000-8000-000000000031', 'Current', '5 mA', 2),
('spc00001-0000-4000-8000-000000000131', 'p0010001-0000-4000-8000-000000000031', 'Max Penetration', '39 mm steel', 3),
('spc00001-0000-4000-8000-000000000132', 'p0010001-0000-4000-8000-000000000031', 'Cooling', 'Forced air cooling', 4),
('spc00001-0000-4000-8000-000000000133', 'p0010001-0000-4000-8000-000000000031', 'Insulation', 'SF6 Gas 0.35 - 0.45 MPa', 5),
('spc00001-0000-4000-8000-000000000134', 'p0010001-0000-4000-8000-000000000032', 'Beam Geometry', '360 x (25-30) degrees panoramic conical beam', 1),
('spc00001-0000-4000-8000-000000000135', 'p0010001-0000-4000-8000-000000000032', 'Voltage', '160 - 300 kV', 2),
('spc00001-0000-4000-8000-000000000136', 'p0010001-0000-4000-8000-000000000032', 'Penetration', '45 mm steel', 3),
('spc00001-0000-4000-8000-000000000137', 'p0010001-0000-4000-8000-000000000032', 'Controller', 'Digital programmable timer and kV control', 4),
('spc00001-0000-4000-8000-000000000138', 'p0010001-0000-4000-8000-000000000033', 'Pipe Diameter', '200 - 450 mm', 1),
('spc00001-0000-4000-8000-000000000139', 'p0010001-0000-4000-8000-000000000033', 'Drive', '4-wheel DC motor drive with regenerative braking', 2),
('spc00001-0000-4000-8000-000000000140', 'p0010001-0000-4000-8000-000000000033', 'Positioning', 'Magnetic / Isotope sensor positioning accuracy +/- 5 mm', 3),
('spc00001-0000-4000-8000-000000000141', 'p0010001-0000-4000-8000-000000000033', 'Operating Range', 'Up to 3 km inside pipe', 4),
('spc00001-0000-4000-8000-000000000142', 'p0010001-0000-4000-8000-000000000034', 'Pipe Diameter', '400 - 800 mm', 1),
('spc00001-0000-4000-8000-000000000143', 'p0010001-0000-4000-8000-000000000034', 'X-Ray Tube Compatibility', '200 - 250 kV Panoramic tubes', 2),
('spc00001-0000-4000-8000-000000000144', 'p0010001-0000-4000-8000-000000000034', 'Speed', 'Up to 18 m/min', 3),
('spc00001-0000-4000-8000-000000000145', 'p0010001-0000-4000-8000-000000000034', 'Battery Capacity', 'Panasonic Lead-acid or LiFePO4 packs', 4),
('spc00001-0000-4000-8000-000000000146', 'p0010001-0000-4000-8000-000000000035', 'Pipe Diameter', '600 - 1200 mm', 1),
('spc00001-0000-4000-8000-000000000147', 'p0010001-0000-4000-8000-000000000035', 'Climbing Ability', 'Up to 40 degrees slope', 2),
('spc00001-0000-4000-8000-000000000148', 'p0010001-0000-4000-8000-000000000035', 'Compatible Tubes', 'Up to 300 kV panoramic generators', 3),
('spc00001-0000-4000-8000-000000000149', 'p0010001-0000-4000-8000-000000000035', 'Safety Features', 'Obstacle sensor, water sensor, auto-retrieval', 4),
('spc00001-0000-4000-8000-000000000150', 'p0010001-0000-4000-8000-000000000036', 'Pipe Diameter', '800 - 1400 mm', 1),
('spc00001-0000-4000-8000-000000000151', 'p0010001-0000-4000-8000-000000000036', 'Drive Mechanism', 'Independent 4-wheel torque drive', 2),
('spc00001-0000-4000-8000-000000000152', 'p0010001-0000-4000-8000-000000000036', 'Battery System', 'High-discharge modular battery pack', 3),
('spc00001-0000-4000-8000-000000000153', 'p0010001-0000-4000-8000-000000000036', 'Control', 'External isotope/magnetic command system', 4),
('spc00001-0000-4000-8000-000000000154', 'p0010001-0000-4000-8000-000000000037', 'Pipe Diameter', '1000 - 1600 mm', 1),
('spc00001-0000-4000-8000-000000000155', 'p0010001-0000-4000-8000-000000000037', 'Drive Power', 'Dual high-torque brushless DC motors', 2),
('spc00001-0000-4000-8000-000000000156', 'p0010001-0000-4000-8000-000000000037', 'Operating Temperature', '-30 to +60 deg C', 3),
('spc00001-0000-4000-8000-000000000157', 'p0010001-0000-4000-8000-000000000037', 'Speed', 'Adjustable 10 - 20 m/min', 4),
('spc00001-0000-4000-8000-000000000158', 'p0010001-0000-4000-8000-000000000038', 'Maximum Luminance', '>= 130,000 cd/m2 (density D >= 4.5 viewable)', 1),
('spc00001-0000-4000-8000-000000000159', 'p0010001-0000-4000-8000-000000000038', 'Built-in Densitometer', 'Range: 0.00 - 5.00 D, Accuracy: +/- 0.02 D', 2),
('spc00001-0000-4000-8000-000000000160', 'p0010001-0000-4000-8000-000000000038', 'Viewing Window', '220 x 80 mm (custom masks included)', 3),
('spc00001-0000-4000-8000-000000000161', 'p0010001-0000-4000-8000-000000000038', 'Cooling', 'Ultra-quiet PWM cooling fan', 4),
('spc00001-0000-4000-8000-000000000162', 'p0010001-0000-4000-8000-000000000039', 'Luminance', '>= 110,000 cd/m2', 1),
('spc00001-0000-4000-8000-000000000163', 'p0010001-0000-4000-8000-000000000039', 'Densitometer Range', '0.00 - 4.50 D', 2),
('spc00001-0000-4000-8000-000000000164', 'p0010001-0000-4000-8000-000000000039', 'Window Size', '200 x 60 mm', 3),
('spc00001-0000-4000-8000-000000000165', 'p0010001-0000-4000-8000-000000000039', 'Power', '100 - 240V AC universal', 4),
('spc00001-0000-4000-8000-000000000166', 'p0010001-0000-4000-8000-000000000040', 'Max Luminance', '>= 130,000 cd/m2', 1),
('spc00001-0000-4000-8000-000000000167', 'p0010001-0000-4000-8000-000000000040', 'Uniformity', '>= 95% across viewing area', 2),
('spc00001-0000-4000-8000-000000000168', 'p0010001-0000-4000-8000-000000000040', 'Dimming', 'Stepless rotary control 5% - 100%', 3),
('spc00001-0000-4000-8000-000000000169', 'p0010001-0000-4000-8000-000000000040', 'LED Lifespan', '>= 50,000 hours', 4),
('spc00001-0000-4000-8000-000000000170', 'p0010001-0000-4000-8000-000000000041', 'Luminance', '>= 105,000 cd/m2', 1),
('spc00001-0000-4000-8000-000000000171', 'p0010001-0000-4000-8000-000000000041', 'Viewing Window', '220 x 75 mm', 2),
('spc00001-0000-4000-8000-000000000172', 'p0010001-0000-4000-8000-000000000041', 'Thickness', 'Only 38 mm ultra-thin profile', 3),
('spc00001-0000-4000-8000-000000000173', 'p0010001-0000-4000-8000-000000000041', 'Control', 'Touch sensor and foot pedal', 4),
('spc00001-0000-4000-8000-000000000174', 'p0010001-0000-4000-8000-000000000042', 'Max Luminance', '>= 100,000 cd/m2', 1),
('spc00001-0000-4000-8000-000000000175', 'p0010001-0000-4000-8000-000000000042', 'Window', '200 x 60 mm', 2),
('spc00001-0000-4000-8000-000000000176', 'p0010001-0000-4000-8000-000000000042', 'Power Supply', '100-240V AC', 3),
('spc00001-0000-4000-8000-000000000177', 'p0010001-0000-4000-8000-000000000042', 'Standards', 'ISO 5580, ASTM E1390', 4),
('spc00001-0000-4000-8000-000000000178', 'p0010001-0000-4000-8000-000000000043', 'Frequency Range', '10 Hz - 10 MHz continuous', 1),
('spc00001-0000-4000-8000-000000000179', 'p0010001-0000-4000-8000-000000000043', 'Gain', '0 - 99.9 dB (0.1 dB step)', 2),
('spc00001-0000-4000-8000-000000000180', 'p0010001-0000-4000-8000-000000000043', 'Phase Rotation', '0 - 359 degrees', 3),
('spc00001-0000-4000-8000-000000000181', 'p0010001-0000-4000-8000-000000000043', 'Display Modes', 'Impedance plane, time base sweep, spot', 4),
('spc00001-0000-4000-8000-000000000182', 'p0010001-0000-4000-8000-000000000043', 'Battery', 'Rechargeable Lithium pack, >8 hours', 5),
('spc00001-0000-4000-8000-000000000183', 'p0010001-0000-4000-8000-000000000044', 'Frequencies', 'Dual independent frequencies (50 Hz - 6 MHz)', 1),
('spc00001-0000-4000-8000-000000000184', 'p0010001-0000-4000-8000-000000000044', 'Display', 'Color TFT LCD', 2),
('spc00001-0000-4000-8000-000000000185', 'p0010001-0000-4000-8000-000000000044', 'Storage', '1000 setups and inspection files', 3),
('spc00001-0000-4000-8000-000000000186', 'p0010001-0000-4000-8000-000000000044', 'Probe Compatibility', 'Absolute, Differential, Reflection probes', 4),
('spc00001-0000-4000-8000-000000000187', 'p0010001-0000-4000-8000-000000000045', 'Operating Frequency', '60 kHz (standard aerospace) & 500 kHz options', 1),
('spc00001-0000-4000-8000-000000000188', 'p0010001-0000-4000-8000-000000000045', 'Measuring Range', '0.8% IACS - 110% IACS (0.45 - 64 MS/m)', 2),
('spc00001-0000-4000-8000-000000000189', 'p0010001-0000-4000-8000-000000000045', 'Resolution', '0.01% IACS', 3),
('spc00001-0000-4000-8000-000000000190', 'p0010001-0000-4000-8000-000000000045', 'Accuracy', '+/- 0.5% of reading at 20 deg C', 4),
('spc00001-0000-4000-8000-000000000191', 'p0010001-0000-4000-8000-000000000045', 'Lift-off Compensation', 'Up to 0.5 mm', 5),
('spc00001-0000-4000-8000-000000000192', 'p0010001-0000-4000-8000-000000000046', 'Conductivity Range', '0.9% - 110% IACS', 1),
('spc00001-0000-4000-8000-000000000193', 'p0010001-0000-4000-8000-000000000046', 'Temperature Sensor', 'Built-in probe thermistor for automatic compensation', 2),
('spc00001-0000-4000-8000-000000000194', 'p0010001-0000-4000-8000-000000000046', 'Display', 'Backlit LCD', 3),
('spc00001-0000-4000-8000-000000000195', 'p0010001-0000-4000-8000-000000000046', 'Battery', 'Rechargeable Li-ion', 4),
('spc00001-0000-4000-8000-000000000196', 'p0010001-0000-4000-8000-000000000047', 'Camera Head', 'Diameter 50 mm, 360 pan / 180 tilt', 1),
('spc00001-0000-4000-8000-000000000197', 'p0010001-0000-4000-8000-000000000047', 'Cable Length', '50 meters (up to 120m optional)', 2),
('spc00001-0000-4000-8000-000000000198', 'p0010001-0000-4000-8000-000000000047', 'Waterproof Rating', 'IP68 submersible to 10 meters', 3),
('spc00001-0000-4000-8000-000000000199', 'p0010001-0000-4000-8000-000000000047', 'Display', '10-inch HD color monitor with sunshield', 4),
('spc00001-0000-4000-8000-000000000200', 'p0010001-0000-4000-8000-000000000047', 'Lighting', 'High-intensity adjustable white LEDs', 5),
('spc00001-0000-4000-8000-000000000201', 'p0010001-0000-4000-8000-000000000048', 'Probe Diameters', '3.9 mm or 6.0 mm', 1),
('spc00001-0000-4000-8000-000000000202', 'p0010001-0000-4000-8000-000000000048', 'Articulation', '4-way 360-degree joystick articulation (>160 degrees bend)', 2),
('spc00001-0000-4000-8000-000000000203', 'p0010001-0000-4000-8000-000000000048', 'Probe Length', '1.5 m, 2.0 m, 3.0 m options', 3),
('spc00001-0000-4000-8000-000000000204', 'p0010001-0000-4000-8000-000000000048', 'Display', '5.0-inch IPS HD touchscreen', 4),
('spc00001-0000-4000-8000-000000000205', 'p0010001-0000-4000-8000-000000000048', 'Tube Material', 'Tungsten wire mesh braid', 5),
('spc00001-0000-4000-8000-000000000206', 'p0010001-0000-4000-8000-000000000049', 'Self-leveling', 'Always upright image sensor', 1),
('spc00001-0000-4000-8000-000000000207', 'p0010001-0000-4000-8000-000000000049', 'Sonde Transmitter', 'Built-in 512 Hz sonde for locator tracking', 2),
('spc00001-0000-4000-8000-000000000208', 'p0010001-0000-4000-8000-000000000049', 'Storage', 'SD card slot up to 64GB', 3),
('spc00001-0000-4000-8000-000000000209', 'p0010001-0000-4000-8000-000000000049', 'Battery', '6600mAh Li-ion, >6 hours', 4),
('spc00001-0000-4000-8000-000000000210', 'p0010001-0000-4000-8000-000000000050', 'Peak Wavelength', '365 nm +/- 5 nm', 1),
('spc00001-0000-4000-8000-000000000211', 'p0010001-0000-4000-8000-000000000050', 'UV-A Intensity', '>= 6,000 uW/cm2 at 38 cm (15 in)', 2),
('spc00001-0000-4000-8000-000000000212', 'p0010001-0000-4000-8000-000000000050', 'Visible Light Emission', '< 10 Lux (< 1 foot-candle)', 3),
('spc00001-0000-4000-8000-000000000213', 'p0010001-0000-4000-8000-000000000050', 'Standards', 'ASTM E3022, Rolls-Royce RRES 90061, ISO 3059', 4),
('spc00001-0000-4000-8000-000000000214', 'p0010001-0000-4000-8000-000000000051', 'Output Variants', '4000+, 6000+, 8000+, 10000+ uW/cm2', 1),
('spc00001-0000-4000-8000-000000000215', 'p0010001-0000-4000-8000-000000000051', 'Beam Diameter', '>= 180 mm effective coverage at 38 cm', 2),
('spc00001-0000-4000-8000-000000000216', 'p0010001-0000-4000-8000-000000000051', 'White Light Mode', 'Integrated white LED for general illumination', 3),
('spc00001-0000-4000-8000-000000000217', 'p0010001-0000-4000-8000-000000000051', 'Power', 'Corded AC or hot-swappable Li-ion batteries', 4),
('spc00001-0000-4000-8000-000000000218', 'p0010001-0000-4000-8000-000000000052', 'Filter Type', 'Integrated black light band-pass filter', 1),
('spc00001-0000-4000-8000-000000000219', 'p0010001-0000-4000-8000-000000000052', 'Wavelength', '365 nm', 2),
('spc00001-0000-4000-8000-000000000220', 'p0010001-0000-4000-8000-000000000052', 'Battery Run Time', '4.5 hours continuous', 3),
('spc00001-0000-4000-8000-000000000221', 'p0010001-0000-4000-8000-000000000052', 'Cooling', 'Fanless passive convection (silent)', 4),
('spc00001-0000-4000-8000-000000000222', 'p0010001-0000-4000-8000-000000000053', 'Coverage Area', '600 x 400 mm at 38 cm', 1),
('spc00001-0000-4000-8000-000000000223', 'p0010001-0000-4000-8000-000000000053', 'UV-A Intensity', '>= 4,500 uW/cm2 uniform', 2),
('spc00001-0000-4000-8000-000000000224', 'p0010001-0000-4000-8000-000000000053', 'Mounting', 'Overhead adjustable bracket', 3),
('spc00001-0000-4000-8000-000000000225', 'p0010001-0000-4000-8000-000000000053', 'Input Power', '100-240V AC 50/60Hz, 80W', 4),
('spc00001-0000-4000-8000-000000000226', 'p0010001-0000-4000-8000-000000000054', 'Wavelength', '365 nm', 1),
('spc00001-0000-4000-8000-000000000227', 'p0010001-0000-4000-8000-000000000054', 'Intensity', '>= 3,500 uW/cm2 at 38 cm', 2),
('spc00001-0000-4000-8000-000000000228', 'p0010001-0000-4000-8000-000000000054', 'Mounting', 'Universal hard hat / helmet clip and headband', 3),
('spc00001-0000-4000-8000-000000000229', 'p0010001-0000-4000-8000-000000000054', 'Battery', 'Belt-mounted Li-ion pack, >6 hrs', 4),
('spc00001-0000-4000-8000-000000000230', 'p0010001-0000-4000-8000-000000000055', 'Trigger', 'Pistol-grip momentary/latching trigger', 1),
('spc00001-0000-4000-8000-000000000231', 'p0010001-0000-4000-8000-000000000055', 'Wavelength', '365 nm', 2),
('spc00001-0000-4000-8000-000000000232', 'p0010001-0000-4000-8000-000000000055', 'Intensity', '>= 5,000 uW/cm2', 3),
('spc00001-0000-4000-8000-000000000233', 'p0010001-0000-4000-8000-000000000055', 'Battery', 'Internal rechargeable 18650 Li-ion', 4),
('spc00001-0000-4000-8000-000000000234', 'p0010001-0000-4000-8000-000000000056', 'Output', 'Up to 40,000 uW/cm2 at high-power mode', 1),
('spc00001-0000-4000-8000-000000000235', 'p0010001-0000-4000-8000-000000000056', 'Beam Pattern', 'Wide homogeneous circular beam', 2),
('spc00001-0000-4000-8000-000000000236', 'p0010001-0000-4000-8000-000000000056', 'Tripod Mount', 'Standard 1/4-inch UNC socket', 3),
('spc00001-0000-4000-8000-000000000237', 'p0010001-0000-4000-8000-000000000056', 'Protection', 'IP65 waterproof', 4),
('spc00001-0000-4000-8000-000000000238', 'p0010001-0000-4000-8000-000000000057', 'Rope Diameter Range', '6 - 70 mm (selectable sensor heads)', 1),
('spc00001-0000-4000-8000-000000000239', 'p0010001-0000-4000-8000-000000000057', 'Testing Speed', '0 - 3 m/s', 2),
('spc00001-0000-4000-8000-000000000240', 'p0010001-0000-4000-8000-000000000057', 'Defect Types', 'LF (Local Faults / Broken Wires) & LMA (Loss of Metallic Area)', 3),
('spc00001-0000-4000-8000-000000000241', 'p0010001-0000-4000-8000-000000000057', 'Sensors', 'Hall effect array with rare-earth permanent magnets', 4),
('spc00001-0000-4000-8000-000000000242', 'p0010001-0000-4000-8000-000000000058', 'Voltage Settings', '9V, 67.5V, 90V selectable', 1),
('spc00001-0000-4000-8000-000000000243', 'p0010001-0000-4000-8000-000000000058', 'Coating Thickness', 'Up to 500 um (20 mils)', 2),
('spc00001-0000-4000-8000-000000000244', 'p0010001-0000-4000-8000-000000000058', 'Alarm', 'Audible buzzer and bright LED indicator', 3),
('spc00001-0000-4000-8000-000000000245', 'p0010001-0000-4000-8000-000000000058', 'Sponge', 'Rectangular open-cell cellulose sponge wand', 4),
('spc00001-0000-4000-8000-000000000246', 'p0010001-0000-4000-8000-000000000059', 'Output Voltage', '0.5 - 35 kV continuously adjustable', 1),
('spc00001-0000-4000-8000-000000000247', 'p0010001-0000-4000-8000-000000000059', 'Thickness Range', '0.05 - 10 mm', 2),
('spc00001-0000-4000-8000-000000000248', 'p0010001-0000-4000-8000-000000000059', 'Display', 'Digital output voltage LCD', 3),
('spc00001-0000-4000-8000-000000000249', 'p0010001-0000-4000-8000-000000000059', 'Electrodes', 'Rolling spring electrode, brass wire brush, conductive rubber', 4),
('spc00001-0000-4000-8000-000000000250', 'p0010001-0000-4000-8000-000000000060', 'Voltage Range', '0.6 - 30 kV DC', 1),
('spc00001-0000-4000-8000-000000000251', 'p0010001-0000-4000-8000-000000000060', 'Resolution', '0.1 kV', 2),
('spc00001-0000-4000-8000-000000000252', 'p0010001-0000-4000-8000-000000000060', 'Standards', 'NACE SP0188, ASTM D5162, ISO 29601', 3),
('spc00001-0000-4000-8000-000000000253', 'p0010001-0000-4000-8000-000000000060', 'Battery', 'Internal lithium battery pack, 10 hours runtime', 4),
('spc00001-0000-4000-8000-000000000254', 'p0010001-0000-4000-8000-000000000061', 'Range', '0 - 50,000 Lux (3 ranges)', 1),
('spc00001-0000-4000-8000-000000000255', 'p0010001-0000-4000-8000-000000000061', 'Accuracy', '+/- 4% rdg + 0.5% f.s.', 2),
('spc00001-0000-4000-8000-000000000256', 'p0010001-0000-4000-8000-000000000061', 'Sensor', 'Silicon photodiode with color correction filter', 3),
('spc00001-0000-4000-8000-000000000257', 'p0010001-0000-4000-8000-000000000061', 'Sampling Rate', '2.0 times per second', 4),
('spc00001-0000-4000-8000-000000000258', 'p0010001-0000-4000-8000-000000000062', 'Range', '0.1 - 100,000 Lux', 1),
('spc00001-0000-4000-8000-000000000259', 'p0010001-0000-4000-8000-000000000062', 'Accuracy', '+/- 3%', 2),
('spc00001-0000-4000-8000-000000000260', 'p0010001-0000-4000-8000-000000000062', 'Functions', 'Data hold, auto zeroing', 3),
('spc00001-0000-4000-8000-000000000261', 'p0010001-0000-4000-8000-000000000062', 'Display', 'Large 3 1/2 digit LCD', 4),
('spc00001-0000-4000-8000-000000000262', 'p0010001-0000-4000-8000-000000000063', 'Range', '0.1 - 200,000 Lux / 0.01 - 20,000 fc', 1),
('spc00001-0000-4000-8000-000000000263', 'p0010001-0000-4000-8000-000000000063', 'Accuracy', '+/- 3% rdg', 2),
('spc00001-0000-4000-8000-000000000264', 'p0010001-0000-4000-8000-000000000063', 'Peak Hold', 'Captures transient lighting pulses', 3),
('spc00001-0000-4000-8000-000000000265', 'p0010001-0000-4000-8000-000000000063', 'Standards', 'CIE photopic curve compliant', 4),
('spc00001-0000-4000-8000-000000000266', 'p0010001-0000-4000-8000-000000000064', 'Spectral Sensitivity', '320 - 400 nm (Peak 365 nm)', 1),
('spc00001-0000-4000-8000-000000000267', 'p0010001-0000-4000-8000-000000000064', 'Irradiance Range', '0 - 19,990 uW/cm2 (0 - 199.9 W/m2)', 2),
('spc00001-0000-4000-8000-000000000268', 'p0010001-0000-4000-8000-000000000064', 'Accuracy', '+/- 4% (+/- 1 digit)', 3),
('spc00001-0000-4000-8000-000000000269', 'p0010001-0000-4000-8000-000000000064', 'Calibration', 'NIST-traceable factory calibration certificate', 4),
('spc00001-0000-4000-8000-000000000270', 'p0010001-0000-4000-8000-000000000065', 'Standards', 'EN ISO 2400, ASTM E164, BS 2704', 1),
('spc00001-0000-4000-8000-000000000271', 'p0010001-0000-4000-8000-000000000065', 'Material Options', '1018 Carbon Steel, 304/316 Stainless Steel, 7075 Aluminum', 2),
('spc00001-0000-4000-8000-000000000272', 'p0010001-0000-4000-8000-000000000065', 'Radii', 'R100 mm and R25 mm reference arcs', 3),
('spc00001-0000-4000-8000-000000000273', 'p0010001-0000-4000-8000-000000000065', 'Holes', '1.5 mm diameter transverse hole and plastic insert', 4),
('spc00001-0000-4000-8000-000000000274', 'p0010001-0000-4000-8000-000000000066', 'Standards', 'DIN 54122, ISO 7963, BS 2704 A4', 1),
('spc00001-0000-4000-8000-000000000275', 'p0010001-0000-4000-8000-000000000066', 'Thickness', '12.5 mm or 20 mm options', 2),
('spc00001-0000-4000-8000-000000000276', 'p0010001-0000-4000-8000-000000000066', 'Radii', 'R25 mm and R50 mm cylindrical surfaces', 3),
('spc00001-0000-4000-8000-000000000277', 'p0010001-0000-4000-8000-000000000066', 'Calibration Target', '5.0 mm through hole', 4),
('spc00001-0000-4000-8000-000000000278', 'p0010001-0000-4000-8000-000000000067', 'Step Configurations', '4-step (2.5, 5.0, 7.5, 10.0 mm) or 5-step (2.5, 5, 10, 15, 20 mm)', 1),
('spc00001-0000-4000-8000-000000000279', 'p0010001-0000-4000-8000-000000000067', 'Tolerance', '+/- 0.02 mm on all steps', 2),
('spc00001-0000-4000-8000-000000000280', 'p0010001-0000-4000-8000-000000000067', 'Materials', '1018 Steel, 316L Stainless, 6061-T6 Aluminum, Brass', 3),
('spc00001-0000-4000-8000-000000000281', 'p0010001-0000-4000-8000-000000000067', 'Case', 'Hardwood storage case included', 4),
('spc00001-0000-4000-8000-000000000282', 'p0010001-0000-4000-8000-000000000068', 'Curvature', 'Radiused to pipe OD specifications', 1),
('spc00001-0000-4000-8000-000000000283', 'p0010001-0000-4000-8000-000000000068', 'Steps', '4 steps or 5 steps custom stepped', 2),
('spc00001-0000-4000-8000-000000000284', 'p0010001-0000-4000-8000-000000000068', 'Tolerance', '+/- 0.02 mm', 3),
('spc00001-0000-4000-8000-000000000285', 'p0010001-0000-4000-8000-000000000068', 'Certificate', 'Individual dimensional calibration report', 4),
('spc00001-0000-4000-8000-000000000286', 'p0010001-0000-4000-8000-000000000069', 'Standard', 'ASME Section V Article 4', 1),
('spc00001-0000-4000-8000-000000000287', 'p0010001-0000-4000-8000-000000000069', 'Thickness', '19 mm (3/4 in) and 38 mm (1.5 in)', 2),
('spc00001-0000-4000-8000-000000000288', 'p0010001-0000-4000-8000-000000000069', 'Notches', '2% depth EDM notches (ID & OD)', 3),
('spc00001-0000-4000-8000-000000000289', 'p0010001-0000-4000-8000-000000000069', 'Side Drilled Holes', 'Calibrated diameter SDH targets', 4),
('spc00001-0000-4000-8000-000000000290', 'p0010001-0000-4000-8000-000000000070', 'Standard', 'ASTM E164, ISO 2400', 1),
('spc00001-0000-4000-8000-000000000291', 'p0010001-0000-4000-8000-000000000070', 'Geometry', 'Modified cut-out with multiple reflection radii', 2),
('spc00001-0000-4000-8000-000000000292', 'p0010001-0000-4000-8000-000000000070', 'Material', '1018 Steel, Nickel plated', 3),
('spc00001-0000-4000-8000-000000000293', 'p0010001-0000-4000-8000-000000000070', 'Dimensions', '300 x 100 x 25 mm', 4),
('spc00001-0000-4000-8000-000000000294', 'p0010001-0000-4000-8000-000000000071', 'Standard', 'USAF Design / ASTM E164 equivalent', 1),
('spc00001-0000-4000-8000-000000000295', 'p0010001-0000-4000-8000-000000000071', 'Dimensions', '150 x 50 x 25 mm', 2),
('spc00001-0000-4000-8000-000000000296', 'p0010001-0000-4000-8000-000000000071', 'Weight', '0.9 kg', 3),
('spc00001-0000-4000-8000-000000000297', 'p0010001-0000-4000-8000-000000000071', 'Engraving', 'Laser marked beam angle and index scales', 4),
('spc00001-0000-4000-8000-000000000298', 'p0010001-0000-4000-8000-000000000072', 'Standard', 'AWS D1.1 / ASTM E164', 1),
('spc00001-0000-4000-8000-000000000299', 'p0010001-0000-4000-8000-000000000072', 'Radii', '1.0 in and 3.0 in radius reflection arcs', 2),
('spc00001-0000-4000-8000-000000000300', 'p0010001-0000-4000-8000-000000000072', 'Targets', '0.375 in deep x 0.032 in wide slot and 0.125 in through hole', 3),
('spc00001-0000-4000-8000-000000000301', 'p0010001-0000-4000-8000-000000000072', 'Thickness', '1.0 in (25.4 mm)', 4),
('spc00001-0000-4000-8000-000000000302', 'p0010001-0000-4000-8000-000000000073', 'Standard', 'AWS D1.1 / ASTM E164', 1),
('spc00001-0000-4000-8000-000000000303', 'p0010001-0000-4000-8000-000000000073', 'Target Holes', 'Two 0.0625 in (1.59 mm) diameter through-holes', 2),
('spc00001-0000-4000-8000-000000000304', 'p0010001-0000-4000-8000-000000000073', 'Dimensions', '2.0 x 1.25 x 0.905 in', 3),
('spc00001-0000-4000-8000-000000000305', 'p0010001-0000-4000-8000-000000000073', 'Engraving', 'Sound path graduation markings', 4),
('spc00001-0000-4000-8000-000000000306', 'p0010001-0000-4000-8000-000000000074', 'Standard', 'AWS D1.1 Figure 6.22', 1),
('spc00001-0000-4000-8000-000000000307', 'p0010001-0000-4000-8000-000000000074', 'Targets', 'Two 1/16 in diameter holes', 2),
('spc00001-0000-4000-8000-000000000308', 'p0010001-0000-4000-8000-000000000074', 'Size', '2.0 x 2.0 x 6.0 in', 3),
('spc00001-0000-4000-8000-000000000309', 'p0010001-0000-4000-8000-000000000074', 'Markings', 'AWS reference depth indices', 4),
('spc00001-0000-4000-8000-000000000310', 'p0010001-0000-4000-8000-000000000075', 'Standard', 'AWS D1.1 Clause 6', 1),
('spc00001-0000-4000-8000-000000000311', 'p0010001-0000-4000-8000-000000000075', 'Targets', 'Sets of closely spaced 0.0625 in diameter holes for 45, 60, and 70 deg probes', 2),
('spc00001-0000-4000-8000-000000000312', 'p0010001-0000-4000-8000-000000000075', 'Dimensions', '6.0 x 3.0 x 1.0 in', 3),
('spc00001-0000-4000-8000-000000000313', 'p0010001-0000-4000-8000-000000000076', 'Standard', 'AWS D1.1 / ASTM E164', 1),
('spc00001-0000-4000-8000-000000000314', 'p0010001-0000-4000-8000-000000000076', 'Reflector', '1.0 in and 2.0 in radius cylindrical targets', 2),
('spc00001-0000-4000-8000-000000000315', 'p0010001-0000-4000-8000-000000000076', 'Dimensions', '2.0 in diameter curved wedge', 3),
('spc00001-0000-4000-8000-000000000316', 'p0010001-0000-4000-8000-000000000077', 'Standard', 'BS 2704 / Institute of Welding', 1),
('spc00001-0000-4000-8000-000000000317', 'p0010001-0000-4000-8000-000000000077', 'Targets', 'Series of 1.5 mm holes at depths from 2 to 24 mm', 2),
('spc00001-0000-4000-8000-000000000318', 'p0010001-0000-4000-8000-000000000077', 'Dimensions', '305 x 75 x 50 mm', 3),
('spc00001-0000-4000-8000-000000000319', 'p0010001-0000-4000-8000-000000000078', 'Reflector', 'R25 mm and R100 mm radius segments', 1),
('spc00001-0000-4000-8000-000000000320', 'p0010001-0000-4000-8000-000000000078', 'Thickness', '25 mm', 2),
('spc00001-0000-4000-8000-000000000321', 'p0010001-0000-4000-8000-000000000078', 'Dimensions', '100 x 50 x 25 mm', 3),
('spc00001-0000-4000-8000-000000000322', 'p0010001-0000-4000-8000-000000000079', 'Standard', 'ASTM E2491, ISO 19675', 1),
('spc00001-0000-4000-8000-000000000323', 'p0010001-0000-4000-8000-000000000079', 'Targets', 'Array of side-drilled holes at constant angular or depth increments', 2),
('spc00001-0000-4000-8000-000000000324', 'p0010001-0000-4000-8000-000000000079', 'Radii', '50 mm and 100 mm radius arcs', 3),
('spc00001-0000-4000-8000-000000000325', 'p0010001-0000-4000-8000-000000000079', 'Dimensions', '250 x 100 x 25 mm', 4),
('spc00001-0000-4000-8000-000000000326', 'p0010001-0000-4000-8000-000000000080', 'Standard', 'ASTM E2491', 1),
('spc00001-0000-4000-8000-000000000327', 'p0010001-0000-4000-8000-000000000080', 'Reflectors', 'Side drilled holes at depths of 5, 10, 15, 20, 25, 30, 35, 40 mm', 2),
('spc00001-0000-4000-8000-000000000328', 'p0010001-0000-4000-8000-000000000080', 'Thickness', '25 mm or 38 mm', 3),
('spc00001-0000-4000-8000-000000000329', 'p0010001-0000-4000-8000-000000000081', 'Standard', 'ISO 19675 / EN ISO 2400', 1),
('spc00001-0000-4000-8000-000000000330', 'p0010001-0000-4000-8000-000000000081', 'Targets', 'R100 arc, R25 arc, SDH arrays, flat bottom holes', 2),
('spc00001-0000-4000-8000-000000000331', 'p0010001-0000-4000-8000-000000000081', 'Dimensions', '300 x 100 x 25 mm', 3),
('spc00001-0000-4000-8000-000000000332', 'p0010001-0000-4000-8000-000000000082', 'Targets', 'Four 3/64 in SDH targets at 0.200, 0.400, 0.600, 0.800 in depth', 1),
('spc00001-0000-4000-8000-000000000333', 'p0010001-0000-4000-8000-000000000082', 'Standard', 'AWS / ASME Section V', 2),
('spc00001-0000-4000-8000-000000000334', 'p0010001-0000-4000-8000-000000000082', 'Dimensions', '18.0 x 1.0 x 1.0 in', 3),
('spc00001-0000-4000-8000-000000000335', 'p0010001-0000-4000-8000-000000000083', 'Standard', 'DIN EN ISO 2400', 1),
('spc00001-0000-4000-8000-000000000336', 'p0010001-0000-4000-8000-000000000083', 'Reflectors', 'R100 mm arc, 1.5 mm and 50 mm hole targets', 2),
('spc00001-0000-4000-8000-000000000337', 'p0010001-0000-4000-8000-000000000083', 'Dimensions', '300 x 100 x 25 mm', 3),
('spc00001-0000-4000-8000-000000000338', 'p0010001-0000-4000-8000-000000000084', 'Standard', 'DIN EN ISO 7963', 1),
('spc00001-0000-4000-8000-000000000339', 'p0010001-0000-4000-8000-000000000084', 'Thickness', '12.5 mm', 2),
('spc00001-0000-4000-8000-000000000340', 'p0010001-0000-4000-8000-000000000084', 'Reflectors', 'R25 mm and R50 mm cylindrical segments', 3),
('spc00001-0000-4000-8000-000000000341', 'p0010001-0000-4000-8000-000000000084', 'Dimensions', '75 x 43 x 12.5 mm', 4),
('spc00001-0000-4000-8000-000000000342', 'p0010001-0000-4000-8000-000000000085', 'Standard', 'NAVSEA T9074-AS-GIB-010/271, MIL-STD-271F', 1),
('spc00001-0000-4000-8000-000000000343', 'p0010001-0000-4000-8000-000000000085', 'Targets', 'Six 3/64 in diameter side-drilled holes at precise increments', 2),
('spc00001-0000-4000-8000-000000000344', 'p0010001-0000-4000-8000-000000000085', 'Dimensions', '12.0 x 1.25 x 1.0 in', 3),
('spc00001-0000-4000-8000-000000000345', 'p0010001-0000-4000-8000-000000000086', 'Standard', 'API RP 2X', 1),
('spc00001-0000-4000-8000-000000000346', 'p0010001-0000-4000-8000-000000000086', 'Targets', 'EDM square, V-notch, and SDH reflectors in curved geometry', 2),
('spc00001-0000-4000-8000-000000000347', 'p0010001-0000-4000-8000-000000000086', 'Application', 'Offshore jacket and tubular node welding', 3),
('spc00001-0000-4000-8000-000000000348', 'p0010001-0000-4000-8000-000000000087', 'Crystal Frequencies', '1 MHz, 2 MHz, 2.5 MHz, 4 MHz, 5 MHz', 1),
('spc00001-0000-4000-8000-000000000349', 'p0010001-0000-4000-8000-000000000087', 'Crystal Diameters', '10 mm, 14 mm, 20 mm, 24 mm', 2),
('spc00001-0000-4000-8000-000000000350', 'p0010001-0000-4000-8000-000000000087', 'Connector', 'LEMO 00 or BNC side/top mount', 3),
('spc00001-0000-4000-8000-000000000351', 'p0010001-0000-4000-8000-000000000087', 'Wear Face', 'Alumina ceramic protective face plate', 4),
('spc00001-0000-4000-8000-000000000352', 'p0010001-0000-4000-8000-000000000088', 'Refracted Angles', '45 deg, 60 deg, 70 deg (in steel)', 1),
('spc00001-0000-4000-8000-000000000353', 'p0010001-0000-4000-8000-000000000088', 'Frequencies', '2 MHz, 4 MHz, 5 MHz', 2),
('spc00001-0000-4000-8000-000000000354', 'p0010001-0000-4000-8000-000000000088', 'Crystal Dimensions', '8x9 mm, 9x9 mm, 13x13 mm, 20x22 mm', 3),
('spc00001-0000-4000-8000-000000000355', 'p0010001-0000-4000-8000-000000000088', 'Connector', 'LEMO 00 / Subvis', 4),
('spc00001-0000-4000-8000-000000000356', 'p0010001-0000-4000-8000-000000000089', 'Element Type', 'Dual Crystal TR / Pitch-Catch', 1),
('spc00001-0000-4000-8000-000000000357', 'p0010001-0000-4000-8000-000000000089', 'Frequencies', '2 MHz, 4 MHz, 5 MHz', 2),
('spc00001-0000-4000-8000-000000000358', 'p0010001-0000-4000-8000-000000000089', 'Near Surface Resolution', '< 1.5 mm', 3),
('spc00001-0000-4000-8000-000000000359', 'p0010001-0000-4000-8000-000000000089', 'Connectors', 'Dual LEMO 00 or Microdot', 4),
('spc00001-0000-4000-8000-000000000360', 'p0010001-0000-4000-8000-000000000090', 'Angles', '45 deg, 60 deg, 70 deg', 1),
('spc00001-0000-4000-8000-000000000361', 'p0010001-0000-4000-8000-000000000090', 'Frequencies', '2 MHz, 4 MHz', 2),
('spc00001-0000-4000-8000-000000000362', 'p0010001-0000-4000-8000-000000000090', 'Focal Zone', 'Custom focus depth 5 - 25 mm', 3),
('spc00001-0000-4000-8000-000000000363', 'p0010001-0000-4000-8000-000000000090', 'Connector', 'Dual LEMO 00', 4),
('spc00001-0000-4000-8000-000000000364', 'p0010001-0000-4000-8000-000000000091', 'Design', 'Low profile snail configuration (<20 mm height)', 1),
('spc00001-0000-4000-8000-000000000365', 'p0010001-0000-4000-8000-000000000091', 'Irrigation', 'Built-in water couplant ports', 2),
('spc00001-0000-4000-8000-000000000366', 'p0010001-0000-4000-8000-000000000091', 'Frequencies', '5 MHz, 7.5 MHz, 10 MHz', 3),
('spc00001-0000-4000-8000-000000000367', 'p0010001-0000-4000-8000-000000000091', 'Application', 'TOFD and restricted pipe clearance scans', 4),
('spc00001-0000-4000-8000-000000000368', 'p0010001-0000-4000-8000-000000000092', 'Membranes', 'Screw-on elastomer protective face / High temp delay line', 1),
('spc00001-0000-4000-8000-000000000369', 'p0010001-0000-4000-8000-000000000092', 'Frequencies', '2 MHz, 4 MHz, 5 MHz', 2),
('spc00001-0000-4000-8000-000000000370', 'p0010001-0000-4000-8000-000000000092', 'Connector', 'LEMO 00 top mount', 3),
('spc00001-0000-4000-8000-000000000371', 'p0010001-0000-4000-8000-000000000092', 'Cost Savings', 'Quick wear-face replacement without buying new transducer', 4),
('spc00001-0000-4000-8000-000000000372', 'p0010001-0000-4000-8000-000000000093', 'Impedance', '50 Ohm RG-174 / RG-58', 1),
('spc00001-0000-4000-8000-000000000373', 'p0010001-0000-4000-8000-000000000093', 'Connector Options', 'BNC to LEMO 00, BNC to LEMO 01, LEMO 00 to LEMO 00, Microdot', 2),
('spc00001-0000-4000-8000-000000000374', 'p0010001-0000-4000-8000-000000000093', 'Length', '1.5 m, 2.0 m standard (custom lengths available)', 3),
('spc00001-0000-4000-8000-000000000375', 'p0010001-0000-4000-8000-000000000093', 'Jacket', 'High-flex oil and abrasion resistant polyurethane', 4)
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

SET FOREIGN_KEY_CHECKS=1;
-- END OF AJR NDT SEED SCRIPT
