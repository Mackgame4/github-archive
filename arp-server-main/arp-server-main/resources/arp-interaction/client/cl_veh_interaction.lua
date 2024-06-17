local vehClassIcons = {
    [0] = 'mdi-car-hatchback', -- Compacts
    [1] = 'mdi-car-side', -- Sedans
    [2] = 'mdi-car-estate', -- SUVs
    [3] = 'mdi-car-side', -- Coupes
    [4] = 'mdi-car-sports', -- Muscle
    [5] = 'mdi-car-sports', -- Sports Classic
    [6] = 'mdi-car-sports', -- Sports
    [7] = 'mdi-car-sports', -- Super
    [8] = 'mdi-motorbike', -- Motorcycles
    [9] = 'mdi-car-lifted-pickup', -- Off-road
    [10] = 'mdi-dump-truck', -- Industrial
    [11] = 'mdi-tow-truck', -- Utility
    [12] = 'mdi-van-utility', -- Vans
    [13] = 'mdi-bicycle', -- Cycles
    [14] = 'mdi-ferry', -- Boats
    [15] = 'mdi-helicopter', -- Helicopters
    [16] = 'mdi-airplane', -- Planes
    [17] = 'mdi-bus', -- Service
    --[18] = 'mdi-car-emergency', -- Emergency
    [19] = 'mdi-tank', -- Military
    [20] = 'mdi-truck', -- Commercial
    --[21] = '', -- Trains
}

local vehIconOverrides = {
    [`taxi`] = 'mdi-taxi',
}

function GetIconForVehicle(vehicle)
    local class = GetVehicleClass(vehicle)
    local model = GetEntityModel(vehicle)
    if vehIconOverrides[model] then
        return vehIconOverrides[model]
    elseif vehClassIcons[class] then 
        return vehClassIcons[class]
    else
        return 'mdi-car'
    end
end