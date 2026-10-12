# Refteck Product Catalog — Migration 015

This document lists **all 107 products across the 13 product categories** of the
Refteck industrial catalog ([refteck.com/product](https://www.refteck.com/product/))
as imported by `database/migrations/015_add_refteck_product_range.sql`.
Verified product-by-product against the live site on 2026-10-12 —
see [REFTECK_VERIFICATION_REPORT.md](REFTECK_VERIFICATION_REPORT.md).

**What the migration does**

- Adds **10 new categories** (`RF` range, sortOrder 140–230). *Industrial Valves*,
  *Pumps* and *Instrumentation* already existed, so their products join the
  existing `valves`, `pumps` and `instrumentation` categories instead of
  duplicating them.
- Inserts **107 products** with SKUs prefixed `RF-<CATEGORY>-<NN>`
  (e.g. `RF-VLV-01` for the Ball Valve), full catalog copy, short descriptions
  and meta tags branded `… | Vortex Precision IT`.
- Adds **107 primary product photos** and **10 category artwork URLs**,
  hot-linked from `refteck.com`. They degrade to the theme's fallback artwork
  automatically; to make them yours run:

  ```bash
  php scripts/localize_product_images.php
  ```

  The localizer downloads every remote photo (product *and* category), verifies
  it really is an image, and points the database at local copies under
  `assets/uploads/products/` and `assets/uploads/categories/`.

- Bumps the homepage category grid from `limit 24` → `limit 32` so all 29
  categories fit (base 6 + AJR NDT 13 + Refteck 10).
- Every statement is guarded (`slug`/`sku` `NOT EXISTS`), so the migration is
  **safe to re-import**.

**Availability:** products in *Rotary Equipment*, *Heavy Plant Machinery &
Vehicles* are seeded as `MADE_TO_ORDER`; everything else is `IN_STOCK`.

---

## Contents

- [Industrial Valves](#valves) — 16 products (SKU prefix `RF-VLV-`)
- [Drilling Equipment](#drilling-equipment) — 9 products (SKU prefix `RF-DRL-`)
- [Maintenance, Repair Tools](#maintenance-repair-tools) — 4 products (SKU prefix `RF-MRT-`)
- [Rotary Equipment](#rotary-equipment) — 8 products (SKU prefix `RF-RTY-`)
- [Pumps & Spare Parts](#pumps) — 10 products (SKU prefix `RF-PMP-`)
- [Process Equipment](#process-equipment) — 9 products (SKU prefix `RF-PRC-`)
- [Instrumentation](#instrumentation) — 3 products (SKU prefix `RF-INS-`)
- [Electrical & Power Transmission](#electrical-power-transmission) — 16 products (SKU prefix `RF-ELX-`)
- [Maintenance, Repair & Operation Tools](#maintenance-repair-operation-tools) — 7 products (SKU prefix `RF-MRO-`)
- [Industrial Oil, Chemicals, and Lubricants](#industrial-oil-chemicals-lubrications) — 4 products (SKU prefix `RF-OLC-`)
- [HVAC & Refrigeration](#hvac-refrigeration) — 6 products (SKU prefix `RF-HVC-`)
- [Heavy Plant Machinery & Vehicles](#heavy-plant-machinery-vehicles) — 9 products (SKU prefix `RF-HPM-`)
- [Safety Products](#safety-products) — 6 products (SKU prefix `RF-SFT-`)

---

## valves

**Industrial Valves** — category slug `valves`, SKU prefix `RF-VLV-`

> Industrial Valves are an essential piece of equipment within every branch of the manufacturing industry and they are heavily utilised within the oil and gas industry, chemical plants and water drainage systems. At Refteck, we are suppliers of industrial valves that vary in size and can withhold a range of pressures regulating the flow of semi-solids, liquids and gases, catering to each and every industry.

Source: [https://www.refteck.com/product/valves/](https://www.refteck.com/product/valves/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Ball Valve** | `RF-VLV-01` | A ball valve regulates the flow of liquids and gases and can range from one-piece, two-piece, three-piece to a flanged body construction. | [Refteck](https://www.refteck.com/product/valves/#ballvalve) |
| **Gate Valve (Also known as a Sluice Valve)** | `RF-VLV-02` | This is one of the most common types of valves, widely used in every industry which act as an on/off switch to either start or stop the flow. | [Refteck](https://www.refteck.com/product/valves/#gatevalvealsoknownasasluicevalve) |
| **Butterfly Valve** | `RF-VLV-03` | We offer a wide range of butterfly valves that can be used in many applications such as in chemical services, heating and air conditioning, water distribution, agricultural, heavy plant and etc. | [Refteck](https://www.refteck.com/product/valves/#butterflyvalve) |
| **Globe Valve** | `RF-VLV-04` | A globe valve is used to control the flow in a pipeline, differing from a ball valve. | [Refteck](https://www.refteck.com/product/valves/#globevalve) |
| **Plug Valve** | `RF-VLV-05` | Like a ball valve, a plug valve also uses a quarter-turn to regulate the flow, providing no leakage of substances. | [Refteck](https://www.refteck.com/product/valves/#plugvalve) |
| **Check Valve** | `RF-VLV-06` | A check valve is one-way directional valve which prevents the flow from reversing because it could ruin the equipment or cause the entire process to halt. | [Refteck](https://www.refteck.com/product/valves/#checkvalve) |
| **Needle valve** | `RF-VLV-07` | A needle valve is a small piece of equipment that is used to gradually stop the flow of the steam, oil, gas, air and etc. | [Refteck](https://www.refteck.com/product/valves/#needlevalve) |
| **Actuated Control Valves** | `RF-VLV-08` | An actuated control valve is used for particular uses such as regulating corrosive liquids in chemical plants or specific applications in electrical power and transmission grids. | [Refteck](https://www.refteck.com/product/valves/#actuatedcontrolvalves) |
| **Solenoid Valves** | `RF-VLV-09` | A solenoid valve can be used for various applications including within heating systems, compressed air technology, industrial automation, swimming pools. | [Refteck](https://www.refteck.com/product/valves/#solenoidvalves) |
| **Safety Valve (Also known as a Relief Valve)** | `RF-VLV-10` | A safety valve is a mechanism used to protect a system in the last line of defence. | [Refteck](https://www.refteck.com/product/valves/#safetyvalvealsoknownasareliefvalve) |
| **Pneumatic Valve** | `RF-VLV-11` | Pneumatic systems rely on the force of the compressed air and hence the actuators need safe and precise control. | [Refteck](https://www.refteck.com/product/valves/#pneumaticvalve) |
| **Pinch Valve** | `RF-VLV-12` | When dealing with abrasive flow, a pinch valve is very useful as it probably the most versatile valve that is able to deal with harsh flow control situations such as slurries. | [Refteck](https://www.refteck.com/product/valves/#pinchvalve) |
| **Diaphragm Valve** | `RF-VLV-13` | One of the key advantages for a diaphragm valve is that it can be used for throttling purposes as it is bidirectional and hence it can also be used for on/off function. | [Refteck](https://www.refteck.com/product/valves/#diaphragmvalve) |
| **Electric Actuators** | `RF-VLV-14` | Electric actuators can replace the hydraulic systems by self-automated actuators which run on electrical power, eliminating the need for hydraulic pumps and tubing, delivering precision and repeatability. | [Refteck](https://www.refteck.com/product/valves/#electricactuators) |
| **Flanges** | `RF-VLV-15` | As flanges are mainly used in plumbing systems and industrial applications, certain standards have been established for the production of them. | [Refteck](https://www.refteck.com/product/valves/#flanges) |
| **Manifold** | `RF-VLV-16` | A manifold is an essential piece of equipment utilised throughout the process industry. | [Refteck](https://www.refteck.com/product/valves/#manifold) |

---

## drilling-equipment

**Drilling Equipment** — category slug `drilling-equipment`, sortOrder 140, SKU prefix `RF-DRL-`

> Drilling equipment is widely used in oilfield supply stores in both land and offshore markets, for designing and forming the top of the line drill rigs, especially for the minerals drilling industries. Such Drill Rigs are working on every continent in the world and are mostly used for mineral exploration drilling, geothermal drilling, construction drilling, water well drilling etc. We at Refteck are specialists in supplying the best drilling equipment and spare parts, which has earned the reputation of erecting the best drilling rigs today. The OEM's we work with are known for their sturdy dependability and low maintenance. Services provided by our team allows us to offer the best equipment and spare parts for a wide range of drill rig models that satisfy a variety of needs, including auger drilling, wet rotary drilling, core drilling, and down-the-hole hammer drilling. Our clients also receive an unmatched MRO services and support that you won't find anywhere else.

Source: [https://www.refteck.com/product/drilling-equipment/](https://www.refteck.com/product/drilling-equipment/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Draw Works** | `RF-DRL-01` | The principal parts of the draw works are the drum, the drum brakes, transmission, and cathead. | [Refteck](https://www.refteck.com/product/drilling-equipment/#drawworks) |
| **Travelling Block** | `RF-DRL-02` | Refteck supplies a wide range of traveling block and spare parts from well-reputed manufacturers, A traveling block is a set of pulleys which forms part of a system in the derrick for lowering and lifting heavy... | [Refteck](https://www.refteck.com/product/drilling-equipment/#travellingblock) |
| **Coiled Tubing** | `RF-DRL-03` | Coiled tubing is widely used in the petrochemical, natural gas, oil and gas, and geothermal applications. | [Refteck](https://www.refteck.com/product/drilling-equipment/#coiledtubing) |
| **Drilling Instrumentation** | `RF-DRL-04` | With today's tough drilling environments there is a critical need for rugged, dependable and accurate tools. | [Refteck](https://www.refteck.com/product/drilling-equipment/#drillinginstrumentation) |
| **Drilling Generators** | `RF-DRL-05` | Power generators are important tools for anyone who wants extra protection in emergencies against power loss. | [Refteck](https://www.refteck.com/product/drilling-equipment/#drillinggenerators) |
| **Wireline Equipment** | `RF-DRL-06` | Wireline Equipment consists of braided cables that are used for pipe recovery, evaluation purposes, well intervention and maintenance. | [Refteck](https://www.refteck.com/product/drilling-equipment/#wirelineequipment) |
| **Completion Tools** | `RF-DRL-07` | Completion equipment is that equipment which is used to bring an oil well to the completion state so that first test production and later on commercial production can be started from it. | [Refteck](https://www.refteck.com/product/drilling-equipment/#completiontools) |
| **Oil Tools** | `RF-DRL-08` | Oil Tools are pieces of oilfield equipment that are used during well drilling, completion, and intervention or well workover activities and help the oil well in optimising the production levels and maintain a... | [Refteck](https://www.refteck.com/product/drilling-equipment/#oiltools) |
| **Power Swivels** | `RF-DRL-09` | The Power Swivels are hydraulic motor driven, pipe rotating machines. | [Refteck](https://www.refteck.com/product/drilling-equipment/#powerswivels) |

---

## maintenance-repair-tools

**Maintenance, Repair Tools** — category slug `maintenance-repair-tools`, sortOrder 150, SKU prefix `RF-MRT-`

> Troubleshoot problems with our maintenance, repair tools and spare parts. Refteck Solutions has the expertise to procure all such MRO tools viz. hand tools, power tools, pneumatic tools and milling tools for our clients and keeping in mind their changing requirements.

Source: [https://www.refteck.com/product/maintenance-repair-tools/](https://www.refteck.com/product/maintenance-repair-tools/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Hand Tools** | `RF-MRT-01` | The foundation of any good and proper toolkit is Hand tools. | [Refteck](https://www.refteck.com/product/maintenance-repair-tools/#handtools) |
| **Power Tools** | `RF-MRT-02` | If users in manufacturing plant wish to save the time, resources and make the task simple and effective, power tools are highly favorable. | [Refteck](https://www.refteck.com/product/maintenance-repair-tools/#powertools) |
| **Pneumatic tools** | `RF-MRT-03` | A pneumatic tool or air tool like jackhammer utilises the energy of compressed air as the power for its operation. | [Refteck](https://www.refteck.com/product/maintenance-repair-tools/#pneumatictools) |
| **Milling tools** | `RF-MRT-04` | Shaping and cutting solid materials like metal, wood, plastics or even brass, the most versatile milling machines with a wide range of cutting or milling tools are used in industries that allows completing... | [Refteck](https://www.refteck.com/product/maintenance-repair-tools/#millingtools) |

---

## rotary-equipment

**Rotary Equipment** — category slug `rotary-equipment`, sortOrder 160, SKU prefix `RF-RTY-`

> Rotary equipment is the given categorisation for mechanical devices that provide kinetic energy to an operation enabling it to move. Rotating equipment is seen in various mechanisms throughout the process industry sector and it consists of components that move solids, liquids or gases through a series of drivers, driven components and the transmission devices. This type of application can be usually found in steam or gas turbines. The steam turbines act as a potential driver, using high-pressure steam to stimulate the rotary equipment such as the forced/induced-draft fans, pumps or air compressors. Whereas the gas turbines can either use compressed air to drive the generator or use "scoop tubes" as a fluid coupling to drive the rotating equipment. Operating this equipment can be fairly risky, and workers should be careful and take the right precautions in order to avoid injuries.

Source: [https://www.refteck.com/product/rotary-equipment/](https://www.refteck.com/product/rotary-equipment/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Gas Turbine** | `RF-RTY-01` | A gas turbine is the soul of the power plants. | [Refteck](https://www.refteck.com/product/rotary-equipment/#gasturbine) |
| **Steam Turbine** | `RF-RTY-02` | Similarly, a steam turbine is equally important to the process industry. | [Refteck](https://www.refteck.com/product/rotary-equipment/#steamturbine) |
| **Compressors** | `RF-RTY-03` | Compressors are used to increase the pressure of any fluid, and this in turn reduces the quantity of the fluid. | [Refteck](https://www.refteck.com/product/rotary-equipment/#compressors) |
| **Gearboxes** | `RF-RTY-04` | We offer a variety of gearboxes of different types, shapes and sizes such as worm, helical, planetary, and spur. | [Refteck](https://www.refteck.com/product/rotary-equipment/#gearboxes) |
| **Reciprocating Engines** | `RF-RTY-05` | A reciprocating engine is mainly used for transforming pressure into a rotating motion, used in various power generation applications such as it provides a back-up capacity for power generation or can be used for... | [Refteck](https://www.refteck.com/product/rotary-equipment/#reciprocatingengines) |
| **Diesel Engine** | `RF-RTY-06` | There are two types of diesel engines; a two stroke or a four stroke. | [Refteck](https://www.refteck.com/product/rotary-equipment/#dieselengine) |
| **Controls and instrumentation** | `RF-RTY-07` | In order to run an operation smoothly, controls and instrumentation are required of the highest quality to ensure that precise measurement and control of the entire process is conducted such as meters, regulators... | [Refteck](https://www.refteck.com/product/rotary-equipment/#controlsandinstrumentation) |
| **Ancillaries and Accessories** | `RF-RTY-08` | Enhance your rotary equipment's performance with our range of ancillaries and accessories. | [Refteck](https://www.refteck.com/product/rotary-equipment/#ancillariesandaccessories) |

---

## pumps

**Pumps & Spare Parts** — category slug `pumps`, SKU prefix `RF-PMP-`

> Buoyed by the technological advancements, growth in the market is largely reliant on significant levels of investments in manufacturing facilities. A major driving force for growth in the market is the increase in global energy needs and the following development in oil and gas exploration, energy generation and petroleum refining activities. All such sectors are expected to spur demand for industrial pumps designed to meet the industrial standard and specialised applications. Pumps are available with or without electric motors. They are utilised mainly to displace material like chemical, petroleum, wastewater, oil, sludge, slurry or food. At Refteck, we source reliable Industrial pumps and spare parts that exceed our client's expectations.

Source: [https://www.refteck.com/product/pumps/](https://www.refteck.com/product/pumps/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Diaphragm Pumps** | `RF-PMP-01` | Mining, industrial and general manufacturing plants where electricity is unavailable diaphragm pumps are extensively used. | [Refteck](https://www.refteck.com/product/pumps/#diaphragmpumps) |
| **Centrifugal Pumps** | `RF-PMP-02` | Centrifugal pumps with different configurations are fire pumps, end suction pumps, chopper pumps, grinder pumps and many more. | [Refteck](https://www.refteck.com/product/pumps/#centrifugalpumps) |
| **Hydraulic Pump** | `RF-PMP-03` | Any processing industry which needs heavy or repetitive work done with the greatest efficiency hydraulic equipment applications are always available there to fill the need. | [Refteck](https://www.refteck.com/product/pumps/#hydraulicpump) |
| **Vacuum Pump** | `RF-PMP-04` | Chemical processing and manufacturing industries require vacuum for various applications such as plastic molding processes, production of lamps, tubes, CRT displays, semiconductor processing, glass coatings and many... | [Refteck](https://www.refteck.com/product/pumps/#vacuumpump) |
| **Screw Pump** | `RF-PMP-05` | Screw pumps (twin and three screw pumps) are uniquely and largely playing a key role in upstream and midstream environment of oil and gas industry by offering long term benefits to their users. | [Refteck](https://www.refteck.com/product/pumps/#screwpump) |
| **Split Casing Pumps** | `RF-PMP-06` | The workhorses for industrial and domestic pumping applications are split casing pumps e.g. | [Refteck](https://www.refteck.com/product/pumps/#splitcasingpumps) |
| **Magnetic Drive Pump** | `RF-PMP-07` | The magnetic drive pumps are seal less pumps that use a balanced magnetic field to create the rotation of the fluid impeller. | [Refteck](https://www.refteck.com/product/pumps/#magneticdrivepump) |
| **Industrial Oil Pumps** | `RF-PMP-08` | Industrial oil pumps are the heart and soul of the oil and gas industry sector. | [Refteck](https://www.refteck.com/product/pumps/#industrialoilpumps) |
| **Bilge pump** | `RF-PMP-09` | Bilge Pumps play an important role in order to empty the bilge well of marine vessel at regular interval of time to prevent the flood in engine room. | [Refteck](https://www.refteck.com/product/pumps/#bilgepump) |
| **Heating pump** | `RF-PMP-10` | The heating pump utilises promising techniques with multitude applications within the process industry. | [Refteck](https://www.refteck.com/product/pumps/#heatingpump) |

---

## process-equipment

**Process Equipment** — category slug `process-equipment`, sortOrder 170, SKU prefix `RF-PRC-`

> Industrial processing equipment encompasses a wide range of products and spare parts that are destined for critical requirements within a variety of downstream manufacturing sectors. Such process equipment plays a major role in many reactions or operations that are not possible under normal environmental conditions related to temperature, pressure or safety purposes. Modern technological advancements in the industrial processing equipment used in industrial sectors such as oil and gas, mining, general manufacturing and construction etc. can have a considerable impact on the speed, quality and volume of production levels and plant profitability. We at Refteck scrutinise all requirements to get a better understanding of the type of process equipment and accessories that are required by our clients.

Source: [https://www.refteck.com/product/process-equipment/](https://www.refteck.com/product/process-equipment/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Autoclaves** | `RF-PRC-01` | Various scientific operations in laboratories require hygiene, disinfection and sterilisation of glassware and instruments. | [Refteck](https://www.refteck.com/product/process-equipment/#autoclaves) |
| **Filtration** | `RF-PRC-02` | Manufacturers and industrial process facilities maintain their production levels in very high volumes. | [Refteck](https://www.refteck.com/product/process-equipment/#filtration) |
| **Heat Exchangers** | `RF-PRC-03` | Heat exchangers are one of the important components of air conditioning, cooling or heating systems in various industry verticals. | [Refteck](https://www.refteck.com/product/process-equipment/#heatexchangers) |
| **Industrial Piping & Tubing** | `RF-PRC-04` | Industrial piping and tubing is a closed system which plays a crucial role to any processing plant. | [Refteck](https://www.refteck.com/product/process-equipment/#industrialpipingtubing) |
| **Bearings** | `RF-PRC-05` | Bearings play a major role in reducing friction among components and keep them at precise places. | [Refteck](https://www.refteck.com/product/process-equipment/#bearings) |
| **Hydraulic hoses** | `RF-PRC-06` | In order to convey fluid to or among hydraulic components such as valves, actuators, and other tools a specifically designed hose named hydraulic hose is used in various industrial processes. | [Refteck](https://www.refteck.com/product/process-equipment/#hydraulichoses) |
| **Oilfield Equipment and Pipeline** | `RF-PRC-07` | Oilfield equipment is of great importance in the drilling and oil extraction process. | [Refteck](https://www.refteck.com/product/process-equipment/#oilfieldequipmentandpipeline) |
| **Pharmaceutical Process Equipment** | `RF-PRC-08` | In Pharmaceutical and chemical industry including petrochemicals, specific reaction chambers/ reactors are used for the completion of various typical reactions. | [Refteck](https://www.refteck.com/product/process-equipment/#pharmaceuticalprocessequipment) |
| **Wind turbine spares** | `RF-PRC-09` | Turbines play a crucial role in power generation industry, especially in wind power industry. | [Refteck](https://www.refteck.com/product/process-equipment/#windturbinespares) |

---

## instrumentation

**Instrumentation** — category slug `instrumentation`, SKU prefix `RF-INS-`

> Instrumentation includes devices capable of detecting change, physical or otherwise, in a particular process. Measuring instruments include Sensor, Amplifier / Conditioner, Display which is used in almost all production industries. We carry a wide range of instrumentation equipment and pride ourselves in providing our customers with the required spare parts at the right price. Our staff of professionals can provide you with in-depth product knowledge to help you select the most cost-effective instrumentation solution. We can supply you with pressure and vacuum gauges, limit and level switches, regulators, industrial gauges, industrial thermometers, and a wide range of other process instrumentation and sensors.

Source: [https://www.refteck.com/product/instrumentation/](https://www.refteck.com/product/instrumentation/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Industrial Gauges** | `RF-INS-01` | We have the ability to supply low cost, yet 100% original and durable Industrial Gauges. | [Refteck](https://www.refteck.com/product/instrumentation/#industrialgauges) |
| **Sensors** | `RF-INS-02` | Refteck Solutions specialise in procuring and delivering high-performance specialty sensors for various uses and requirements. | [Refteck](https://www.refteck.com/product/instrumentation/#sensors) |
| **Flow Meters** | `RF-INS-03` | Refteck Solutions has the ability to provide multiple varieties of industrial flow meters to cater to your demand. | [Refteck](https://www.refteck.com/product/instrumentation/#flowmeters) |

---

## electrical-power-transmission

**Electrical & Power Transmission** — category slug `electrical-power-transmission`, sortOrder 180, SKU prefix `RF-ELX-`

> Long distance transmission of electrical power is one of the major challenges of the electrical age. The goals which engineers have been working towards have remained the same despite many other things changing over the years. We at Refteck provide solutions to meet the Efficiency, Safety, Cost, and Robustness. Efficiency here defines the extent to which time is well used for the intended task, in general transportation of electric power over distance with minimal losses. Safety: The condition or feeling of being safe, security; transport power through urban and rural areas minimising harm to people and the environment. Cost: Amount of money, time, etc. that is required or used; to use minimal raw materials and building/operating costs possible. Robustness: The quality of being robust; create a system which is not vulnerable to surges from lightning, solar flares, earthquakes, ice storms, wind storms and have the system be able to 'heal' itself when outages occur, isolating problem areas.

Source: [https://www.refteck.com/product/electrical-power-transmission/](https://www.refteck.com/product/electrical-power-transmission/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Circuit Breakers** | `RF-ELX-01` | A circuit breaker is a widely used product which is ordinarily used in Electrical and Power Transmission Industry. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#circuitbreakers) |
| **Magnetic Starters** | `RF-ELX-02` | Magnetic starters are stock components for many machines, and aftermarket starters are also available for use as replacements or for retrofitting older machines. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#magneticstarters) |
| **Lighting** | `RF-ELX-03` | We provide the best in quality, energy-efficiency and ceiling light fixtures, lamps, wall lights, outdoor lighting, fans, and other accents by fulfilling the HVAC requirement at the plant specifically for the... | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#lighting) |
| **Cabling** | `RF-ELX-04` | We offer a full range of ELV (Extra-low voltage) and LV (low voltage) wire and cable products of various makes. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#cabling) |
| **Panel Boards** | `RF-ELX-05` | A Panelboard (PB) is the component in which the electrical supply is distributed from within the building. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#panelboards) |
| **Transformers** | `RF-ELX-06` | Since the high voltages carried in the wires are significantly greater than what is needed in-home, transformers are also used extensively in electronic products to decrease (or step-down) the supply voltage to a... | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#transformers) |
| **Electric Generator** | `RF-ELX-07` | Generators are available that provide one phase or three-phase power, 120 volts or 480 volts. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#electricgenerator) |
| **Batteries** | `RF-ELX-08` | Industrial applications have unique power needs and the choice of battery is important. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#batteries) |
| **Electric Motors** | `RF-ELX-09` | The largest electric motors are used for ship propulsion, pipeline compression and pumped-storage applications with ratings reaching 100 megawatts. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#electricmotors) |
| **Contactors** | `RF-ELX-10` | When a relay is used to switch a large amount of electrical power through its contacts, it is designated by a special name: contactor. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#contactors) |
| **Enclosures** | `RF-ELX-11` | Enclosures are specifically designed to enclose electrical and/or electronic equipment and protect against harsh, industrial environments. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#enclosures) |
| **Relays** | `RF-ELX-12` | At Refteck solutions, we recommend numerous applications for electromechanical relays. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#relays) |
| **Electrical Switches** | `RF-ELX-13` | The definition of relay states "A relay is an electrically operated switch" so electrical switches are viewed in a wider sense if it comes to the industrial sector. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#electricalswitches) |
| **LED Systems** | `RF-ELX-14` | Although LED lighting market size was estimated lower but is expected to witness significant growth over the forecast period. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#ledsystems) |
| **Variable Frequency Drives** | `RF-ELX-15` | Variable Frequency Drive (VFD) is a type of motor controller that drives an electric motor by varying the frequency and voltage supplied to the electric motor. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#variablefrequencydrives) |
| **Electrical Conduit Fittings** | `RF-ELX-16` | Electrical conduit provides very good protection to enclosed conductors from impact, moisture, and chemical vapours. | [Refteck](https://www.refteck.com/product/electrical-power-transmission/#electricalconduitfittings) |

---

## maintenance-repair-operation-tools

**Maintenance, Repair & Operation Tools** — category slug `maintenance-repair-operation-tools`, sortOrder 190, SKU prefix `RF-MRO-`

> Maintenance, Repair and Operations functions in tandem with every aspect of the processing and manufacturing industry in general. Experts with aim of better product safety and proper mechanical component maintenance design MRO management programs. Manufacturing Facilities are steadily crowding with more equipment and there is huge pressure on maintenance staff to keep production facilities running without any interruption. MRO helps workers to increase uptime and reliability at a lower cost by allowing them to predict and prevent equipment failure. Heavy equipment such as cranes, bulldozers, loaders, draglines etc have different maintenance requirements. We have the expertise to procure all such MRO tools, spare parts for our clients keeping in mind their changing requirements.

Source: [https://www.refteck.com/product/maintenance-repair-operation-tools/](https://www.refteck.com/product/maintenance-repair-operation-tools/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Chain hoist** | `RF-MRO-01` | Chain hoists (electric) are suitable for various jobs that require lifting of heavy equipment at sites. | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#chainhoist) |
| **Rock Tricone drill bit** | `RF-MRO-02` | The tricone drill bits are extensively used in the process of local rock fracture and mining comminution these also play a crucial role in the removal of any kind of rock. | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#rocktriconedrillbit) |
| **Couplings** | `RF-MRO-03` | Couplings, serving as very important transmission elements, are not any exception to fulfill higher and a lot of rigorous quality necessities. | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#couplings) |
| **Gasket** | `RF-MRO-04` | Industrial gaskets and seals play an important role in ensuring leak proof processes. | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#gasket) |
| **O Rings** | `RF-MRO-05` | Heavy manufacturing industries such as metal, automotive, wind generation and energy, construction, mining, oil and gas offer a difficult working atmosphere for radial shaft seals. | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#orings) |
| **Washers** | `RF-MRO-06` | Circulars disks made up of metallic or non-metallic material fixed with a nut are called Washers (plain, spring and locking washers). | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#washers) |
| **Nuts Bolts** | `RF-MRO-07` | The smallest unit of an instrument or equipment is nuts and bolts. | [Refteck](https://www.refteck.com/product/maintenance-repair-operation-tools/#nutsbolts) |

---

## industrial-oil-chemicals-lubrications

**Industrial Oil, Chemicals, and Lubricants** — category slug `industrial-oil-chemicals-lubrications`, sortOrder 200, SKU prefix `RF-OLC-`

> Industrial Oil, chemicals and industrial lubricants are essential to the process industry. Industrial oils can be used in various types of machines and vehicles and hence are available in a variety including gear oils, air compressor oils and hydraulic oils to rock drill oils, turbine oils and low-toxicity oils. Whereas the chemicals can be mixed to increase fuel efficiency or to protect equipment from corrosion. Lubricants are essential to the process industry. They are used to reduce the amount of friction between the moving surfaces such as rotary equipment, which in turn ensures the smooth running of the machinery. The most popular types of lubricants are motor oils, marine oils, silicone, greases, turbine oils, metalworking fluids, cutting fluids, grinding fluids, farming oils, gas engine oils, brake oils, hydraulic oils, etc.

Source: [https://www.refteck.com/product/industrial-oil-chemicals-lubrications/](https://www.refteck.com/product/industrial-oil-chemicals-lubrications/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Lubricating grease** | `RF-OLC-01` | Lubricating grease makes it simpler to adhere to the moving surfaces of the machinery because it is a semi-solid mixture which does not easily flow like a fluid, composed of mineral oil blended with a soap thickener. | [Refteck](https://www.refteck.com/product/industrial-oil-chemicals-lubrications/#lubricatinggrease) |
| **Grease gun** | `RF-OLC-02` | At Refteck, we offer a variety of grease guns including lever, pistol grip and hand grip as we understand our clients' procurement requirements and hence we source the best grease guns suited to their situation. | [Refteck](https://www.refteck.com/product/industrial-oil-chemicals-lubrications/#greasegun) |
| **Industrial oil and chemicals** | `RF-OLC-03` | Three quarters of the chemicals manufactured today are used to make other products in various industries such as detergents, soaps and perfumes. | [Refteck](https://www.refteck.com/product/industrial-oil-chemicals-lubrications/#industrialoilandchemicals) |
| **Industrial Grease** | `RF-OLC-04` | At Refteck, we provide a comprehensive selection of industrial grease products designed to meet the demands of various applications. | [Refteck](https://www.refteck.com/product/industrial-oil-chemicals-lubrications/#industrialgrease) |

---

## hvac-refrigeration

**HVAC & Refrigeration** — category slug `hvac-refrigeration`, sortOrder 210, SKU prefix `RF-HVC-`

> HVAC & refrigeration is vital to today's lifestyle for personal comfort, food preservation, medical health, industrial uses and water supply; regulating and preserving the climate control and airflow of the systems in play. With constant developments in technology requiring air flow control, the demand for HVAC & refrigeration services has increased which suggests that high growth within this industry is to be expected. At Refteck, we understand how a heating and cooling system can have a direct effect on financial and environmental performance and hence we source reliable spare parts that approve every end users' expectations.

Source: [https://www.refteck.com/product/hvac-refrigeration/](https://www.refteck.com/product/hvac-refrigeration/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Air Conditioners** | `RF-HVC-01` | An air conditioner controls and regulates the entire air flow to provide preferable surrounding conditions so that the necessary processes are carried out and products are made in optimal temperature. | [Refteck](https://www.refteck.com/product/hvac-refrigeration/#airconditioners) |
| **Industrial Chillers** | `RF-HVC-02` | Industrial chillers utilise refrigeration technology and use a constant stream of coolant by dehumidifying air or just by cooling process fluids. | [Refteck](https://www.refteck.com/product/hvac-refrigeration/#industrialchillers) |
| **HVAC Testing Instruments** | `RF-HVC-03` | Testing instruments are used to measure accurately and reliably various factors such as temperature or pressure within the air conditioning system. | [Refteck](https://www.refteck.com/product/hvac-refrigeration/#hvactestinginstruments) |
| **Fans and blowers** | `RF-HVC-04` | At Refteck, we procure a range of fans and blowers, varying in sizes and types such as centrifugal, axial, and mixed flow. | [Refteck](https://www.refteck.com/product/hvac-refrigeration/#fansandblowers) |
| **Laboratory Heaters for Flasks** | `RF-HVC-05` | Devices such as mantles, Bunsen burners, hot plates, water baths and circulators are segmented under laboratory heaters as they provide heating and temperature control. | [Refteck](https://www.refteck.com/product/hvac-refrigeration/#laboratoryheatersforflasks) |
| **Devices for Air Conditioners Check** | `RF-HVC-06` | We source reliable and efficient equipment to repair and maintain air conditioners because we understand the need to ensure proper functioning and achieve optimum performance in air conditioners. | [Refteck](https://www.refteck.com/product/hvac-refrigeration/#devicesforairconditionerscheck) |

---

## heavy-plant-machinery-vehicles

**Heavy Plant Machinery & Vehicles** — category slug `heavy-plant-machinery-vehicles`, sortOrder 220, SKU prefix `RF-HPM-`

> Heavy plant machinery & vehicles used in construction tasks are specifically designed to perform effectively on projects of a large scale, ensuring that the tasks are completed timely. In addition to this, they make sure that the projects are conducted with the highest quality, helping businesses achieve their goals readily. There are four categories of heavy machinery: Earth-moving equipment, construction vehicles, material handling and construction equipment. The machines need to be operated by a professional and be maintained regularly in order to safeguard the workers. Previously, all these tasks were carried out by the labour force however due to the mechanisation in the plants, companies are able to mass-produce at a faster pace, improving their efficiency. This is not to say that the labourers do not produce high-quality work, but are just limited to the speed at which these machines can. As fewer workers are needed, heavy plant machinery & vehicles help companies minimise the costs and the risks involved. Machines are able to withstand extreme temperatures and conduct dangerous tasks, creating a safer environment.

Source: [https://www.refteck.com/product/heavy-plant-machinery-vehicles/](https://www.refteck.com/product/heavy-plant-machinery-vehicles/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Compact Excavator** | `RF-HPM-01` | A compact excavator is one of the most useful piece of heavy plant machinery vehicles equipment used within the various industries such as mining & minerals, agriculture, construction and cement. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#compactexcavator) |
| **Dump trucks** | `RF-HPM-02` | Similarly, to compact excavators, dump trucks are used within these mining & minerals, agriculture, construction and cement industries. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#dumptrucks) |
| **Forklift** | `RF-HPM-03` | Forklifts (also known as an industrial truck), contain sharp steel forks which help lift and transport material. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#forklift) |
| **Cranes** | `RF-HPM-04` | A crane's main purpose lies to lift and lower heavy material used within mainly the construction industry. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#cranes) |
| **Backhoe Loader** | `RF-HPM-05` | A backhoe loaderis a small type of excavation vehicle, made up of a tractor, a shovel and a small backhoe in the rear end and a bucket. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#backhoeloader) |
| **Bulldozer** | `RF-HPM-06` | A bulldozer is a large, powerful tracked piece of equipment used within quarries, military bases, heavy industry factories, engineering projects and farms. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#bulldozer) |
| **Compactors** | `RF-HPM-07` | Compactor is an industrial machine, vital for large quantities of scrap metal such as copper, tin, brass, iron and steel. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#compactors) |
| **Clutch** | `RF-HPM-08` | A clutch can make the process of speed regulation easier by providing a connection between the two rotating shafts. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#clutch) |
| **Brake Discs** | `RF-HPM-09` | At Refteck, we understand the importance of brake disks as it plays an integral part of the braking system, and therefore should be regularly maintained. | [Refteck](https://www.refteck.com/product/heavy-plant-machinery-vehicles/#brakediscs) |

---

## safety-products

**Safety Products** — category slug `safety-products`, sortOrder 230, SKU prefix `RF-SFT-`

> Any workplace injury causes an immeasurable suffering. Companies that put safety first turn out higher quality products. In some cases, that's because a safe workplace tends to be a more efficient one, free of debris and tangles of cords. Industrial workers are exposed to various risks in the workplace. Hence each one of them should be provided with the required tools and equipment to ensure their safety at the workplace. The requirement differs from industry to industry. Refteck has the ability to provide almost every major occupational industrial safety product such as Safety Glasses, Hearing Protection, Respirators and Face Masks, Face Shield, Searchlights, Fall arresters, Personal Protective Equipment, Protective hood, etc. We select the best in the industry suppliers to provide our clients with genuine high-quality products at most competitive price.

Source: [https://www.refteck.com/product/safety-products/](https://www.refteck.com/product/safety-products/)

| Product | SKU | Summary | Source |
| :--- | :--- | :--- | :--- |
| **Safety Harness** | `RF-SFT-01` | A Safety harness comes under the categories of protective types of safety equipment and is designed to protect person, animal or object from injuries or damage. | [Refteck](https://www.refteck.com/product/safety-products/#safetyharness) |
| **Safety Glasses** | `RF-SFT-02` | Safety Glasses or Goggles are the form of protective covering that enclose or protects the eyes and areas surrounding in order to prevent the particulates, water or chemicals from striking the eyes. | [Refteck](https://www.refteck.com/product/safety-products/#safetyglasses) |
| **Protective Clothing** | `RF-SFT-03` | Protective clothing falls under the categories of clothing and protective gear referring to the item called pads, guards, masks, etc. | [Refteck](https://www.refteck.com/product/safety-products/#protectiveclothing) |
| **Face Shield** | `RF-SFT-04` | Face shield is a protective device used to cover the wearer Head, Face, Eyes from various hazards. | [Refteck](https://www.refteck.com/product/safety-products/#faceshield) |
| **Helmets** | `RF-SFT-05` | We offer a comprehensive range of head protection gears like industrial safety helmets and industrial helmets that are available in a wide array of option suiting a different hazardous situation where head protection... | [Refteck](https://www.refteck.com/product/safety-products/#helmets) |
| **Industrial And Mining Torch** | `RF-SFT-06` | The depth, the dark, and the dangers inherent in mining created a uniquely dangerous working environment for the miner. | [Refteck](https://www.refteck.com/product/safety-products/#industrialandminingtorch) |

---


*Generated from the Refteck site catalog. Product copy is reproduced from the
source pages for catalog parity; edit rows via `Admin → Products` after import.*