#!/usr/bin/env python3
"""
Generator script for AJR NDT Products:
1. docs/AJR_NDT_PRODUCT_CATALOG.md - Comprehensive catalog of all 93 products
2. database/ajr_ndt_products.sql - SQL seed file to import into the application
"""
import json

categories = [
    {
        "id": "c0010001-0000-4000-8000-000000000001",
        "name": "Ultrasonic Flaw Detection",
        "slug": "ultrasonic-flaw-detection",
        "icon": "activity",
        "sortOrder": 10,
        "description": "High-resolution digital ultrasonic testing (UT) equipment designed for locating, evaluating, and diagnosing internal cracks, inclusions, and discontinuities in welds, forgings, and composite structures.",
        "metaTitle": "Ultrasonic Flaw Detectors | AJR NDT",
        "metaDescription": "Explore AJR NDT advanced digital ultrasonic flaw detectors including AFD100, AFD800, AFD856, and AFD860."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000002",
        "name": "Thickness & Coating Gauges",
        "slug": "thickness-coating-gauges",
        "icon": "layers",
        "sortOrder": 20,
        "description": "Digital ultrasonic thickness gauges and coating thickness meters for wall thinning, corrosion monitoring, and dry film thickness (DFT) measurement on ferrous and non-ferrous substrates.",
        "metaTitle": "Thickness Gauges & Coating Thickness Meters | AJR NDT",
        "metaDescription": "High-precision ultrasonic thickness gauges and Bluetooth coating thickness testers for industrial QA/QC."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000003",
        "name": "Hardness Testers",
        "slug": "hardness-testing",
        "icon": "shield",
        "sortOrder": 30,
        "description": "Portable Leeb rebound hardness testers and Ultrasonic Contact Impedance (UCI) testers for rapid hardness inspection of heavy machinery, heat-treated parts, and weld heat-affected zones.",
        "metaTitle": "Portable Leeb & UCI Hardness Testers | AJR NDT",
        "metaDescription": "Industrial portable hardness testers including AJH300, AJH410, AJH580, AJH720, and AUH-III UCI tester."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000004",
        "name": "Surface Roughness & Profile Testers",
        "slug": "surface-roughness-testing",
        "icon": "sliders",
        "sortOrder": 40,
        "description": "Handheld surface roughness testers and digital surface profile gauges for blast-cleaned steel and machined surfaces compliant with ISO and ASTM standards.",
        "metaTitle": "Surface Roughness & Profile Gauges | AJR NDT",
        "metaDescription": "Measure Ra, Rz, Rq, Rt and blasted peak-to-valley profile heights with ART380, ART300, ART100, and ART90."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000005",
        "name": "Magnetic Particle Inspection",
        "slug": "magnetic-particle-inspection",
        "icon": "compass",
        "sortOrder": 50,
        "description": "Electromagnetic AC/DC yokes, permanent magnet yokes, and magnetic charging coils for detecting surface and near-surface cracks in ferromagnetic welds, forgings, and castings.",
        "metaTitle": "Magnetic Particle Inspection Equipment | AJR NDT",
        "metaDescription": "Reliable AC/DC magnetic yokes, battery-powered MT flaw detectors, and coils for magnetic particle testing."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000006",
        "name": "Radiography Testing & Pipeline Crawlers",
        "slug": "radiography-testing",
        "icon": "camera",
        "sortOrder": 60,
        "description": "Industrial directional/panoramic X-ray flaw detectors, motorized pipeline crawlers (5100-5500 series), and high-luminance LED film viewers with integrated digital densitometers.",
        "metaTitle": "Radiography Testing & Pipeline Crawlers | AJR NDT",
        "metaDescription": "Industrial X-ray systems, pipeline internal weld crawlers, and high-brightness LED radiograph viewers."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000007",
        "name": "Eddy Current Testing",
        "slug": "eddy-current-testing",
        "icon": "cpu",
        "sortOrder": 70,
        "description": "Multi-frequency eddy current flaw detectors and electrical conductivity meters for flaw detection, alloy sorting, and heat treatment verification without stripping paint.",
        "metaTitle": "Eddy Current Flaw Detectors & Conductivity Meters | AJR NDT",
        "metaDescription": "AEC640, AEC620 eddy current flaw detectors and AEC670, AEC660 conductivity meters (% IACS)."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000008",
        "name": "Visual Inspection & Videoscopes",
        "slug": "visual-inspection-videoscopes",
        "icon": "eye",
        "sortOrder": 80,
        "description": "High-definition articulating industrial videoscopes, borescopes, and long-reach push-rod pipeline inspection camera systems for remote visual inspection (RVI).",
        "metaTitle": "Industrial Videoscopes & Borescopes | AJR NDT",
        "metaDescription": "Remote visual inspection systems including AJR 90 pipeline cameras and 50039/50060 articulating endoscopes."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000009",
        "name": "NDT UV LED Lamps & Black Lights",
        "slug": "ndt-uv-lamps",
        "icon": "sun",
        "sortOrder": 90,
        "description": "High-intensity 365 nm UV-A LED blacklights, handheld torches, helmet-mounted lamps, and overhead stationary flood lights for fluorescent penetrant (FPI) and magnetic particle (MPI) testing.",
        "metaTitle": "NDT UV LED Black Lights & Lamps | AJR NDT",
        "metaDescription": "High-output 365nm UV LED inspection lamps compliant with ASTM E3022 and Rolls-Royce RRES 90061."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000010",
        "name": "Holiday Detectors & Wire Rope Testers",
        "slug": "holiday-wire-rope-testing",
        "icon": "zap",
        "sortOrder": 100,
        "description": "High-voltage spark testers and low-voltage wet sponge holiday detectors for tank and pipeline lining flaw inspection, alongside electromagnetic wire rope testers.",
        "metaTitle": "Holiday Detectors & Wire Rope Testers | AJR NDT",
        "metaDescription": "AHD810, AHD820, AHD860 holiday detectors and ART-11S electromagnetic wire rope flaw tester."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000011",
        "name": "Photometers & Radiometers",
        "slug": "photometers-radiometers",
        "icon": "sun",
        "sortOrder": 110,
        "description": "Digital visible lux meters and UV-A radiometers designed for verifying ambient illumination and black light intensity in NDT inspection booths per ASTM and ISO standards.",
        "metaTitle": "Digital Lux Meters & UV-A Radiometers | AJR NDT",
        "metaDescription": "LX1010B, LX1020BS, LX1330B lux meters and UVA365 UV-A radiometer for NDT quality standards."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000012",
        "name": "Calibration Blocks & Reference Standards",
        "slug": "calibration-blocks",
        "icon": "box",
        "sortOrder": 120,
        "description": "Precision-machined standard ultrasonic calibration blocks including IIW Type 1 (V1), V2, ASME, AWS DS, DSC, SC, RC, DC, PAUT, and step wedges in certified carbon steel, stainless steel, and aluminum.",
        "metaTitle": "Ultrasonic Calibration Blocks & Standards | AJR NDT",
        "metaDescription": "Comprehensive calibration test blocks compliant with EN ISO 2400, ASTM E164, and ASME Section V."
    },
    {
        "id": "c0010001-0000-4000-8000-000000000013",
        "name": "Ultrasonic Probes, Transducers & Cables",
        "slug": "ultrasonic-probes-cables",
        "icon": "link",
        "sortOrder": 130,
        "description": "Straight beam longitudinal wave probes, angle beam shear wave probes, dual element TR probes, low-profile snail probes with contoured wedges, and RF coaxial cables (BNC/LEMO).",
        "metaTitle": "Ultrasonic Transducers, Probes & Cables | AJR NDT",
        "metaDescription": "Industrial ultrasonic testing probes, wedges, and low-noise LEMO/BNC cables for flaw detection."
    }
]

cat_map = {c["slug"]: c for c in categories}

products = [
    # 1. Ultrasonic Flaw Detectors
    {
        "name": "AFD100 UT Flaw Detector",
        "slug": "afd100-ut-flaw-detector",
        "sku": "AJR-AFD-100",
        "cat": "ultrasonic-flaw-detection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231225/d28d19aac696876af0d5ebaf4f3b7e36.jpg",
        "url": "https://www.ajrndt.com/products/afd100-ut-flaw-detector.html",
        "short": "Flagship digital portable ultrasonic flaw detector with DAC/AVG/TCG, AWS D1.1, and 12-hour Li-ion battery.",
        "desc": "The AFD100 is AJR's flagship digital ultrasonic flaw detector for non-destructive testing (NDT). It offers a 0-6000 mm measuring range in steel, automated calibration of velocity/zero point/probe angle, 500 channel setups, 500 A-scan waveform memories, video capture to USB, and automated report export to Excel. Meets AWS D1.1 structural welding standards and EN 12668-1.",
        "specs": [("Measuring Range", "0 - 6000 mm (in steel)"), ("Bandwidth", "0.5 - 10 MHz"), ("Gain Range", "0 - 110 dB"), ("Dynamic Range", ">= 32 dB"), ("Vertical Linearity", "<= 3%"), ("Horizontal Linearity", "<= 0.1%"), ("Battery Life", "12 hours (Li-ion 5600mAh)"), ("Dimensions", "240 x 156 x 48 mm"), ("Weight", "1.0 kg (with battery)")],
        "material": "High-impact polymer & aluminum", "weight": "1.0 kg", "featured": 1
    },
    {
        "name": "AFD800 Portable Flaw Detector",
        "slug": "afd800-portable-flaw-detector",
        "sku": "AJR-AFD-800",
        "cat": "ultrasonic-flaw-detection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/3e965c998321625a54ecf802ca1564ed.jpg",
        "url": "https://www.ajrndt.com/products/afd800-portable-flaw-detector.html",
        "short": "Compact field digital UT flaw detector for rapid on-site weld and crack evaluation.",
        "desc": "The AFD800 Portable Ultrasonic Flaw Detector delivers high pulse repetition rates, vivid sunlight-readable display, and robust flaw gating for field inspectors evaluating structural welds, forgings, and piping.",
        "specs": [("Measuring Range", "0 - 5000 mm"), ("Frequency Range", "0.5 - 15 MHz"), ("Gain", "0 - 110 dB"), ("Display", "High-contrast color TFT"), ("Power", "Rechargeable Lithium Pack, >8 hrs")],
        "material": "Rugged industrial casing", "weight": "1.1 kg", "featured": 1
    },
    {
        "name": "AFD856 Multi Channel Ultrasonic Flaw Detector",
        "slug": "afd856-multi-channel-ultrasonic-flaw-detector",
        "sku": "AJR-AFD-856",
        "cat": "ultrasonic-flaw-detection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/f3b0b8dcf15ed85b0b41a0b7ae222491.jpg",
        "url": "https://www.ajrndt.com/products/afd856-multi-channel-ultrasonic-flaw-detector.html",
        "short": "Multi-channel UT flaw detector engineered for automated inline pipe, rail, and plate testing.",
        "desc": "The AFD856 is a rack/bench multi-channel ultrasonic flaw detector designed for integration into semi-automated and automated inspection systems. It provides synchronized multi-probe excitation, individual channel gating, and high-speed data acquisition.",
        "specs": [("Channels", "Multi-channel simultaneous acquisition"), ("Operating Frequency", "0.5 - 20 MHz"), ("Data Interface", "TCP/IP Ethernet & High-speed USB"), ("Alarm Output", "Optically isolated I/O relay")],
        "material": "Industrial rack chassis", "weight": "3.8 kg", "featured": 0
    },
    {
        "name": "AFD860 NDT Flaw Detector",
        "slug": "afd860-ndt-flaw-detector",
        "sku": "AJR-AFD-860",
        "cat": "ultrasonic-flaw-detection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/bee5ec61ae7cb0029d398518760c2455.jpg",
        "url": "https://www.ajrndt.com/products/afd860-ndt-flaw-detector.html",
        "short": "High-dynamic-range ultrasonic flaw detector with narrow-band filtering for heavy industrial inspection.",
        "desc": "The AFD860 features advanced narrow-band analog and digital filtering, high signal-to-noise ratio, and extended 0-10000 mm range, making it ideal for large castings, austenitic stainless steel welds, and coarse-grained materials.",
        "specs": [("Measuring Range", "0 - 10000 mm"), ("Dynamic Range", ">= 36 dB"), ("PRF", "20 - 1000 Hz adjustable"), ("Enclosure Rating", "IP65 weather-resistant")],
        "material": "Cast aluminum / impact rubber", "weight": "1.2 kg", "featured": 0
    },

    # 2. Thickness & Coating Gauges
    {
        "name": "ATG140 UT Thickness Gauge",
        "slug": "atg140-ut-thickness-gauge",
        "sku": "AJR-ATG-140",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/926375f4954eef3df226a899867e988a.jpg",
        "url": "https://www.ajrndt.com/products/atg140-ut-thickness-gauge.html",
        "short": "Digital ultrasonic wall thickness gauge with multi-material velocity library.",
        "desc": "The ATG140 Ultrasonic Thickness Gauge is an easy-to-use precision instrument for assessing remaining wall thickness of pipelines, tanks, boiler tubes, and pressure vessels subjected to corrosion and erosion.",
        "specs": [("Range", "0.75 - 300 mm (steel)"), ("Resolution", "0.01 mm / 0.001 in"), ("Velocity Range", "1000 - 9999 m/s"), ("Battery", "2x 1.5V AA cells, ~100 operating hours")],
        "material": "ABS housing", "weight": "250 g", "featured": 1
    },
    {
        "name": "ATG400 Ultrasonic Through Coating Thickness Gauge",
        "slug": "atg400-ultrasonic-through-coating-thickness-gauge",
        "sku": "AJR-ATG-400",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/35346334df2cca4bd3b2a77378e3bb47.jpg",
        "url": "https://www.ajrndt.com/products/atg400-ultrasonic-through-coating-thickness-gauge.html",
        "short": "Echo-to-echo ultrasonic thickness gauge measuring base metal through paint and protective coatings.",
        "desc": "The ATG400 features Echo-Echo (E-E) through-coating measurement capability, eliminating the need to scrape or destroy paint and protective coatings to determine underlying substrate wall thickness.",
        "specs": [("Standard Mode", "0.65 - 500 mm"), ("Through Coating Mode", "3.0 - 50 mm"), ("Resolution", "0.01 mm / 0.001 mm selectable"), ("Display", "High-contrast OLED")],
        "material": "Industrial polymer", "weight": "280 g", "featured": 1
    },
    {
        "name": "Scan-I A Scan Handheld Thickness Gauge",
        "slug": "scan-i-a-scan-handheld-thickness-gauge",
        "sku": "AJR-SCN-01",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240108/8f94708acb1de98aece9a481ae76978a.jpg",
        "url": "https://www.ajrndt.com/products/scan-i-a-scan-handheld-thickness-gauge.html",
        "short": "Precision thickness gauge featuring live A-Scan waveform display for acoustic verification.",
        "desc": "Scan-I combines precision ultrasonic thickness gauging with real-time RF / A-scan waveform verification, allowing the operator to view ultrasonic echoes and place measuring gates precisely to eliminate false readings in complex materials.",
        "specs": [("Measuring Range", "0.5 - 508 mm"), ("Display Modes", "RF, Full Wave, Positive Half, A-scan & B-scan"), ("Memory", "100,000 readings with A-scans"), ("Interface", "USB 2.0 with PC software")],
        "material": "Ruggedized ABS with rubber protective case", "weight": "340 g", "featured": 0
    },
    {
        "name": "Scan-II Thickness Gauge",
        "slug": "scan-ii-ut-thickness-gauge",
        "sku": "AJR-SCN-02",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/91192df181093ce05dd287798a421196.jpg",
        "url": "https://www.ajrndt.com/products/scan-ii-ut-thickness-gauge.html",
        "short": "High-accuracy ultrasonic thickness gauge with high/low alarms and differential mode.",
        "desc": "The Scan-II provides high-resolution ultrasonic thickness measurements with differential mode, high/low limit acoustic alarms, and probe zero automatic calibration.",
        "specs": [("Range", "0.65 - 400 mm"), ("Accuracy", "+/-(0.5%H + 0.01) mm"), ("Units", "mm / inch selectable"), ("Display", "Backlit LCD screen")],
        "material": "ABS casing", "weight": "260 g", "featured": 0
    },
    {
        "name": "ACT2300 Bluetooth Coating Thickness Gauge",
        "slug": "act2300-coating-thickness-gauge-765119",
        "sku": "AJR-ACT-2300",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/d49d4f3215a3d6ef9d619fa027ad0795.jpg",
        "url": "https://www.ajrndt.com/products/act2300-coating-thickness-gauge-765119.html",
        "short": "Bluetooth-enabled dual F/NF coating thickness gauge for paint, galvanizing, and anodizing.",
        "desc": "The ACT2300 features integrated Bluetooth connectivity for instantaneous wireless data transfer to iOS, Android, and Windows devices. Utilizes dual magnetic induction (F) and eddy current (NF) principles for ferrous and non-ferrous substrates.",
        "specs": [("Range", "0 - 2000 um (0 - 78.7 mils)"), ("Accuracy", "+/-(2% + 1um)"), ("Substrates", "Ferrous (Steel/Iron) & Non-Ferrous (Aluminum/Copper/Brass)"), ("Connectivity", "Bluetooth 5.0 + USB")],
        "material": "Polycarbonate housing with ruby probe tip", "weight": "120 g", "featured": 1
    },
    {
        "name": "ACT2200 Digital Coating Thickness Gauge",
        "slug": "act2200-digital-coating-thickness-gauge",
        "sku": "AJR-ACT-2200",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/cb9116b95b0f14d10b871e06730e8747.jpg",
        "url": "https://www.ajrndt.com/products/act2200-digital-coating-thickness-gauge.html",
        "short": "Handheld dual ferrous / non-ferrous dry film thickness (DFT) paint gauge.",
        "desc": "The ACT2200 Digital Coating Thickness Gauge accurately measures non-magnetic coatings on ferromagnetic substrates and non-conductive coatings on non-ferrous metals, ideal for automotive reconditioning and powder coating QA.",
        "specs": [("Measuring Range", "0 - 1500 um"), ("Resolution", "0.1 um (<100 um), 1 um (>100 um)"), ("Calibration", "Zero point & multi-foil calibration"), ("Display", "Backlit color LCD with rotation")],
        "material": "ABS casing", "weight": "110 g", "featured": 0
    },
    {
        "name": "ACT4000 Paint Thickness Gauge",
        "slug": "act4000-paint-thickness-gauge",
        "sku": "AJR-ACT-4000",
        "cat": "thickness-coating-gauges",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/227e0dec5e8cb493641c50227e669f41.jpg",
        "url": "https://www.ajrndt.com/products/act4000-paint-thickness-gauge.html",
        "short": "Heavy-duty coating thickness gauge with extended measuring range up to 5000 um.",
        "desc": "The ACT4000 is built for heavy-duty industrial coatings, asphalt coatings, epoxy linings, and fireproofing materials with an extended thickness capability up to 5000 um.",
        "specs": [("Measuring Range", "0 - 5000 um"), ("Accuracy", "+/-(3% + 2 um)"), ("Probe Type", "Separate cable probe with wear-resistant tip"), ("Memory", "500 readings")],
        "material": "Reinforced ABS casing", "weight": "220 g", "featured": 0
    },

    # 3. Hardness Testers
    {
        "name": "AJH300 Portable Hardness Tester",
        "slug": "ajh300-portable-hardness-tester",
        "sku": "AJR-AJH-300",
        "cat": "hardness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/bb3ed01dffe6e9248b95cb7dd1db6fbd.jpg",
        "url": "https://www.ajrndt.com/products/ajh300-portable-hardness-tester.html",
        "short": "Standard Leeb rebound hardness tester with multi-scale conversion (HL, HRC, HRB, HB, HV, HS).",
        "desc": "The AJH300 is a versatile Leeb rebound hardness tester equipped with a Type D impact device for testing dies, pressure vessels, bearings, and heavy structural forgings on-site.",
        "specs": [("Hardness Scales", "HL, HRC, HRB, HRA, HB, HV, HS"), ("Accuracy", "+/- 6 HLD (at 790 HLD)"), ("Impact Device", "Type D standard (optional DC, D+15, C, G, DL)"), ("Memory", "100 groups")],
        "material": "Durable polymer casing", "weight": "310 g", "featured": 1
    },
    {
        "name": "AJH410 Metal Hardness Tester",
        "slug": "ajh410-metal-hardness-tester",
        "sku": "AJR-AJH-410",
        "cat": "hardness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/d0cc7712851c9fc2bee6757ac0dd6d32.jpg",
        "url": "https://www.ajrndt.com/products/ajh410-metal-hardness-tester.html",
        "short": "High-precision digital metal hardness tester with wide material selection and USB data transfer.",
        "desc": "The AJH410 provides broad material presets (steel, cast steel, alloy tool steel, gray cast iron, aluminum alloys, brass, copper) with automatic test direction compensation.",
        "specs": [("Impact Direction", "360 degrees full automatic compensation"), ("Test Accuracy", "+/- 0.5% (at 800 HLD)"), ("Display", "Large matrix LCD with backlight"), ("Output", "USB interface to PC")],
        "material": "Industrial composite shell", "weight": "330 g", "featured": 0
    },
    {
        "name": "AJH580 Leeb Hardness Tester with Mini Printer",
        "slug": "ajh580-leeb-hardness-tester-with-mini-printer",
        "sku": "AJR-AJH-580",
        "cat": "hardness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/03fdc8dea69f9301b365c3507a8644db.jpg",
        "url": "https://www.ajrndt.com/products/ajh580-leeb-hardness-tester-with-mini-printer.html",
        "short": "Portable Leeb hardness tester with integrated high-speed thermal mini-printer for instant field documentation.",
        "desc": "The AJH580 includes an onboard thermal printer allowing inspectors to generate immediate physical test certificates on the shop floor or in remote field locations.",
        "specs": [("Printer", "Integrated high-speed thermal printer (57mm paper)"), ("Hardness Parameters", "HLD, HRC, HRB, HB, HV, HSD"), ("Memory", "500 test batches"), ("Battery", "High capacity rechargeable Li-ion")],
        "material": "Rugged ABS housing", "weight": "420 g", "featured": 0
    },
    {
        "name": "AJH720 Pen Hardness Tester",
        "slug": "ajh720-pen-hardness-tester",
        "sku": "AJR-AJH-720",
        "cat": "hardness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/86b86092341e61ad68bcfabd2eb21eda.jpg",
        "url": "https://www.ajrndt.com/products/ajh720-pen-hardness-tester.html",
        "short": "All-in-one pocket pen-type Leeb hardness tester with vivid OLED screen.",
        "desc": "The AJH720 integrates the impact device and electronics into a single ultra-compact pen form factor. Features an OLED display, USB charging, and automatic impact direction sensor.",
        "specs": [("Design", "Integrated cable-free pen body"), ("Display", "High-contrast OLED"), ("Accuracy", "+/- 6 HLD"), ("Battery", "Rechargeable Li-poly via Micro-USB"), ("Dimensions", "145 x 35 x 28 mm")],
        "material": "Anodized aluminum alloy body", "weight": "110 g", "featured": 0
    },
    {
        "name": "AUH-III UCI Hardness Tester",
        "slug": "auh-iii-uci-hardness-tester",
        "sku": "AJR-AUH-3",
        "cat": "hardness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/54a88517ec7e659de8ed4c9435e79216.jpg",
        "url": "https://www.ajrndt.com/products/auh-iii-uci-hardness-tester.html",
        "short": "Ultrasonic Contact Impedance (UCI) hardness tester for thin-walled parts, coatings, and weld HAZ.",
        "desc": "The AUH-III employs Ultrasonic Contact Impedance (UCI) methodology with a Vickers diamond indenter, enabling accurate non-destructive hardness testing on thin sheets, case-hardened teeth, chrome plating, and heat-affected zones where rebound testing is unsuitable.",
        "specs": [("Method", "Ultrasonic Contact Impedance (UCI) per ASTM A1038"), ("Test Load", "10N (1 kgf), 50N (5 kgf), or 98N (10 kgf) probe"), ("Indenter", "Vickers diamond 136 degree"), ("Measuring Scales", "HV, HRC, HB, HRB, MPa")],
        "material": "Precision machined probe with polymer console", "weight": "450 g", "featured": 1
    },

    # 4. Surface Roughness & Profile Testers
    {
        "name": "ART380 Roughness Tester",
        "slug": "art380-roughness-tester",
        "sku": "AJR-ART-380",
        "cat": "surface-roughness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/dd80f018f868a8e6561231c7f43f00e8.jpg",
        "url": "https://www.ajrndt.com/products/art380-roughness-tester.html",
        "short": "Advanced surface roughness tester measuring 22 parameters with graphic profile display.",
        "desc": "The ART380 is a sophisticated surface finish gauge measuring Ra, Rz, Rq, Rt, Rp, Rv, R3z, Rmax, and Rpc. Features DSP high-speed processing, color OLED profile curve graphing, and Bluetooth PC communication.",
        "specs": [("Parameters", "Ra, Rz, Rq, Rt, Rp, Rv, R3z, Rsk, Rku, Rmax"), ("Traversing Length", "Up to 17.5 mm"), ("Stylus", "Diamond 90 degree / 5 um radius"), ("Conforms To", "ISO 4287, DIN 4768, ANSI B46.1, JIS B601")],
        "material": "Aluminum alloy body with titanium stylus arm", "weight": "360 g", "featured": 1
    },
    {
        "name": "ART300 Surface Roughness Gauge",
        "slug": "art300-surface-roughness-gauge",
        "sku": "AJR-ART-300",
        "cat": "surface-roughness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/36a071c95d9a8a7a731a9706f93505f6.jpg",
        "url": "https://www.ajrndt.com/products/art300-surface-roughness-gauge.html",
        "short": "Shop-floor surface roughness tester measuring Ra and Rz with high repeat accuracy.",
        "desc": "The ART300 Surface Roughness Gauge provides rapid and accurate roughness evaluation for machine shops and manufacturing inspection lines.",
        "specs": [("Parameters", "Ra, Rz, Rq, Rt"), ("Measuring Range", "Ra: 0.05 - 10.0 um; Rz: 0.1 - 50 um"), ("Cut-off Lengths", "0.25 mm, 0.8 mm, 2.5 mm"), ("Filter", "RC, PC-RC, GAUSS, D-P")],
        "material": "Durable industrial polymer", "weight": "280 g", "featured": 0
    },
    {
        "name": "ART100 Digital Profile Gauge",
        "slug": "art100-digital-profile-gauge",
        "sku": "AJR-ART-100",
        "cat": "surface-roughness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/ba9ed16fdc77d60d6467f3605359f4d4.jpg",
        "url": "https://www.ajrndt.com/products/art100-digital-profile-gauge.html",
        "short": "Handheld peak-to-valley surface profile gauge for blast-cleaned steel substrates.",
        "desc": "The ART100 Digital Surface Profile Gauge measures the peak-to-valley height of blast-cleaned steel surfaces prior to coating application per ASTM D4417 Method B.",
        "specs": [("Range", "0 - 1000 um (0 - 40 mils)"), ("Accuracy", "+/- 2 um"), ("Tip Angle", "60 degrees conical tungsten carbide tip"), ("Standards", "ASTM D4417-B, SSPC-PA 17, ISO 8503-5")],
        "material": "Hardened aluminum base", "weight": "160 g", "featured": 0
    },
    {
        "name": "ART90 Surface Profile Gauge",
        "slug": "art90-surface-profile-gauge",
        "sku": "AJR-ART-90",
        "cat": "surface-roughness-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/48c5158b200ac310814ad0dfc6c36559.jpg",
        "url": "https://www.ajrndt.com/products/art90-surface-profile-gauge.html",
        "short": "Compact needle-depth surface profile tester for abrasive blast profiling.",
        "desc": "The ART90 is an ultra-compact electronic surface profile tester designed for paint and coating inspectors to quickly verify anchor profiles on grit-blasted or shot-blasted surfaces.",
        "specs": [("Range", "0 - 750 um"), ("Resolution", "1 um / 0.05 mil"), ("Operating Temp", "0 to 50 deg C"), ("Calibration", "Glass zero plate included")],
        "material": "Anodized metal housing", "weight": "140 g", "featured": 0
    },

    # 5. Magnetic Particle Inspection (MPI)
    {
        "name": "AJE220B MT Flaw Detector",
        "slug": "aje220b-mt-flaw-detector",
        "sku": "AJR-AJE-220B",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20231228/651fb6ade694f29555fe9bfba9959772.jpg",
        "url": "https://www.ajrndt.com/products/aje220b-mt-flaw-detector.html",
        "short": "Portable electromagnetic yoke with articulating double-jointed legs for complex weld geometries.",
        "desc": "The AJE220B is a portable magnetic particle testing yoke featuring double-jointed articulating legs that conform to fillets, butt welds, curved pipes, and uneven surfaces.",
        "specs": [("Power Input", "220V AC 50/60Hz"), ("Lifting Power", ">= 4.5 kg (AC) / >= 18 kg (DC)"), ("Pole Spacing", "0 - 210 mm"), ("Duty Cycle", "50%")],
        "material": "Reinforced glass-filled nylon housing with polyurethane encapsulation", "weight": "3.1 kg", "featured": 1
    },
    {
        "name": "AJE220B AC DC Magnetic Yoke Tester",
        "slug": "aje220b-ac-dc-magnetic-yoke-tester",
        "sku": "AJR-AJE-220B-ACDC",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240102/c66940aeb6cafe21523c61133c573734.jpg",
        "url": "https://www.ajrndt.com/products/aje220b-ac-dc-magnetic-yoke-tester.html",
        "short": "Dual-mode AC/DC electromagnetic yoke for surface and subsurface flaw detection.",
        "desc": "The AJE220B AC/DC offers switchable AC and pulsed DC magnetization modes. The AC mode provides skin-effect concentration for sharp surface crack indications, while DC penetration reveals sub-surface inclusions.",
        "specs": [("Modes", "Selectable AC / DC"), ("AC Lifting Force", ">= 4.5 kg"), ("DC Lifting Force", ">= 18.1 kg"), ("Standards", "ASTM E709, ASTM E1444, ASME Section V")],
        "material": "Molded polymer case with ergonomic handle", "weight": "3.3 kg", "featured": 0
    },
    {
        "name": "AJE230 Permanent Yoke Tester",
        "slug": "aje230-permanent-yoke-tester",
        "sku": "AJR-AJE-230-PERM",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/91136efe201ff5b4a15d0fc0d8f0b489.jpg",
        "url": "https://www.ajrndt.com/products/aje230-permanent-yoke-tester.html",
        "short": "Intrinsically safe permanent magnet yoke requiring no electricity or batteries.",
        "desc": "The AJE230 Permanent Magnet Yoke contains powerful rare-earth permanent magnets, making it completely intrinsically safe for explosive atmospheres (ATEX Zone 0/1), offshore platforms, and remote underwater applications without electrical hazard.",
        "specs": [("Lifting Power", ">= 18 kg (exceeds ASTM requirements)"), ("Magnet Type", "High-coercivity NdFeB permanent magnets"), ("Pole Distance", "50 - 250 mm adjustable"), ("Power Requirement", "None (100% passive)")],
        "material": "Non-sparking alloy and stainless steel", "weight": "2.8 kg", "featured": 0
    },
    {
        "name": "AJE220 AC DC MT Flaw Detector",
        "slug": "aje220-ac-dc-mt-flaw-detector",
        "sku": "AJR-AJE-220-ACDC",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/c6be24b939e04682bba68755de76e115.jpg",
        "url": "https://www.ajrndt.com/products/aje220-ac-dc-mt-flaw-detector.html",
        "short": "Heavy-duty electromagnetic AC/DC yoke with high-duty cycle.",
        "desc": "The AJE220 AC/DC Magnetic Particle Flaw Detector is a workhorse unit for fabrication yards, structural steel erection, and petrochemical turnaround inspections.",
        "specs": [("Input Voltage", "220V 50Hz / 110V 60Hz"), ("Current", "2.8A"), ("Lifting Capacity", "AC >= 5 kg, DC >= 18 kg"), ("Cable Length", "3.0 meters oil-resistant cord")],
        "material": "High-durability sealed casing", "weight": "3.2 kg", "featured": 0
    },
    {
        "name": "AJE220 Magnetic Particle Inspection Tester (with UV Light)",
        "slug": "aje220-magnetic-flaw-detector",
        "sku": "AJR-AJE-220-UV",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/f9453bcebe79abaf59cced530b4ea62d.jpg",
        "url": "https://www.ajrndt.com/products/aje220-magnetic-flaw-detector.html",
        "short": "Electromagnetic yoke with built-in UV-A 365 nm LED light for fluorescent magnetic particle inspection.",
        "desc": "Features an integrated high-intensity 365 nm UV-A LED source centered between the poles, illuminating the testing zone for fluorescent wet magnetic particle inspections without needing a separate handheld blacklight.",
        "specs": [("Integrated Lighting", "365 nm UV-A LED (>2000 uW/cm2 at 15cm)"), ("Lifting Power", ">= 4.5 kg"), ("Pole Center Distance", "0 - 200 mm"), ("Duty Cycle", "50%")],
        "material": "Sealed industrial polymer", "weight": "3.2 kg", "featured": 0
    },
    {
        "name": "AJE220 AC Yoke Tester with White Light",
        "slug": "aje220-ac-yoke-tester",
        "sku": "AJR-AJE-220-WHT",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/9f828e3b701d017603c5b9c10c453538.jpg",
        "url": "https://www.ajrndt.com/products/aje220-ac-yoke-tester.html",
        "short": "Electromagnetic AC yoke with built-in high-lumen white LED for dark inspection spaces.",
        "desc": "Equipped with a built-in bright white LED beam to illuminate weld seams in dark vessels, boilers, and shadowed shop corners during visible dry/wet magnetic particle testing.",
        "specs": [("Built-in Illumination", "White LED (>1000 Lux on test zone)"), ("Lifting Power", ">= 4.5 kg"), ("Input", "AC 220V / 110V"), ("Leg Articulation", "Double-jointed swivel")],
        "material": "Rugged encapsulated body", "weight": "3.1 kg", "featured": 0
    },
    {
        "name": "AJE220 Mt Yoke Tester",
        "slug": "aje220-mt-yoke-tester",
        "sku": "AJR-AJE-220-STD",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/3d8487f5e89f46a73523c48707498457.jpg",
        "url": "https://www.ajrndt.com/products/aje220-mt-yoke-tester.html",
        "short": "Standard AC electromagnetic flaw detector yoke for routine MPI weld checks.",
        "desc": "Standard industrial AC magnetic particle inspection yoke compliant with all major international boiler, vessel, and structural fabrication codes.",
        "specs": [("Voltage", "220V AC 50Hz"), ("Lifting Capacity", ">= 4.5 kg (10 lbs)"), ("Pole Pitch", "25 - 230 mm"), ("Duty Cycle", "50% (2 min on / 2 min off)")],
        "material": "Impact-resistant resin housing", "weight": "3.0 kg", "featured": 0
    },
    {
        "name": "AJE110 Magnetic Flaw Detector",
        "slug": "aje110-magnetic-flaw-detector",
        "sku": "AJR-AJE-110",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/1ff50d0d52a56ddbff4ca363564f3f41.jpg",
        "url": "https://www.ajrndt.com/products/aje110-magnetic-flaw-detector.html",
        "short": "Lightweight ergonomic AC magnetic yoke for fatigue-free overhead inspection.",
        "desc": "Compact, lightweight ergonomic yoke designed to minimize inspector fatigue during overhead piping inspection and extended structural testing shifts.",
        "specs": [("Power", "110V / 220V AC"), ("Lifting Power", ">= 4.5 kg"), ("Weight", "2.5 kg lightweight design"), ("Pole Spacing", "0 - 180 mm")],
        "material": "Lightweight nylon casing", "weight": "2.5 kg", "featured": 0
    },
    {
        "name": "AMT Magnetic Charging Coil",
        "slug": "amt-magnetic-charging-coil",
        "sku": "AJR-AMT-COIL",
        "cat": "magnetic-particle-inspection",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/5c02ee7170b09959b1f4b380c8e855ed.jpg",
        "url": "https://www.ajrndt.com/products/amt-magnetic-charging-coil.html",
        "short": "High-flux longitudinal magnetization coil for shafts, bars, and tubular components.",
        "desc": "The AMT Magnetic Charging Coil induces high longitudinal magnetic fields in cylindrical parts, pipes, shafts, and bolts to detect transverse surface cracks.",
        "specs": [("Internal Diameter", "150 mm / 200 mm / 300 mm available"), ("Ampere Turns", ">= 4500 AT"), ("Operation Mode", "Continuous / Intermittent pulsed"), ("Duty Cycle", "25%")],
        "material": "Epoxy molded heavy copper windings", "weight": "6.5 kg", "featured": 0
    },

    # 6. Radiography Testing & Pipeline Crawlers
    {
        "name": "AJR NDT 120-300KV X Ray Flaw Detector",
        "slug": "ajr-ndt-x-ray-flaw-detector",
        "sku": "AJR-XR-300KV",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/7af111ca2eac10ccdabfffa6764a55db.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-x-ray-flaw-detector.html",
        "short": "High-output directional industrial X-ray generator (120-300 kV) for heavy weld radiography.",
        "desc": "The AJR 120-300KV industrial X-ray generator features SF6 gas insulation, ceramic tube construction, micro-computer controller, and superior penetration capacity up to 50 mm in steel.",
        "specs": [("Output Voltage", "120 - 300 kV continuously adjustable"), ("Tube Current", "5 mA"), ("Penetration (Steel)", "Up to 50 mm (A3 steel, density >= 1.5)"), ("Focal Spot", "2.0 x 2.0 mm"), ("Beam Angle", "40 + 5 degrees directional")],
        "material": "SF6 gas insulated metal tube head with digital controller", "weight": "32 kg", "featured": 1
    },
    {
        "name": "AJR NDT: Portable X Ray Flaw Detector",
        "slug": "ajr-ndt-portable-x-ray-flaw-detector",
        "sku": "AJR-XR-PORTABLE",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/359b6646797f1b0f1c7c66990399bf4d.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-portable-x-ray-flaw-detector.html",
        "short": "Portable 160-250 kV industrial X-ray flaw detector with lightweight generator head.",
        "desc": "Engineered for on-site field radiography of pipeline welds, pressure vessels, and aerospace assemblies. Features automated warm-up and fault diagnostic protection.",
        "specs": [("Voltage Range", "100 - 250 kV"), ("Current", "5 mA"), ("Max Penetration", "39 mm steel"), ("Cooling", "Forced air cooling"), ("Insulation", "SF6 Gas 0.35 - 0.45 MPa")],
        "material": "Aviation aluminum casing", "weight": "24 kg", "featured": 0
    },
    {
        "name": "AJR NDT: RT X Ray Flaw Detector",
        "slug": "ajr-ndt-rt-x-ray-flaw-detector",
        "sku": "AJR-XR-RT-PANORAMIC",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/7a184420901668914207245c856c526b.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-rt-x-ray-flaw-detector.html",
        "short": "Panoramic 360-degree X-ray flaw detector for one-shot circumferential pipe weld inspection.",
        "desc": "Features a 360-degree panoramic beam tube head allowing inspectors to radiograph an entire circumferential pipe weld in a single exposure, drastically reducing inspection time on pipeline projects.",
        "specs": [("Beam Geometry", "360 x (25-30) degrees panoramic conical beam"), ("Voltage", "160 - 300 kV"), ("Penetration", "45 mm steel"), ("Controller", "Digital programmable timer and kV control")],
        "material": "Industrial radiation-shielded tube housing", "weight": "33 kg", "featured": 0
    },
    {
        "name": "AJR NDT 5100 X Ray Crawler",
        "slug": "ajr-ndt-5100-x-ray-crawler",
        "sku": "AJR-CRW-5100",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240124/1111e6518c34d9adc7c21a0270ddaba0.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-5100-x-ray-crawler.html",
        "short": "Internal pipeline radiography crawler for small-diameter pipelines (200 - 450 mm).",
        "desc": "The AJR NDT 5100 is an autonomous battery-powered crawler designed for internal circumferential weld radiography inside small-diameter transmission pipelines.",
        "specs": [("Pipe Diameter", "200 - 450 mm"), ("Drive", "4-wheel DC motor drive with regenerative braking"), ("Positioning", "Magnetic / Isotope sensor positioning accuracy +/- 5 mm"), ("Operating Range", "Up to 3 km inside pipe")],
        "material": "High-strength stainless steel and aluminum alloy chassis", "weight": "55 kg", "featured": 1
    },
    {
        "name": "AJR NDT 5200 RT Pipeline Crawler",
        "slug": "ajr-ndt-5200-rt-pipeline-crawler",
        "sku": "AJR-CRW-5200",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240124/d542d6c93902990355476d2290cb84f1.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-5200-rt-pipeline-crawler.html",
        "short": "Medium-diameter pipeline X-ray inspection crawler (400 - 800 mm).",
        "desc": "Designed for oil and natural gas pipeline construction, the 5200 series integrates safety fail-safes including reverse on loss of signal, water detection, and low battery auto-return.",
        "specs": [("Pipe Diameter", "400 - 800 mm"), ("X-Ray Tube Compatibility", "200 - 250 kV Panoramic tubes"), ("Speed", "Up to 18 m/min"), ("Battery Capacity", "Panasonic Lead-acid or LiFePO4 packs")],
        "material": "Modular alloy frame with polyurethane wheels", "weight": "75 kg", "featured": 0
    },
    {
        "name": "AJR NDT 5300 RT Crawler",
        "slug": "ajr-ndt-5300-rt-crawler",
        "sku": "AJR-CRW-5300",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240124/63750736ce40bfc5110ff9086cffb5fb.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-5300-rt-crawler.html",
        "short": "Heavy-duty pipeline crawler for 600 - 1200 mm cross-country pipelines.",
        "desc": "Built for rigorous cross-country transmission pipelines in desert, arctic, and mountainous terrains with high climbing capacity up to 40 degrees slope.",
        "specs": [("Pipe Diameter", "600 - 1200 mm"), ("Climbing Ability", "Up to 40 degrees slope"), ("Compatible Tubes", "Up to 300 kV panoramic generators"), ("Safety Features", "Obstacle sensor, water sensor, auto-retrieval")],
        "material": "Heavy duty reinforced steel-aluminum chassis", "weight": "95 kg", "featured": 0
    },
    {
        "name": "AJR NDT 5400 Series X-ray Pipeline Crawler",
        "slug": "ajr-ndt-5400-pipeline-crawler",
        "sku": "AJR-CRW-5400",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240124/dcc9ab460b453837adb4bebc21d24f64.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-5400-pipeline-crawler.html",
        "short": "Large-diameter cross-country pipeline radiography crawler (800 - 1400 mm).",
        "desc": "The 5400 series handles heavy 300-350 kV panoramic tubeheads for thick-walled transmission gas pipelines with extended runtime batteries.",
        "specs": [("Pipe Diameter", "800 - 1400 mm"), ("Drive Mechanism", "Independent 4-wheel torque drive"), ("Battery System", "High-discharge modular battery pack"), ("Control", "External isotope/magnetic command system")],
        "material": "Corrosion-resistant treated alloy structure", "weight": "115 kg", "featured": 0
    },
    {
        "name": "AJR NDT 5500 X Ray Pipeline Crawler",
        "slug": "ajr-ndt-5500-x-ray-pipeline-crawler",
        "sku": "AJR-CRW-5500",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240124/01a93ba3a883d716c79fc01b13607216.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-5500-x-ray-pipeline-crawler.html",
        "short": "Extra-large pipeline crawler system (1000 - 1600 mm) with intelligent electronic control.",
        "desc": "AJR's largest crawler system engineered for major trunklines and offshore spoolbases, accommodating ultra-high penetration panoramic X-ray systems.",
        "specs": [("Pipe Diameter", "1000 - 1600 mm"), ("Drive Power", "Dual high-torque brushless DC motors"), ("Operating Temperature", "-30 to +60 deg C"), ("Speed", "Adjustable 10 - 20 m/min")],
        "material": "Stainless steel & structural aircraft alloy", "weight": "135 kg", "featured": 0
    },
    {
        "name": "AFV2131D Industrial X-Ray Film Viewer with Densitometer",
        "slug": "afv2131d-led-industrial-x-ray-film-viewer-combine-with-densitometer",
        "sku": "AJR-AFV-2131D",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/7b4ea06456b50589926681cdfd4366f2.jpg",
        "url": "https://www.ajrndt.com/products/afv2131d-led-industrial-x-ray-film-viewer-combine-with-densitometer.html",
        "short": "High-luminance LED radiograph viewer with built-in calibrated transmission densitometer.",
        "desc": "The AFV2131D integrates an ultra-bright uniform LED backlight (up to 130,000 cd/m2) and an optical transmission densitometer (measuring optical density D 0.00 - 5.00) in one sleek chassis.",
        "specs": [("Maximum Luminance", ">= 130,000 cd/m2 (density D >= 4.5 viewable)"), ("Built-in Densitometer", "Range: 0.00 - 5.00 D, Accuracy: +/- 0.02 D"), ("Viewing Window", "220 x 80 mm (custom masks included)"), ("Cooling", "Ultra-quiet PWM cooling fan")],
        "material": "Anodized aluminum alloy housing", "weight": "3.8 kg", "featured": 1
    },
    {
        "name": "AFV2126D Film Viewer with Densitometer",
        "slug": "afv2126d-film-viewer-with-densitometer",
        "sku": "AJR-AFV-2126D",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240125/cb669b5168e6eb5ab7d189aae5927ea5.jpg",
        "url": "https://www.ajrndt.com/products/afv2126d-film-viewer-with-densitometer.html",
        "short": "Compact LED industrial film illuminator with integrated black-and-white densitometer.",
        "desc": "Compact footprint model for darkrooms and mobile inspection vans, offering calibrated film density reading and foot-switch illumination control.",
        "specs": [("Luminance", ">= 110,000 cd/m2"), ("Densitometer Range", "0.00 - 4.50 D"), ("Window Size", "200 x 60 mm"), ("Power", "100 - 240V AC universal")],
        "material": "Aluminum alloy frame", "weight": "3.2 kg", "featured": 0
    },
    {
        "name": "AFV2131 LED Film Viewer",
        "slug": "afv2131-led-film-viewer",
        "sku": "AJR-AFV-2131",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240125/b3d4896276228dbf29affae938253c73.jpg",
        "url": "https://www.ajrndt.com/products/afv2131-led-film-viewer.html",
        "short": "High-luminance uniform LED radiograph viewer with continuous dimmer and foot pedal.",
        "desc": "Features premium surface-mount LEDs providing exceptional uniformity (g >= 0.95), low surface heat, and stepless dimming for reviewing high-density industrial radiographs.",
        "specs": [("Max Luminance", ">= 130,000 cd/m2"), ("Uniformity", ">= 95% across viewing area"), ("Dimming", "Stepless rotary control 5% - 100%"), ("LED Lifespan", ">= 50,000 hours")],
        "material": "Extruded aluminum casing", "weight": "3.4 kg", "featured": 0
    },
    {
        "name": "AFV2128 Film Viewer",
        "slug": "afv2128-film-viewer",
        "sku": "AJR-AFV-2128",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/bcf54ff8e63bbc0862c6c031c25bf923.jpg",
        "url": "https://www.ajrndt.com/products/afv2128-film-viewer.html",
        "short": "Slimline LED film viewer for evaluating industrial radiographs up to 4.0D.",
        "desc": "Ultra-thin portable LED film viewer designed for field inspection trucks and darkrooms.",
        "specs": [("Luminance", ">= 105,000 cd/m2"), ("Viewing Window", "220 x 75 mm"), ("Thickness", "Only 38 mm ultra-thin profile"), ("Control", "Touch sensor and foot pedal")],
        "material": "Anodized aluminum", "weight": "2.9 kg", "featured": 0
    },
    {
        "name": "AFV2126 Industrial Film Viewer",
        "slug": "afv2126-industrial-film-viewer",
        "sku": "AJR-AFV-2126",
        "cat": "radiography-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240125/fe2e33f0016f737fd4c7f69fe100e286.jpg",
        "url": "https://www.ajrndt.com/products/afv2126-industrial-film-viewer.html",
        "short": "Standard compact LED radiograph illuminator for weld radiographs.",
        "desc": "Economical, rugged industrial LED film viewer providing high brightness and cold light operation for weld quality interpretation.",
        "specs": [("Max Luminance", ">= 100,000 cd/m2"), ("Window", "200 x 60 mm"), ("Power Supply", "100-240V AC"), ("Standards", "ISO 5580, ASTM E1390")],
        "material": "Aluminum alloy", "weight": "2.8 kg", "featured": 0
    },

    # 7. Eddy Current Testing (ECT)
    {
        "name": "AJR NDT AEC640 Eddy Current Flaw Detector",
        "slug": "ajr-ndt-aec640-eddy-current-flaw-detector",
        "sku": "AJR-AEC-640",
        "cat": "eddy-current-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/a2c273a121bae89299484d37bb386e73.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-aec640-eddy-current-flaw-detector.html",
        "short": "Multi-frequency digital eddy current flaw detector for surface cracks and heat exchanger tubing.",
        "desc": "The AEC640 is a high-performance portable eddy current flaw detector covering 10 Hz to 10 MHz. Offers impedance plane display, sweep display, multi-frequency mixing to cancel support plate signals, and high sensitivity for surface cracks through non-conductive coatings.",
        "specs": [("Frequency Range", "10 Hz - 10 MHz continuous"), ("Gain", "0 - 99.9 dB (0.1 dB step)"), ("Phase Rotation", "0 - 359 degrees"), ("Display Modes", "Impedance plane, time base sweep, spot"), ("Battery", "Rechargeable Lithium pack, >8 hours")],
        "material": "Rugged industrial casing", "weight": "1.8 kg", "featured": 1
    },
    {
        "name": "AEC620 Eddy Current Tester",
        "slug": "aec620-eddy-current-tester",
        "sku": "AJR-AEC-620",
        "cat": "eddy-current-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/0989dae8965c20f51b30324caf183043.jpg",
        "url": "https://www.ajrndt.com/products/aec620-eddy-current-tester.html",
        "short": "Handheld dual-frequency eddy current crack detector for aerospace and structural welds.",
        "desc": "The AEC620 provides dual-frequency inspection with automated balancing, variable alarm gates, and high signal-to-noise ratio for fastener hole and surface weld inspection.",
        "specs": [("Frequencies", "Dual independent frequencies (50 Hz - 6 MHz)"), ("Display", "Color TFT LCD"), ("Storage", "1000 setups and inspection files"), ("Probe Compatibility", "Absolute, Differential, Reflection probes")],
        "material": "Impact-resistant polymer enclosure", "weight": "1.3 kg", "featured": 0
    },
    {
        "name": "AJR NDT AEC670 Eddy Current Electrical Conductivity Meter",
        "slug": "ajr-ndt-aec670-eddy-current-electrical-conductivity-meter",
        "sku": "AJR-AEC-670",
        "cat": "eddy-current-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/3cc5d6cba28d4bb0ce1d2eb4fee0aee2.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-aec670-eddy-current-electrical-conductivity-meter.html",
        "short": "Precision digital eddy current conductivity meter (% IACS / MS/m) for alloy verification.",
        "desc": "The AEC670 measures electrical conductivity of non-ferrous metals per ASTM E1004. Used for aluminum alloy heat treatment verification, precipitation hardening checks, and electrical conductor sorting.",
        "specs": [("Operating Frequency", "60 kHz (standard aerospace) & 500 kHz options"), ("Measuring Range", "0.8% IACS - 110% IACS (0.45 - 64 MS/m)"), ("Resolution", "0.01% IACS"), ("Accuracy", "+/- 0.5% of reading at 20 deg C"), ("Lift-off Compensation", "Up to 0.5 mm")],
        "material": "Ergonomic handheld casing with certified calibration blocks", "weight": "420 g", "featured": 1
    },
    {
        "name": "AEC660 Eddy Current Conductivity Tester",
        "slug": "aec660-eddy-current-conductivity-tester",
        "sku": "AJR-AEC-660",
        "cat": "eddy-current-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/de99b5c31273689a9c14009cf9097220.jpg",
        "url": "https://www.ajrndt.com/products/aec660-eddy-current-conductivity-tester.html",
        "short": "Handheld eddy current conductivity meter with automatic temperature compensation.",
        "desc": "The AEC660 provides rapid metal sorting and heat treatment verification with automatic temperature compensation to 20 deg C.",
        "specs": [("Conductivity Range", "0.9% - 110% IACS"), ("Temperature Sensor", "Built-in probe thermistor for automatic compensation"), ("Display", "Backlit LCD"), ("Battery", "Rechargeable Li-ion")],
        "material": "ABS casing", "weight": "390 g", "featured": 0
    },

    # 8. Visual Inspection & Videoscopes
    {
        "name": "AJR 90 Pipeline Videoscope",
        "slug": "ajr-90-pipeline-videoscope",
        "sku": "AJR-VID-90",
        "cat": "visual-inspection-videoscopes",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240102/b296ac9af00466f7feea4d5de1af0a92.jpg",
        "url": "https://www.ajrndt.com/products/ajr-90-pipeline-videoscope.html",
        "short": "Heavy-duty push-rod pipeline inspection camera with pan/tilt head and distance counter.",
        "desc": "The AJR 90 is an industrial push-rod pipe inspection camera system featuring a 360-degree pan / 180-degree tilt camera head, 50-meter fiberglass push cable, on-screen digital distance meter counter, and high-resolution DVR recording.",
        "specs": [("Camera Head", "Diameter 50 mm, 360 pan / 180 tilt"), ("Cable Length", "50 meters (up to 120m optional)"), ("Waterproof Rating", "IP68 submersible to 10 meters"), ("Display", "10-inch HD color monitor with sunshield"), ("Lighting", "High-intensity adjustable white LEDs")],
        "material": "Stainless steel camera head, rugged reel cart", "weight": "16 kg", "featured": 1
    },
    {
        "name": "50039 / 50060 Portable Video Endoscopes",
        "slug": "ajr-ndt-50039-50060-videoscope",
        "sku": "AJR-VID-50039-60",
        "cat": "visual-inspection-videoscopes",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240102/25aaeeff79947018812c12f1e8f5b3d3.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-50039-50060-videoscope.html",
        "short": "Articulating industrial videoscope with 3.9mm / 6.0mm HD probes for turbine and engine RVI.",
        "desc": "The 50039 / 50060 series industrial videoscopes feature 360-degree mechanical or joystick 4-way articulation, 3.9mm or 6.0mm insertion tube diameters, tungsten braided armor, and high-definition image capture.",
        "specs": [("Probe Diameters", "3.9 mm or 6.0 mm"), ("Articulation", "4-way 360-degree joystick articulation (>160 degrees bend)"), ("Probe Length", "1.5 m, 2.0 m, 3.0 m options"), ("Display", "5.0-inch IPS HD touchscreen"), ("Tube Material", "Tungsten wire mesh braid")],
        "material": "Magnesium alloy console with tungsten braided probe", "weight": "1.1 kg", "featured": 0
    },
    {
        "name": "AJR90 Series Pipe Inspection Camera",
        "slug": "pipe-videoscope",
        "sku": "AJR-VID-90-SERIES",
        "cat": "visual-inspection-videoscopes",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240122/3aaa51ba415b57d62d6fd14884e552eb.jpg",
        "url": "https://www.ajrndt.com/products/pipe-videoscope.html",
        "short": "Self-leveling drain and industrial pipe camera system with wireless keyboard logging.",
        "desc": "Comprehensive pipe inspection camera system with self-leveling optics, 512 Hz sonde transmitter for underground location, and keyboard text overlay for defect annotation.",
        "specs": [("Self-leveling", "Always upright image sensor"), ("Sonde Transmitter", "Built-in 512 Hz sonde for locator tracking"), ("Storage", "SD card slot up to 64GB"), ("Battery", "6600mAh Li-ion, >6 hours")],
        "material": "Sapphire glass lens, stainless steel housing", "weight": "14 kg", "featured": 0
    },

    # 9. NDT UV LED Lamps & Black Lights
    {
        "name": "AJR UV LED 6000P+ UV LED Lamp",
        "slug": "ndt-lamp-black-light",
        "sku": "AJR-UV-6000P-PLUS",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/18a0ed86bdaaf388efdac67cc45409cf.jpg",
        "url": "https://www.ajrndt.com/products/ndt-lamp-black-light.html",
        "short": "High-intensity handheld 365 nm UV-A LED black light compliant with ASTM E3022.",
        "desc": "The AJR UV LED 6000P+ delivers high UV-A intensity with pure 365 nm wavelength and zero UV-B/C emission, engineered specifically for fluorescent penetrant (FPI) and fluorescent magnetic particle inspection (MPI).",
        "specs": [("Peak Wavelength", "365 nm +/- 5 nm"), ("UV-A Intensity", ">= 6,000 uW/cm2 at 38 cm (15 in)"), ("Visible Light Emission", "< 10 Lux (< 1 foot-candle)"), ("Standards", "ASTM E3022, Rolls-Royce RRES 90061, ISO 3059")],
        "material": "Anodized aviation aluminum with mechanical cooling fins", "weight": "720 g", "featured": 1
    },
    {
        "name": "AJR UV LED 4000+ / 6000+ / 8000+ / 10000+ NDT UV LED Lamp",
        "slug": "ndt-uv-led-lamp",
        "sku": "AJR-UV-SERIES-PLUS",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240102/a476b4391bf52a8ad8db237e10041d30.jpg",
        "url": "https://www.ajrndt.com/products/ndt-uv-led-lamp.html",
        "short": "Configurable intensity UV-A blacklight series (4,000 to 10,000 uW/cm2).",
        "desc": "A modular UV inspection lamp series offering tailored UV-A outputs to meet specific aerospace (ASTM E3022) or high-intensity foundry and casting inspection requirements.",
        "specs": [("Output Variants", "4000+, 6000+, 8000+, 10000+ uW/cm2"), ("Beam Diameter", ">= 180 mm effective coverage at 38 cm"), ("White Light Mode", "Integrated white LED for general illumination"), ("Power", "Corded AC or hot-swappable Li-ion batteries")],
        "material": "Aerospace-grade 6061-T6 aluminum", "weight": "790 g", "featured": 0
    },
    {
        "name": "AJR UV LED4000 / 6000 / 8000 / 10000 Model NDT UV LED Lamp",
        "slug": "ajr-uv-led4000-6000-8000-10000-model-ndt-uv-led-lamp",
        "sku": "AJR-UV-MODULAR",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240102/f963e0b1a136606bd0799b129e667571.jpg",
        "url": "https://www.ajrndt.com/products/ajr-uv-led4000-6000-8000-10000-model-ndt-uv-led-lamp.html",
        "short": "Field-ready UV-A inspection lamp with Wood's glass optical filter.",
        "desc": "Features integrated black light filters (Wood's glass) to eliminate visible light glare and maximize contrast of fluorescent indications in non-destructive testing.",
        "specs": [("Filter Type", "Integrated black light band-pass filter"), ("Wavelength", "365 nm"), ("Battery Run Time", "4.5 hours continuous"), ("Cooling", "Fanless passive convection (silent)")],
        "material": "Thermal dissipation alloy housing", "weight": "680 g", "featured": 0
    },
    {
        "name": "AJR NDT Stationary Flood UV A Lamp",
        "slug": "ajr-ndt-stationary-flood-uv-a-lamp",
        "sku": "AJR-UV-FLOOD-STAT",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/fb5d752d56273acf80332e9c24ef4412.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-stationary-flood-uv-a-lamp.html",
        "short": "Overhead high-coverage stationary UV-A flood lamp for MPI benches and wash stations.",
        "desc": "The Stationary Flood UV-A Lamp provides wide-area, uniform 365 nm irradiation over wet horizontal magnetic testing benches, penetrant rinse stations, and inspection booths.",
        "specs": [("Coverage Area", "600 x 400 mm at 38 cm"), ("UV-A Intensity", ">= 4,500 uW/cm2 uniform"), ("Mounting", "Overhead adjustable bracket"), ("Input Power", "100-240V AC 50/60Hz, 80W")],
        "material": "Heavy duty finned aluminum enclosure", "weight": "4.5 kg", "featured": 0
    },
    {
        "name": "AJR NDT UV-H Helmet Type UV LED LAMP",
        "slug": "ajr-ndt-uv-ndt-mt-pt",
        "sku": "AJR-UV-HELMET-H",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/2e74160412ab46af63c38b4af255563c.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-uv-ndt-mt-pt.html",
        "short": "Hands-free helmet-mounted UV-A headlamp for rope access and confined space inspection.",
        "desc": "Hands-free UV-A inspection light engineered for inspectors operating on climbing harnesses, rope access, tanks, and confined spaces where both hands are required.",
        "specs": [("Wavelength", "365 nm"), ("Intensity", ">= 3,500 uW/cm2 at 38 cm"), ("Mounting", "Universal hard hat / helmet clip and headband"), ("Battery", "Belt-mounted Li-ion pack, >6 hrs")],
        "material": "Impact-resistant polymer and aluminum head", "weight": "260 g", "featured": 0
    },
    {
        "name": "AJR UV-T UV LED Torch with Trigger",
        "slug": "ajr-uv-t-uv-led-torch-with-trigger",
        "sku": "AJR-UV-TORCH-T",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/36b162a84552eda31acd551b6c63b8ff.jpg",
        "url": "https://www.ajrndt.com/products/ajr-uv-t-uv-led-torch-with-trigger.html",
        "short": "Pistol-grip UV-A inspection torch with momentary/continuous trigger switch.",
        "desc": "Ergonomic pistol grip UV torch allowing rapid momentary trigger activation or continuous lock for aerospace and oil & gas weld inspection.",
        "specs": [("Trigger", "Pistol-grip momentary/latching trigger"), ("Wavelength", "365 nm"), ("Intensity", ">= 5,000 uW/cm2"), ("Battery", "Internal rechargeable 18650 Li-ion")],
        "material": "Ergonomic rubberized grip with aluminum bezel", "weight": "480 g", "featured": 0
    },
    {
        "name": "AJR UV Flashlight, Black Floor Lamp",
        "slug": "ajr-uv-led-4000p-6000p-8000p-10000p-40000p-black-light",
        "sku": "AJR-UV-FLASHLIGHT-MULTI",
        "cat": "ndt-uv-lamps",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/4a36e42c414862423cb62ec859a2d0d5.jpg",
        "url": "https://www.ajrndt.com/products/ajr-uv-led-4000p-6000p-8000p-10000p-40000p-black-light.html",
        "short": "Multi-mode high-power blacklight flashlight and floor stand fixture.",
        "desc": "Versatile UV-A luminaire usable as a handheld heavy-duty flashlight or mounted on a floor tripod stand for hands-free component inspection.",
        "specs": [("Output", "Up to 40,000 uW/cm2 at high-power mode"), ("Beam Pattern", "Wide homogeneous circular beam"), ("Tripod Mount", "Standard 1/4-inch UNC socket"), ("Protection", "IP65 waterproof")],
        "material": "Anodized heavy aluminum", "weight": "950 g", "featured": 0
    },

    # 10. Holiday Detectors & Wire Rope Testers
    {
        "name": "ART-11S Steel Wire Rope Tester",
        "slug": "art-11s-steel-wire-rope-tester",
        "sku": "AJR-ART-11S",
        "cat": "holiday-wire-rope-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240102/403d208cedeeaa4a1c1fe1d0c097c71d.jpg",
        "url": "https://www.ajrndt.com/products/art-11s-steel-wire-rope-tester.html",
        "short": "Electromagnetic wire rope tester for detecting broken wires, corrosion, and wear in crane/mining cables.",
        "desc": "The ART-11S uses Magnetic Flux Leakage (MFL) principles to quantitatively test steel wire ropes for internal and external broken wires (LF) and loss of metallic cross-sectional area (LMA) in elevators, cranes, ropeways, and mine hoists.",
        "specs": [("Rope Diameter Range", "6 - 70 mm (selectable sensor heads)"), ("Testing Speed", "0 - 3 m/s"), ("Defect Types", "LF (Local Faults / Broken Wires) & LMA (Loss of Metallic Area)"), ("Sensors", "Hall effect array with rare-earth permanent magnets")],
        "material": "Modular split-clamp sensor head with rugged console", "weight": "5.5 kg (head)", "featured": 1
    },
    {
        "name": "AHD810 Pinhole Holiday Detector",
        "slug": "ahd810-pinhole-holiday-detector",
        "sku": "AJR-AHD-810",
        "cat": "holiday-wire-rope-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/7aa54039f33009c1d2e9caab64b045dc.jpg",
        "url": "https://www.ajrndt.com/products/ahd810-pinhole-holiday-detector.html",
        "short": "Low-voltage wet sponge holiday detector for pinholes in coatings under 500 um.",
        "desc": "The AHD810 is a low-voltage wet sponge holiday detector designed to find holidays, pinholes, and voids in non-conductive coatings applied to conductive metal substrates per ASTM G62.",
        "specs": [("Voltage Settings", "9V, 67.5V, 90V selectable"), ("Coating Thickness", "Up to 500 um (20 mils)"), ("Alarm", "Audible buzzer and bright LED indicator"), ("Sponge", "Rectangular open-cell cellulose sponge wand")],
        "material": "ABS casing with ground wire clamp", "weight": "420 g", "featured": 0
    },
    {
        "name": "AHD820 Spark Holiday Detector",
        "slug": "ahd820-spark-holiday-detector",
        "sku": "AJR-AHD-820",
        "cat": "holiday-wire-rope-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240103/f9cb3988e1dc9e161f574fca49856899.jpg",
        "url": "https://www.ajrndt.com/products/ahd820-spark-holiday-detector.html",
        "short": "High-voltage pulse spark tester (0.5 - 35 kV) for tank and pipe protective linings.",
        "desc": "The AHD820 generates precise high-voltage test pulses to detect microscopic pinholes, porosity, and cracks in thick protective coatings such as fusion-bonded epoxy (FBE), coal tar enamel, rubber, and glass linings.",
        "specs": [("Output Voltage", "0.5 - 35 kV continuously adjustable"), ("Thickness Range", "0.05 - 10 mm"), ("Display", "Digital output voltage LCD"), ("Electrodes", "Rolling spring electrode, brass wire brush, conductive rubber")],
        "material": "High-impact polyurethane carrying case", "weight": "2.2 kg (console)", "featured": 1
    },
    {
        "name": "AHD860 Porosity Holiday Detector",
        "slug": "ahd860-porosity-holiday-detector",
        "sku": "AJR-AHD-860",
        "cat": "holiday-wire-rope-testing",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/023e5ca631f94551263574637ffeb6b6.jpg",
        "url": "https://www.ajrndt.com/products/porosity-holiday-detector.html",
        "short": "Intelligent digital DC high-voltage porosity detector with automatic voltage calculation.",
        "desc": "The AHD860 calculates the exact required test voltage based on coating thickness and standard formulas (NACE SP0188 / ASTM D5162), preventing coating burn-through while guaranteeing detection.",
        "specs": [("Voltage Range", "0.6 - 30 kV DC"), ("Resolution", "0.1 kV"), ("Standards", "NACE SP0188, ASTM D5162, ISO 29601"), ("Battery", "Internal lithium battery pack, 10 hours runtime")],
        "material": "Ruggedized field console with safety ground interlock", "weight": "2.4 kg", "featured": 0
    },

    # 11. Photometers & Radiometers
    {
        "name": "AJR NDT: LX1010B Light Meter",
        "slug": "ajr-ndt-light-meter",
        "sku": "AJR-LX-1010B",
        "cat": "photometers-radiometers",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/31a7f0c3edbd8d8af6219c5d92a2cd8c.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-light-meter.html",
        "short": "Digital visible light illuminance meter for NDT inspection booth compliance.",
        "desc": "Measures ambient visible white light levels in fluorescent penetrant and magnetic particle inspection booths to verify compliance with ASTM E1444 (<20 Lux ambient) and visible inspection (>1000 Lux).",
        "specs": [("Range", "0 - 50,000 Lux (3 ranges)"), ("Accuracy", "+/- 4% rdg + 0.5% f.s."), ("Sensor", "Silicon photodiode with color correction filter"), ("Sampling Rate", "2.0 times per second")],
        "material": "Compact ABS housing", "weight": "160 g", "featured": 0
    },
    {
        "name": "AJR NDT: LX1020BS Digital Lux Meter",
        "slug": "ajr-ndt-digital-lux-meter",
        "sku": "AJR-LX-1020BS",
        "cat": "photometers-radiometers",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/7d8415fb8514524f45f24f47295eda87.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-digital-lux-meter.html",
        "short": "Precision digital lux meter with coiled probe cord and wide 100,000 Lux range.",
        "desc": "Features a remote tethered photodiode sensor on a flexible coiled cable for measuring illuminance on awkwardly oriented weld surfaces and within dark inspection chambers.",
        "specs": [("Range", "0.1 - 100,000 Lux"), ("Accuracy", "+/- 3%"), ("Functions", "Data hold, auto zeroing"), ("Display", "Large 3 1/2 digit LCD")],
        "material": "ABS casing with protective holster", "weight": "210 g", "featured": 0
    },
    {
        "name": "AJR NDT: LX1330B Digital Lux Meter",
        "slug": "ajr-ndt--lux-meter",
        "sku": "AJR-LX-1330B",
        "cat": "photometers-radiometers",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/3f27b6d6f005e59e1d01d962bbb46a5a.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt--lux-meter.html",
        "short": "High-accuracy lux/foot-candle meter with 200,000 Lux range and peak value memory.",
        "desc": "Professional grade illuminometer measuring in both Lux and Foot-Candles (fc) with peak value detection, relative mode, and cosine angular correction.",
        "specs": [("Range", "0.1 - 200,000 Lux / 0.01 - 20,000 fc"), ("Accuracy", "+/- 3% rdg"), ("Peak Hold", "Captures transient lighting pulses"), ("Standards", "CIE photopic curve compliant")],
        "material": "Heavy duty casing", "weight": "250 g", "featured": 0
    },
    {
        "name": "AJR NDT: UVA365 UV A Radiometer / Light Meter",
        "slug": "ajr-ndt-uva365-uv-a-radiometer-light-meter",
        "sku": "AJR-UVA-365",
        "cat": "photometers-radiometers",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240109/3433fae0c9afcc5c4b74fc65fdbc661d.jpg",
        "url": "https://www.ajrndt.com/products/ajr-ndt-uva365-uv-a-radiometer-light-meter.html",
        "short": "Calibrated UV-A radiometer for measuring 365 nm black light intensity per ASTM E3022.",
        "desc": "The UVA365 is a specialized ultraviolet radiometer calibrated specifically for 365 nm UV-A black light inspection sources used in FPI and MPI per ISO 3059 and ASTM E3022.",
        "specs": [("Spectral Sensitivity", "320 - 400 nm (Peak 365 nm)"), ("Irradiance Range", "0 - 19,990 uW/cm2 (0 - 199.9 W/m2)"), ("Accuracy", "+/- 4% (+/- 1 digit)"), ("Calibration", "NIST-traceable factory calibration certificate")],
        "material": "Shielded sensor head with precision console", "weight": "320 g", "featured": 1
    },

    # 12. Calibration Blocks & Reference Standards
    {
        "name": "IIW Type 1 (V1) UT Test Block",
        "slug": "v1-ut-block",
        "sku": "AJR-BLK-V1",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240114/0f66f3522b8d64457cd37e7387080bd0.jpg",
        "url": "https://www.ajrndt.com/products/v1-ut-block.html",
        "short": "Standard EN ISO 2400 / ASTM E164 calibration block for ultrasonic shear and normal beam probes.",
        "desc": "The IIW Type 1 (V1) Calibration Block is used for calibrating ultrasonic flaw detectors for shear and longitudinal wave testing: time base calibration, probe index, beam angle, and sensitivity.",
        "specs": [("Standards", "EN ISO 2400, ASTM E164, BS 2704"), ("Material Options", "1018 Carbon Steel, 304/316 Stainless Steel, 7075 Aluminum"), ("Radii", "R100 mm and R25 mm reference arcs"), ("Holes", "1.5 mm diameter transverse hole and plastic insert")],
        "material": "1018 Steel (Nickel-plated or oil protected)", "weight": "5.2 kg", "featured": 1
    },
    {
        "name": "V2 UT Test Block",
        "slug": "v2-ut-block",
        "sku": "AJR-BLK-V2",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240114/ad002a7ee28f956bedf1288acd2aaebd.jpg",
        "url": "https://www.ajrndt.com/products/v2-ut-block.html",
        "short": "Compact DIN 54122 / ISO 7963 miniature calibration block for on-site angle beam checks.",
        "desc": "The V2 block is a lightweight, pocket-sized reference block for field calibration of ultrasonic angle beam probes: index point, sound path, and angle verification.",
        "specs": [("Standards", "DIN 54122, ISO 7963, BS 2704 A4"), ("Thickness", "12.5 mm or 20 mm options"), ("Radii", "R25 mm and R50 mm cylindrical surfaces"), ("Calibration Target", "5.0 mm through hole")],
        "material": "1018 Carbon Steel / 316 Stainless", "weight": "0.5 kg", "featured": 0
    },
    {
        "name": "Ultrasonic Thickness Step Block",
        "slug": "thickness-step-block",
        "sku": "AJR-BLK-STP",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240115/3ae47f72e755478ab92ecea326bce92b.jpg",
        "url": "https://www.ajrndt.com/products/thickness-step-block.html",
        "short": "4-step / 5-step precision thickness calibration block for ultrasonic thickness gauges.",
        "desc": "Precision machined step wedge blocks for linearity and zero calibration of ultrasonic thickness gauges and flaw detectors.",
        "specs": [("Step Configurations", "4-step (2.5, 5.0, 7.5, 10.0 mm) or 5-step (2.5, 5, 10, 15, 20 mm)"), ("Tolerance", "+/- 0.02 mm on all steps"), ("Materials", "1018 Steel, 316L Stainless, 6061-T6 Aluminum, Brass"), ("Case", "Hardwood storage case included")],
        "material": "Precision ground steel / stainless", "weight": "0.6 kg", "featured": 0
    },
    {
        "name": "Pipe Step Block",
        "slug": "pipe-step-block",
        "sku": "AJR-BLK-PIP",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240116/f1397607a652bae3a75c3050115a91bb.jpg",
        "url": "https://www.ajrndt.com/products/pipe-step-block.html",
        "short": "Curved step block for calibration of curved pipe wall thickness measurements.",
        "desc": "Machined with specific outer radii to match pipe diameters, eliminating couplant layer errors when calibrating ultrasonic gauges on convex pipe surfaces.",
        "specs": [("Curvature", "Radiused to pipe OD specifications"), ("Steps", "4 steps or 5 steps custom stepped"), ("Tolerance", "+/- 0.02 mm"), ("Certificate", "Individual dimensional calibration report")],
        "material": "Carbon Steel / Stainless Steel", "weight": "0.8 kg", "featured": 0
    },
    {
        "name": "ASME 19 & 38 Test Block",
        "slug": "asme-block",
        "sku": "AJR-BLK-ASME",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/bf48f13dd0c7b436b8d56da56ff41898.jpg",
        "url": "https://www.ajrndt.com/products/asme-block.html",
        "short": "ASME Section V Article 4 basic calibration blocks (19mm & 38mm) for weld inspection.",
        "desc": "Manufactured strictly in accordance with ASME Section V Article 4 Section T-434.2.1, featuring side-drilled holes (SDH) and EDM surface notches at 1/4T, 1/2T, and 3/4T.",
        "specs": [("Standard", "ASME Section V Article 4"), ("Thickness", "19 mm (3/4 in) and 38 mm (1.5 in)"), ("Notches", "2% depth EDM notches (ID & OD)"), ("Side Drilled Holes", "Calibrated diameter SDH targets")],
        "material": "SA-516 Grade 70 / SA-106 / Stainless", "weight": "4.5 kg", "featured": 1
    },
    {
        "name": "IIW Type 2 Block",
        "slug": "iiw-type-2-block",
        "sku": "AJR-BLK-V2-IIW",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/654968ad09f91ba971e95270f03728f3.jpg",
        "url": "https://www.ajrndt.com/products/iiw-type-2-block.html",
        "short": "Modified IIW calibration block with 50mm radius arc and calibration side notches.",
        "desc": "Modified IIW Type 2 design for ultrasonic testing, providing additional angle beam calibration targets and notch reflections.",
        "specs": [("Standard", "ASTM E164, ISO 2400"), ("Geometry", "Modified cut-out with multiple reflection radii"), ("Material", "1018 Steel, Nickel plated"), ("Dimensions", "300 x 100 x 25 mm")],
        "material": "1018 Carbon Steel", "weight": "5.5 kg", "featured": 0
    },
    {
        "name": "Mini IIW 2 Block",
        "slug": "mini-iiw-block",
        "sku": "AJR-BLK-MIIW",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/7947338d897d3ab17919de7215a09fb2.jpg",
        "url": "https://www.ajrndt.com/products/mini-iiw-block.html",
        "short": "Pocket-sized mini IIW type 2 reference block for climbing and pipeline inspectors.",
        "desc": "Convenient compact version of the IIW Type 2 standard block, weighing under 1 kg for easy carriage during rope access or climbing structural inspections.",
        "specs": [("Standard", "USAF Design / ASTM E164 equivalent"), ("Dimensions", "150 x 50 x 25 mm"), ("Weight", "0.9 kg"), ("Engraving", "Laser marked beam angle and index scales")],
        "material": "1018 Steel", "weight": "0.9 kg", "featured": 0
    },
    {
        "name": "DSC UT Test Block",
        "slug": "dsc-ut-test-block",
        "sku": "AJR-BLK-DSC",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240116/5ff0e0f6cacc4818f340e2d2f9795633.jpg",
        "url": "https://www.ajrndt.com/products/dsc-ut-test-block.html",
        "short": "Distance and Sensitivity Calibration (DSC) block for AWS D1.1 structural welding code.",
        "desc": "The DSC block is specifically used for distance and sensitivity calibration of shear wave transducers in accordance with AWS D1.1 and ASTM E164.",
        "specs": [("Standard", "AWS D1.1 / ASTM E164"), ("Radii", "1.0 in and 3.0 in radius reflection arcs"), ("Targets", "0.375 in deep x 0.032 in wide slot and 0.125 in through hole"), ("Thickness", "1.0 in (25.4 mm)")],
        "material": "1018 Carbon Steel / Stainless 304", "weight": "1.2 kg", "featured": 0
    },
    {
        "name": "SC UT Block",
        "slug": "sc-ut-block",
        "sku": "AJR-BLK-SC",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240116/ed5b19a4511dd97dd478ca1fc69464b5.jpg",
        "url": "https://www.ajrndt.com/products/sc-ut-block.html",
        "short": "Sensitivity Calibration block for angle beam transducers per AWS D1.1.",
        "desc": "The SC Block is utilized for sensitivity calibration of angle beam search units per AWS structural welding code requirements.",
        "specs": [("Standard", "AWS D1.1 / ASTM E164"), ("Target Holes", "Two 0.0625 in (1.59 mm) diameter through-holes"), ("Dimensions", "2.0 x 1.25 x 0.905 in"), ("Engraving", "Sound path graduation markings")],
        "material": "1018 Steel", "weight": "0.4 kg", "featured": 0
    },
    {
        "name": "AWS DS Block",
        "slug": "ds-block",
        "sku": "AJR-BLK-AWS-DS",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240116/9964f1904c2576447743d597438f0ab6.jpg",
        "url": "https://www.ajrndt.com/products/ds-block.html",
        "short": "Distance and Sensitivity reference standard block for AWS D1.1 longitudinal and shear wave.",
        "desc": "The AWS DS Block contains two 0.0625 in side-drilled holes at 3/8 in and 3/4 in depth for horizontal linearity and sensitivity calibration.",
        "specs": [("Standard", "AWS D1.1 Figure 6.22"), ("Targets", "Two 1/16 in diameter holes"), ("Size", "2.0 x 2.0 x 6.0 in"), ("Markings", "AWS reference depth indices")],
        "material": "1018 Carbon Steel", "weight": "3.1 kg", "featured": 0
    },
    {
        "name": "RC Test Block",
        "slug": "rc-block",
        "sku": "AJR-BLK-RC",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/d55cd5fd7cd4ee0c8d06443960542e5d.jpg",
        "url": "https://www.ajrndt.com/products/rc-block.html",
        "short": "Resolution Calibration block for evaluating resolution of angle beam transducers.",
        "desc": "The RC (Resolution Calibration) Block is used for testing the resolving power of ultrasonic angle beam transducers in compliance with AWS D1.1 Table 6.1.",
        "specs": [("Standard", "AWS D1.1 Clause 6"), ("Targets", "Sets of closely spaced 0.0625 in diameter holes for 45, 60, and 70 deg probes"), ("Dimensions", "6.0 x 3.0 x 1.0 in")],
        "material": "1018 Steel", "weight": "2.2 kg", "featured": 0
    },
    {
        "name": "DC UT Test block",
        "slug": "dc-block",
        "sku": "AJR-BLK-DC",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240116/2cd1a1bc36ffedd5331765726241c5bb.jpg",
        "url": "https://www.ajrndt.com/products/dc-block.html",
        "short": "Distance Calibration block for AWS D1.1 shear-wave instrument time base setting.",
        "desc": "The DC (Distance Calibration) block features a curved 1.0 inch radius surface and cylindrical bore for fast time base calibration.",
        "specs": [("Standard", "AWS D1.1 / ASTM E164"), ("Reflector", "1.0 in and 2.0 in radius cylindrical targets"), ("Dimensions", "2.0 in diameter curved wedge")],
        "material": "1018 Carbon Steel", "weight": "0.7 kg", "featured": 0
    },
    {
        "name": "IOW UT Block",
        "slug": "iow-block",
        "sku": "AJR-BLK-IOW",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/440c4a019b0c9951c34573da4ec796a2.jpg",
        "url": "https://www.ajrndt.com/products/iow-block.html",
        "short": "Institute of Welding beam index and angle verification calibration block.",
        "desc": "Standard British Institute of Welding (IOW) beam profile reference block containing calibrated 1.5 mm diameter holes at varying depths for beam spread evaluation.",
        "specs": [("Standard", "BS 2704 / Institute of Welding"), ("Targets", "Series of 1.5 mm holes at depths from 2 to 24 mm"), ("Dimensions", "305 x 75 x 50 mm")],
        "material": "Normalized carbon steel", "weight": "6.0 kg", "featured": 0
    },
    {
        "name": "V3 Test Block",
        "slug": "v3-block",
        "sku": "AJR-BLK-V3",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/84b25bd62aa5bc56a50966cf4de92ae7.jpg",
        "url": "https://www.ajrndt.com/products/v3-block.html",
        "short": "Quick-check miniature angle probe calibration block.",
        "desc": "The V3 block provides quick index point and timebase check for ultrasonic angle probes in tight quarters.",
        "specs": [("Reflector", "R25 mm and R100 mm radius segments"), ("Thickness", "25 mm"), ("Dimensions", "100 x 50 x 25 mm")],
        "material": "1018 Steel", "weight": "0.8 kg", "featured": 0
    },
    {
        "name": "Phased Array Block Type A",
        "slug": "pa-block",
        "sku": "AJR-BLK-PA-A",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/d81823f2446589fea5713a567961e102.jpg",
        "url": "https://www.ajrndt.com/products/pa-block.html",
        "short": "Standard phased array reference block for angle beam verification and TCG calibration.",
        "desc": "Used during phased array ultrasonic testing (PAUT) for beam steering verification, time-corrected gain (TCG) calibration, and multi-angle velocity measurement.",
        "specs": [("Standard", "ASTM E2491, ISO 19675"), ("Targets", "Array of side-drilled holes at constant angular or depth increments"), ("Radii", "50 mm and 100 mm radius arcs"), ("Dimensions", "250 x 100 x 25 mm")],
        "material": "1018 Steel / 316L Stainless / Aluminum", "weight": "3.5 kg", "featured": 1
    },
    {
        "name": "PA Type B block",
        "slug": "phased-array-block",
        "sku": "AJR-BLK-PA-B",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/c322bea5743b932a0d43df317793e783.jpg",
        "url": "https://www.ajrndt.com/products/phased-array-block.html",
        "short": "Phased array sensitivity and depth calibration standard block.",
        "desc": "Features multiple horizontal rows of side-drilled holes for evaluating phased array sensitivity, electronic sectorial scan focal laws, and beam exit points.",
        "specs": [("Standard", "ASTM E2491"), ("Reflectors", "Side drilled holes at depths of 5, 10, 15, 20, 25, 30, 35, 40 mm"), ("Thickness", "25 mm or 38 mm")],
        "material": "1018 Carbon Steel", "weight": "3.8 kg", "featured": 0
    },
    {
        "name": "PAUT IIW Block",
        "slug": "paut-iiw-block",
        "sku": "AJR-BLK-PAUT-IIW",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/01e3dca2b9ed238929912d56b03f13a3.jpg",
        "url": "https://www.ajrndt.com/products/paut-iiw-block.html",
        "short": "Phased Array Ultrasonic Testing block tailored with dedicated PAUT targets.",
        "desc": "Combines classic IIW Type 1 geometry with micro-SDH phased array calibration targets for combined conventional and phased array calibration.",
        "specs": [("Standard", "ISO 19675 / EN ISO 2400"), ("Targets", "R100 arc, R25 arc, SDH arrays, flat bottom holes"), ("Dimensions", "300 x 100 x 25 mm")],
        "material": "Fine-grain normalized steel", "weight": "5.4 kg", "featured": 0
    },
    {
        "name": "PACS UT Test Block",
        "slug": "pacs-ut-test-block",
        "sku": "AJR-BLK-PACS",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/688323999f6042fcf470a11304adc32a.jpg",
        "url": "https://www.ajrndt.com/products/pacs-ut-test-block.html",
        "short": "Phased Array & Conventional Shear-wave reference block.",
        "desc": "PACS block is designed for sensitivity calibration and angle verification of both phased array and conventional ultrasonic shear wave probes.",
        "specs": [("Targets", "Four 3/64 in SDH targets at 0.200, 0.400, 0.600, 0.800 in depth"), ("Standard", "AWS / ASME Section V"), ("Dimensions", "18.0 x 1.0 x 1.0 in")],
        "material": "1018 Steel", "weight": "2.1 kg", "featured": 0
    },
    {
        "name": "K1 Calibration Block",
        "slug": "k1-ultrasonic-block",
        "sku": "AJR-BLK-K1",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/e8451aaf57f1913259673711a648b0fc.jpg",
        "url": "https://www.ajrndt.com/products/k1-ultrasonic-block.html",
        "short": "European standard DIN EN ISO 2400 K1 ultrasonic calibration test block.",
        "desc": "Standard European K1 block used extensively throughout continental Europe for calibrating ultrasonic testing systems prior to weld examination.",
        "specs": [("Standard", "DIN EN ISO 2400"), ("Reflectors", "R100 mm arc, 1.5 mm and 50 mm hole targets"), ("Dimensions", "300 x 100 x 25 mm")],
        "material": "1018 Steel with protective wood box", "weight": "5.0 kg", "featured": 0
    },
    {
        "name": "K2 Test Block",
        "slug": "k2-test-block",
        "sku": "AJR-BLK-K2",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/b115e7263bed7e9adc3416181c00e215.jpg",
        "url": "https://www.ajrndt.com/products/k2-test-block.html",
        "short": "European standard DIN EN ISO 7963 K2 miniature calibration test block.",
        "desc": "Compact DIN EN ISO 7963 (formerly DIN 54122) K2 test block for angle probe angle and sound path verification on the construction site.",
        "specs": [("Standard", "DIN EN ISO 7963"), ("Thickness", "12.5 mm"), ("Reflectors", "R25 mm and R50 mm cylindrical segments"), ("Dimensions", "75 x 43 x 12.5 mm")],
        "material": "1018 Steel", "weight": "0.45 kg", "featured": 0
    },
    {
        "name": "Navyships Block",
        "slug": "navyships-block",
        "sku": "AJR-BLK-NAVY",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/a629d44660cf2402c92a1151c1736a14.jpg",
        "url": "https://www.ajrndt.com/products/navyships-block.html",
        "short": "US Naval specification reference block for ultrasonic distance and sensitivity calibration.",
        "desc": "Constructed per US Navy specifications (NAVSEA T9074-AS-GIB-010/271) for angle beam and longitudinal beam ultrasonic testing on military vessels.",
        "specs": [("Standard", "NAVSEA T9074-AS-GIB-010/271, MIL-STD-271F"), ("Targets", "Six 3/64 in diameter side-drilled holes at precise increments"), ("Dimensions", "12.0 x 1.25 x 1.0 in")],
        "material": "Certified Navy grade steel", "weight": "2.4 kg", "featured": 0
    },
    {
        "name": "API RP 2X Reference Standard Block",
        "slug": "api-rp-2x-block",
        "sku": "AJR-BLK-API-2X",
        "cat": "calibration-blocks",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240119/a7f7249a70642818ad2b7fcb19fc027c.jpg",
        "url": "https://www.ajrndt.com/products/api-rp-2x-block.html",
        "short": "API RP 2X reference standard block for offshore tubular structural weld inspection.",
        "desc": "Manufactured to API Recommended Practice 2X (RP 2X) for ultrasonic examination of offshore platform tubular structures, nodal joints, and member welds.",
        "specs": [("Standard", "API RP 2X"), ("Targets", "EDM square, V-notch, and SDH reflectors in curved geometry"), ("Application", "Offshore jacket and tubular node welding")],
        "material": "Offshore grade structural steel (A36 / 50D)", "weight": "4.2 kg", "featured": 0
    },

    # 13. Ultrasonic Probes, Transducers & Cables
    {
        "name": "Straight Probe",
        "slug": "straight-probe",
        "sku": "AJR-PRB-STR",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/678898952cb2947c11c50f0697eb6ce9.jpg",
        "url": "https://www.ajrndt.com/products/straight-probe.html",
        "short": "Single element longitudinal wave normal beam ultrasonic transducer (1 - 5 MHz).",
        "desc": "High-damped single crystal straight beam transducer for general flaw detection, delamination checks, and thickness testing of plates, bars, and forgings.",
        "specs": [("Crystal Frequencies", "1 MHz, 2 MHz, 2.5 MHz, 4 MHz, 5 MHz"), ("Crystal Diameters", "10 mm, 14 mm, 20 mm, 24 mm"), ("Connector", "LEMO 00 or BNC side/top mount"), ("Wear Face", "Alumina ceramic protective face plate")],
        "material": "Stainless steel casing with ceramic face", "weight": "120 g", "featured": 1
    },
    {
        "name": "Angle Probe",
        "slug": "angle-probe",
        "sku": "AJR-PRB-ANG",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/e8b170f48c0f20e06a32a3db9f4e5cfa.jpg",
        "url": "https://www.ajrndt.com/products/angle-probe.html",
        "short": "Shear wave angle beam probe (45, 60, 70 degrees) for weld and crack inspection.",
        "desc": "Single crystal shear wave angle beam probes designed for precise weld flaw detection, sizing, and root crack identification per AWS, ASME, and EN standards.",
        "specs": [("Refracted Angles", "45 deg, 60 deg, 70 deg (in steel)"), ("Frequencies", "2 MHz, 4 MHz, 5 MHz"), ("Crystal Dimensions", "8x9 mm, 9x9 mm, 13x13 mm, 20x22 mm"), ("Connector", "LEMO 00 / Subvis")],
        "material": "High-durability Rexolite wedge with stainless housing", "weight": "90 g", "featured": 1
    },
    {
        "name": "Dual Straight Probe",
        "slug": "dual-straight-probe",
        "sku": "AJR-PRB-DUAL-STR",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/83ac6c1affb356554c121b81aab8394c.jpg",
        "url": "https://www.ajrndt.com/products/dual-straight-probe.html",
        "short": "TR (Transmit-Receive) dual element normal beam probe for near-surface flaw resolution.",
        "desc": "Twin crystal probe featuring acoustically isolated transmitter and receiver elements tilted toward each other, providing superior near-surface defect resolution and thin wall capability.",
        "specs": [("Element Type", "Dual Crystal TR / Pitch-Catch"), ("Frequencies", "2 MHz, 4 MHz, 5 MHz"), ("Near Surface Resolution", "< 1.5 mm"), ("Connectors", "Dual LEMO 00 or Microdot")],
        "material": "Stainless steel body with acoustic isolation barrier", "weight": "130 g", "featured": 0
    },
    {
        "name": "Dual Angle Probe",
        "slug": "dual-angle-probe",
        "sku": "AJR-PRB-DUAL-ANG",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240110/9ecab92afbd6a73ef06d25c8105bb94a.jpg",
        "url": "https://www.ajrndt.com/products/dual-angle-probe.html",
        "short": "Twin crystal shear wave angle beam transducer for thin wall pipe and austenitic welds.",
        "desc": "Dual element shear wave probe designed to eliminate interface ringdown and reduce acoustic noise in coarse-grain austenitic stainless steels and thin piping welds.",
        "specs": [("Angles", "45 deg, 60 deg, 70 deg"), ("Frequencies", "2 MHz, 4 MHz"), ("Focal Zone", "Custom focus depth 5 - 25 mm"), ("Connector", "Dual LEMO 00")],
        "material": "Rexolite wedge in stainless body", "weight": "110 g", "featured": 0
    },
    {
        "name": "Ultrasound Snail Transducer and Wedge",
        "slug": "ultrasound-snail-transducer-and-wedge",
        "sku": "AJR-PRB-SNAIL",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240129/451cbd2c6dd933ff6b3e9a95b7b9d5ee.jpg",
        "url": "https://www.ajrndt.com/products/ultrasound-snail-transducer-and-wedge.html",
        "short": "Low-profile snail TOFD / Phased Array transducer with contoured irrigation wedge.",
        "desc": "Low-profile 'snail' shape transducer and couplant-irrigated wedge for Time of Flight Diffraction (TOFD) and phased array weld inspection in restricted clearance areas.",
        "specs": [("Design", "Low profile snail configuration (<20 mm height)"), ("Irrigation", "Built-in water couplant ports"), ("Frequencies", "5 MHz, 7.5 MHz, 10 MHz"), ("Application", "TOFD and restricted pipe clearance scans")],
        "material": "Brass / Stainless body with low-wear Rexolite wedge", "weight": "95 g", "featured": 0
    },
    {
        "name": "Replaceable Ultrasonic Probe",
        "slug": "replaceable-ultrasonic-probe",
        "sku": "AJR-PRB-REPL",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240129/b1ce83fb2e31b8c0c6cf849bd20a4802.jpg",
        "url": "https://www.ajrndt.com/products/replaceable-ultrasonic-probe.html",
        "short": "Transducer with screw-on replaceable delay lines and protective contact membranes.",
        "desc": "Features threaded replaceable delay lines and flexible protective membranes to prolong crystal life when inspecting rough, abrasive cast or scale-covered surfaces.",
        "specs": [("Membranes", "Screw-on elastomer protective face / High temp delay line"), ("Frequencies", "2 MHz, 4 MHz, 5 MHz"), ("Connector", "LEMO 00 top mount"), ("Cost Savings", "Quick wear-face replacement without buying new transducer")],
        "material": "Threaded knurled brass / stainless steel", "weight": "115 g", "featured": 0
    },
    {
        "name": "NDT Ultrasonic Cable",
        "slug": "ultrasonic-cable",
        "sku": "AJR-CBL-NDT",
        "cat": "ultrasonic-probes-cables",
        "img": "https://image.chukouplus.com/upload/C_3791/file/20240112/69db05dfe0adcf1bfdc927ec74658c1b.jpg",
        "url": "https://www.ajrndt.com/products/ultrasonic-cable.html",
        "short": "RG-174 low-noise high-flex RF coaxial cables with BNC, LEMO 00, and LEMO 01 connectors.",
        "desc": "Industrial low-noise 50-ohm RF coaxial cables for ultrasonic and eddy current flaw detection. Reinforced with strain relief boots and flexible oil-resistant jackets.",
        "specs": [("Impedance", "50 Ohm RG-174 / RG-58"), ("Connector Options", "BNC to LEMO 00, BNC to LEMO 01, LEMO 00 to LEMO 00, Microdot"), ("Length", "1.5 m, 2.0 m standard (custom lengths available)"), ("Jacket", "High-flex oil and abrasion resistant polyurethane")],
        "material": "Gold-plated center pins, nickel-plated brass connectors", "weight": "85 g", "featured": 0
    }
]

print(f"Loaded {len(products)} products across {len(categories)} categories.")
assert len(products) == 93, f"Expected 93 products, found {len(products)}"

# -------------------------------------------------------------
# Generate docs/AJR_NDT_PRODUCT_CATALOG.md
# -------------------------------------------------------------
md_content = """# AJR NDT CO LIMITED — Comprehensive Product Catalog & Technical Reference

This document provides a comprehensive technical catalog of **all 93 Non-Destructive Testing (NDT) products** from the official AJR NDT catalog ([ajrndt.com](https://www.ajrndt.com/products.html)). 

Each product listing includes its exact model name, SKU, primary technology classification, technical specifications, dimensional attributes, target industrial applications, and direct manufacturer links.

---

## Table of Contents

1. [Ultrasonic Flaw Detection (UT)](#1-ultrasonic-flaw-detection)
2. [Thickness & Coating Gauges](#2-thickness--coating-gauges)
3. [Hardness Testers (Leeb & UCI)](#3-hardness-testers)
4. [Surface Roughness & Profile Testers](#4-surface-roughness--profile-testers)
5. [Magnetic Particle Inspection (MPI)](#5-magnetic-particle-inspection)
6. [Radiography Testing (RT) & Pipeline Crawlers](#6-radiography-testing--pipeline-crawlers)
7. [Eddy Current Testing (ECT)](#7-eddy-current-testing)
8. [Visual Inspection & Videoscopes (RVI)](#8-visual-inspection--videoscopes)
9. [NDT UV LED Lamps & Black Lights](#9-ndt-uv-led-lamps--black-lights)
10. [Holiday Detectors & Wire Rope Testers](#10-holiday-detectors--wire-rope-testers)
11. [Photometers & UV-A Radiometers](#11-photometers--radiometers)
12. [NDT Calibration Blocks & Reference Standards](#12-calibration-blocks--reference-standards)
13. [Ultrasonic Probes, Transducers & Cables](#13-ultrasonic-probes-transducers--cables)

---
"""

cat_num = 1
for cat in categories:
    cat_prods = [p for p in products if p["cat"] == cat["slug"]]
    md_content += f"\n## {cat_num}. {cat['name']}\n\n"
    md_content += f"> **Overview:** {cat['description']}\n\n"
    md_content += "| Photo | Product Name | Model / SKU | Key Specifications | Direct URL |\n"
    md_content += "| :---: | :--- | :--- | :--- | :--- |\n"
    
    for p in cat_prods:
        spec_summary = "<br>".join([f"**{k}:** {v}" for k, v in p["specs"][:3]])
        md_content += f"| ![{p['name']}]({p['img']}) | **{p['name']}**<br><small>{p['short']}</small> | `{p['sku']}` | {spec_summary} | [View Page]({p['url']}) |\n"
    
    md_content += "\n### Detailed Specifications\n\n"
    for p in cat_prods:
        md_content += f"#### {p['name']} (`{p['sku']}`)\n\n"
        md_content += f"- **Product URL:** [{p['url']}]({p['url']})\n"
        md_content += f"- **Primary Category:** {cat['name']}\n"
        md_content += f"- **Description:** {p['desc']}\n"
        md_content += f"- **Housing / Material:** {p.get('material', 'Industrial standard')}\n"
        md_content += f"- **Weight:** {p.get('weight', 'N/A')}\n"
        md_content += "- **Technical Specifications:**\n"
        for k, v in p["specs"]:
            md_content += f"  - **{k}:** {v}\n"
        md_content += "\n---\n"
    cat_num += 1

with open("docs/AJR_NDT_PRODUCT_CATALOG.md", "w", encoding="utf-8") as f:
    f.write(md_content)
print("Successfully generated docs/AJR_NDT_PRODUCT_CATALOG.md")

# -------------------------------------------------------------
# Generate database/ajr_ndt_products.sql
# -------------------------------------------------------------
sql_lines = [
    "-- =============================================================================",
    "-- AJR NDT PRODUCTS SEED SCRIPT",
    "-- Imports all 13 Categories, 93 Products, Images & Specifications",
    "-- Compatible with Vortex Precision IT schema (MySQL 5.7+ / 8.0+ / MariaDB 10.3+)",
    "-- =============================================================================",
    "SET FOREIGN_KEY_CHECKS=0;",
    "",
    "-- 1. INSERT CATEGORIES",
    "INSERT INTO `categories` (`id`,`name`,`slug`,`description`,`icon`,`sortOrder`,`isActive`,`metaTitle`,`metaDescription`) VALUES"
]

def esc(s):
    return str(s).replace("'", "\\'").replace(";", ",")

cat_sql_parts = []
for c in categories:
    c_name = esc(c['name'])
    c_desc = esc(c['description'])
    c_title = esc(c['metaTitle'])
    c_mdesc = esc(c['metaDescription'])
    cat_sql_parts.append(
        f"('{c['id']}', '{c_name}', '{c['slug']}', '{c_desc}', '{c['icon']}', {c['sortOrder']}, 1, '{c_title}', '{c_mdesc}')"
    )
sql_lines.append(",\n".join(cat_sql_parts))
sql_lines.append("ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`), `icon`=VALUES(`icon`);\n")

sql_lines.append("-- 2. INSERT PRODUCTS")
sql_lines.append(
    "INSERT INTO `products` ("
    "`id`,`name`,`slug`,`sku`,`description`,`shortDescription`,`categoryId`,"
    "`material`,`dimensions`,`weight`,`certifications`,`availability`,`featured`,`isActive`,`views`,`metaTitle`"
    ") VALUES"
)

prod_sql_parts = []
prod_uuids = {}
for idx, p in enumerate(products, 1):
    pid = f"p0010001-0000-4000-8000-{idx:012d}"
    prod_uuids[p["slug"]] = pid
    cat_id = cat_map[p["cat"]]["id"]
    certs = esc(json.dumps(["ISO 9001", "CE", "ASTM", "EN"]))
    p_name = esc(p['name'])
    p_slug = p['slug']
    p_sku = p['sku']
    p_desc = esc(p['desc'])
    p_short = esc(p['short'])
    p_mat = esc(p.get('material', ''))
    p_dim = esc(p.get('dimensions', 'N/A'))
    p_wt = esc(p.get('weight', 'N/A'))
    p_feat = p.get('featured', 0)
    meta_title = esc(f"{p['name']} | AJR NDT")
    
    prod_sql_parts.append(
        f"('{pid}', '{p_name}', '{p_slug}', '{p_sku}', '{p_desc}', '{p_short}', "
        f"'{cat_id}', '{p_mat}', '{p_dim}', '{p_wt}', '{certs}', 'IN_STOCK', {p_feat}, 1, 150, '{meta_title}')"
    )

sql_lines.append(",\n".join(prod_sql_parts))
sql_lines.append("ON DUPLICATE KEY UPDATE `name`=VALUES(`name`), `description`=VALUES(`description`), `categoryId`=VALUES(`categoryId`);\n")

sql_lines.append("-- 3. INSERT PRODUCT IMAGES")
sql_lines.append("INSERT INTO `product_images` (`id`,`productId`,`url`,`alt`,`isPrimary`,`sortOrder`) VALUES")
img_sql_parts = []
for idx, p in enumerate(products, 1):
    img_id = f"img00001-0000-4000-8000-{idx:012d}"
    pid = prod_uuids[p["slug"]]
    p_img = p['img']
    p_alt = esc(p['name'])
    img_sql_parts.append(f"('{img_id}', '{pid}', '{p_img}', '{p_alt}', 1, 0)")

sql_lines.append(",\n".join(img_sql_parts))
sql_lines.append("ON DUPLICATE KEY UPDATE `url`=VALUES(`url`);\n")

sql_lines.append("-- 4. INSERT SPECIFICATIONS")
sql_lines.append("INSERT INTO `specifications` (`id`,`productId`,`key`,`value`,`sortOrder`) VALUES")
spec_sql_parts = []
spec_count = 1
for p in products:
    pid = prod_uuids[p["slug"]]
    for sort_ord, (k, v) in enumerate(p["specs"], 1):
        s_id = f"spc00001-0000-4000-8000-{spec_count:012d}"
        spec_count += 1
        k_esc = esc(k)
        v_esc = esc(v)
        spec_sql_parts.append(f"('{s_id}', '{pid}', '{k_esc}', '{v_esc}', {sort_ord})")

sql_lines.append(",\n".join(spec_sql_parts))
sql_lines.append("ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);\n")

sql_lines.append("SET FOREIGN_KEY_CHECKS=1;")
sql_lines.append("-- END OF AJR NDT SEED SCRIPT")

with open("database/ajr_ndt_products.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_lines))

print("Successfully generated database/ajr_ndt_products.sql")
