AI_VINS = {}

VEHICLES.VIN = {
    Random = function(self, owned)
        return exports['arp-libs']:GenerateVIN(owned)
    end,
    GenerateOwned = function(self)
        local vin = Components.Vehicles.VIN:Random(true)
        while IsOwnedVINTaken(vin) do 
            vin = Components.Vehicles.VIN:Random(true)
            Citizen.Wait(100)
        end

        return vin
    end,
    GenerateAI = function(self, entityId)
        local vin = Components.Vehicles.VIN:Random(false)
        while ARP.GetPositionInTable(AI_VINS, vin) ~= nil do
            vin = Components.Vehicles.VIN:Random(false)
        end

        AI_VINS[entityId] = vin
        return vin
    end,
}

VEHICLES.Plates = {
    Random = function(self)
        return exports['arp-libs']:GeneratePlate()
    end,
    GenerateOwned = function(self)
        local plate = Components.Vehicles.Plates:Random()
        while IsPlateTaken(plate) do 
            plate = Components.Vehicles.Plates:Random()
            Citizen.Wait(100)
        end

        return plate
    end
}

function IsOwnedVINTaken(vin) -- should probably add a local table for ai VINS
    local res = Components.DB:FindOne('vehicles', { VIN = vin })
    if res.success and #res.docs <= 0 then 
        return false
    end
    return true
end

function IsPlateTaken(plate) -- also add checks for fake plates
    local res = Components.DB:FindOne('vehicles', { Plate = plate })
    if res.success and #res.docs <= 0 then 
        return false
    end
    return true
end