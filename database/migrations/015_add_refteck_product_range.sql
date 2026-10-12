-- ============================================================================
-- REFTECK PRODUCT RANGE (migration 015)
-- ============================================================================
-- Adds every product published in the Refteck product catalog
-- (https://www.refteck.com/product/) to the Vortex Precision IT catalog:
--
--   * 10 new categories (Industrial Valves, Pumps & Instrumentation
--     reuse the categories that already exist, so they are not duplicated)
--   * 107 products with their catalog copy (name, description,
--     short description, meta tags)
--   * 107 primary product photos, hot-linked from refteck.com with the
--     standard on-theme fallback artwork. Run
--         php scripts/localize_product_images.php
--     afterwards to download the photos onto your own server (same tool
--     that localizes the AJR NDT catalog images).
--   * homepage category grid limit 24 -> 32 so every category fits.
--
-- SKUs use the RF-<CATEGORY>-<NN> prefix and ids are deterministic, so
-- the file is safe to re-import: every statement is skipped once its
-- row exists (SKU / slug guards), mirroring migrations 008 and 010.
-- Compatible with MySQL 5.7+/8.0+/MariaDB 10.3+ (utf8mb4).


-- ----------------------------------------------------------------------------
-- 1. CATEGORIES (10 new; valves / pumps / instrumentation already exist)
-- ----------------------------------------------------------------------------
INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000001','Drilling Equipment','drilling-equipment','Drilling equipment is widely used in oilfield supply stores in both land and offshore markets, for designing and forming the top of the line drill rigs, especially for the minerals drilling industries. Such Drill Rigs are working on every continent in the world and are mostly used for mineral exploration drilling, geothermal drilling, construction drilling, water well drilling etc. We at Refteck are specialists in supplying the best drilling equipment and spare parts, which has earned the reputation of erecting the best drilling rigs today. The OEM\'s we work with are known for their sturdy dependability and low maintenance. Services provided by our team allows us to offer the best equipment and spare parts for a wide range of drill rig models that satisfy a variety of needs, including auger drilling, wet rotary drilling, core drilling, and down-the-hole hammer drilling. Our clients also receive an unmatched MRO services and support that you won\'t find anywhere else.','compass','https://www.refteck.com/wp-content/uploads/2017/03/driling.jpg',140,1,'Drilling Equipment - Vortex Precision IT','Drilling equipment is widely used in oilfield supply stores in both land and offshore markets, for designing and forming the top of the line drill rigs, especially for the minerals drilling industries.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'drilling-equipment');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000002','Maintenance, Repair Tools','maintenance-repair-tools','Troubleshoot problems with our maintenance, repair tools and spare parts. Refteck Solutions has the expertise to procure all such MRO tools viz. hand tools, power tools, pneumatic tools and milling tools for our clients and keeping in mind their changing requirements.','tool','https://www.refteck.com/wp-content/uploads/2017/03/repair.jpg',150,1,'Maintenance, Repair Tools - Vortex Precision IT','Troubleshoot problems with our maintenance, repair tools and spare parts.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'maintenance-repair-tools');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000003','Rotary Equipment','rotary-equipment','Rotary equipment is the given categorisation for mechanical devices that provide kinetic energy to an operation enabling it to move. Rotating equipment is seen in various mechanisms throughout the process industry sector and it consists of components that move solids, liquids or gases through a series of drivers, driven components and the transmission devices. This type of application can be usually found in steam or gas turbines. The steam turbines act as a potential driver, using high-pressure steam to stimulate the rotary equipment such as the forced/induced-draft fans, pumps or air compressors. Whereas the gas turbines can either use compressed air to drive the generator or use "scoop tubes" as a fluid coupling to drive the rotating equipment. Operating this equipment can be fairly risky, and workers should be careful and take the right precautions in order to avoid injuries.','refresh-cw','https://www.refteck.com/wp-content/uploads/2017/03/rotary.jpg',160,1,'Rotary Equipment - Vortex Precision IT','Rotary equipment is the given categorisation for mechanical devices that provide kinetic energy to an operation enabling it to move.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'rotary-equipment');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000004','Process Equipment','process-equipment','Industrial processing equipment encompasses a wide range of products and spare parts that are destined for critical requirements within a variety of downstream manufacturing sectors. Such process equipment plays a major role in many reactions or operations that are not possible under normal environmental conditions related to temperature, pressure or safety purposes. Modern technological advancements in the industrial processing equipment used in industrial sectors such as oil and gas, mining, general manufacturing and construction etc. can have a considerable impact on the speed, quality and volume of production levels and plant profitability. We at Refteck scrutinise all requirements to get a better understanding of the type of process equipment and accessories that are required by our clients.','settings','https://www.refteck.com/wp-content/uploads/2017/03/process-equipment-1.jpg',170,1,'Process Equipment - Vortex Precision IT','Industrial processing equipment encompasses a wide range of products and spare parts that are destined for critical requirements within a variety of downstream manufacturing sectors.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'process-equipment');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000005','Electrical & Power Transmission','electrical-power-transmission','Long distance transmission of electrical power is one of the major challenges of the electrical age. The goals which engineers have been working towards have remained the same despite many other things changing over the years. We at Refteck provide solutions to meet the Efficiency, Safety, Cost, and Robustness. Efficiency here defines the extent to which time is well used for the intended task, in general transportation of electric power over distance with minimal losses. Safety: The condition or feeling of being safe, security; transport power through urban and rural areas minimising harm to people and the environment. Cost: Amount of money, time, etc. that is required or used; to use minimal raw materials and building/operating costs possible. Robustness: The quality of being robust; create a system which is not vulnerable to surges from lightning, solar flares, earthquakes, ice storms, wind storms and have the system be able to \'heal\' itself when outages occur, isolating problem areas.','zap','https://www.refteck.com/wp-content/uploads/2017/03/Elec-power-transm.jpg',180,1,'Electrical & Power Transmission - Vortex Precision IT','Long distance transmission of electrical power is one of the major challenges of the electrical age.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'electrical-power-transmission');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000006','Maintenance, Repair & Operation Tools','maintenance-repair-operation-tools','Maintenance, Repair and Operations functions in tandem with every aspect of the processing and manufacturing industry in general. Experts with aim of better product safety and proper mechanical component maintenance design MRO management programs. Manufacturing Facilities are steadily crowding with more equipment and there is huge pressure on maintenance staff to keep production facilities running without any interruption. MRO helps workers to increase uptime and reliability at a lower cost by allowing them to predict and prevent equipment failure. Heavy equipment such as cranes, bulldozers, loaders, draglines etc have different maintenance requirements. We have the expertise to procure all such MRO tools, spare parts for our clients keeping in mind their changing requirements.','briefcase','https://www.refteck.com/wp-content/uploads/2017/03/mro-featured.jpg',190,1,'Maintenance, Repair & Operation Tools - Vortex Precision IT','Maintenance, Repair and Operations functions in tandem with every aspect of the processing and manufacturing industry in general.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'maintenance-repair-operation-tools');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000007','Industrial Oil, Chemicals, and Lubricants','industrial-oil-chemicals-lubrications','Industrial Oil, chemicals and industrial lubricants are essential to the process industry. Industrial oils can be used in various types of machines and vehicles and hence are available in a variety including gear oils, air compressor oils and hydraulic oils to rock drill oils, turbine oils and low-toxicity oils. Whereas the chemicals can be mixed to increase fuel efficiency or to protect equipment from corrosion. Lubricants are essential to the process industry. They are used to reduce the amount of friction between the moving surfaces such as rotary equipment, which in turn ensures the smooth running of the machinery. The most popular types of lubricants are motor oils, marine oils, silicone, greases, turbine oils, metalworking fluids, cutting fluids, grinding fluids, farming oils, gas engine oils, brake oils, hydraulic oils, etc.','droplet','https://www.refteck.com/wp-content/uploads/2017/03/industry-oil-featured.jpg',200,1,'Industrial Oil, Chemicals, and Lubricants - Vortex Precision IT','Industrial Oil, chemicals and industrial lubricants are essential to the process industry.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'industrial-oil-chemicals-lubrications');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000008','HVAC & Refrigeration','hvac-refrigeration','HVAC & refrigeration is vital to today\'s lifestyle for personal comfort, food preservation, medical health, industrial uses and water supply; regulating and preserving the climate control and airflow of the systems in play. With constant developments in technology requiring air flow control, the demand for HVAC & refrigeration services has increased which suggests that high growth within this industry is to be expected. At Refteck, we understand how a heating and cooling system can have a direct effect on financial and environmental performance and hence we source reliable spare parts that approve every end users\' expectations.','wind','https://www.refteck.com/wp-content/uploads/2017/03/HVAC.jpg',210,1,'HVAC & Refrigeration - Vortex Precision IT','HVAC & refrigeration is vital to today\'s lifestyle for personal comfort, food preservation, medical health, industrial uses and water supply; regulating and preserving the climate control and airflow of the systems in play.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'hvac-refrigeration');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000009','Heavy Plant Machinery & Vehicles','heavy-plant-machinery-vehicles','Heavy plant machinery & vehicles used in construction tasks are specifically designed to perform effectively on projects of a large scale, ensuring that the tasks are completed timely. In addition to this, they make sure that the projects are conducted with the highest quality, helping businesses achieve their goals readily. There are four categories of heavy machinery: Earth-moving equipment, construction vehicles, material handling and construction equipment. The machines need to be operated by a professional and be maintained regularly in order to safeguard the workers. Previously, all these tasks were carried out by the labour force however due to the mechanisation in the plants, companies are able to mass-produce at a faster pace, improving their efficiency. This is not to say that the labourers do not produce high-quality work, but are just limited to the speed at which these machines can. As fewer workers are needed, heavy plant machinery & vehicles help companies minimise the costs and the risks involved. Machines are able to withstand extreme temperatures and conduct dangerous tasks, creating a safer environment.','truck','https://www.refteck.com/wp-content/uploads/2017/03/heavy-plant-featured.jpg',220,1,'Heavy Plant Machinery & Vehicles - Vortex Precision IT','Heavy plant machinery & vehicles used in construction tasks are specifically designed to perform effectively on projects of a large scale, ensuring that the tasks are completed timely.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'heavy-plant-machinery-vehicles');

INSERT INTO categories (`id`,`name`,`slug`,`description`,`icon`,`image`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`)
SELECT 'rc000010','Safety Products','safety-products','Any workplace injury causes an immeasurable suffering. Companies that put safety first turn out higher quality products. In some cases, that\'s because a safe workplace tends to be a more efficient one, free of debris and tangles of cords. Industrial workers are exposed to various risks in the workplace. Hence each one of them should be provided with the required tools and equipment to ensure their safety at the workplace. The requirement differs from industry to industry. Refteck has the ability to provide almost every major occupational industrial safety product such as Safety Glasses, Hearing Protection, Respirators and Face Masks, Face Shield, Searchlights, Fall arresters, Personal Protective Equipment, Protective hood, etc. We select the best in the industry suppliers to provide our clients with genuine high-quality products at most competitive price.','shield','https://www.refteck.com/wp-content/uploads/2017/03/safety-featured.jpg',230,1,'Safety Products - Vortex Precision IT','Any workplace injury causes an immeasurable suffering.'
FROM (SELECT 1) AS _dual
 WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'safety-products');


-- ----------------------------------------------------------------------------
-- 2. PRODUCTS (107)
-- ----------------------------------------------------------------------------
INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000001-0000-4000-8000-000000000001','Ball Valve','ball-valve','RF-VLV-01','A ball valve regulates the flow of liquids and gases and can range from one-piece, two-piece, three-piece to a flanged body construction. It is a quick-acting tool as it only requires a quarter-turn of the actuator and can be instantaneously switched on and off. Ball valves are highly-durable as they are made from robust materials so the valve is able to function efficiently in the long term.','A ball valve regulates the flow of liquids and gases and can range from one-piece, two-piece, three-piece to a flanged body construction.',c.id,'IN_STOCK',0,1,0,'Ball Valve | Vortex Precision IT','A ball valve regulates the flow of liquids and gases and can range from one-piece, two-piece, three-piece to a flanged body construction.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000002-0000-4000-8000-000000000002','Gate Valve (Also known as a Sluice Valve)','gate-valve-also-known-as-a-sluice-valve','RF-VLV-02','This is one of the most common types of valves, widely used in every industry which act as an on/off switch to either start or stop the flow. We offer a variety of gate valves including screwed, union, bolted-bonnet, welded-bonnet & pressure-seal. Turning the wheel, controls the flow of the liquids and gases by moving the gate up and down. Although fluid regulation is one of the functions, it not recommended as its main purpose is to fully open or fully close the flow.','This is one of the most common types of valves, widely used in every industry which act as an on/off switch to either start or stop the flow.',c.id,'IN_STOCK',0,1,0,'Gate Valve (Also known as a Sluice Valve) | Vortex Precision IT','This is one of the most common types of valves, widely used in every industry which act as an on/off switch to either start or stop the flow.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000003-0000-4000-8000-000000000003','Butterfly Valve','butterfly-valve','RF-VLV-03','We offer a wide range of butterfly valves that can be used in many applications such as in chemical services, heating and air conditioning, water distribution, agricultural, heavy plant and etc. It uses a circular disk to control the flow of substances and is available in small dimensions so it can be used in confined spaces.','We offer a wide range of butterfly valves that can be used in many applications such as in chemical services, heating and air conditioning, water distribution, agricultural, heavy plant and etc.',c.id,'IN_STOCK',0,1,0,'Butterfly Valve | Vortex Precision IT','We offer a wide range of butterfly valves that can be used in many applications such as in chemical services, heating and air conditioning, water distribution, agricultural, heavy plant and etc.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000004-0000-4000-8000-000000000004','Globe Valve','globe-valve','RF-VLV-04','A globe valve is used to control the flow in a pipeline, differing from a ball valve. It has good shut off and throttling capabilities and is easy to machine. Typical utilisation of an industrial globe valve is in the fuel oil system, cooling water systems, turbine seals and vents.','A globe valve is used to control the flow in a pipeline, differing from a ball valve.',c.id,'IN_STOCK',0,1,0,'Globe Valve | Vortex Precision IT','A globe valve is used to control the flow in a pipeline, differing from a ball valve.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000005-0000-4000-8000-000000000005','Plug Valve','plug-valve','RF-VLV-05','Like a ball valve, a plug valve also uses a quarter-turn to regulate the flow, providing no leakage of substances. It can be opened and closed instantaneously and is extremely versatile piece of equipment that can be found in petroleum pipelines, chemical processing or even industrial applications. A plug valve can be used for directional flow maintenance as it can withstand extreme temperatures and safely handles the substances.','Like a ball valve, a plug valve also uses a quarter-turn to regulate the flow, providing no leakage of substances.',c.id,'IN_STOCK',0,1,0,'Plug Valve | Vortex Precision IT','Like a ball valve, a plug valve also uses a quarter-turn to regulate the flow, providing no leakage of substances.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000006-0000-4000-8000-000000000006','Check Valve','check-valve','RF-VLV-06','A check valve is one-way directional valve which prevents the flow from reversing because it could ruin the equipment or cause the entire process to halt. Check valves can be used with different media types such as liquids, gases, steam, condensate and other semi-liquids such as slurries.','A check valve is one-way directional valve which prevents the flow from reversing because it could ruin the equipment or cause the entire process to halt.',c.id,'IN_STOCK',0,1,0,'Check Valve | Vortex Precision IT','A check valve is one-way directional valve which prevents the flow from reversing because it could ruin the equipment or cause the entire process to halt.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000007-0000-4000-8000-000000000007','Needle valve','needle-valve','RF-VLV-07','A needle valve is a small piece of equipment that is used to gradually stop the flow of the steam, oil, gas, air and etc. It can also be used for accurate flow regulation even though it is at a slower rate, i.e. in vacuum systems or gas lasers.','A needle valve is a small piece of equipment that is used to gradually stop the flow of the steam, oil, gas, air and etc.',c.id,'IN_STOCK',0,1,0,'Needle valve | Vortex Precision IT','A needle valve is a small piece of equipment that is used to gradually stop the flow of the steam, oil, gas, air and etc.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000008-0000-4000-8000-000000000008','Actuated Control Valves','actuated-control-valves','RF-VLV-08','An actuated control valve is used for particular uses such as regulating corrosive liquids in chemical plants or specific applications in electrical power and transmission grids. Most of these applications require precise control of the flow, which in turn depends on the amount of pressure needed.','An actuated control valve is used for particular uses such as regulating corrosive liquids in chemical plants or specific applications in electrical power and transmission grids.',c.id,'IN_STOCK',0,1,0,'Actuated Control Valves | Vortex Precision IT','An actuated control valve is used for particular uses such as regulating corrosive liquids in chemical plants or specific applications in electrical power and transmission grids.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000009-0000-4000-8000-000000000009','Solenoid Valves','solenoid-valves','RF-VLV-09','A solenoid valve can be used for various applications including within heating systems, compressed air technology, industrial automation, swimming pools. It allows the system to automatically control the flow of liquids and gases. It is highly reliable and durable as well as allowing for quick operations.','A solenoid valve can be used for various applications including within heating systems, compressed air technology, industrial automation, swimming pools.',c.id,'IN_STOCK',0,1,0,'Solenoid Valves | Vortex Precision IT','A solenoid valve can be used for various applications including within heating systems, compressed air technology, industrial automation, swimming pools.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-09');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000010-0000-4000-8000-000000000010','Safety Valve (Also known as a Relief Valve)','safety-valve-also-known-as-a-relief-valve','RF-VLV-10','A safety valve is a mechanism used to protect a system in the last line of defence. It is used to limit the pressure that has been built up by equipment failure or by a process that has been disrupted. Although the main application for a safety valve is in chemical plants, gas storage tanks and electrical power boiler.','A safety valve is a mechanism used to protect a system in the last line of defence.',c.id,'IN_STOCK',0,1,0,'Safety Valve (Also known as a Relief Valve) | Vortex Precision IT','A safety valve is a mechanism used to protect a system in the last line of defence.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-10');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000011-0000-4000-8000-000000000011','Pneumatic Valve','pneumatic-valve','RF-VLV-11','Pneumatic systems rely on the force of the compressed air and hence the actuators need safe and precise control. There are three different uses for pneumatic valves which are regulating the pressure, controlling the flow and the directional control. They come in various sizes depending on the type of application involved.','Pneumatic systems rely on the force of the compressed air and hence the actuators need safe and precise control.',c.id,'IN_STOCK',0,1,0,'Pneumatic Valve | Vortex Precision IT','Pneumatic systems rely on the force of the compressed air and hence the actuators need safe and precise control.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-11');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000012-0000-4000-8000-000000000012','Pinch Valve','pinch-valve','RF-VLV-12','When dealing with abrasive flow, a pinch valve is very useful as it probably the most versatile valve that is able to deal with harsh flow control situations such as slurries. It is weightless and requires minimal maintenance.','When dealing with abrasive flow, a pinch valve is very useful as it probably the most versatile valve that is able to deal with harsh flow control situations such as slurries.',c.id,'IN_STOCK',0,1,0,'Pinch Valve | Vortex Precision IT','When dealing with abrasive flow, a pinch valve is very useful as it probably the most versatile valve that is able to deal with harsh flow control situations such as slurries.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-12');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000013-0000-4000-8000-000000000013','Diaphragm Valve','diaphragm-valve','RF-VLV-13','One of the key advantages for a diaphragm valve is that it can be used for throttling purposes as it is bidirectional and hence it can also be used for on/off function. It is extremely clean and can be easily maintained. If there are any repairs that need to be made, then they can happen without interrupting the pipeline.','One of the key advantages for a diaphragm valve is that it can be used for throttling purposes as it is bidirectional and hence it can also be used for on/off function.',c.id,'IN_STOCK',0,1,0,'Diaphragm Valve | Vortex Precision IT','One of the key advantages for a diaphragm valve is that it can be used for throttling purposes as it is bidirectional and hence it can also be used for on/off function.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-13');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000014-0000-4000-8000-000000000014','Electric Actuators','electric-actuators','RF-VLV-14','Electric actuators can replace the hydraulic systems by self-automated actuators which run on electrical power, eliminating the need for hydraulic pumps and tubing, delivering precision and repeatability. As they are programmable, the electric actuators are able to adapt to any situation, and hence are useful for many applications such as aircrafts.','Electric actuators can replace the hydraulic systems by self-automated actuators which run on electrical power, eliminating the need for hydraulic pumps and tubing, delivering precision and repeatability.',c.id,'IN_STOCK',0,1,0,'Electric Actuators | Vortex Precision IT','Electric actuators can replace the hydraulic systems by self-automated actuators which run on electrical power, eliminating the need for hydraulic pumps and tubing, delivering precision and repeatability.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-14');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000015-0000-4000-8000-000000000015','Flanges','flanges','RF-VLV-15','As flanges are mainly used in plumbing systems and industrial applications, certain standards have been established for the production of them. We offer a wide range of flanges including welding neck flanges, slip on flanges, socket weld flanges, lap joint flanges, threaded flanges, and blind flanges. They are available in a variety of materials such as stainless steel, cast iron, brass, aluminium, and etc.','As flanges are mainly used in plumbing systems and industrial applications, certain standards have been established for the production of them.',c.id,'IN_STOCK',0,1,0,'Flanges | Vortex Precision IT','As flanges are mainly used in plumbing systems and industrial applications, certain standards have been established for the production of them.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-15');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000016-0000-4000-8000-000000000016','Manifold','manifold','RF-VLV-16','A manifold is an essential piece of equipment utilised throughout the process industry. It is used to either converge multiple branches into a single channel or diverge a single channel into multiple branches. There are a variety of manifolds available but choosing the correct one depends on pressure, flow, temperature, material selection, and port & valve selection.','A manifold is an essential piece of equipment utilised throughout the process industry.',c.id,'IN_STOCK',0,1,0,'Manifold | Vortex Precision IT','A manifold is an essential piece of equipment utilised throughout the process industry.'
  FROM categories c
 WHERE c.slug = 'valves'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-VLV-16');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000017-0000-4000-8000-000000000017','Draw Works','draw-works','RF-DRL-01','The principal parts of the draw works are the drum, the drum brakes, transmission, and cathead. Draw works spare parts are most popular in Domestic Market, Middle-East, and Southeast Asia, Draw works is the primary hoisting machinery that is a component of a rotary drilling rig. Our services fused with our customer service will bring you a sophisticated, well-oiled business process that is able to address all business process requirements.','The principal parts of the draw works are the drum, the drum brakes, transmission, and cathead.',c.id,'MADE_TO_ORDER',0,1,0,'Draw Works | Vortex Precision IT','The principal parts of the draw works are the drum, the drum brakes, transmission, and cathead.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000018-0000-4000-8000-000000000018','Travelling Block','travelling-block','RF-DRL-02','Refteck supplies a wide range of traveling block and spare parts from well-reputed manufacturers, A traveling block is a set of pulleys which forms part of a system in the derrick for lowering and lifting heavy things into or out of the wellbore. We also offer Multiple Sheave Unites, Customer Engineered Designs to meet each customer\'s specific requirements from standard to highly tailor-made solutions.','Refteck supplies a wide range of traveling block and spare parts from well-reputed manufacturers, A traveling block is a set of pulleys which forms part of a system in the derrick for lowering and lifting heavy things into or out of the wellbore.',c.id,'MADE_TO_ORDER',0,1,0,'Travelling Block | Vortex Precision IT','Refteck supplies a wide range of traveling block and spare parts from well-reputed manufacturers, A traveling block is a set of pulleys which forms part of a system in the derrick for lowering and lifting heavy things into or out of the wellbore.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000019-0000-4000-8000-000000000019','Coiled Tubing','coiled-tubing','RF-DRL-03','Coiled tubing is widely used in the petrochemical, natural gas, oil and gas, and geothermal applications. Most of the standard sizes of coiled tubes are readily available for the industrial uses. At Refteck we supply both stainless steel seamless coiled tubes and stainless welded coiled tubes which are available in a wide range of steel, i.e. nickel, titanium, and other special alloys. We hold a extensive experience in supplying coiled tubing from the duplex, nickel alloy and stainless steel grades to industry and customer-specific requirements.','Coiled tubing is widely used in the petrochemical, natural gas, oil and gas, and geothermal applications.',c.id,'MADE_TO_ORDER',0,1,0,'Coiled Tubing | Vortex Precision IT','Coiled tubing is widely used in the petrochemical, natural gas, oil and gas, and geothermal applications.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000020-0000-4000-8000-000000000020','Drilling Instrumentation','drilling-instrumentation','RF-DRL-04','With today\'s tough drilling environments there is a critical need for rugged, dependable and accurate tools. Refteck provides a complete line of Oilfield Instruments equipment. With everything from pressure gauges to complete systems, we will help identify the highest quality, the most cost-effective product for your job, and then back it with individual attention.','With today\'s tough drilling environments there is a critical need for rugged, dependable and accurate tools.',c.id,'MADE_TO_ORDER',0,1,0,'Drilling Instrumentation | Vortex Precision IT','With today\'s tough drilling environments there is a critical need for rugged, dependable and accurate tools.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000021-0000-4000-8000-000000000021','Drilling Generators','drilling-generators','RF-DRL-05','Power generators are important tools for anyone who wants extra protection in emergencies against power loss. For the oil and gas industry, power generators are a very important necessity. These generators provide key power sources for the oil and gas industry, particularly to assist with drilling and digging. The procedure of both drilling and digging are key to these industries, and a lot of power is needed to provide service to heavy equipment.','Power generators are important tools for anyone who wants extra protection in emergencies against power loss.',c.id,'MADE_TO_ORDER',0,1,0,'Drilling Generators | Vortex Precision IT','Power generators are important tools for anyone who wants extra protection in emergencies against power loss.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000022-0000-4000-8000-000000000022','Wireline Equipment','wireline-equipment','RF-DRL-06','Wireline Equipment consists of braided cables that are used for pipe recovery, evaluation purposes, well intervention and maintenance. The cabling system is used by operators to lower down wireline equipment and tools, or any other measuring devices into a wellbore. It also contains electrical cables which are used to check the condition of the wellbore. These equipment are extensively used in oil and gas industries. Refteck offers Modern Wireline types of equipment which can withstand a harsh environment since in the gas wells the pressure can exceed 30,000 psi and in a geothermal well the temperature can be as high as 500 degrees Fahrenheit.','Wireline Equipment consists of braided cables that are used for pipe recovery, evaluation purposes, well intervention and maintenance.',c.id,'MADE_TO_ORDER',0,1,0,'Wireline Equipment | Vortex Precision IT','Wireline Equipment consists of braided cables that are used for pipe recovery, evaluation purposes, well intervention and maintenance.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000023-0000-4000-8000-000000000023','Completion Tools','completion-tools','RF-DRL-07','Completion equipment is that equipment which is used to bring an oil well to the completion state so that first test production and later on commercial production can be started from it. The completion tools are handy during good completion and help in making an oil and gas well safely and effectively producing hydrocarbons. Refteck offers a comprehensive completion tool line, from an Open hole and Cemented Multi-Stage Stimulation systems to Composite Plugs. Tools used are Wellhead, Tubing hanger, Production tubing, Downhole safety valve (DHSV), Annular safety valve, Electrical submersible pump, Landing nipple, Sliding sleeve, Centraliser, Side pocket mandrel.','Completion equipment is that equipment which is used to bring an oil well to the completion state so that first test production and later on commercial production can be started from it.',c.id,'MADE_TO_ORDER',0,1,0,'Completion Tools | Vortex Precision IT','Completion equipment is that equipment which is used to bring an oil well to the completion state so that first test production and later on commercial production can be started from it.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000024-0000-4000-8000-000000000024','Oil Tools','oil-tools','RF-DRL-08','Oil Tools are pieces of oilfield equipment that are used during well drilling, completion, and intervention or well workover activities and help the oil well in optimising the production levels and maintain a continuous flow from a reservoir. Downhole tools help in minimising the cost involved in performing oil recovery-related activities from an oil well and helps in improving the life of an oil well and thus, improving the continuous flow of fluid. These tools perform various operations such as fishing of any leftover equipment/tool in the borehole, repairing & performing any cementing and well casing operations, well measurement, creating fracs in the reservoir bed, etc.','Oil Tools are pieces of oilfield equipment that are used during well drilling, completion, and intervention or well workover activities and help the oil well in optimising the production levels and maintain a continuous flow from a reservoir.',c.id,'MADE_TO_ORDER',0,1,0,'Oil Tools | Vortex Precision IT','Oil Tools are pieces of oilfield equipment that are used during well drilling, completion, and intervention or well workover activities and help the oil well in optimising the production levels and maintain a continuous flow from a reservoir.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000025-0000-4000-8000-000000000025','Power Swivels','power-swivels','RF-DRL-09','The Power Swivels are hydraulic motor driven, pipe rotating machines. Their drilling application includes oil and gas wells, water wells, piling drilling for offshore platforms, piers, and foundation drilling for construction. We offer a wide range of high-performance Power Swivels systems that deliver both safety and reliability, providing you with the best selection of models to fit your specific drilling needs.','The Power Swivels are hydraulic motor driven, pipe rotating machines.',c.id,'MADE_TO_ORDER',0,1,0,'Power Swivels | Vortex Precision IT','The Power Swivels are hydraulic motor driven, pipe rotating machines.'
  FROM categories c
 WHERE c.slug = 'drilling-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-DRL-09');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000026-0000-4000-8000-000000000026','Hand Tools','hand-tools','RF-MRT-01','The foundation of any good and proper toolkit is Hand tools. Depending on the nature of the work a craftsman must have proper hand tools and he must be able to choose the right tool for the task. In the absence of proper hand tools and knowledge about using it, the craftsman will lose his efficiency and quality. Mechanical hand tools like pillars, wire cutters, wrenches, sockets and ratchets, saws and many more are the backbone of maintenance, repair and operation programs.','The foundation of any good and proper toolkit is Hand tools.',c.id,'IN_STOCK',0,1,0,'Hand Tools | Vortex Precision IT','The foundation of any good and proper toolkit is Hand tools.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRT-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000027-0000-4000-8000-000000000027','Power Tools','power-tools','RF-MRT-02','If users in manufacturing plant wish to save the time, resources and make the task simple and effective, power tools are highly favorable. Productivity, safety and efficiency are the major factors driving the demand for efficient power tools. Reciprocating saw, angle grinder, oscillating multi-tool, impact driver, powering up and many more power tools are enhancing the productivity in manufacturing plants across the world.','If users in manufacturing plant wish to save the time, resources and make the task simple and effective, power tools are highly favorable.',c.id,'IN_STOCK',0,1,0,'Power Tools | Vortex Precision IT','If users in manufacturing plant wish to save the time, resources and make the task simple and effective, power tools are highly favorable.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRT-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000028-0000-4000-8000-000000000028','Pneumatic tools','pneumatic-tools','RF-MRT-03','A pneumatic tool or air tool like jackhammer utilises the energy of compressed air as the power for its operation. Also, it is the perfect solutions for site locations in remote area where power access is limited or there is absolutely no power access available. From increased power potential to the stability of a well-maintained air compressor system, pneumatic tools are a reliable way to accomplish the MRO task. The greatest advantages of the use of such tools for the industries are the dependability of continuous use and less breakdowns and maintenance reflects in lower down times.','A pneumatic tool or air tool like jackhammer utilises the energy of compressed air as the power for its operation.',c.id,'IN_STOCK',0,1,0,'Pneumatic tools | Vortex Precision IT','A pneumatic tool or air tool like jackhammer utilises the energy of compressed air as the power for its operation.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRT-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000029-0000-4000-8000-000000000029','Milling tools','milling-tools','RF-MRT-04','Shaping and cutting solid materials like metal, wood, plastics or even brass, the most versatile milling machines with a wide range of cutting or milling tools are used in industries that allows completing complicated operations such as indexing, straddle milling & gang milling, slot cutting, planning and drilling etc.','Shaping and cutting solid materials like metal, wood, plastics or even brass, the most versatile milling machines with a wide range of cutting or milling tools are used in industries that allows completing complicated operations such as indexing, straddle milling & gang milling, slot cutting, planning and drilling etc.',c.id,'IN_STOCK',0,1,0,'Milling tools | Vortex Precision IT','Shaping and cutting solid materials like metal, wood, plastics or even brass, the most versatile milling machines with a wide range of cutting or milling tools are used in industries that allows completing complicated operations such as indexing, straddle milling & gang milling, slot cutting, planning and drilling etc.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRT-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000030-0000-4000-8000-000000000030','Gas Turbine','gas-turbine','RF-RTY-01','A gas turbine is the soul of the power plants. Its main purpose is to generate electricity by heating a mixture of air and fuel, at high temperatures causing the turbine blades to spin. We remain supplier neutral and aim to select the finest gas turbines according to our clients\' procurement requirements as well as minimising their costs.','A gas turbine is the soul of the power plants.',c.id,'MADE_TO_ORDER',0,1,0,'Gas Turbine | Vortex Precision IT','A gas turbine is the soul of the power plants.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000031-0000-4000-8000-000000000031','Steam Turbine','steam-turbine','RF-RTY-02','Similarly, a steam turbine is equally important to the process industry. It transforms thermal energy to mechanical energy and the turbine can work with either constant or variable speeds depending on the type of application. They can be utilised as a mechanical drive for compressors and pumps, available in different sizes ranging from small to large.','Similarly, a steam turbine is equally important to the process industry.',c.id,'MADE_TO_ORDER',0,1,0,'Steam Turbine | Vortex Precision IT','Similarly, a steam turbine is equally important to the process industry.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000032-0000-4000-8000-000000000032','Compressors','compressors','RF-RTY-03','Compressors are used to increase the pressure of any fluid, and this in turn reduces the quantity of the fluid. Gases are compressible as well as some liquids. We supply the finest air compressors used with refineries and mainly general manufacturing. At Refteck, we understand the importance of air quality and the strict requirements of the compressors and hence we can help source the correct compressor to meet our clients\' procurement expectations.','Compressors are used to increase the pressure of any fluid, and this in turn reduces the quantity of the fluid.',c.id,'MADE_TO_ORDER',0,1,0,'Compressors | Vortex Precision IT','Compressors are used to increase the pressure of any fluid, and this in turn reduces the quantity of the fluid.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000033-0000-4000-8000-000000000033','Gearboxes','gearboxes','RF-RTY-04','We offer a variety of gearboxes of different types, shapes and sizes such as worm, helical, planetary, and spur. Gear boxes are essentially used to alter speed, direction and the torque of the mechanical equipment. It is a vital piece of equipment; with just a small amount of rotational force, gear boxes are able to generate an even greater torque.','We offer a variety of gearboxes of different types, shapes and sizes such as worm, helical, planetary, and spur.',c.id,'MADE_TO_ORDER',0,1,0,'Gearboxes | Vortex Precision IT','We offer a variety of gearboxes of different types, shapes and sizes such as worm, helical, planetary, and spur.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000034-0000-4000-8000-000000000034','Reciprocating Engines','reciprocating-engines','RF-RTY-05','A reciprocating engine is mainly used for transforming pressure into a rotating motion, used in various power generation applications such as it provides a back-up capacity for power generation or can be used for industrial and commercial power systems. We provide the finest and robust products as we understand how important the automation is within the process industry.','A reciprocating engine is mainly used for transforming pressure into a rotating motion, used in various power generation applications such as it provides a back-up capacity for power generation or can be used for industrial and commercial power systems.',c.id,'MADE_TO_ORDER',0,1,0,'Reciprocating Engines | Vortex Precision IT','A reciprocating engine is mainly used for transforming pressure into a rotating motion, used in various power generation applications such as it provides a back-up capacity for power generation or can be used for industrial and commercial power systems.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000035-0000-4000-8000-000000000035','Diesel Engine','diesel-engine','RF-RTY-06','There are two types of diesel engines; a two stroke or a four stroke. It has the topmost thermal efficiency of any combustion engine used within the industrial and domestic industry. We source modern diesel engines which are noiseless, low cost and that require less maintenance than the natural or propane gas-powered generators.','There are two types of diesel engines; a two stroke or a four stroke.',c.id,'MADE_TO_ORDER',0,1,0,'Diesel Engine | Vortex Precision IT','There are two types of diesel engines; a two stroke or a four stroke.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000036-0000-4000-8000-000000000036','Controls and instrumentation','controls-and-instrumentation','RF-RTY-07','In order to run an operation smoothly, controls and instrumentation are required of the highest quality to ensure that precise measurement and control of the entire process is conducted such as meters, regulators, gauges, detectors, sensors, control panels and etc. It also has various applications including in power generation, industrial and fire pumping, irrigation, agriculture, oil and gas production and marine equipment.','In order to run an operation smoothly, controls and instrumentation are required of the highest quality to ensure that precise measurement and control of the entire process is conducted such as meters, regulators, gauges, detectors, sensors, control panels and etc.',c.id,'MADE_TO_ORDER',0,1,0,'Controls and instrumentation | Vortex Precision IT','In order to run an operation smoothly, controls and instrumentation are required of the highest quality to ensure that precise measurement and control of the entire process is conducted such as meters, regulators, gauges, detectors, sensors, control panels and etc.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000037-0000-4000-8000-000000000037','Ancillaries and Accessories','ancillaries-and-accessories','RF-RTY-08','Enhance your rotary equipment\'s performance with our range of ancillaries and accessories. Designed to complement our core products, these components include seals, bearings, and drive mechanisms, ensuring optimal functionality and longevity. Choose from our high-quality offerings to tailor your rotary systems to your specific operational needs.','Enhance your rotary equipment\'s performance with our range of ancillaries and accessories.',c.id,'MADE_TO_ORDER',0,1,0,'Ancillaries and Accessories | Vortex Precision IT','Enhance your rotary equipment\'s performance with our range of ancillaries and accessories.'
  FROM categories c
 WHERE c.slug = 'rotary-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-RTY-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000038-0000-4000-8000-000000000038','Diaphragm Pumps','diaphragm-pumps','RF-PMP-01','Mining, industrial and general manufacturing plants where electricity is unavailable diaphragm pumps are extensively used. Also these pumps are highly used in explosive or flammable areas for pumping applications of viscous or difficult fluids like fuels, glues, paints, resins, inks, dewatering underground coal mines and also in processing of food-based or cosmetic liquids. The specific feature of diaphragm pump is it creates a vacuum in the inlet when it is pumping so it can be mounted over the liquid it is pumping.','Mining, industrial and general manufacturing plants where electricity is unavailable diaphragm pumps are extensively used.',c.id,'IN_STOCK',0,1,0,'Diaphragm Pumps | Vortex Precision IT','Mining, industrial and general manufacturing plants where electricity is unavailable diaphragm pumps are extensively used.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000039-0000-4000-8000-000000000039','Centrifugal Pumps','centrifugal-pumps','RF-PMP-02','Centrifugal pumps with different configurations are fire pumps, end suction pumps, chopper pumps, grinder pumps and many more. It can be quick to install and generally require low level of maintenance and are simple to maintain. In reverse it works like water turbines. Besides oil and gas industry these pumps have numerous applications in power plants, process industries for chemicals, paints, petrochemicals, pharmaceuticals, cellulose, hydrocarbons, food and beverage production and sugar refining.','Centrifugal pumps with different configurations are fire pumps, end suction pumps, chopper pumps, grinder pumps and many more.',c.id,'IN_STOCK',0,1,0,'Centrifugal Pumps | Vortex Precision IT','Centrifugal pumps with different configurations are fire pumps, end suction pumps, chopper pumps, grinder pumps and many more.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000040-0000-4000-8000-000000000040','Hydraulic Pump','hydraulic-pump','RF-PMP-03','Any processing industry which needs heavy or repetitive work done with the greatest efficiency hydraulic equipment applications are always available there to fill the need. Industrial hydraulic pumps such as vane pump, gear pump, and piston pumps are used on heavy machineries like excavators, cranes, loaders, tractors, graders, dump trucks and mining machinery etc.','Any processing industry which needs heavy or repetitive work done with the greatest efficiency hydraulic equipment applications are always available there to fill the need.',c.id,'IN_STOCK',0,1,0,'Hydraulic Pump | Vortex Precision IT','Any processing industry which needs heavy or repetitive work done with the greatest efficiency hydraulic equipment applications are always available there to fill the need.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000041-0000-4000-8000-000000000041','Vacuum Pump','vacuum-pump','RF-PMP-04','Chemical processing and manufacturing industries require vacuum for various applications such as plastic molding processes, production of lamps, tubes, CRT displays, semiconductor processing, glass coatings and many more. For a wide variety of purposes and benefits Vacuum pumping systems are used. Industrial vacuum pumps handle organic solvents and compounds in a reliable and safe way. Also, these pumps ensure control and reduction of environmental pollution and cost of ownership.','Chemical processing and manufacturing industries require vacuum for various applications such as plastic molding processes, production of lamps, tubes, CRT displays, semiconductor processing, glass coatings and many more.',c.id,'IN_STOCK',0,1,0,'Vacuum Pump | Vortex Precision IT','Chemical processing and manufacturing industries require vacuum for various applications such as plastic molding processes, production of lamps, tubes, CRT displays, semiconductor processing, glass coatings and many more.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000042-0000-4000-8000-000000000042','Screw Pump','screw-pump','RF-PMP-05','Screw pumps (twin and three screw pumps) are uniquely and largely playing a key role in upstream and midstream environment of oil and gas industry by offering long term benefits to their users. Crude oil is highly viscous in nature and often requires diluents, steam or other stimulation to flow the oil from the reservoirs to the pipelines. Vertical screw pumps are highly suitable for pumping these types of nontraditional grades of crude oil.','Screw pumps (twin and three screw pumps) are uniquely and largely playing a key role in upstream and midstream environment of oil and gas industry by offering long term benefits to their users.',c.id,'IN_STOCK',0,1,0,'Screw Pump | Vortex Precision IT','Screw pumps (twin and three screw pumps) are uniquely and largely playing a key role in upstream and midstream environment of oil and gas industry by offering long term benefits to their users.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000043-0000-4000-8000-000000000043','Split Casing Pumps','split-casing-pumps','RF-PMP-06','The workhorses for industrial and domestic pumping applications are split casing pumps e.g. horizontally axially split casing, single stage, double suction pumps etc. These pumps are highly used in industries for handling water with impurities, petroleum refineries, air conditioning and refrigeration system and in the mining industry.','The workhorses for industrial and domestic pumping applications are split casing pumps e.g.',c.id,'IN_STOCK',0,1,0,'Split Casing Pumps | Vortex Precision IT','The workhorses for industrial and domestic pumping applications are split casing pumps e.g.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000044-0000-4000-8000-000000000044','Magnetic Drive Pump','magnetic-drive-pump','RF-PMP-07','The magnetic drive pumps are seal less pumps that use a balanced magnetic field to create the rotation of the fluid impeller. Being completely leak-proof these are one of the only types of pumps that use the force of magnetism. These pumps are engineered to meet the harshest environment conditions. Corrosive and fluids with high viscosity like adhesives, chemicals, concretes, hazardous materials, oils, gasoline, saltwater, groundwater and wastewater can be effectively handled with magnetic drive pumps.','The magnetic drive pumps are seal less pumps that use a balanced magnetic field to create the rotation of the fluid impeller.',c.id,'IN_STOCK',0,1,0,'Magnetic Drive Pump | Vortex Precision IT','The magnetic drive pumps are seal less pumps that use a balanced magnetic field to create the rotation of the fluid impeller.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000045-0000-4000-8000-000000000045','Industrial Oil Pumps','industrial-oil-pumps','RF-PMP-08','Industrial oil pumps are the heart and soul of the oil and gas industry sector. These must cover a wide range of viscosity with uniform and efficient performance to deliver high discharge pressure or high capacity, depending on the requirements. These pumps are capable of pumping crude oil that contains gas or is mixed with salt water.','Industrial oil pumps are the heart and soul of the oil and gas industry sector.',c.id,'IN_STOCK',0,1,0,'Industrial Oil Pumps | Vortex Precision IT','Industrial oil pumps are the heart and soul of the oil and gas industry sector.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000046-0000-4000-8000-000000000046','Bilge pump','bilge-pump','RF-PMP-09','Bilge Pumps play an important role in order to empty the bilge well of marine vessel at regular interval of time to prevent the flood in engine room. All the systems on vessel require proper operational bilge pump and pumping system for it to be at sea for prolonged periods.','Bilge Pumps play an important role in order to empty the bilge well of marine vessel at regular interval of time to prevent the flood in engine room.',c.id,'IN_STOCK',0,1,0,'Bilge pump | Vortex Precision IT','Bilge Pumps play an important role in order to empty the bilge well of marine vessel at regular interval of time to prevent the flood in engine room.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-09');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000047-0000-4000-8000-000000000047','Heating pump','heating-pump','RF-PMP-10','The heating pump utilises promising techniques with multitude applications within the process industry. Such pumps are useful in conserving energy in industrial processes by recovering waste heat produced in plant and lift the temperature to a level high enough for reuse. Recoverable waste heat and process heat are found in industrial verticals like food processing, paper and pulp, refineries, and chemical industry etc. These types of pumps can also function reversibly as space coolers.','The heating pump utilises promising techniques with multitude applications within the process industry.',c.id,'IN_STOCK',0,1,0,'Heating pump | Vortex Precision IT','The heating pump utilises promising techniques with multitude applications within the process industry.'
  FROM categories c
 WHERE c.slug = 'pumps'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PMP-10');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000048-0000-4000-8000-000000000048','Autoclaves','autoclaves','RF-PRC-01','Various scientific operations in laboratories require hygiene, disinfection and sterilisation of glassware and instruments. Very large in size and highly specialised autoclaves have been used for this specific task in industrial laboratories. Other than dairy operations, food processing units, wineries autoclaves also play major role in rubber industry for vulcanisation of rubber i.e. thermoplastic process, or making something mouldable by applying heat at specific temperature and pressurised environment.','Various scientific operations in laboratories require hygiene, disinfection and sterilisation of glassware and instruments.',c.id,'IN_STOCK',0,1,0,'Autoclaves | Vortex Precision IT','Various scientific operations in laboratories require hygiene, disinfection and sterilisation of glassware and instruments.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000049-0000-4000-8000-000000000049','Filtration','filtration','RF-PRC-02','Manufacturers and industrial process facilities maintain their production levels in very high volumes. Pollutants always have the diverse effect on humans, machines, and the environment. Such factors have lead to a rising demand for extraction and filtration technology, which reliably protects equipment and employee health, and furthermore takes account of changing process parameters. Products that are easy to fit, robust enough to handle the environment and ones that can easily be replaced if needed are the requirement of the effective filtration system. An efficient filtration system and filters reduce the cost of raw materials used in industrial processes.','Manufacturers and industrial process facilities maintain their production levels in very high volumes.',c.id,'IN_STOCK',0,1,0,'Filtration | Vortex Precision IT','Manufacturers and industrial process facilities maintain their production levels in very high volumes.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000050-0000-4000-8000-000000000050','Heat Exchangers','heat-exchangers','RF-PRC-03','Heat exchangers are one of the important components of air conditioning, cooling or heating systems in various industry verticals. Heat Exchangers play an important role to keep industrial machinery, chemicals, fluids, gas, and other substances within a safe operating temperature. Heat exchangers also have a wide range of industrial applications in oil and gas industry, power generation, chemical processing, space heating, refrigeration, petrochemical plants and refineries, and also in sewage treatment. Steam or heat exhaust released as a by-product of the process can also be captured or transferred for better utilisation with the help of heat exchangers which result in the increase in efficiency and enhance revenue.','Heat exchangers are one of the important components of air conditioning, cooling or heating systems in various industry verticals.',c.id,'IN_STOCK',0,1,0,'Heat Exchangers | Vortex Precision IT','Heat exchangers are one of the important components of air conditioning, cooling or heating systems in various industry verticals.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000051-0000-4000-8000-000000000051','Industrial Piping & Tubing','industrial-piping-and-tubing','RF-PRC-04','Industrial piping and tubing is a closed system which plays a crucial role to any processing plant. Oil and Gas, petrochemical complexes, refineries, chemical production facilities, power generation plants and other manufacturing industries use this closed system for transport of fluid, solid and gases with zero loss of the quality and properties of the material being transferred from one location to other.','Industrial piping and tubing is a closed system which plays a crucial role to any processing plant.',c.id,'IN_STOCK',0,1,0,'Industrial Piping & Tubing | Vortex Precision IT','Industrial piping and tubing is a closed system which plays a crucial role to any processing plant.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000052-0000-4000-8000-000000000052','Bearings','bearings','RF-PRC-05','Bearings play a major role in reducing friction among components and keep them at precise places. Proper knowledge of the application of bearings is essential for various activities such as maintenance, repairing, installation, removal, lubrication, and troubleshooting in various machineries. In absence of bearings, all the engines, steering, driveshaft and driveline etc. in heavy machineries definitely would not work. Ball bearing, roller bearing, ball thrust bearing, tapered roller bearing and many more specialised bearing providing motion to various process industries sectors like automotive, aerospace or aviation, cement industry etc.','Bearings play a major role in reducing friction among components and keep them at precise places.',c.id,'IN_STOCK',0,1,0,'Bearings | Vortex Precision IT','Bearings play a major role in reducing friction among components and keep them at precise places.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000053-0000-4000-8000-000000000053','Hydraulic hoses','hydraulic-hoses','RF-PRC-06','In order to convey fluid to or among hydraulic components such as valves, actuators, and other tools a specifically designed hose named hydraulic hose is used in various industrial processes. When searching for hydraulic hose quite a few important parameters needs to be considered such as dimensions, materials, specifications, performance, nature of use and others features etc. Hydraulic hoses are suitable for high pressure lines in long wall mining equipment, in roof support systems/petroleum or water emulsion fluids and also in working compatibility with biodegradable hydraulic fluids like vegetable oils etc.','In order to convey fluid to or among hydraulic components such as valves, actuators, and other tools a specifically designed hose named hydraulic hose is used in various industrial processes.',c.id,'IN_STOCK',0,1,0,'Hydraulic hoses | Vortex Precision IT','In order to convey fluid to or among hydraulic components such as valves, actuators, and other tools a specifically designed hose named hydraulic hose is used in various industrial processes.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000054-0000-4000-8000-000000000054','Oilfield Equipment and Pipeline','oilfield-equipment-and-pipeline','RF-PRC-07','Oilfield equipment is of great importance in the drilling and oil extraction process. There is an ever growing demand for oil and this creates the necessity of moving oilfield equipment like drilling dampener, pulsation dampener, pipelining and much more from location to location. In other words, there is an increased demand for drilling rig moving equipment. The oil drilling teams in changing site areas need reliable oil field equipment maintenance and other services. Refteck Solutions procure all spare parts and accessories regularly used in these kinds of operations.','Oilfield equipment is of great importance in the drilling and oil extraction process.',c.id,'IN_STOCK',0,1,0,'Oilfield Equipment and Pipeline | Vortex Precision IT','Oilfield equipment is of great importance in the drilling and oil extraction process.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000055-0000-4000-8000-000000000055','Pharmaceutical Process Equipment','pharmaceutical-process-equipment','RF-PRC-08','In Pharmaceutical and chemical industry including petrochemicals, specific reaction chambers/ reactors are used for the completion of various typical reactions. These reactors are widely used for stirring, mixing, temperature and pressure treatment as well as for the treatment of active biochemical ingredients etc. For instance, melting tanks are commonly used in the cosmetics industry to melt aqueous and oil phase while producing cosmetic products at large scale.','In Pharmaceutical and chemical industry including petrochemicals, specific reaction chambers/ reactors are used for the completion of various typical reactions.',c.id,'IN_STOCK',0,1,0,'Pharmaceutical Process Equipment | Vortex Precision IT','In Pharmaceutical and chemical industry including petrochemicals, specific reaction chambers/ reactors are used for the completion of various typical reactions.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000056-0000-4000-8000-000000000056','Wind turbine spares','wind-turbine-spares','RF-PRC-09','Turbines play a crucial role in power generation industry, especially in wind power industry. Offshore wind turbines have proven to be very difficult and expensive in terms of servicing and maintenance. So in order to reduce the costs associated with wind turbine support a well-coordinated support organisation and optimised maintenance strategies are mandatory. At, Refteck we understand the requirement and are capable of sourcing genuine spare parts required for servicing and maintenance of wind power industry.','Turbines play a crucial role in power generation industry, especially in wind power industry.',c.id,'IN_STOCK',0,1,0,'Wind turbine spares | Vortex Precision IT','Turbines play a crucial role in power generation industry, especially in wind power industry.'
  FROM categories c
 WHERE c.slug = 'process-equipment'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-PRC-09');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000057-0000-4000-8000-000000000057','Industrial Gauges','industrial-gauges','RF-INS-01','We have the ability to supply low cost, yet 100% original and durable Industrial Gauges. Pressure related accessories and gauges are devices utilised for measuring the pressure of liquids and fluids in multiple industries. Viewing the increasing need for sophisticated and safer temperature and pressure industries, we at Refteck Solutions have surfaced as a paramount of procurement services and supplying company. According to the CIO 2018 Review, Refteck has the ability to provide the finest of industrial gauges via optimum manufacturers and choicest suppliers in the industry. Gauges procured through Refteck have emerged as benchmarks in temperature and pressure measurement.','We have the ability to supply low cost, yet 100% original and durable Industrial Gauges.',c.id,'IN_STOCK',0,1,0,'Industrial Gauges | Vortex Precision IT','We have the ability to supply low cost, yet 100% original and durable Industrial Gauges.'
  FROM categories c
 WHERE c.slug = 'instrumentation'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-INS-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000058-0000-4000-8000-000000000058','Sensors','sensors','RF-INS-02','Refteck Solutions specialise in procuring and delivering high-performance specialty sensors for various uses and requirements. Sensors come in use with day-to-day items including dimming lamps that activate by merely touching their base, touch-activated elevators, and a host of multiple applications that most people are not even aware of! Armed with advanced micro machinery technology couple with easy to use microprocessor platforms; the use of sensors has extended typical fields of flow measurement, pressure, and temperature: for instance MARG sensors. Furthermore, Refteck Solutions has a panache for delivering the right sensor at the best price ranging from machinery, aerospace and aircraft, medicine, robotics and automotive to anything else imaginative – anywhere in the world!','Refteck Solutions specialise in procuring and delivering high-performance specialty sensors for various uses and requirements.',c.id,'IN_STOCK',0,1,0,'Sensors | Vortex Precision IT','Refteck Solutions specialise in procuring and delivering high-performance specialty sensors for various uses and requirements.'
  FROM categories c
 WHERE c.slug = 'instrumentation'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-INS-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000059-0000-4000-8000-000000000059','Flow Meters','flow-meters','RF-INS-03','Refteck Solutions has the ability to provide multiple varieties of industrial flow meters to cater to your demand. Flow meters are devices that measure the flow rate of liquid by analysing the spread-rate of ultrasonic wave upstream and downstream of liquids in a pipeline. Such a feat is achieved by making use of clamp-on sensors that non-intrusively send and receive ultrasonic waves. The flow meters are affably suited for measuring homogenous liquids bearing immensely low percentage of induced gas bubbles and solids.','Refteck Solutions has the ability to provide multiple varieties of industrial flow meters to cater to your demand.',c.id,'IN_STOCK',0,1,0,'Flow Meters | Vortex Precision IT','Refteck Solutions has the ability to provide multiple varieties of industrial flow meters to cater to your demand.'
  FROM categories c
 WHERE c.slug = 'instrumentation'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-INS-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000060-0000-4000-8000-000000000060','Circuit Breakers','circuit-breakers','RF-ELX-01','A circuit breaker is a widely used product which is ordinarily used in Electrical and Power Transmission Industry. It is an automatically operated electrical switch designed to protect an electrical circuit from damage caused by excess current from an overload or short circuit. Circuit breakers are available in varying sizes, from small devices that protect low-current circuits or individual household appliance, up to large switchgear designed to protect high voltage circuits feeding an entire city. We also offer "Smart" circuit breakers that are currently in trend at most of the industry verticals as it allows the engineers to monitor the digital circuit breaker remotely.','A circuit breaker is a widely used product which is ordinarily used in Electrical and Power Transmission Industry.',c.id,'IN_STOCK',0,1,0,'Circuit Breakers | Vortex Precision IT','A circuit breaker is a widely used product which is ordinarily used in Electrical and Power Transmission Industry.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000061-0000-4000-8000-000000000061','Magnetic Starters','magnetic-starters','RF-ELX-02','Magnetic starters are stock components for many machines, and aftermarket starters are also available for use as replacements or for retrofitting older machines. Magnetic starters are commonly found on equipment drawing several horsepowers or higher. It is an electromagnetically operated switch which provides a safe method for starting an electric motor with a large load. Magnetic starters also provide under-voltage and overload protection and an automatic cut-off in the event of a power failure. We offer Manual Starter, Magnetic Motor Starter, and Magnetic Motor Starter Circuitry and may more depend upon the client\'s requirement.','Magnetic starters are stock components for many machines, and aftermarket starters are also available for use as replacements or for retrofitting older machines.',c.id,'IN_STOCK',0,1,0,'Magnetic Starters | Vortex Precision IT','Magnetic starters are stock components for many machines, and aftermarket starters are also available for use as replacements or for retrofitting older machines.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000062-0000-4000-8000-000000000062','Lighting','lighting','RF-ELX-03','We provide the best in quality, energy-efficiency and ceiling light fixtures, lamps, wall lights, outdoor lighting, fans, and other accents by fulfilling the HVAC requirement at the plant specifically for the commercial purpose. We can cater to your budget while also getting the supply completed punctually and exactly to one\'s individual specifications. Reasonable prices and pleasant customer service are the perfect combinations in every Supply Chain environment. When you have a business, it\'s important of all of the above, efficient team and everything else you need is right here at www.refteck.com','We provide the best in quality, energy-efficiency and ceiling light fixtures, lamps, wall lights, outdoor lighting, fans, and other accents by fulfilling the HVAC requirement at the plant specifically for the commercial purpose.',c.id,'IN_STOCK',0,1,0,'Lighting | Vortex Precision IT','We provide the best in quality, energy-efficiency and ceiling light fixtures, lamps, wall lights, outdoor lighting, fans, and other accents by fulfilling the HVAC requirement at the plant specifically for the commercial purpose.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000063-0000-4000-8000-000000000063','Cabling','cabling','RF-ELX-04','We offer a full range of ELV (Extra-low voltage) and LV (low voltage) wire and cable products of various makes. We trust only to the reliable technology that you can confidently use for years. While it may not seem like the type of wiring and cabling you use are necessarily important. Refteck is in an SCM business for large industries with a strong background in working directly with manufacturers of wiring and cabling using the cutting edge technology, only prefer the highest-quality products and systems for the clients.','We offer a full range of ELV (Extra-low voltage) and LV (low voltage) wire and cable products of various makes.',c.id,'IN_STOCK',0,1,0,'Cabling | Vortex Precision IT','We offer a full range of ELV (Extra-low voltage) and LV (low voltage) wire and cable products of various makes.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000064-0000-4000-8000-000000000064','Panel Boards','panel-boards','RF-ELX-05','A Panelboard (PB) is the component in which the electrical supply is distributed from within the building. The main supply cable comes into the board and is then distributed to the breakers and from there to all the circuits, e.g. lights, plugs etc. Panelboard is an electricity supply system that divides an electrical power feed into subsidiary circuits while providing a protective fuse or circuit breaker for each circuit in a common enclosure. We offer both the main types of Panelboards i.e. distribution and appliance panelboards.','A Panelboard (PB) is the component in which the electrical supply is distributed from within the building.',c.id,'IN_STOCK',0,1,0,'Panel Boards | Vortex Precision IT','A Panelboard (PB) is the component in which the electrical supply is distributed from within the building.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000065-0000-4000-8000-000000000065','Transformers','transformers','RF-ELX-06','Since the high voltages carried in the wires are significantly greater than what is needed in-home, transformers are also used extensively in electronic products to decrease (or step-down) the supply voltage to a level suitable for the low voltage circuits they contain. We know transformers, from Toroid, Ferrite, Laminated Iron Core, High Voltage, Auto Transformers, Audio, Encapsulated, Power Transformers, and Instrument Transformers which sold under different brands. We used to outsource this product as per the end user procurement requirement. This is what we do and we do it well.','Since the high voltages carried in the wires are significantly greater than what is needed in-home, transformers are also used extensively in electronic products to decrease (or step-down) the supply voltage to a level suitable for the low voltage circuits they contain.',c.id,'IN_STOCK',0,1,0,'Transformers | Vortex Precision IT','Since the high voltages carried in the wires are significantly greater than what is needed in-home, transformers are also used extensively in electronic products to decrease (or step-down) the supply voltage to a level suitable for the low voltage circuits they contain.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000066-0000-4000-8000-000000000066','Electric Generator','electric-generator','RF-ELX-07','Generators are available that provide one phase or three-phase power, 120 volts or 480 volts. Industrial applications normally call for three-phase power generation or 480 volts. Generators for multiple requirements include those that provide 120 – 208-volt service and 277 – 480-volt service. Major types of Industrial Generators that we offer are as follows: Diesel Generators, Petroleum, Portable Industrial Generators, Heavy Fuel Oil Generators, etc...','Generators are available that provide one phase or three-phase power, 120 volts or 480 volts.',c.id,'IN_STOCK',0,1,0,'Electric Generator | Vortex Precision IT','Generators are available that provide one phase or three-phase power, 120 volts or 480 volts.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000067-0000-4000-8000-000000000067','Batteries','batteries','RF-ELX-08','Industrial applications have unique power needs and the choice of battery is important. While consumer products demand high energy density to obtain slim and elegant designs, industry focuses on durability and reliability. Industrial batteries are commonly bulkier than those used in consumer products but achieve a longer service life. All these parameters are focused here at Refteck that bring expertise with batteries, outsourcing, and distribution to equipment manufacturing, working with the Major OEM partners to supply batteries and solutions that comply with regulations and exceed performance challenges.','Industrial applications have unique power needs and the choice of battery is important.',c.id,'IN_STOCK',0,1,0,'Batteries | Vortex Precision IT','Industrial applications have unique power needs and the choice of battery is important.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000068-0000-4000-8000-000000000068','Electric Motors','electric-motors','RF-ELX-09','The largest electric motors are used for ship propulsion, pipeline compression and pumped-storage applications with ratings reaching 100 megawatts. Electric motors are found in industrial fans, blowers and pumps, machine tools, household appliances, power tools, and disk drives. Electric motors exist in all diversified range of industries including oil and gas, refining, heavy and medium engineering and many more. Various types of motors that we offer are Squirrel Cage Induction Motor, Three phases Synchronous Motor, DC Shunt Motor, DC Series Motor etc. We provide application-engineered specialty fractional-horsepower motor and motion control products. Refteck provides advanced precision solutions with the highest reliability and cost-efficient motors which is best suitable for customer need.','The largest electric motors are used for ship propulsion, pipeline compression and pumped-storage applications with ratings reaching 100 megawatts.',c.id,'IN_STOCK',0,1,0,'Electric Motors | Vortex Precision IT','The largest electric motors are used for ship propulsion, pipeline compression and pumped-storage applications with ratings reaching 100 megawatts.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-09');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000069-0000-4000-8000-000000000069','Contactors','contactors','RF-ELX-10','When a relay is used to switch a large amount of electrical power through its contacts, it is designated by a special name: contactor. We offer compact high voltage relays and high voltage reed relays for specialised DC and RF (Radio Frequency) application requirements.','When a relay is used to switch a large amount of electrical power through its contacts, it is designated by a special name: contactor.',c.id,'IN_STOCK',0,1,0,'Contactors | Vortex Precision IT','When a relay is used to switch a large amount of electrical power through its contacts, it is designated by a special name: contactor.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-10');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000070-0000-4000-8000-000000000070','Enclosures','enclosures','RF-ELX-11','Enclosures are specifically designed to enclose electrical and/or electronic equipment and protect against harsh, industrial environments. They are used as instrument enclosures, electric, hydraulic or pneumatic control housings, electrical junction boxes or terminal wiring enclosures. Current trend generally focuses on impressive styling features that make us more curious to cross match the exact requirement to suit any high-tech equipment installation which needs a powerful protection. Corrosion Resistant Enclosures, Disconnect Enclosures, Modular Freestanding Enclosures, Commercial Enclosures, are some major categories that we source from the known original equipment manufacturer.','Enclosures are specifically designed to enclose electrical and/or electronic equipment and protect against harsh, industrial environments.',c.id,'IN_STOCK',0,1,0,'Enclosures | Vortex Precision IT','Enclosures are specifically designed to enclose electrical and/or electronic equipment and protect against harsh, industrial environments.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-11');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000071-0000-4000-8000-000000000071','Relays','relays','RF-ELX-12','At Refteck solutions, we recommend numerous applications for electromechanical relays. Several types of relays are used in applications based on varying criteria such as rating, number & type, the voltage rating of contacts, operating lifetime, coil voltage & current, package, and so on. Relays are frequently being used in power system networks for controlling, automation, and protection purpose. We look to various OEM for answers to the most important circuit protection questions. Our innovation, proven technical expertise, comprehensive portfolio of technologies and global resources enable us to provide objective, comprehensive solutions for each customer\'s unique applications.','At Refteck solutions, we recommend numerous applications for electromechanical relays.',c.id,'IN_STOCK',0,1,0,'Relays | Vortex Precision IT','At Refteck solutions, we recommend numerous applications for electromechanical relays.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-12');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000072-0000-4000-8000-000000000072','Electrical Switches','electrical-switches','RF-ELX-13','The definition of relay states "A relay is an electrically operated switch" so electrical switches are viewed in a wider sense if it comes to the industrial sector. Various categories such as pushbuttons, emergency stop safety switch, select switch, rocker switch, toggle switch, switch unit, foot switch etc, they all are usually operated over a wide range of voltage, current, and power ratings. Depending upon the specification we offer the best choices.','The definition of relay states "A relay is an electrically operated switch" so electrical switches are viewed in a wider sense if it comes to the industrial sector.',c.id,'IN_STOCK',0,1,0,'Electrical Switches | Vortex Precision IT','The definition of relay states "A relay is an electrically operated switch" so electrical switches are viewed in a wider sense if it comes to the industrial sector.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-13');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000073-0000-4000-8000-000000000073','LED Systems','led-systems','RF-ELX-14','Although LED lighting market size was estimated lower but is expected to witness significant growth over the forecast period. High efficiency, reliability, and a longer lifespan are expected to drive LED demand over conventional technologies. Refteck focuses to provide High brightness level, condensed size, low power consumption, and robust nature LED solutions that will surely trigger industry growth.','Although LED lighting market size was estimated lower but is expected to witness significant growth over the forecast period.',c.id,'IN_STOCK',0,1,0,'LED Systems | Vortex Precision IT','Although LED lighting market size was estimated lower but is expected to witness significant growth over the forecast period.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-14');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000074-0000-4000-8000-000000000074','Variable Frequency Drives','variable-frequency-drives','RF-ELX-15','Variable Frequency Drive (VFD) is a type of motor controller that drives an electric motor by varying the frequency and voltage supplied to the electric motor. Other names for a VFD are variable speed drive, adjustable speed drive, adjustable frequency drive, AC drive, microdrive, and inverter. Typical Applications of VFD are the Commercial lift, Industrial pumping systems, Miniature lathes and mills, Small shop machine tools and many more. Refteck focuses specifically on engineered for today\'s more demanding commercial and industrial applications.','Variable Frequency Drive (VFD) is a type of motor controller that drives an electric motor by varying the frequency and voltage supplied to the electric motor.',c.id,'IN_STOCK',0,1,0,'Variable Frequency Drives | Vortex Precision IT','Variable Frequency Drive (VFD) is a type of motor controller that drives an electric motor by varying the frequency and voltage supplied to the electric motor.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-15');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000075-0000-4000-8000-000000000075','Electrical Conduit Fittings','electrical-conduit-fittings','RF-ELX-16','Electrical conduit provides very good protection to enclosed conductors from impact, moisture, and chemical vapours. Varying numbers, sizes, and types of conductors can be pulled into a conduit, which simplifies design and construction compared to multiple runs of cables or the expense of customised composite cable. Wiring systems in buildings may be subject to frequent alterations. Frequent wiring changes are made simpler and safer through the use of electrical conduit, as existing conductors can be withdrawn and new conductors installed, with little disruption along the path of the conduit.','Electrical conduit provides very good protection to enclosed conductors from impact, moisture, and chemical vapours.',c.id,'IN_STOCK',0,1,0,'Electrical Conduit Fittings | Vortex Precision IT','Electrical conduit provides very good protection to enclosed conductors from impact, moisture, and chemical vapours.'
  FROM categories c
 WHERE c.slug = 'electrical-power-transmission'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-ELX-16');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000076-0000-4000-8000-000000000076','Chain hoist','chain-hoist','RF-MRO-01','Chain hoists (electric) are suitable for various jobs that require lifting of heavy equipment at sites. Such heavy duty lifting machines are able to lift and relocate large and heavy material quickly and effectively, which in turn helps to lower worker expenses and increases your bottom line. A mining hoist used in underground mining used for raising humans, equipment, and assorted loads has a key role to play in the industry. Refteck is aware of the different uses of the chain hoists in different industry verticals and has been continuously supporting the client\'s requirements.','Chain hoists (electric) are suitable for various jobs that require lifting of heavy equipment at sites.',c.id,'IN_STOCK',0,1,0,'Chain hoist | Vortex Precision IT','Chain hoists (electric) are suitable for various jobs that require lifting of heavy equipment at sites.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000077-0000-4000-8000-000000000077','Rock Tricone drill bit','rock-tricone-drill-bit','RF-MRO-02','The tricone drill bits are extensively used in the process of local rock fracture and mining comminution these also play a crucial role in the removal of any kind of rock. The different types of tricone drill bit bearings are used in the mining and construction industry are open roller bearings, air-cooled roller bearings, sealed roller bearings, and sealed journal bearings etc. Proper maintenance of drill bit is highly recommended for the required and successful results. Refteck helps to procure accessories required for specific drilling bits used in industries for different purposes, including high- speed steel, solid carbide, coal and diamond related etc.','The tricone drill bits are extensively used in the process of local rock fracture and mining comminution these also play a crucial role in the removal of any kind of rock.',c.id,'IN_STOCK',0,1,0,'Rock Tricone drill bit | Vortex Precision IT','The tricone drill bits are extensively used in the process of local rock fracture and mining comminution these also play a crucial role in the removal of any kind of rock.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000078-0000-4000-8000-000000000078','Couplings','couplings','RF-MRO-03','Couplings, serving as very important transmission elements, are not any exception to fulfill higher and a lot of rigorous quality necessities. Within the world of power transmission, most couplings accommodate for the failings and dynamics inherent in most systems. Versatile couplings complete arrangement, whereas rigid styles square measure used once shafts square measure already in alignment. Precision, or motion management couplings, give precise transmission of speed, angular positioning, and torque.','Couplings, serving as very important transmission elements, are not any exception to fulfill higher and a lot of rigorous quality necessities.',c.id,'IN_STOCK',0,1,0,'Couplings | Vortex Precision IT','Couplings, serving as very important transmission elements, are not any exception to fulfill higher and a lot of rigorous quality necessities.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000079-0000-4000-8000-000000000079','Gasket','gasket','RF-MRO-04','Industrial gaskets and seals play an important role in ensuring leak proof processes. With various industrial applications in use these gaskets are need to satisfy every application\'s specific requirement. A gasket\'s important function is to provide a strong seal of a gas or a fluid throughout the lifetime of the appliance. All manufacturing industries such as heavy engineering, electronics, aerospace, defense and many more use gaskets within the production facilities.','Industrial gaskets and seals play an important role in ensuring leak proof processes.',c.id,'IN_STOCK',0,1,0,'Gasket | Vortex Precision IT','Industrial gaskets and seals play an important role in ensuring leak proof processes.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000080-0000-4000-8000-000000000080','O Rings','o-rings','RF-MRO-05','Heavy manufacturing industries such as metal, automotive, wind generation and energy, construction, mining, oil and gas offer a difficult working atmosphere for radial shaft seals. The seals need to reliably retain lubricants and greases in order to prevent harsh contaminants from entering the system because the machines operate in a varying range of speeds, temperature, pressure and environmental conditions. O ring is a sealing device which blocks the pathway through which air or fluid may escape and affects the working.','Heavy manufacturing industries such as metal, automotive, wind generation and energy, construction, mining, oil and gas offer a difficult working atmosphere for radial shaft seals.',c.id,'IN_STOCK',0,1,0,'O Rings | Vortex Precision IT','Heavy manufacturing industries such as metal, automotive, wind generation and energy, construction, mining, oil and gas offer a difficult working atmosphere for radial shaft seals.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000081-0000-4000-8000-000000000081','Washers','washers','RF-MRO-06','Circulars disks made up of metallic or non-metallic material fixed with a nut are called Washers (plain, spring and locking washers). Also washers are placed beneath a joint to relieve friction, an axle bearing, to stop leakage and loosening, or to distribute pressure. In order to prevent the loss of preload after torque is applied bolted joints need hardened steel washers. The characterisation and measurement of washers is done by either metric or imperial design units and their dimension can be specified by standard and gauged values, or may be customised for particular applications.','Circulars disks made up of metallic or non-metallic material fixed with a nut are called Washers (plain, spring and locking washers).',c.id,'IN_STOCK',0,1,0,'Washers | Vortex Precision IT','Circulars disks made up of metallic or non-metallic material fixed with a nut are called Washers (plain, spring and locking washers).'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000082-0000-4000-8000-000000000082','Nuts Bolts','nuts-bolts','RF-MRO-07','The smallest unit of an instrument or equipment is nuts and bolts. Without nuts and bolts together one cannot produce strong equipment. These are important parts of any building or mechanical product. Carelessness in choosing the correct nuts and bolts for projects may hampers the progress because equipment cannot work properly.','The smallest unit of an instrument or equipment is nuts and bolts.',c.id,'IN_STOCK',0,1,0,'Nuts Bolts | Vortex Precision IT','The smallest unit of an instrument or equipment is nuts and bolts.'
  FROM categories c
 WHERE c.slug = 'maintenance-repair-operation-tools'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-MRO-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000083-0000-4000-8000-000000000083','Lubricating grease','lubricating-grease','RF-OLC-01','Lubricating grease makes it simpler to adhere to the moving surfaces of the machinery because it is a semi-solid mixture which does not easily flow like a fluid, composed of mineral oil blended with a soap thickener. Its unique properties make it a highly reliable lubricant because it is easy to handle and has great sealing abilities. Lubricating grease is mainly used within the construction industry, agriculture, oil and gas industry, chemical plants and etc.','Lubricating grease makes it simpler to adhere to the moving surfaces of the machinery because it is a semi-solid mixture which does not easily flow like a fluid, composed of mineral oil blended with a soap thickener.',c.id,'IN_STOCK',0,1,0,'Lubricating grease | Vortex Precision IT','Lubricating grease makes it simpler to adhere to the moving surfaces of the machinery because it is a semi-solid mixture which does not easily flow like a fluid, composed of mineral oil blended with a soap thickener.'
  FROM categories c
 WHERE c.slug = 'industrial-oil-chemicals-lubrications'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-OLC-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000084-0000-4000-8000-000000000084','Grease gun','grease-gun','RF-OLC-02','At Refteck, we offer a variety of grease guns including lever, pistol grip and hand grip as we understand our clients\' procurement requirements and hence we source the best grease guns suited to their situation. A grease gun is a mechanical instrument which pumps about one to three grammes of grease per stroke, which are either air or battery powered.','At Refteck, we offer a variety of grease guns including lever, pistol grip and hand grip as we understand our clients\' procurement requirements and hence we source the best grease guns suited to their situation.',c.id,'IN_STOCK',0,1,0,'Grease gun | Vortex Precision IT','At Refteck, we offer a variety of grease guns including lever, pistol grip and hand grip as we understand our clients\' procurement requirements and hence we source the best grease guns suited to their situation.'
  FROM categories c
 WHERE c.slug = 'industrial-oil-chemicals-lubrications'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-OLC-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000085-0000-4000-8000-000000000085','Industrial oil and chemicals','industrial-oil-and-chemicals','RF-OLC-03','Three quarters of the chemicals manufactured today are used to make other products in various industries such as detergents, soaps and perfumes. Industrial oils are essential and are used mainly for supplying energy to the power industry, heating homes and providing fuel for vehicles and aeroplanes. At Refteck, we source a range of industrials oils and chemicals to meet our clients\' requirements.','Three quarters of the chemicals manufactured today are used to make other products in various industries such as detergents, soaps and perfumes.',c.id,'IN_STOCK',0,1,0,'Industrial oil and chemicals | Vortex Precision IT','Three quarters of the chemicals manufactured today are used to make other products in various industries such as detergents, soaps and perfumes.'
  FROM categories c
 WHERE c.slug = 'industrial-oil-chemicals-lubrications'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-OLC-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000086-0000-4000-8000-000000000086','Industrial Grease','industrial-grease','RF-OLC-04','At Refteck, we provide a comprehensive selection of industrial grease products designed to meet the demands of various applications. As leading industrial grease suppliers, we offer high-performance industrial grease oil that ensures optimal lubrication and protection for machinery. Our industrial grease lubricants are formulated to withstand extreme conditions, reducing wear and extending equipment life. Explore our range to find the perfect solution for your lubrication needs.','At Refteck, we provide a comprehensive selection of industrial grease products designed to meet the demands of various applications.',c.id,'IN_STOCK',0,1,0,'Industrial Grease | Vortex Precision IT','At Refteck, we provide a comprehensive selection of industrial grease products designed to meet the demands of various applications.'
  FROM categories c
 WHERE c.slug = 'industrial-oil-chemicals-lubrications'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-OLC-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000087-0000-4000-8000-000000000087','Air Conditioners','air-conditioners','RF-HVC-01','An air conditioner controls and regulates the entire air flow to provide preferable surrounding conditions so that the necessary processes are carried out and products are made in optimal temperature. Air conditioners are used within various industries such as textile, printing, manufacturing, pharmaceutical, power plants and etc. At Refteck, we procure the spare parts for air conditioners as we understand the importance of the cooling systems to function.','An air conditioner controls and regulates the entire air flow to provide preferable surrounding conditions so that the necessary processes are carried out and products are made in optimal temperature.',c.id,'IN_STOCK',0,1,0,'Air Conditioners | Vortex Precision IT','An air conditioner controls and regulates the entire air flow to provide preferable surrounding conditions so that the necessary processes are carried out and products are made in optimal temperature.'
  FROM categories c
 WHERE c.slug = 'hvac-refrigeration'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HVC-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000088-0000-4000-8000-000000000088','Industrial Chillers','industrial-chillers','RF-HVC-02','Industrial chillers utilise refrigeration technology and use a constant stream of coolant by dehumidifying air or just by cooling process fluids. There are various applications for chillers including controlled cooling of plastics during fabrication, manufacturing parts such as printer rollers, and intense-heat specialised instruments such as MRI machines and lasers. We source compact chillers & spare parts, available in many sizes, tailored to our customers\' specification.','Industrial chillers utilise refrigeration technology and use a constant stream of coolant by dehumidifying air or just by cooling process fluids.',c.id,'IN_STOCK',0,1,0,'Industrial Chillers | Vortex Precision IT','Industrial chillers utilise refrigeration technology and use a constant stream of coolant by dehumidifying air or just by cooling process fluids.'
  FROM categories c
 WHERE c.slug = 'hvac-refrigeration'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HVC-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000089-0000-4000-8000-000000000089','HVAC Testing Instruments','hvac-testing-instruments','RF-HVC-03','Testing instruments are used to measure accurately and reliably various factors such as temperature or pressure within the air conditioning system. These instruments are also used to measure and identify any problems within the systems. We source various HVAC testing instruments including leak detectors, vacuum gauges, temp measurement devices, air sampler, clamp meter, multifunctional HVAC meter and is used for indoor climate and environmental monitoring.','Testing instruments are used to measure accurately and reliably various factors such as temperature or pressure within the air conditioning system.',c.id,'IN_STOCK',0,1,0,'HVAC Testing Instruments | Vortex Precision IT','Testing instruments are used to measure accurately and reliably various factors such as temperature or pressure within the air conditioning system.'
  FROM categories c
 WHERE c.slug = 'hvac-refrigeration'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HVC-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000090-0000-4000-8000-000000000090','Fans and blowers','fans-and-blowers','RF-HVC-04','At Refteck, we procure a range of fans and blowers, varying in sizes and types such as centrifugal, axial, and mixed flow. Industrial fans & blowers are mainly used for cooling, ventilation, drying, combustion and pneumatic conveying. We aim to source the most reliable spare parts for fans and blowers as efficiency is an integral component to the process industry.','At Refteck, we procure a range of fans and blowers, varying in sizes and types such as centrifugal, axial, and mixed flow.',c.id,'IN_STOCK',0,1,0,'Fans and blowers | Vortex Precision IT','At Refteck, we procure a range of fans and blowers, varying in sizes and types such as centrifugal, axial, and mixed flow.'
  FROM categories c
 WHERE c.slug = 'hvac-refrigeration'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HVC-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000091-0000-4000-8000-000000000091','Laboratory Heaters for Flasks','laboratory-heaters-for-flasks','RF-HVC-05','Devices such as mantles, Bunsen burners, hot plates, water baths and circulators are segmented under laboratory heaters as they provide heating and temperature control. Chemical Laboratory use at least one kind of heating device such as ovens, hot plates, oil baths, salt baths, sand baths, air baths, hot-tube furnaces and hot-air guns.','Devices such as mantles, Bunsen burners, hot plates, water baths and circulators are segmented under laboratory heaters as they provide heating and temperature control.',c.id,'IN_STOCK',0,1,0,'Laboratory Heaters for Flasks | Vortex Precision IT','Devices such as mantles, Bunsen burners, hot plates, water baths and circulators are segmented under laboratory heaters as they provide heating and temperature control.'
  FROM categories c
 WHERE c.slug = 'hvac-refrigeration'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HVC-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000092-0000-4000-8000-000000000092','Devices for Air Conditioners Check','devices-for-air-conditioners-check','RF-HVC-06','We source reliable and efficient equipment to repair and maintain air conditioners because we understand the need to ensure proper functioning and achieve optimum performance in air conditioners. The devices range from compressors, condensation units, blowers, control panels and chiller trays.','We source reliable and efficient equipment to repair and maintain air conditioners because we understand the need to ensure proper functioning and achieve optimum performance in air conditioners.',c.id,'IN_STOCK',0,1,0,'Devices for Air Conditioners Check | Vortex Precision IT','We source reliable and efficient equipment to repair and maintain air conditioners because we understand the need to ensure proper functioning and achieve optimum performance in air conditioners.'
  FROM categories c
 WHERE c.slug = 'hvac-refrigeration'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HVC-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000093-0000-4000-8000-000000000093','Compact Excavator','compact-excavator','RF-HPM-01','A compact excavator is one of the most useful piece of heavy plant machinery vehicles equipment used within the various industries such as mining & minerals, agriculture, construction and cement. In compact excavators, the blade, rotation, travel functions and the work group are activated by the transfer of hydraulic fluid acting upon the hydraulic cylinders. We supply the most efficient and reliable spare parts suppliers for machinery which provide power, precision and high performance.','A compact excavator is one of the most useful piece of heavy plant machinery vehicles equipment used within the various industries such as mining & minerals, agriculture, construction and cement.',c.id,'MADE_TO_ORDER',0,1,0,'Compact Excavator | Vortex Precision IT','A compact excavator is one of the most useful piece of heavy plant machinery vehicles equipment used within the various industries such as mining & minerals, agriculture, construction and cement.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000094-0000-4000-8000-000000000094','Dump trucks','dump-trucks','RF-HPM-02','Similarly, to compact excavators, dump trucks are used within these mining & minerals, agriculture, construction and cement industries. The main function of a dump truck is to transport loose material such as coal, sand, gravel and dirt used for construction. We source reliable and robust spare parts for production trucks in various sizes, best suited to your expectations.','Similarly, to compact excavators, dump trucks are used within these mining & minerals, agriculture, construction and cement industries.',c.id,'MADE_TO_ORDER',0,1,0,'Dump trucks | Vortex Precision IT','Similarly, to compact excavators, dump trucks are used within these mining & minerals, agriculture, construction and cement industries.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000095-0000-4000-8000-000000000095','Forklift','forklift','RF-HPM-03','Forklifts (also known as an industrial truck), contain sharp steel forks which help lift and transport material. We procure the most reliable and efficient spare parts for forklifts as we understand the importance and the requirements for these machines.','Forklifts (also known as an industrial truck), contain sharp steel forks which help lift and transport material.',c.id,'MADE_TO_ORDER',0,1,0,'Forklift | Vortex Precision IT','Forklifts (also known as an industrial truck), contain sharp steel forks which help lift and transport material.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000096-0000-4000-8000-000000000096','Cranes','cranes','RF-HPM-04','A crane\'s main purpose lies to lift and lower heavy material used within mainly the construction industry. It is normally a temporary structure. At Refteck, we are able to source various types of spare parts for cranes including truck-mounted crane, all-terrain telescopic cranes or hydraulic models.','A crane\'s main purpose lies to lift and lower heavy material used within mainly the construction industry.',c.id,'MADE_TO_ORDER',0,1,0,'Cranes | Vortex Precision IT','A crane\'s main purpose lies to lift and lower heavy material used within mainly the construction industry.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000097-0000-4000-8000-000000000097','Backhoe Loader','backhoe-loader','RF-HPM-05','A backhoe loaderis a small type of excavation vehicle, made up of a tractor, a shovel and a small backhoe in the rear end and a bucket. It is primarily used for small construction projects and is a multipurpose machine due to its versatile attributes. Backhoe loaders are also very common within the agriculture industry. We source the finest spare parts for the machines, suited to our customers\' expectations.','A backhoe loaderis a small type of excavation vehicle, made up of a tractor, a shovel and a small backhoe in the rear end and a bucket.',c.id,'MADE_TO_ORDER',0,1,0,'Backhoe Loader | Vortex Precision IT','A backhoe loaderis a small type of excavation vehicle, made up of a tractor, a shovel and a small backhoe in the rear end and a bucket.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000098-0000-4000-8000-000000000098','Bulldozer','bulldozer','RF-HPM-06','A bulldozer is a large, powerful tracked piece of equipment used within quarries, military bases, heavy industry factories, engineering projects and farms. Its main purpose is to push large quantities of material such as soil and sand and can be used for demolition purposes. We procure a variety of spare parts for bulldozers with different specifications.','A bulldozer is a large, powerful tracked piece of equipment used within quarries, military bases, heavy industry factories, engineering projects and farms.',c.id,'MADE_TO_ORDER',0,1,0,'Bulldozer | Vortex Precision IT','A bulldozer is a large, powerful tracked piece of equipment used within quarries, military bases, heavy industry factories, engineering projects and farms.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-06');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000099-0000-4000-8000-000000000099','Compactors','compactors','RF-HPM-07','Compactor is an industrial machine, vital for large quantities of scrap metal such as copper, tin, brass, iron and steel. They are able to compress any material to a firm block. At Refteck, we can source spare parts for a compactor, according to our clients expectations.','Compactor is an industrial machine, vital for large quantities of scrap metal such as copper, tin, brass, iron and steel.',c.id,'MADE_TO_ORDER',0,1,0,'Compactors | Vortex Precision IT','Compactor is an industrial machine, vital for large quantities of scrap metal such as copper, tin, brass, iron and steel.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-07');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000100-0000-4000-8000-000000000100','Clutch','clutch','RF-HPM-08','A clutch can make the process of speed regulation easier by providing a connection between the two rotating shafts. This link then adjusts and regulates the different speeds of the two shafts. It requires proper care and maintenance by professionals in order for the machines to perform effectively. However, it needs to be replaced regularly and we offer high-quality clutches that can improve the performance of the machines.','A clutch can make the process of speed regulation easier by providing a connection between the two rotating shafts.',c.id,'MADE_TO_ORDER',0,1,0,'Clutch | Vortex Precision IT','A clutch can make the process of speed regulation easier by providing a connection between the two rotating shafts.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-08');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000101-0000-4000-8000-000000000101','Brake Discs','brake-discs','RF-HPM-09','At Refteck, we understand the importance of brake disks as it plays an integral part of the braking system, and therefore should be regularly maintained. We offer a vast variety of industrial brake discs, with a variation of thrusters, flexible couplings, brake disc systems, catering to your every need.','At Refteck, we understand the importance of brake disks as it plays an integral part of the braking system, and therefore should be regularly maintained.',c.id,'MADE_TO_ORDER',0,1,0,'Brake Discs | Vortex Precision IT','At Refteck, we understand the importance of brake disks as it plays an integral part of the braking system, and therefore should be regularly maintained.'
  FROM categories c
 WHERE c.slug = 'heavy-plant-machinery-vehicles'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-HPM-09');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000102-0000-4000-8000-000000000102','Safety Harness','safety-harness','RF-SFT-01','A Safety harness comes under the categories of protective types of safety equipment and is designed to protect person, animal or object from injuries or damage. A harness is fabricated from rope, cable and locking hardware. The harness is an attachment or link between a stationary or stationary object. It acts a key part is an active fall arrest system. Selecting the right harness for every worker as per the job is important. Application requirements, size, weight limit, number of attachment points, worker comfort, and freedom of worker movement while in the harness are all factors we considered when supplying a safety harness for the end user.','A Safety harness comes under the categories of protective types of safety equipment and is designed to protect person, animal or object from injuries or damage.',c.id,'IN_STOCK',0,1,0,'Safety Harness | Vortex Precision IT','A Safety harness comes under the categories of protective types of safety equipment and is designed to protect person, animal or object from injuries or damage.'
  FROM categories c
 WHERE c.slug = 'safety-products'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-SFT-01');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000103-0000-4000-8000-000000000103','Safety Glasses','safety-glasses','RF-SFT-02','Safety Glasses or Goggles are the form of protective covering that enclose or protects the eyes and areas surrounding in order to prevent the particulates, water or chemicals from striking the eyes. Safety glasses find the application in numerous areas like laboratories, lumbering, sports, swimming etc. Safety glasses are used in industries like metal working where they are worn out easily as they are subjected to flying metal particles during metal cutting. There are different variations of goggles that we supply depending upon their use some examples are Cold Weather goggles, Power tools goggles, Welding torch goggles, blowing goggles etc.','Safety Glasses or Goggles are the form of protective covering that enclose or protects the eyes and areas surrounding in order to prevent the particulates, water or chemicals from striking the eyes.',c.id,'IN_STOCK',0,1,0,'Safety Glasses | Vortex Precision IT','Safety Glasses or Goggles are the form of protective covering that enclose or protects the eyes and areas surrounding in order to prevent the particulates, water or chemicals from striking the eyes.'
  FROM categories c
 WHERE c.slug = 'safety-products'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-SFT-02');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000104-0000-4000-8000-000000000104','Protective Clothing','protective-clothing','RF-SFT-03','Protective clothing falls under the categories of clothing and protective gear referring to the item called pads, guards, masks, etc. The purposes of the protective clothing are to reduce the employee exposure to hazards which can be controlled engineering and administrative ways. At Refteck we supply Heat and Flame-resistant clothing, Extreme cold weather clothing, Protective clothing against chemical and radiation etc. Various types of material are used to make protective clothing such as Kevlar, Nomex etc. In some cases, these clothing become a barrier between the worker and working environment in order to reduce such complexity we examine each requirement intensely and then we suggest the best suitable product as per the end user requirement. We also supply the latest standard ergonomic design protective clothing that can lead to ensuring safety and healthy working environment.','Protective clothing falls under the categories of clothing and protective gear referring to the item called pads, guards, masks, etc.',c.id,'IN_STOCK',0,1,0,'Protective Clothing | Vortex Precision IT','Protective clothing falls under the categories of clothing and protective gear referring to the item called pads, guards, masks, etc.'
  FROM categories c
 WHERE c.slug = 'safety-products'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-SFT-03');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000105-0000-4000-8000-000000000105','Face Shield','face-shield','RF-SFT-04','Face shield is a protective device used to cover the wearer Head, Face, Eyes from various hazards. A face shield is basically used in addition with spectacles. Here at Refteck, you will find better products that have no other match. The face shield we provide is mostly built of Polycarbonate and cellulose acetate which provide excellent toughness, durability and especially a good built quality.','Face shield is a protective device used to cover the wearer Head, Face, Eyes from various hazards.',c.id,'IN_STOCK',0,1,0,'Face Shield | Vortex Precision IT','Face shield is a protective device used to cover the wearer Head, Face, Eyes from various hazards.'
  FROM categories c
 WHERE c.slug = 'safety-products'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-SFT-04');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000106-0000-4000-8000-000000000106','Helmets','helmets','RF-SFT-05','We offer a comprehensive range of head protection gears like industrial safety helmets and industrial helmets that are available in a wide array of option suiting a different hazardous situation where head protection is a must. Some helmets have the front shield, some have additional straps for extra protection and are at the same time lightweight for easy usage. We supply high-efficiency Helmet; The helmet that we supply has high impact resistance to provide safety from various hazards.','We offer a comprehensive range of head protection gears like industrial safety helmets and industrial helmets that are available in a wide array of option suiting a different hazardous situation where head protection is a must.',c.id,'IN_STOCK',0,1,0,'Helmets | Vortex Precision IT','We offer a comprehensive range of head protection gears like industrial safety helmets and industrial helmets that are available in a wide array of option suiting a different hazardous situation where head protection is a must.'
  FROM categories c
 WHERE c.slug = 'safety-products'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-SFT-05');

INSERT INTO products (`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,`availability`,`featured`,`isActive`,`views`,`metaTitle`,`metaDescription`)
SELECT 'rp000107-0000-4000-8000-000000000107','Industrial And Mining Torch','industrial-and-mining-torch','RF-SFT-06','The depth, the dark, and the dangers inherent in mining created a uniquely dangerous working environment for the miner. Industrial and mining torch is a torch or light developed for the necessities of underground mining operations. The industrial torch that we supply are LED Torch - both normal standard type and Rechargeable versions, Rechargeable Bulb Torch, Non-Chargeable & Rechargeable LED Lamps, Handy LED Torch - both nonchargeable & rechargeable types, Multi-Colour Flashlight, Rechargeable Flashing & Flickering Torch etc.','The depth, the dark, and the dangers inherent in mining created a uniquely dangerous working environment for the miner.',c.id,'IN_STOCK',0,1,0,'Industrial And Mining Torch | Vortex Precision IT','The depth, the dark, and the dangers inherent in mining created a uniquely dangerous working environment for the miner.'
  FROM categories c
 WHERE c.slug = 'safety-products'
   AND NOT EXISTS (SELECT 1 FROM products WHERE sku = 'RF-SFT-06');


-- ----------------------------------------------------------------------------
-- 3. PRIMARY PRODUCT IMAGES (hot-linked from refteck.com; localize later
--    with: php scripts/localize_product_images.php)
-- ----------------------------------------------------------------------------
INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000001-0000-4000-8000-000000000001', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Ball_valus.png', 'Ball Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000002-0000-4000-8000-000000000002', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Ball-Value.png', 'Gate Valve (Also known as a Sluice Valve)', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000003-0000-4000-8000-000000000003', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/butterfly_valve.jpg', 'Butterfly Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000004-0000-4000-8000-000000000004', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Globe-Valve.png', 'Globe Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000005-0000-4000-8000-000000000005', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Untitled.png', 'Plug Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000006-0000-4000-8000-000000000006', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/check_valve.jpg', 'Check Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000007-0000-4000-8000-000000000007', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/needle_valve.jpg', 'Needle valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000008-0000-4000-8000-000000000008', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Actuated-Control-Valves.png', 'Actuated Control Valves', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000009-0000-4000-8000-000000000009', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/solenoid_valves.jpg', 'Solenoid Valves', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-09'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000010-0000-4000-8000-000000000010', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/safety_valve.jpg', 'Safety Valve (Also known as a Relief Valve)', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-10'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000011-0000-4000-8000-000000000011', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/pneumatic-valve.jpg', 'Pneumatic Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-11'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000012-0000-4000-8000-000000000012', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/valve.jpg', 'Pinch Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-12'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000013-0000-4000-8000-000000000013', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/daigram-valve.jpg', 'Diaphragm Valve', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-13'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000014-0000-4000-8000-000000000014', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/electric-actuators.jpg', 'Electric Actuators', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-14'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000015-0000-4000-8000-000000000015', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/flanges.jpg', 'Flanges', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-15'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000016-0000-4000-8000-000000000016', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/manifold-valve.jpg', 'Manifold', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-VLV-16'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000017-0000-4000-8000-000000000017', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Draw-Works.png', 'Draw Works', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000018-0000-4000-8000-000000000018', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Travelling-Block.png', 'Travelling Block', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000019-0000-4000-8000-000000000019', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/coiled_tubing.jpg', 'Coiled Tubing', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000020-0000-4000-8000-000000000020', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Drilling-Instrumentation.png', 'Drilling Instrumentation', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000021-0000-4000-8000-000000000021', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Drilling-Generators.png', 'Drilling Generators', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000022-0000-4000-8000-000000000022', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Wireline-Equipment.png', 'Wireline Equipment', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000023-0000-4000-8000-000000000023', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/completion_tools.jpg', 'Completion Tools', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000024-0000-4000-8000-000000000024', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Oil-tools.png', 'Oil Tools', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000025-0000-4000-8000-000000000025', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Power-Swivel.png', 'Power Swivels', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-DRL-09'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000026-0000-4000-8000-000000000026', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Hand-Tools.png', 'Hand Tools', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRT-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000027-0000-4000-8000-000000000027', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Power-Tools.png', 'Power Tools', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRT-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000028-0000-4000-8000-000000000028', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Pneumatic-tools.png', 'Pneumatic tools', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRT-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000029-0000-4000-8000-000000000029', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/milling-tools.jpg', 'Milling tools', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRT-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000030-0000-4000-8000-000000000030', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Gas-Turbine.png', 'Gas Turbine', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000031-0000-4000-8000-000000000031', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Steam-Turbine.png', 'Steam Turbine', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000032-0000-4000-8000-000000000032', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Compressors.png', 'Compressors', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000033-0000-4000-8000-000000000033', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Gearboxes.png', 'Gearboxes', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000034-0000-4000-8000-000000000034', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Reciprocating-Engines.png', 'Reciprocating Engines', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000035-0000-4000-8000-000000000035', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Diesel-Engine.png', 'Diesel Engine', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000036-0000-4000-8000-000000000036', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Controls-and-instrumentation.png', 'Controls and instrumentation', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000037-0000-4000-8000-000000000037', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/rotary-1.jpg', 'Ancillaries and Accessories', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-RTY-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000038-0000-4000-8000-000000000038', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Diaphragm-Pumps.png', 'Diaphragm Pumps', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000039-0000-4000-8000-000000000039', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Centrifugal-Pumps.png', 'Centrifugal Pumps', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000040-0000-4000-8000-000000000040', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Hydraulic-Pump.png', 'Hydraulic Pump', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000041-0000-4000-8000-000000000041', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/vacuum_pump.jpg', 'Vacuum Pump', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000042-0000-4000-8000-000000000042', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Screw-Pump.png', 'Screw Pump', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000043-0000-4000-8000-000000000043', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/split-casing-pump.jpg', 'Split Casing Pumps', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000044-0000-4000-8000-000000000044', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/magnetic-drive-pump.jpg', 'Magnetic Drive Pump', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000045-0000-4000-8000-000000000045', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/oil-pumps.jpg', 'Industrial Oil Pumps', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000046-0000-4000-8000-000000000046', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/bilge-pump.jpg', 'Bilge pump', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-09'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000047-0000-4000-8000-000000000047', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/heating-pump.jpg', 'Heating pump', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PMP-10'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000048-0000-4000-8000-000000000048', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Autoclaves.png', 'Autoclaves', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000049-0000-4000-8000-000000000049', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Filtration.png', 'Filtration', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000050-0000-4000-8000-000000000050', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/heat_exchangers.jpg', 'Heat Exchangers', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000051-0000-4000-8000-000000000051', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Pipe-Tubing.png', 'Industrial Piping & Tubing', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000052-0000-4000-8000-000000000052', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Bearings.png', 'Bearings', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000053-0000-4000-8000-000000000053', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/hydraulic.png', 'Hydraulic hoses', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000054-0000-4000-8000-000000000054', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/oilfield.png', 'Oilfield Equipment and Pipeline', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000055-0000-4000-8000-000000000055', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/pharmaceutical.png', 'Pharmaceutical Process Equipment', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000056-0000-4000-8000-000000000056', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/wind-turbine.png', 'Wind turbine spares', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-PRC-09'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000057-0000-4000-8000-000000000057', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Industrial-Gauges.png', 'Industrial Gauges', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-INS-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000058-0000-4000-8000-000000000058', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Sensors.png', 'Sensors', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-INS-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000059-0000-4000-8000-000000000059', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Flow-meters.png', 'Flow Meters', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-INS-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000060-0000-4000-8000-000000000060', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Circuit-Breakers.png', 'Circuit Breakers', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000061-0000-4000-8000-000000000061', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Magnetic-Starters.png', 'Magnetic Starters', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000062-0000-4000-8000-000000000062', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Lighting.png', 'Lighting', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000063-0000-4000-8000-000000000063', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Cabling.png', 'Cabling', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000064-0000-4000-8000-000000000064', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Panel-Boards.png', 'Panel Boards', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000065-0000-4000-8000-000000000065', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Transformers.png', 'Transformers', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000066-0000-4000-8000-000000000066', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Electric-generators.png', 'Electric Generator', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000067-0000-4000-8000-000000000067', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Batteries.png', 'Batteries', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000068-0000-4000-8000-000000000068', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Electric-motors.png', 'Electric Motors', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-09'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000069-0000-4000-8000-000000000069', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Contactors.png', 'Contactors', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-10'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000070-0000-4000-8000-000000000070', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Enclosures.png', 'Enclosures', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-11'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000071-0000-4000-8000-000000000071', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Relays.png', 'Relays', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-12'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000072-0000-4000-8000-000000000072', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Electrical-Switches.png', 'Electrical Switches', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-13'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000073-0000-4000-8000-000000000073', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/LED-systems.png', 'LED Systems', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-14'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000074-0000-4000-8000-000000000074', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/VFDs.png', 'Variable Frequency Drives', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-15'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000075-0000-4000-8000-000000000075', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Electrical-conduit-fittings.png', 'Electrical Conduit Fittings', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-ELX-16'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000076-0000-4000-8000-000000000076', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/chain-hoist.jpg', 'Chain hoist', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000077-0000-4000-8000-000000000077', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/drill-bit.jpg', 'Rock Tricone drill bit', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000078-0000-4000-8000-000000000078', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/couplings.jpg', 'Couplings', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000079-0000-4000-8000-000000000079', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/gasket.jpg', 'Gasket', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000080-0000-4000-8000-000000000080', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/o-rings.jpg', 'O Rings', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000081-0000-4000-8000-000000000081', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/washers.jpg', 'Washers', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000082-0000-4000-8000-000000000082', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/nuts-bolts.jpg', 'Nuts Bolts', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-MRO-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000083-0000-4000-8000-000000000083', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Lubricating-grease.png', 'Lubricating grease', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-OLC-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000084-0000-4000-8000-000000000084', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Grease-gun.png', 'Grease gun', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-OLC-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000085-0000-4000-8000-000000000085', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Industrial-oil-and-chemicals.png', 'Industrial oil and chemicals', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-OLC-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000086-0000-4000-8000-000000000086', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/industrial.jpg', 'Industrial Grease', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-OLC-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000087-0000-4000-8000-000000000087', p.id, 'https://www.refteck.com/wp-content/uploads/2017/05/air-conditioners.jpg', 'Air Conditioners', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HVC-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000088-0000-4000-8000-000000000088', p.id, 'https://www.refteck.com/wp-content/uploads/2017/05/chillers.jpg', 'Industrial Chillers', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HVC-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000089-0000-4000-8000-000000000089', p.id, 'https://www.refteck.com/wp-content/uploads/2017/05/hvac-testing.jpg', 'HVAC Testing Instruments', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HVC-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000090-0000-4000-8000-000000000090', p.id, 'https://www.refteck.com/wp-content/uploads/2017/05/fans-blowers.jpg', 'Fans and blowers', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HVC-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000091-0000-4000-8000-000000000091', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/laboratory-heaters.jpg', 'Laboratory Heaters for Flasks', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HVC-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000092-0000-4000-8000-000000000092', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/devices-for-air.jpg', 'Devices for Air Conditioners Check', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HVC-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000093-0000-4000-8000-000000000093', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Compact-Excavator.png', 'Compact Excavator', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000094-0000-4000-8000-000000000094', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Dump-trucks.png', 'Dump trucks', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000095-0000-4000-8000-000000000095', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Forklift.png', 'Forklift', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000096-0000-4000-8000-000000000096', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Cranes.png', 'Cranes', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000097-0000-4000-8000-000000000097', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Backhoe-Loader.png', 'Backhoe Loader', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000098-0000-4000-8000-000000000098', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Bulldozer.png', 'Bulldozer', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000099-0000-4000-8000-000000000099', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Compactors.png', 'Compactors', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-07'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000100-0000-4000-8000-000000000100', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Clutch.png', 'Clutch', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-08'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000101-0000-4000-8000-000000000101', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Brake-Discs.png', 'Brake Discs', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-HPM-09'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000102-0000-4000-8000-000000000102', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Safety-harness.png', 'Safety Harness', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-SFT-01'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000103-0000-4000-8000-000000000103', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Safety-glasses.png', 'Safety Glasses', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-SFT-02'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000104-0000-4000-8000-000000000104', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Protective-clothing.png', 'Protective Clothing', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-SFT-03'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000105-0000-4000-8000-000000000105', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Face-shield.png', 'Face Shield', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-SFT-04'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000106-0000-4000-8000-000000000106', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Helmets.png', 'Helmets', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-SFT-05'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);

INSERT INTO product_images (`id`,`productId`,`url`,`alt`,`caption`,`sortOrder`,`isPrimary`)
SELECT 'ri000107-0000-4000-8000-000000000107', p.id, 'https://www.refteck.com/wp-content/uploads/2017/03/Industrial-and-mining-torch.png', 'Industrial And Mining Torch', 'Product image', 0, 1
  FROM products p
 WHERE p.sku = 'RF-SFT-06'
   AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.productId = p.id AND pi.isPrimary = 1);


-- ----------------------------------------------------------------------------
-- 4. HOMEPAGE: fit every category in the grid
--    (base 6 + AJR NDT 13 + Refteck 10 = 29 rows; the section was left at
--     limit 24 by migration 011). Guarded so a custom limit is preserved.
-- ----------------------------------------------------------------------------
UPDATE `page_sections`
   SET `settings` = '{"limit":32}'
 WHERE `pageKey` = 'home' AND `type` = 'categories'
   AND `settings` = '{"limit":24}';
