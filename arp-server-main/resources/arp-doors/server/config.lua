--[[ -- * Example Door
    {
        id = string - not required - it will be assigned if not provided,
        target = boolean - if it should add a target for the object,
        doorHash = number - the hash of the door object,
        coords = vector3 - location of the door,
        double = string - not required - the id of the door to pair with,
        autoRate = number - default 10.0, not required - keep as 0.0 on garage doors otherwise they are retarded,
    }
]]


_doors = { -- They only need and id var if required, otherwise they will be assigned one automatically
    -- Mission Row Police Department
    -- Main Floor ?'government:police:false:1'
    { -- Reception Double Doors
        id = 'mrpd_reception_1',
        doorHash = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(434.7444, -980.7556, 30.8153),
        defaultLock = true,
        double = 'mrpd_reception_2'
    },
    { -- Reception Double Doors
        id = 'mrpd_reception_2',
        doorHash = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(434.7444, -983.0781, 30.8153),
        defaultLock = true,
        double = 'mrpd_reception_1'
    },

    { -- Side Double Doors
        id = 'mrpd_side_1',
        doorHash = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(455.8862, -972.2543, 30.81531),
        defaultLock = true,
        double = 'mrpd_side_2'
    },
    { -- Side Double Doors
        id = 'mrpd_side_2',
        doorHash = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(458.2087, -972.2543, 30.81531),
        defaultLock = true,
        double = 'mrpd_side_1'
    },

    { -- Carpark Side Double Doors
        id = 'mrpd_cside_1',
        doorHash = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(440.7392, -998.7462, 30.8153),
        defaultLock = true,
        double = 'mrpd_cside_2'
    },
    { -- Carpark Side Double Doors
        id = 'mrpd_cside_2',
        doorHash = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(443.0618, -998.7462, 30.8153),
        defaultLock = true,
        double = 'mrpd_cside_1'
    },



    {
        id = 'mrpd_bollards_exit',
        doorHash = `gabz_mrpd_bollards1`,
        coords = vector3(410.0258, -1024.226, 29.22022),
        defaultLock = true,
        autoRate = 0.0,
    },
    {
        id = 'mrpd_bollards_enter',
        doorHash = `gabz_mrpd_bollards2`,
        coords = vector3(410.0258, -1024.226, 29.22022),
        defaultLock = true,
        autoRate = 0.0,
    },
    { -- MRPD Back Gate Slider
        id = 'mrpd_reargate',
        doorHash = -1603817716,
        coords = vector3(488.8948, -1017.21, 27.14584),
        defaultLock = true,
    },
}