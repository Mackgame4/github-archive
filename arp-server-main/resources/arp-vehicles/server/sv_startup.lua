function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        Components.Commands:AddConsole('gethash', function(args)
            local model = args[1]
            Logging:Debug('Vehicles', ('Model Hash For %q is %q'):format(string.upper(model), GetHashKey(model)))
        end)

        RegisterCommands()
    end

    if not c or c == 'Callbacks' then
        VehicleKeysRegisterCallbacks()

        Components.Callbacks:Register('Vehicles:Server:GetPublicGarage', function(src, cb, garageId)
            local Character = Characters:Source(src)
            if not Character or not _publicVehStorage[garageId] then return end
            local garageVehicles = {}
            local charactersVehicles = DB:Find('vehicles', { 
                ['$and'] = { 
                    { ['Owner.Type'] = 1 },
                    { ['Owner.Id'] = Character:GetData('CID') },
                    { ['Stored.Type'] = 1 },
                    { ['Stored.Id'] = tostring(garageId) },
                } 
            })
            if charactersVehicles.success and #charactersVehicles.docs > 0 then 
                for k, veh in ipairs(charactersVehicles.docs) do 
                    if VEHICLES.Owned:Get(veh.VIN) then 
                        charactersVehicles.docs[k] = nil
                    end
                end
                garageVehicles = charactersVehicles.docs
            end
            cb({ storedVehicles = garageVehicles })
        end)

        Components.Callbacks:Register('Vehicles:Server:StorePublicGarage', function(src, cb, vin, garageId)
            local Character = Characters:Source(src)
            if not Character or not _publicVehStorage[garageId] then return cb(false) end
            if DoesCharacterHaveKeys(src, vin) then -- check for having keys
                print('store')
                VEHICLES.Owned:Store(vin, 1, tostring(garageId))
                return cb(true)
            end
            cb(false)
        end)
    end

    if not c then 
        local vehicleCFetch = Components.DB:Count('vehicles', {})
        if vehicleCFetch.success and vehicleCFetch.count then 
            Components.Logging:Info('Vehicles', ('Loaded %s Owned Vehicles'):format(vehicleCFetch.count))
        end
        print('bs')
        StartSavingThread()
    end
end