local coordMenu = nil

RegisterNetEvent('Admin:Client:Coords')
AddEventHandler('Admin:Client:Coords', function()
    local coords = GetEntityCoords(ARP.GblPed)
    local rotation = GetEntityRotation(ARP.GblPed)
    local heading = GetEntityHeading(ARP.GblPed)

    local veh = GetVehiclePedIsIn(ARP.GblPed)
    local vehCoords = GetEntityCoords(veh)
    local vehHeading = GetEntityHeading(veh)

    local menuData = {
        { name = 'Coords Vector3', value = ('vector3(%.3f, %.3f, %.3f)'):format(coords.x, coords.y, coords.z)},
        { name = 'Coords Vector4', value = ('vector4(%.3f, %.3f, %.3f, %.3f)'):format(coords.x, coords.y, coords.z, heading) },
        { name = 'Vehicle Coords Vector4', value = ('vector4(%.3f, %.3f, %.3f, %.3f)'):format(vehCoords.x, vehCoords.y, vehCoords.z, vehHeading) },
        { name = 'Coords JSON', value = json.encode(('vector4(%.3f, %.3f, %.3f, %.3f)'):format(coords.x, coords.y, coords.z, heading)) },
        { name = 'Coords Lua Table', value = ('{ x = %.3f, y = %.3f, z = %.3f, h = %.3f }'):format(coords.x, coords.y, coords.z, heading) },
        { name = 'Rotation Vector3', value = ('vector3(%.3f, %.3f, %.3f)'):format(rotation.x, rotation.y, rotation.z) },
        { name = 'Rotation JSON', value = json.encode(('{ x = %.3f, y = %.3f, z = %.3f }'):format(rotation.x, rotation.y, rotation.z)) },
        { name = 'Rotation Lua Table', value = ('{ x = %.3f, y = %.3f, z = %.3f }'):format(rotation.x, rotation.y, rotation.z) },
    }

    if coordMenu == nil then 
        coordMenu = Components.Menus:New('coordMenu', 'Coordinate Menu', false, false, 'View or Copy Current Coordinates')
    end

    coordMenu:ClearElements()

    for k, v in ipairs(menuData) do 
        coordMenu.Add:MenuSpacer()
        coordMenu.Add:TextDisplay(v.value)
        coordMenu.Add:Button(v.name, {}, function(element)
            Components.Logging:Info('Admin', 'Coords: ' .. v.value)
            Components.UI:Send('clipboardCopy', v.value)
        end)
    end

    coordMenu:Open()
end)

RegisterCommand('dev:coords', function(src, args)
    local action = args[1]
    local coords = GetEntityCoords(ARP.GblPed)
    local heading = GetEntityHeading(ARP.GblPed)
    if action == 'vec3' then
        local c = ('vector3(%.3f, %.3f, %.3f)'):format(coords.x, coords.y, coords.z) 
        Components.Logging:Info('Admin', 'Coords: ' .. c)
        Components.UI:Send('clipboardCopy', c)
    elseif action == 'vec4' then
        local c = ('vector4(%.3f, %.3f, %.3f, %.3f)'):format(coords.x, coords.y, coords.z, heading) 
        Components.Logging:Info('Admin', 'Coords: ' .. c)
        Components.UI:Send('clipboardCopy', c)
    end

end)