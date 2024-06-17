function RegisterCommands()

    Components.Commands:Add('seat', function(src, args)
        local seat = tonumber(args[1])
        if seat and seat >= 1 and seat <= 14 then 
            TriggerClientEvent('Vehicles:Client:SwitchSeatsOfVehicle', -1, seat - 2)
        end
    end, 'Switch Vehicle Seat', {
        { name = 'Seat Number', help = 'Seat number from 1-14' },
    }, false)

    Components.Commands:AddStaff('delveh', function(src, args)
        local target = Components.Callbacks:Execute(src, 'Admin:Client:GetEntityLookingAt', true)
        if target and target.type == 2 and target.entity then 
            local entity = NetworkGetEntityFromNetworkId(target.entity)
            local entityModel = GetEntityModel(entity)
            if DoesEntityExist(entity) then 
                local owner = 'N/A'
                local vehEnt = Entity(entity)
                if vehEnt.state.owned and vehEnt.state.VIN then 
                    if VEHICLES.Owned:Get(vehEnt.state.VIN) then 
                        owner = vehEnt.state.VIN
                        VEHICLES.Owned:Store(vehEnt.state.VIN)
                    else
                        DeleteEntity(entity)
                    end
                else
                    DeleteEntity(entity)
                end
                Components.Logging:Info('Admin', ('Vehicle %s (Model: %s, Owned: %s) Deleted By %s'):format(entity, entityModel, owner, Users:GenerateLogStringSrc(src)))
                TriggerClientEvent('Client:Notify', src, 'success', 'Deleted Vehicle', owner ~= 'N/A' and ('Owned, VIN: ' .. owner) or false, 'mdi-cog')
                return
            end
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Delete Vehicle', false, 'mdi-cog')
    end, 'Delete the vehicle you are looking at or are inside of')

    Components.Commands:AddStaff('veh', function(src, args)
        if not args[1] then return end
        local input = string.upper(args[1])
        local vehModel = GetHashKey(args[1])
        local spawnPoint = Components.Callbacks:Execute(src, 'Admin:Client:GetVehicleSpawningData', vehModel)
        local spawnHeading = (GetEntityHeading(GetPlayerPed(src)) - 90.0)
        if spawnPoint then 
            local sp = vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z + 0.6)
            local success = VEHICLES.Temp:Spawn(src, vehModel, sp, spawnHeading)
            if success then
                TriggerClientEvent('Client:Notify', src, 'success', 'Vehicle Spawned', input, 'mdi-cog')
                Components.Logging:Info('Admin', ('Vehicle (Model: %s) Spawned By %s'):format(input, Components.Users:GenerateLogStringSrc(src)))
            else
                TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Spawn', 'Error', 'mdi-cog')
            end
        else
            TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Spawn', 'Invalid Vehicle Model or Too Far Away', 'mdi-cog')
        end
    end, 'Spawn a vehicle where you are looking', {
        { name = 'Model', help = 'The Vehicle\'s Model Name' },
    })


    Components.Commands:AddStaff('playergrantveh', function(src, args, raw)
        local target = tonumber(args[1])
        if target ~= nil and target > 0 then 
            local targetCharacter
            if target >= 10000 then 
                targetCharacter = Components.Characters:CID(target)
            else
                targetCharacter = Components.Characters:Source(target)
            end
            if targetCharacter and targetCharacter:GetData('_Loaded') then
                local myPed = GetPlayerPed(targetCharacter:GetData('Source'))
                local pedVehicle = GetVehiclePedIsIn(myPed, false)
                if pedVehicle > 0 and DoesEntityExist(pedVehicle) then 
                    local vehEnt = Entity(pedVehicle)
                    if vehEnt.state and vehEnt.state.VIN then 
                        if not DoesCharacterHaveKeys(targetCharacter:GetData('Source'), vehEnt.state.VIN) then 
                            AddVehicleKeysToChar(targetCharacter:GetData('Source'), vehEnt.state.VIN)
                            TriggerClientEvent('Client:Notify', src, 'success', 'Successfully Granted Keys', false, 'mdi-cog')
                        end
                        return
                    end
                end
            end
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Granting Keys Failed', 'Invalid Target', 'mdi-cog')
    end, 'Grant Player Keys to a Vehicle', {
        { name = 'ID', help = 'Server ID or Character ID', required = true },
    }, true)

    Components.Commands:AddStaff('playerejectveh', function(src, args, raw)
        local target = tonumber(args[1])
        if target ~= nil and target > 0 then 
            local targetCharacter
            if target >= 10000 then 
                targetCharacter = Components.Characters:CID(target)
            else
                targetCharacter = Components.Characters:Source(target)
            end
            if targetCharacter and targetCharacter:GetData('_Loaded') then
                local myPed = GetPlayerPed(targetCharacter:GetData('Source'))
                local pedVehicle = GetVehiclePedIsIn(myPed, false)
                if pedVehicle > 0 and DoesEntityExist(pedVehicle) then 
                    TriggerClientEvent('Vehicles:Client:FunEjection', targetCharacter:GetData('Source'))
                    TriggerClientEvent('Client:Notify', src, 'success', 'Successfully Ejected', false, 'mdi-cog')
                    return
                end
            end
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Ejection Failed', 'Invalid Target', 'mdi-cog')
    end, 'Eject Player from Vehicle', {
        { name = 'ID', help = 'Server ID or Character ID', required = true },
    })
end