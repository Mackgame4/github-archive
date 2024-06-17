local doorsNamed = {
    [0] = 'Front Left',
    [1] = 'Front Right',
    [2] = 'Rear Left',
    [3] = 'Rear Right',
    [4] = 'Hood',
    [5] = 'Trunk',
    [6] = 'Extra Door 1',
    [7] = 'Extra Door 2' 
}

function AddInteractionPoints()
    -- Los Santos Impound
    Components.Interaction.Targeting:AddBoxZone('impound', 'mdi-tow-truck', vector3(401.64, -1632.2, 29.29), 14.2, 8.8, {
        minZ = 27.74,
        maxZ = 30.74,
        heading = 320,
        debugPoly = true
    }, 10)

    Components.Blips:Add('impound', vector3(401.64, -1632.2, 29.29), 'Los Santos Impound', 68, 0.8, 9, 2)

    local garageZones = {}
    for garageId, garage in pairs(_publicVehStorage) do 
        Components.Blips:Add('garage_' .. garageId, garage.zone.center, 'Vehicle Storage - '.. garage.name, 357, 0.9, 12, 2, 10)

        if garage.zone.type == 'box' then 
            Components.Interaction.Targeting:AddBoxZone('garage_' .. garageId, 'mdi-garage-variant', garage.zone.center, garage.zone.length, garage.zone.width, {
                heading = garage.zone.heading,
                minZ = garage.zone.minZ,
                maxZ = garage.zone.maxZ,
                debugPoly = false,
            }, 10, { id = garageId })
        elseif garage.zone.type == 'poly' and garage.zone.points then
            Components.Interaction.Targeting:AddPolyZone('garage_' .. garageId, 'mdi-garage-variant', garage.zone.points, {
                debugPoly = false,
            }, 10, { id = garageId })
        end
    end
end

AddEventHandler('Interaction:Targeting:ZoneAction', function(zone, data, key, mod, endCoords)
    if zone and ARP.StringStartsWith(zone, 'garage_') and data and data.id then
        if key == 1 then -- primary
            print('garage zone action', data.id)
            OpenPublicGarage(data.id, endCoords)
        end
    end
end)

AddEventHandler('Interaction:Targeting:VehicleAction', function(veh, icon)
    OpenVehicleInteraction(veh)
end)

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'f6' then 
        local targetVehicle = false
        local insideVehicle = false
        if VEHICLE_INSIDE then 
            targetVehicle = VEHICLE_INSIDE
            insideVehicle = true
        else
            local nearVeh = GetClosestVehicle(GetEntityCoords(ARP.GblPed), 3.0, 0, 71)
            if nearVeh > 0 then 
                targetVehicle = nearVeh
            end
        end
        if not targetVehicle then return end
        OpenVehicleInteraction(targetVehicle, insideVehicle)
    end
end)

function OpenVehicleInteraction(veh, inside)
    local vehMenuItems = {}
    local vehCoords = GetEntityCoords(veh)
    local pedCoords = GetEntityCoords(ARP.GblPed)
    local vehDist = #(vehCoords - pedCoords)
    local vehClass = GetVehicleClass(veh)

    local vehEnt = Entity(veh)
    local vehVin = vehEnt.state.VIN
    local isLocked = vehEnt.state.locked
    if not vehVin then return end

    local currentZone = Components.Interaction.Targeting:IsCoordsInAZone(vehCoords)
    local garageZone = false
    if currentZone and currentZone.name and ARP.StringStartsWith(currentZone.name, 'garage_') and currentZone.data and currentZone.data.id then
        garageZone = currentZone.data.id
    end

    local hasKeys = HasKeysToTargetVehicle(vehVin)

    if hasKeys then 
        if garageZone and not inside and vehEnt.state.owned then
            table.insert(vehMenuItems, {
                id = 'store',
                title = 'Store Vehicle',
                text = 'Store the target vehicle.',
                icon = 'mdi-home-import-outline'
            })
        end

        table.insert(vehMenuItems, {
            id = 'lock',
            title = 'Toggle Locks',
            icon = 'mdi-car-key',
        })
    end

    if inside then 
        if hasKeys then 
            if VEHICLE_SEAT == -1 then 
                table.insert(vehMenuItems, {
                    id = 'engine',
                    title = 'Toggle Engine',
                    icon = 'mdi-engine',
                })
            end
        else
            if not vehEnt.state.hotwired then 
                table.insert(vehMenuItems, {
                    id = 'hotwire',
                    title = 'Attempt Hotwire',
                    icon = 'mdi-car-cog',
                    disabled = not CanHotwireAVehicle(veh)
                })
            end
            if not vehEnt.state.owned then 
                -- key searching
                table.insert(vehMenuItems, {
                    id = 'searchkeys',
                    title = 'Search for Keys',
                    icon = 'mdi-car-key',
                    disabled = not CanSeachVehicleForKeys(veh)
                })
            end
        end

        if AreAnyVehicleSeatsFree(veh) then 
            local seatSubmenu = {}
            local maxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
            --if maxSeats > 0 then
            print(maxSeats)
            for s = 1, maxSeats do 
                local actualSeat = s - 2
                print('seat', IsVehicleSeatFree(veh, actualSeat))
    
                table.insert(seatSubmenu, {
                    id = actualSeat,
                    title = actualSeat == -1 and 'Driver\'s Seat' or 'Seat ' .. (s),
                    text = not IsVehicleSeatFree(veh, actualSeat) and 'Occupied' or false
                })
    
            end
    
            table.insert(vehMenuItems, {
                id = 'seats',
                title = 'Switch Seats',
                icon = 'mdi-car-seat',
                secondary = seatSubmenu,
            })
        else
            table.insert(vehMenuItems, {
                id = 'seats',
                title = 'Switch Seats',
                icon = 'mdi-car-seat',
                disabled = true
            })
        end
    end

    if vehClass ~= 8 and vehClass ~= 13 and vehDist <= 5.0 and (hasKeys or not isLocked) then 
        local doorSub = {}
        local doorCount = GetNumberOfVehicleDoors(veh)

        table.insert(doorSub, {
            id = 'all_open',
            title = 'All Opened',
            icon = 'mdi-car-door',
        })
        table.insert(doorSub, {
            id = 'all_close',
            title = 'All Closed',
            icon = 'mdi-car-door',
        })

        if IsVehicleClassACar(vehClass) then 
            table.insert(doorSub, {
                id = 4,
                title = 'Hood',
                icon = 'mdi-car-door',
            })
            table.insert(doorSub, {
                id = 5,
                title = 'Trunk',
                icon = 'mdi-car-door',
            })

            for d = 0, doorCount - 1 do 
                if d ~= 4 and d ~= 5 then 
                    table.insert(doorSub, {
                        id = d,
                        title = doorsNamed[d] or 'Door ' .. d,
                        icon = 'mdi-car-door',
                    })
                end
            end
        else
            for d = 0, doorCount do 
                table.insert(doorSub, {
                    id = d,
                    title = 'Door ' .. d + 1,
                    icon = 'mdi-car-door',
                })
            end
        end

        table.insert(vehMenuItems, {
            id = 'doors',
            title = 'Vehicle Doors',
            icon = 'mdi-car-door',
            secondary = doorSub,
        })
    end

    if #vehMenuItems == 0 then return end

    Components.Interaction:Menu({ title = GetVehicleNameForModel(GetEntityModel(veh)) or 'Vehicle', icon = 'mdi-car' }, vehMenuItems, function(p, s)
        local vehicleCoords = GetEntityCoords(veh)
        local pedCoords = GetEntityCoords(ARP.GblPed)

        local vehDist = #(vehicleCoords - pedCoords)

        if vehDist <= 10.0 then -- in case the vehicle drives off

            if p == 'store' then 
                local success = Components.Callbacks:Execute('Vehicles:Server:StorePublicGarage', vehVin, garageZone)
                print(success)
            elseif p == 'engine' and VEHICLE_INSIDE == veh and VEHICLE_SEAT == -1 then 
                ToggleVehiclesEngine()
            elseif p == 'lock' then 
                TriggerEvent('Vehicles:Client:TryKeys', veh)
            elseif p == 'hotwire' and VEHICLE_INSIDE == veh then
                TriggerEvent('Vehicles:Client:TryHotwire')
            elseif p == 'searchkeys' and VEHICLE_INSIDE == veh then 
                TriggerEvent('Vehicles:Client:TryKeySearch')
            elseif p == 'seats' then 
                TriggerEvent('Vehicles:Client:SwitchSeatsOfVehicle', s)
            elseif p == 'doors' and vehDist <= 5.0 then 
                if s == 'all_open' then 
                    for i = 0, 8 do 
                        SetVehicleDoorOpen(veh, i, false, false)
                    end
                elseif s == 'all_close' then
                    for i = 0, 8 do 
                        SetVehicleDoorShut(veh, i, false)
                    end
                else
                    local currentDoorState = GetVehicleDoorAngleRatio(veh, s)
                    if currentDoorState > 0.0 then -- open
                        SetVehicleDoorShut(veh, s, false)
                    else -- closed
                        SetVehicleDoorOpen(veh, s, false, false)
                    end
                end
            end
        end
    end)
end

RegisterNetEvent('Vehicles:Client:SwitchSeatsOfVehicle')
AddEventHandler('Vehicles:Client:SwitchSeatsOfVehicle', function(seat)
    if VEHICLE_INSIDE then 
        if IsVehicleSeatFree(VEHICLE_INSIDE, seat) then 
            SetPedIntoVehicle(ARP.GblPed, VEHICLE_INSIDE, seat)
        end
    end
end)
