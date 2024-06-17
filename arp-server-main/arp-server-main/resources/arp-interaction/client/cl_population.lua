local blockedPedSpawns = {
    { coords = vector3(365.209, -1596.337, 29.292), radius = 30 },
    { coords = vector3(451.395, -991.660, 30.689), radius = 50 }
}

local blockedPeds = {

}

AddEventHandler('populationPedCreating', function(x, y, z, model)
    local spawn = vector3(x, y, z)
    for k, v in ipairs(blockedPedSpawns) do 
        local dist = #(v.coords - spawn)
        if dist <= v.radius then 
            return CancelEvent()
        end
    end
end)