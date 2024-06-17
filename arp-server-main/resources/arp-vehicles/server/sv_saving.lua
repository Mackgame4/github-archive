local _avoidSave = { '_id', 'VIN', 'Entity' }

function SaveVehicle(vin)
    local vehStore = Components.Vehicles.Owned:Get(vin)
    if vehStore then
        local vehEntityId = vehStore:GetData('Entity')
        local vehVin = vehStore:GetData('VIN')
        if vehEntityId and vehVin then
            if DoesEntityExist(vehEntityId) then
                local vehEntity = Entity(vehEntityId)
                print('found entity')
                -- Get fuel level and other shit like that
                --vehStore:SetData('Fuel', veh.st)
            end

            local vehicleData = vehStore:GetData()
            for _, v in ipairs(_avoidSave) do vehicleData[v] = nil end
            for key, data in pairs(vehicleData) do
                if ARP.StringStartsWith(key, '_') then -- so we can have temp data
                    vehicleData[key] = nil
                end
            end

            local success = Components.DB:UpdateOne('vehicles', { VIN = vehVin }, { ['$set'] = vehicleData })
            print(success.success)
        end
    end
end

function StartSavingThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(300000) -- 5 mins
            local count = 0
            for vin, _ in pairs(ActiveOwnedVehicles) do 
                SaveVehicle(vin)
                count = count + 1
            end
            if count > 0 then 
                Components.Logging:Info('Vehicles', ('Synced %d Vehicle\'s'):format(count), { skipDiscord = true })
            end
        end
    end)
end