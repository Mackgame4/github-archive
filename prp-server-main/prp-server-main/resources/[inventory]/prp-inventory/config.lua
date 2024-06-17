Config = {}

Config.OpenControl = 289
Config.TrunkOpenControl = 246
Config.HotKeyCooldown = 500
Config.LicensePrice  = 10000
Config.LicensePrices  = 5000


Config.license = {
    vector3(-552.93, -190.58, 38.21 + 0.05)
}

Config.driver = {
    vector3(-552.93, -190.58, 38.21 - 0.05)
}

Config.Shops = {
    ['Ambulance'] = {
        coords = {
            vector3(306.21, -601.61, 43.28), -- Pillbox
            vector3(1828.36, 3674.13, 34.27), -- Sandy PD
        },
        items = {
            { name = "morphine", price = 0, count = 3, grade = 2 },
            { name = "medkit", price = 0, count = 2, grade = 0 },
            { name = "gauze", price = 0, count = 5, grade = 0 },
            { name = "bandage", price = 0, count = 5, grade = 0 },
            { name = "fixkit", price = 0, count = 1, grade = 0 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Medic Supplies',
        job = 'ambulance'

    },
    ['Weapon Shop - Hunter'] = {
        Blip = {
            Id = 141,
            Color = 70,
            Text = 'Hunting Lodge'
        },
        coords = {
            vector3(-674.93, 5836.34, 17.34),
        },
        items = {
            { name = "hunting_license", price = 1000, count = 1, grade = 0 },
            { name = "WEAPON_KNIFE", price = 300, count = 1, grade = 0 },
            { name = "WEAPON_MUSKET", price = 2400, count = 1, grade = 0 },
            { name = "shotgun_ammo", price = 150, count = 2, grade = 0 },

        },
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 0 },
        msg = '[E] - Hunting Lodge',
        job = 'all'
    },
    ['Weapon Shop - Police'] = {
        coords = {
            vector3(1845.736, 3692.612, 34.26), -- Sandy PD
            vector3(-442.57, 6012.57, 31.97), -- PALETO
            vector3(482.53, -995.16, 30.69), -- MRPD
        },
        items = {
            -- Ammo
            { name = "WEAPON_COMBATPISTOL", price = 50, count = 1, grade = 0 },
            { name = "WEAPON_CARBINERIFLE", price = 50, count = 1, grade = 4 },
            { name = "WEAPON_STUNGUN", price = 250, count = 1, grade = 0 },
            { name = "WEAPON_FLARE", price = 10, count = 1, grade = 0 },
            { name = "WEAPON_NIGHTSTICK", price = 0, count = 1, grade = 0 },
            { name = "WEAPON_FLASHLIGHT", price = 250, count = 1, grade = 0 },
            { name = "WEAPON_PUMPSHOTGUN", price = 0, count = 1, grade = 2 },

            { name = "medkit", price = 0, count = 2, grade = 0 },
            { name = "gauze", price = 0, count = 5, grade = 0 },
            { name = "bandage", price = 0, count = 5, grade = 0 },
            { name = "morphine", price = 0, count = 3, grade = 6 },
            { name = "fixkit", price = 400, count = 1, grade = 0 },

            { name = "small_armor", price = 250, count = 1, grade = 0 },
            { name = "large_armor", price = 350, count = 1, grade = 0 },            
            { name = "pistol_ammo", price = 10, count = 1, grade = 0 },
            { name = "sub_ammo", price = 10, count = 1, grade = 0 },
            { name = "rifle_ammo", price = 10, count = 1, grade = 0 },
            { name = "shotgun_ammo", price = 10, count = 2, grade = 0 },

            { name = "pdbadge", price = 10, count = 1, grade = 0 },
        },
        markerType = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Police shop',
        job = 'police'
    },
    ['Tool Store'] = {
        Blip = {
            Id = 402,
            Color = 49,
            Text = 'Tool Store'
        },
        coords = {
            vector3(343.17, -1298.06, 32.50),
            vector3(-3153.85, 1053.55, 20.88),
            vector3(2747.64, 3472.90, 55.67),
            vector3(-10.91, 6499.37, 31.50),
        },
        items = {
            { name = "scanner", price = 5500, count = 1 },
            { name = "fishingrod", price = 200, count = 1 },
            { name = "fishbait", price = 5, count = 5 },
            { name = "binoculars", price = 300, count = 1 },
            { name = "cuffs", price = 10000, count = 1 },
            { name = "cuffkeys", price = 10000, count = 1 },
            { name = "car_wash", price = 200, count = 1 },
            { name = "hatchet_lj", price = 250, count = 1 },
            { name = "screwdriver", price = 500, count = 1 },
            { name = "bobbypin", price = 10, count = 1 },
            { name = "notepad", price = 100, count = 1 },
            { name = "radio", price = 1000, count = 1 },
            { name = "sandnbucket", price = 100, count = 1 },
            { name = "scuba_tank", price = 100, count = 1 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Tool Store',
        job = 'all'
    },
    ['Prison Shop'] = {
        coords = {
            vector3(1760.18, 2480.39, 45.58),
        },
        items = {
            { name = "prison_food", price = 15, count = 1},
            { name = "slushy", price = 6, count = 5 },
            { name = "cola", price = 5, count = 5 },
            { name = "sprunk", price = 5, count = 5 },
            { name = "cigar", price = 12, count = 1 },
            { name = "redwood_pack", price = 65, count = 1 },
            { name = "cigarette", price = 5, count = 5 },
            { name = "chips", price = 5, count = 5 },
            { name = "bandage", price = 25, count = 1 },
            { name = "cards", price = 125, count = 1 },
            { name = "dice", price = 125, count = 1 },
            { name = "coin", price = 125, count = 1 },
        },
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 0 },
        msg = '[E] - Prison Shop',
        job = 'all'
    },
    ['Porn Shop'] = {
        coords = {
            vector3(-174.57, 230.28, 88.05),
        },
        items = {
            { name = "viagra", price = 500, count = 1 },
            { name = "tissue_box", price = 25, count = 1 },
            { name = "lotion", price = 25, count = 1 },
            { name = "rose", price = 25, count = 1 },
            { name = "teddy_bear", price = 100, count = 1 },
        },
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 0 },
        msg = '[E] - Adult Shop',
        job = 'all'
    },
    ['Movie Theater'] = {
        coords = {
            vector3(337.18, 177.93, 103.09),
            vector3(-483.55, -401.09, 34.54),
        },
        items = {
            { name = "popcorn", price = 30, count = 1 },
            { name = "movie_ticket", price = 13, count = 1 },
            { name = "chips", price = 10, count = 5 },
            { name = "burger", price = 30, count = 5 },
            { name = "slushy", price = 12, count = 5 },
            { name = "hotdog", price = 12, count = 5 },
            { name = "cola", price = 10, count = 5 },
            { name = "sprunk", price = 10, count = 5 },
        },
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 0 },
        msg = '[E] - Movie Theater',
        job = 'all'
    },
    ['TwentyFourSeven'] = {     
        Blip = {
            Id = 52,
            Color = 2,
            Text = 'Convenient Store'
        },
        coords = {
            vector3(373.875, 325.896, 102.766),
            vector3(2557.279, 382.093, 107.822),
            vector3(-3038.939, 585.954, 7.008),
            vector3(-3241.927, 1001.462, 11.930),
            vector3(547.798, 2671.22, 42.356),
            vector3(1961.198, 3740.672, 32.543),
            vector3(2678.916, 3280.671, 55.441),
            vector3(1728.82, 6414.49, 35.237),
            vector3(25.74, -1347.29, 29.49),
            vector3(161.35, 6640.60, 31.71), -- Paleto
        },
        items = {
            { name = "cards", price = 75, count = 1 },
            { name = "phone", price = 400, count = 1 },
            { name = "dice", price = 75, count = 1 },
            { name = "coin", price = 75, count = 1 },
            { name = "bread", price = 5, count = 5 },
            { name = "water", price = 7, count = 5 },
            { name = "pet_food", price = 50, count = 5 },
            { name = "muffin", price = 5, count = 5 },
            { name = "chips", price = 5, count = 5 },
            { name = "sandwich_panini", price = 12, count = 5 },
            { name = "medkit", price = 75, count = 1 },
            { name = "donut", price = 6, count = 5 },
            { name = "energy_bar", price = 12, count = 5 },
            { name = "cola", price = 5, count = 5 },
            { name = "sprunk", price = 5, count = 5 },
            { name = "cigar", price = 12, count = 1 },
            { name = "redwood_pack", price = 65, count = 1 },
            { name = "cigarette", price = 5, count = 5 },
            { name = "gauze", price = 50, count = 1 },
            { name = "bandage", price = 25, count = 1 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Shop',
        job = 'all'
    },
    ['RobsLiquor'] = {
        Blip = {
            Id = 52,
            Color = 7,
            Text = 'Liquor Store'
        },
        coords = {
            vector3(-2967.857, 391.03, 15.243),
            vector3(1165.95, 2709.39, 39.15),
            vector3(1392.562, 3604.684, 35.100),
            vector3(-1222.36, -906.92, 12.32),
            vector3(1135.63, -982.36, 46.15),
        },
        items = {
            { name = "icetea", price = 5, count = 5 },
            { name = "whisky", price = 25, count = 5 },
            { name = "gintonic", price = 15, count = 5 },
            { name = "vodka", price = 10, count = 5 },
            { name = "champagne", price = 40, count = 5 },
            { name = "beer", price = 5, count = 5 },
            { name = "wine_white", price = 20, count = 5 },
            { name = "sake", price = 7, count = 5 },      
            { name = "rum", price = 13, count = 5 },            
            { name = "wine_red", price = 20, count = 5 },    
            { name = "dusche", price = 5, count = 5 },
            { name = "tequila", price = 15, count = 5 },
            { name = "jager", price = 15, count = 5 },
            { name = "cigar", price = 12, count = 1 },
            { name = "redwood_pack", price = 65, count = 1 },
            { name = "cigarette", price = 5, count = 5 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Liquor Store',
        job = 'all'
    },
    ['LTDgasoline'] = {
        coords = {
            vector3(1163.373, -323.801, 69.405), -- Mirror Park
            vector3(-1820.523, 792.518, 138.318),
            vector3(1698.388, 4924.404, 42.263),
            vector3(-707.69, -914.49, 19.24), -- Little Seuol
            vector3(-48.34, -1757.83, 29.42), -- Grove LTD
        },
        items = {
            { name = "water", price = 7, count = 1 },
            { name = "phone", price = 400, count = 1 },
            { name = "pet_food", price = 50, count = 1 },
            { name = "tacos", price = 7, count = 1 },
            { name = "cola", price = 5, count = 1 },
            { name = "sprunk", price = 5, count = 1 },
            { name = "beer", price = 5, count = 1 },
            { name = "dusche", price = 5, count = 1 },
            { name = "burger", price = 12, count = 1 },
            { name = "bread", price = 5, count = 1 },
            { name = "cigar", price = 12, count = 1 },
            { name = "redwood_pack", price = 65, count = 1 },
            { name = "cigarette", price = 5, count = 5 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Gas Station',
        job = 'all'
    },
    ['Bean Machine'] = {
        coords = {
            vector3(-631.88, 228.05, 81.88),
        },
        items = {
            { name = "breakfast_sandwich", price = 15, count = 5 },
            { name = "eggs_and_bacon", price = 10, count = 5 },
            { name = "frappuccino", price = 7, count = 5 },
            { name = "french_toast", price = 12, count = 5 },
            { name = "horchata", price = 9, count = 5 },
            { name = "latte", price = 7, count = 5 },
            { name = "muffin", price = 5, count = 5 },
            { name = "sandwich_panini", price = 12, count = 5 },
            { name = "milkshake", price = 5, count = 5 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Bean Machine',
        job = 'all'
    },
    ['Tacolicious'] = {
        coords = {
            vector3(16.95, -1599.62, 29.37),
        },
        items = {
            { name = "tacos", price = 7, count = 5 },
            { name = "cola", price = 5, count = 5 },
            { name = "sprunk", price = 5, count = 5 },
            { name = "burrito", price = 10, count = 5 },
            { name = "tacos_fish", price = 11, count = 5 },
            { name = "nachos", price = 9, count = 5 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Taco Shop',
        job = 'all'
    },
    ['Bars'] = {
        coords = {
            vector3(129.68, -1284.49, 29.28), -- Vanilla Unicorn
            vector3(-1394.44, -604.04, 30.31), -- Bahama Mammas
            vector3(-560.20, 287.16, 82.17), -- Tequilala
            vector3(1985.83, 3053.81, 47.21), -- Yellow Jack
            vector3(-441.69, 268.00, 83.01), -- Comdy Club
            vector3(-2092.90, -1015.41, 8.98), -- Lil Yachty
        },
        items = {
            { name = "icetea", price = 5, count = 5 },
            { name = "water", price = 1, count = 5 },
            { name = "nachos", price = 9, count = 5 },
            { name = "whisky", price = 25, count = 5 },
            { name = "gintonic", price = 15, count = 5 },
            { name = "vodka", price = 10, count = 5 },
            { name = "champagne", price = 50, count = 5 },
            { name = "beer", price = 5, count = 5 },
            { name = "tequila", price = 15, count = 5 },
            { name = "dusche", price = 5, count = 5 },            
            { name = "jager", price = 15, count = 5 },  
            { name = "rum", price = 13, count = 5 },  
            { name = "sake", price = 7, count = 5 },    
            { name = "wine_white", price = 20, count = 5 },            
            { name = "wine_red", price = 20, count = 5 },            
            { name = "martini", price = 17, count = 5 },         
            { name = "pina_colada", price = 15, count = 5 },
            { name = "bloody_marry", price = 20, count = 5 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Bar Menu',
        job = 'all'
    },
    ['Pet_Shop'] = {
        coords = {
            vector3(561.08, 2748.43, 42.87),
        },
        items = {
            { name = "tennis_ball", price = 25, count = 1 },
            { name = "pet_food", price = 50, count = 5 },
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Pet Shop',
        job = 'all'
    },
    ['Smoke Water'] = {
        Blip = {
            Id = 140,
            Color = 24,
            Text = 'Smoke on the Water'
        },
        coords = {
            vector3(-1171.80, -1571.48, 4.72),
        },
        items = {
            { name = "weed_medical", price = 15, count = 5 },
            { name = "bong", price = 250, count = 1 },
            { name = "hemptea", price = 20, count = 5 },
            { name = "lotion_medical", price = 60, count = 1 },
            { name = "fertilizer", price = 10, count = 5 },
            { name = "water_bottle", price = 10, count = 5 },

            
        },
        markerType = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Smoke on the Water',
        job = 'all'
    }
}

Config.Stash = {
    ['MRPD'] = { -- MRPD
        coords = vector3(472.62, -996.34, 26.27),
        size = vector3(0.5, 0.2, 0.2),
        job = 'police',
        markerType = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Evidence Locker'
    },
    ['Police'] = { -- Sandy
        coords = vector3(1840.864, 3691.263, 34.26),
        size = vector3(0.5, 0.2, 0.2),
        job = 'police',
        markerType = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Evidence Locker'
    },
    ['PaletoPD'] = { -- Paleto
        coords = vector3(-449.98, 6016.2, 31.79),
        size = vector3(0.5, 0.2, 0.2),
        job = 'police',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Evidence Locker'
    },
    ['Comedy_Club'] = {
        coords = vector3(-429.05, 279.85, 83.01),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Open Stash'
    },
    ['Tequilala'] = {
        coords = vector3(-568.50, 291.08, 79.17),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Open Stash'
    },
    ['Bahamas'] = {
        coords = vector3(-1386.70, -608.71, 30.31),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Open Stash'
    },
    ['Vanilla_Unicorn'] = {
        coords = vector3(93.18, -1291.37, 29.26),
        size = vector3(0.5, 0.2, 0.2),
        job = 'vu',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Open Stash'
    },
    ['LaFuertaRV'] = {
        coords = vector3(1435.53, 1501.011, 114.15),
        size = vector3(0.5, 0.2, 0.2),
        job = 'police',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Open Stash'
    },
    ['Lost_MC_Mirror_Park'] = {
        coords = vector3(977.16, -104.07, 74.84),
        size = vector3(0.5, 0.2, 0.2),
        job = 'lostmc',
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '[E] - Open Stash'
    },
    ['prisonstash'] = {
        coords = vector3(1746.34, 2496.01, 45.59),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['mechanic'] = {
        coords = vector3(-196.52, -1315.34, 31.09),
        size = vector3(0.5, 0.2, 0.2),
        job = 'mechanic',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Random stash'] = {
        coords = vector3(736.16, -808.16, 16.28),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Taco stash'] = {
        coords = vector3(20.4, -1602.04, 29.36),
        size = vector3(0.5, 0.2, 0.2),
        job = 'tacos',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Bean Machine stash'] = {
        coords = vector3(-634.63, 225.67, 81.88),
        size = vector3(0.5, 0.2, 0.2),
        job = 'beanmachine',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Random#5 stash'] = {
        coords = vector3(-127.8, -2234.28, 8.0),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Franklin_Aunt'] = {
        coords = vector3(-18.44, -1438.92, 31.12),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Floyd_House'] = {
        coords = vector3(-1144.08, -1515.92, 10.64),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Vagos_Garage'] = {
        coords = vector3(-1079.56, -1679.92, 4.56),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['RadioTower_SideBuilding'] = {
        coords = vector3(741.48, 2586.84, 75.52),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Paleto_Hut'] = {
        coords = vector3(65.44, 6662.6, 31.8),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['Vinewood_Hidden'] = {
        coords = vector3(242.64, 370.68, 105.8),
        size = vector3(0.5, 0.2, 0.2),
        job = 'all',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    },
    ['BurgerShot_Stash'] = {
        coords = vector3(-1196.9976806641, -893.94946289063, 13.995231628418),
        size = vector3(0.5, 0.2, 0.2),
        job = 'burgershot',
        markertype = 27,
        markerColour = { r = 255, g = 0, b = 0 },
        msg = '[E] - Open Stash'
    }
}


Config.gunshop = {

    ['weapshop2'] = {
        Blip = {
            Id = 313,
            Color = 32,
            Text = 'Ammunation'
        },
        coords = {
            vector3(810.25, -2157.60, 28.82),
            vector3(1693.44, 3760.16, 33.91),
            vector3(-330.24, 6083.88, 30.65),
            vector3(252.55, -50.10, 69.94), -- 7121
            vector3(22.44, -1106.89, 29.79), -- Legion
            vector3(2567.69, 294.38, 107.93),
            vector3(-1117.58, 2698.61, 17.75),
            vector3(842.44, -1033.42, 27.39),
            vector3(-3172.37, 1087.68, 20.99),
            vector3(-1306.239, -394.018, 35.895),
            vector3(-662.03, -935.12, 21.82), -- Little Seuol
        },
        items = {
            { name = "WEAPON_SAWNOFFSHOTGUN", price = 3500, count = 1, grade = 0 },
            { name = "WEAPON_DBSHOTGUN", price = 3200, count = 1, grade = 0 },
            { name = "WEAPON_PUMPSHOTGUN", price = 4200, count = 1, grade = 0  },
            { name = "WEAPON_SNSPISTOL", price = 800, count = 1, grade = 0 },
            { name = "WEAPON_PISTOL", price = 1200, count = 1, grade = 0 },
            { name = "WEAPON_VINTAGEPISTOL", price = 3500, count = 1, grade = 0 },
            { name = "pistol_ammo", price = 50, count = 1, grade = 0  },
            { name = "shotgun_ammo", price = 150, count = 1, grade = 0  },
            { name = "WEAPON_FLASHLIGHT", price = 80, count = 1, grade = 0  },
            { name = "WEAPON_KNIFE", price = 300, count = 1, grade = 0  },
            { name = "WEAPON_MACHETE", price = 500, count = 1, grade = 0  },
            { name = "WEAPON_BAT", price = 150, count = 1, grade = 0  },
            { name = "WEAPON_GOLFCLUB", price = 100, count = 1, grade = 0  },
            { name = "WEAPON_DAGGER", price = 550, count = 1, grade = 0  },
            { name = "WEAPON_POOLCUE", price = 225, count = 1, grade = 0  },
            { name = "WEAPON_BOTTLE", price = 35, count = 1, grade = 0  },
            { name = "WEAPON_PETROLCAN", price = 120, count = 1, grade = 0  },
            { name = "WEAPON_WRENCH", price = 175, count = 1, grade = 0  },
            { name = "WEAPON_HAMMER", price = 50, count = 1, grade = 0  },
            { name = "grip", price = 200, count = 1, grade = 0  },
            { name = "small_armor", price = 500, count = 1, grade = 0  },
            { name = "flashlight", price = 100, count = 1, grade = 0  },
        },
        name = "weapshop2",
        markertype = 27,
        markerColour = { r = 0, g = 0, b = 0 },
        msg = '[E] - Weapon Shop',
        job = 'all'
    }
}

Config.Craft = {
    ['cuffs'] = {
        coords = vector3(1109.8978271484, -2008.1369628906, 31.057577133179),
        size = vector3(1.0, 1.0, 1.0),
        job = 'all',
        markerType = 2,
        markerColour = { r = 0, g = 211, b = 255 },
        msg = '[E] - Smelt Materials',
        recipes = {
            
            [1] = {
                required_item = {--car_battery
                    name = "car_battery", count = 1
                },
                return_item = {--wires, plastic
                    {name = "wire", count = 1},
                    {name = "plastic", count = 1}
                }
            },

            [2] = {
                required_item = {--car_hood
                    name = "car_hood", count = 1
                },
                return_item = {--aluminum, steel
                    {name = "aluminum", count = 1},
                    {name = "steel", count = 1}
                }
            },
           
            [3] = {
                required_item = {--clutch
                   name = "clutch", count = 1
                },
                return_item = {--steel, scrap_metal
                    {name = "steel", count = 1},
                    {name = "scrap_metal", count = math.random(1,2)}
                }
            }, 

            [4] = {
                required_item = {--front_bumper
                   name = "front_bumper", count = 1
                },
                return_item = {--plastic, scrap_metal
                    {name = "plastic", count = 1},
                    {name = "scrap_metal", count = math.random(1,2)}
                }
            },

            [5] = {
                required_item = {--racing_rims
                    name = "racing_rims", count = 1
                },
                return_item = {--aluminum
                    {name = "aluminum", count = 1},
                    {name = "scrap_metal", count = math.random(2,3)}
                }
            },

            [6] = {
                required_item = {--car_seat
                    name = "car_seat", count = 1
                },
                return_item = {--leather 
                    {name = "leather", count = 1}
                }
            },

            [7] = {
                required_item = {--car_side_mirror
                    name = "car_side_mirror", count = 1
                },
                return_item = {--glass 
                    {name = "glass", count = 1}
                }
            },

            [8] = {
                required_item = {--car_side_skirt
                    name = "car_side_skirt", count = 1
                },
                return_item = {--plastic 
                    {name = "plastic", count = 1}
                }
            },

            [9] = {
                required_item = {--car_sound_system
                    name = "car_sound_system", count = 1
                },
                return_item = {--electronics, aluminum 
                    {name = "electronics", count = 1},
                    {name = "aluminum", count = 1}
                }
            },

            [10] = {
                required_item = {--spoiler
                    name = "spoiler", count = 1
                },
                return_item = {--plastic, steel 
                    {name = "plastic", count = 1},
                    {name = "steel", count = 1}
                }
            },

            [11] = {
                required_item = {--tire
                    name = "tire", count = 1
                },
                return_item = {--rubber 
                    {name = "rubber", count = 1}
                }
            },

            [12] = {
                required_item = {--rims
                    name = "rims", count = 1
                },
                return_item = {--iron 
                    {name = "iron", count = 1},
                    {name = "scrap_metal", count = math.random(2,3)}
                }
            },

            [13] = {
                required_item = {-- steering_wheel
                    name = "steering_wheel", count = 1
                },
                return_item = {--rubber, scrap_metal
                    {name = "rubber", count = 1},
                    {name = "scrap_metal", count = math.random(2,3)}
                }
            },
        }
    },

}

Config.Evidence = { -- only for PD Evidence Locker (see server/evidence.lua)

}

Config.Steal = {
    black_money = true,
    cash = true
}

Config.Seize = {
    black_money = true,
    cash = false
}

--Courtesy DoctorTwitch
Config.VehicleSlot = {
    [0] = 5, --Compact
    [1] = 10, --Sedan
    [2] = 15, --SUV
    [3] = 5, --Coupes
    [4] = 5, --Muscle
    [5] = 5, --Sports Classics
    [6] = 5, --Sports
    [7] = 5, --Super
    [8] = 0, --Motorcycles
    [9] = 15, --Off-road
    [10] = 20, --Industrial
    [11] = 15, --Utility
    [12] = 20, --Vans
    [13] = 0, --Cycles
    [14] = 5, --Boats
    [15] = 5, --Helicopters
    [16] = 0, --Planes
    [17] = 20, --Service
    [18] = 20, --Emergency
    [19] = 20, --Military
    [20] = 0, --Commercial
    [21] = 0 --Trains
}
Config.VehicleGloveSlot = {
    [0] = 5, --Compact
    [1] = 5, --Sedan
    [2] = 5, --SUV
    [3] = 5, --Coupes
    [4] = 5, --Muscle
    [5] = 5, --Sports Classics
    [6] = 5, --Sports
    [7] = 5, --Super
    [8] = 0, --Motorcycles
    [9] = 5, --Off-road
    [10] = 5, --Industrial
    [11] = 5, --Utility
    [12] = 5, --Vans
    [13] = 0, --Cycles
    [14] = 25, --Boats
    [15] = 5, --Helicopters
    [16] = 0, --Planes
    [17] = 5, --Service
    [18] = 5, --Emergency
    [19] = 5, --Military
    [20] = 0, --Commercial
    [21] = 0 --Trains
}

Config.Throwables = {
    WEAPON_MOLOTOV = 615608432,
    WEAPON_FLARE = GetHashKey('WEAPON_FLARE'),
    WEAPON_GRENADE = -1813897027,
    WEAPON_STICKYBOMB = 741814745,
    WEAPON_PROXMINE = -1420407917,
    WEAPON_SMOKEGRENADE = -37975472,
    WEAPON_PIPEBOMB = -1169823560,
    WEAPON_SNOWBALL = 126349499
}

Config.FuelCan = 883325847

Config.Weapons = {
    WEAPON_KNIFE = { item = 'WEAPON_KNIFE' },
    WEAPON_SNOWBALL = { item = 'WEAPON_SNOWBALL' },
    WEAPON_NIGHTSTICK = { item = 'WEAPON_NIGHTSTICK' },
    WEAPON_HAMMER = { item = 'WEAPON_HAMMER' },
    WEAPON_BAT = { item = 'WEAPON_BAT' },
    WEAPON_GOLFCLUB = { item = 'WEAPON_GOLFCLUB' },
    WEAPON_CROWBAR = { item = 'WEAPON_CROWBAR' },
    WEAPON_PISTOL = { item = 'WEAPON_PISTOL' },
    WEAPON_COMBATPISTOL = { item = 'WEAPON_COMBATPISTOL' },
    WEAPON_APPISTOL = { item = 'WEAPON_APPISTOL' },
    WEAPON_PISTOL50 = { item = 'WEAPON_PISTOL50' },
    WEAPON_MICROSMG = { item = 'WEAPON_MICROSMG' },
    WEAPON_SMG = { item = 'WEAPON_SMG' },
    WEAPON_ASSAULTSMG = { item = 'WEAPON_ASSAULTSMG' },
    WEAPON_ASSAULTRIFLE = { item = 'WEAPON_ASSAULTRIFLE' },
    WEAPON_CARBINERIFLE = { item = 'WEAPON_CARBINERIFLE' },
    WEAPON_ADVANCEDRIFLE = { item = 'WEAPON_ADVANCEDRIFLE' },
    WEAPON_MG = { item = 'WEAPON_MG' },
    WEAPON_COMBATMG = { item = 'WEAPON_COMBATMG' },
    WEAPON_PUMPSHOTGUN = { item = 'WEAPON_PUMPSHOTGUN' },
    WEAPON_SAWNOFFSHOTGUN = { item = 'WEAPON_SAWNOFFSHOTGUN' },
    WEAPON_ASSAULTSHOTGUN = { item = 'WEAPON_ASSAULTSHOTGUN' },
    WEAPON_BULLPUPSHOTGUN = { item = 'WEAPON_BULLPUPSHOTGUN' },
    WEAPON_STUNGUN = { item = 'WEAPON_STUNGUN' },
    WEAPON_SNIPERRIFLE = { item = 'WEAPON_SNIPERRIFLE' },
    WEAPON_HEAVYSNIPER = { item = 'WEAPON_HEAVYSNIPER' },
    WEAPON_GRENADE = { item = 'WEAPON_GRENADE' },
    WEAPON_STICKYBOMB = { item = 'WEAPON_STICKYBOMB' },
    WEAPON_SMOKEGRENADE = { item = 'WEAPON_SMOKEGRENADE' },
    WEAPON_BZGAS = { item = 'WEAPON_BZGAS' },
    WEAPON_MOLOTOV = { item = 'WEAPON_MOLOTOV' },
    WEAPON_BALL = { item = 'WEAPON_BALL' },
--    WEAPON_SNSPISTOL = { item = 'WEAPON_SNSPISTOL' },
    WEAPON_BOTTLE = { item = 'WEAPON_BOTTLE' },
    WEAPON_GUSENBERG = { item = 'WEAPON_GUSENBERG' },
    WEAPON_SPECIALCARBINE = { item = 'WEAPON_SPECIALCARBINE' },
    WEAPON_HEAVYPISTOL = { item = 'WEAPON_HEAVYPISTOL' },
    WEAPON_BULLPUPRIFLE = { item = 'WEAPON_BULLPUPRIFLE' },
    WEAPON_DAGGER = { item = 'WEAPON_DAGGER' },
    WEAPON_VINTAGEPISTOL = { item = 'WEAPON_VINTAGEPISTOL' },
    WEAPON_FIREWORK = { item = 'WEAPON_FIREWORK' },
    WEAPON_MUSKET = { item = 'WEAPON_MUSKET' },
    WEAPON_HEAVYSHOTGUN = { item = 'WEAPON_HEAVYSHOTGUN' },
    WEAPON_MARKSMANRIFLE = { item = 'WEAPON_MARKSMANRIFLE' },
    WEAPON_PROXMINE = { item = 'WEAPON_PROXMINE' },
    WEAPON_FLAREGUN = { item = 'WEAPON_FLAREGUN' },
    WEAPON_COMBATPDW = { item = 'WEAPON_COMBATPDW' },
    WEAPON_MARKSMANPISTOL = { item = 'WEAPON_MARKSMANPISTOL' },
    WEAPON_KNUCKLE = { item = 'WEAPON_KNUCKLE' },
    WEAPON_HATCHET = { item = 'WEAPON_HATCHET' },
    WEAPON_MACHETE = { item = 'WEAPON_MACHETE' },
    WEAPON_MACHINEPISTOL = { item = 'WEAPON_MACHINEPISTOL' },
    WEAPON_SWITCHBLADE = { item = 'WEAPON_SWITCHBLADE' },
    WEAPON_REVOLVER = { item = 'WEAPON_REVOLVER' },
    WEAPON_DBSHOTGUN = { item = 'WEAPON_DBSHOTGUN' },
    WEAPON_COMPACTRIFLE = { item = 'WEAPON_COMPACTRIFLE' },
    WEAPON_BATTLEAXE = { item = 'WEAPON_BATTLEAXE' },
    WEAPON_MINISMG = { item = 'WEAPON_MINISMG' },
    WEAPON_PIPEBOMB = { item = 'WEAPON_PIPEBOMB' },
    WEAPON_POOLCUE = { item = 'WEAPON_POOLCUE' },
    WEAPON_WRENCH = { item = 'WEAPON_WRENCH' },
    WEAPON_FLASHLIGHT = { item = 'WEAPON_FLASHLIGHT' },
    GADGET_NIGHTVISION = { item = 'GADGET_NIGHTVISION' },
    GADGET_PARACHUTE = { item = 'GADGET_PARACHUTE' },
    WEAPON_FLARE = { item = 'WEAPON_FLARE', }, 
    WEAPON_SNSPISTOL_MK2 = { item = 'WEAPON_SNSPISTOL_MK2' }, 
    WEAPON_REVOLVER_MK2 = { item = 'WEAPON_REVOLVER_MK2' },  
    WEAPON_DOUBLEACTION = { item = 'WEAPON_DOUBLEACTION' },    
    WEAPON_SPECIALCARBINE_MK2 = { item = 'WEAPON_SPECIALCARBINE_MK2' },  
    WEAPON_BULLPUPRIFLE_MK2 = { item = 'WEAPON_BULLPUPRIFLE_MK2' },   
    WEAPON_PUMPSHOTGUN_MK2 = { item = 'WEAPON_PUMPSHOTGUN_MK2' },
    WEAPON_MARKSMANRIFLE_MK2 = { item = 'WEAPON_MARKSMANRIFLE_MK2' },  
    WEAPON_ASSAULTRIFLE_MK2 = { item = 'WEAPON_ASSAULTRIFLE_MK2' },
    WEAPON_CARBINERIFLE_MK2 = { item = 'WEAPON_CARBINERIFLE_MK2' },  
    WEAPON_COMBATMG_MK2 = { item = 'WEAPON_COMBATMG_MK2' },   
    WEAPON_HEAVYSNIPER_MK2 = { item = 'WEAPON_HEAVYSNIPER_MK2' },   
    WEAPON_PISTOL_MK2 = { item = 'WEAPON_PISTOL_MK2' },   
    WEAPON_SMG_MK2 = { item = 'WEAPON_SMG_MK2' },
    WEAPON_PETROLCAN = { item = 'WEAPON_PETROLCAN' },
    WEAPON_FIREEXTINGUISHER = { item = 'WEAPON_FIREEXTINGUISHER' }
}
  
Config.AmmoTypes = {
    AMMO_PISTOL = { item = 'pistol_ammo' },
    AMMO_SMG = { item = 'sub_ammo' },
    AMMO_FIREWORK = { item = 'firework_ammo' },
    AMMO_RIFLE = { item = 'rifle_ammo' },
    AMMO_MG = { item = 'mg_ammo' },
    AMMO_SHOTGUN = { item = 'shotgun_ammo' },
    AMMO_SNIPER = { item = 'sniper_ammo' },
    AMMO_BALL = { item = 'ball' },
    AMMO_STICKYBOMB = { item = 'stickybomb' },
    AMMO_SMOKEGRENADE = { item = 'smokegrenade' },
    AMMO_MOLOTOV = { item = 'molotov' },
}
