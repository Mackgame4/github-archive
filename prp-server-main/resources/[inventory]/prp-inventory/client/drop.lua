local serverDrops = {}
local drops = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for k, v in pairs(serverDrops) do
            local dropCoords = getCoordsFromOwner(k)
            if #(dropCoords - coords) < 20 then
                if drops[k] then
                    drops[k].active = true
                else
                    drops[k] = {
                        name = k,
                        coords = dropCoords,
                        active = true
                    }
                end
            end
        end
        
        for k, v in pairs(drops) do
            if v.active then
                local x, y, z = table.unpack(v.coords)
                local marker = {
                    name = v.name .. '_drop',
                    type = 2,
                    coords = vector3(x, y, z + 0.75),
                    rotate = false,
                    colour = { r = 240, b = 60, g = 60 },
                    size = vector3(0.3, 0.3, 0.1),
                }
                drops[k].active = false
                TriggerEvent('np_marker:registerMarker', marker)
--                TriggerEvent('prp-inventory:removeCurrentWeapon')
            else
                TriggerEvent('np_marker:removeMarker', v.name .. '_drop')
                drops[v.name] = nil
            end
        end
    end
end)

RegisterNetEvent('prp-inventory:updateDrops')
AddEventHandler('prp-inventory:updateDrops', function(newDrops)
    serverDrops = newDrops
end)
