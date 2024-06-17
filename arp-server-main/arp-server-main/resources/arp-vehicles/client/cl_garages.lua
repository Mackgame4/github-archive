function OpenPublicGarage(gId, endCoords)
    if not _publicVehStorage[gId] then return end
    local parkingSpaces = _publicVehStorage[gId].spaces
    print('access veh storage')
    local garageData = Components.Callbacks:Execute('Vehicles:Server:GetPublicGarage', gId)
    local vehMenuItems = {}
    if garageData and garageData.storedVehicles and #garageData.storedVehicles > 0 then 
        for _, vehicle in ipairs(garageData.storedVehicles) do 
            if vehicle.VIN then 
                table.insert(vehMenuItems, {
                    id = vehicle.VIN,
                    title = GetVehicleNameForModel(vehicle.Vehicle) or 'Unknown Name',
                    text = ('<b>%s</b>'):format(vehicle.PlateRegistered),
                    icon = 'mdi-car',
                    secondary = {
                        {
                            id = 'info',
                            title = 'Vehicle Information',
                            text = ('VIN: <b>%s</b> <br>Fuel: <b>%.0f</b> <br>Plates: <b>%s</b>'):format(vehicle.VIN, vehicle.Fuel, vehicle.PlateRegistered),
                            icon = false,
                            disabled = true,
                        },
                        {
                            id = 'out',
                            title = 'Take Out Vehicle',
                            text = 'Take out your vehicle in the closest space.',
                            icon = 'mdi-home-export-outline',
                            disabled = false,
                        }
                    }
                })
            end
        end
    else
        table.insert(vehMenuItems, {
            id = 'disabled',
            title = 'No Vehicles Stored',
            text = 'There are no vehicles stored here.',
            disabled = true,
        })
    end


    Interaction:Menu({ title = 'Vehicle Storage', icon = 'mdi-garage-variant', text = _publicVehStorage[gId].name }, vehMenuItems, function(p, s)
        if p == 'disabled' or not s then return end
        if s == 'out' then 
            print('take vehicle out', p, s)
            local freeSpace = GetClosestCoordPointToCoords(endCoords, parkingSpaces)
            local pedCoords = GetEntityCoords(ARP.GblPed)
            local spaceDistance = #(freeSpace.xyz - pedCoords)
            local heightAllow = true
            if _publicVehStorage[gId].zone.checkHeight then 
                local heightDiff = math.abs(freeSpace.z - pedCoords.z)
                if heightDiff > 1.5 then 
                    heightAllow = false
                end
            end
            if spaceDistance <= 20.0 and GetClosestVehicle(freeSpace.xyz, 2.0, 0, 71) == 0 and heightAllow then 
                print('close enough')
                --print(freeSpace)
                TriggerServerEvent('Vehicles:Server:RequestSpawnVehicle', p, freeSpace)
            else
                Notify:Error('Couldn\'t Find Parking Space', false, 'mdi-garage-variant')
            end
        end
    end)
end