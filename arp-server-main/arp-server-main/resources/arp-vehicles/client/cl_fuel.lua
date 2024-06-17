local classConsumptionOverrides = {
    --[0] = 1.0, -- Compacts
	--[1] = 1.0, -- Sedans
	--[2] = 1.0, -- SUVs
	--[3] = 1.0, -- Coupes
	--[4] = 1.0, -- Muscle
	--[5] = 1.0, -- Sports Classics
	--[6] = 1.0, -- Sports
	--[7] = 1.0, -- Super
	--[8] = 1.0, -- Motorcycles
	--[9] = 1.0, -- Off-road
	--[10] = 1.0, -- Industrial
	--[11] = 1.0, -- Utility
	--[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	--[14] = 1.0, -- Boats
	--[15] = 1.0, -- Helicopters
	--[16] = 1.0, -- Planes
	--[17] = 1.0, -- Service
	--[18] = 1.0, -- Emergency
	--[19] = 1.0, -- Military
	--[20] = 1.0, -- Commercial
	--[21] = 1.0, -- Trains
}

local modelConsumptionOverrides = {

}

local trackedVeh = 0
local trackedFuel = 100
local trackedVehConsumption = 1.0
local trackedVehEntity = false

function getTrackedVehicleFuel(veh)
    if trackedVeh == veh then 
        return trackedFuel 
    end
    return false
end

function vehicleFuelUpdateThread()
    if VEHICLE_INSIDE_LAST and DoesEntityExist(VEHICLE_INSIDE_LAST) and (VEHICLE_SEAT == -1 or (GetPedInVehicleSeat(VEHICLE_INSIDE_LAST, -1) == 0 and NetworkHasControlOfEntity(VEHICLE_INSIDE_LAST))) then 
        
        if VEHICLE_INSIDE_LAST ~= trackedVeh then 
            print('newVeh')
            local vehClass = GetVehicleClass(trackedVeh)
            if vehClass == 13 then return end -- its a bike - they don't have fuel
            trackedVeh = VEHICLE_INSIDE_LAST
            trackedVehEntity = Entity(VEHICLE_INSIDE_LAST)
            print(trackedVehEntity.state.fuel)
            if trackedVehEntity.state and type(trackedVehEntity.state.fuel) == 'number' then 
                trackedFuel = trackedVehEntity.state.fuel
            else
                trackedFuel = ARP.RandomNumber(20, 100)
            end
            local vehModel = GetEntityModel(trackedVeh)
            trackedVehConsumption = classConsumptionOverrides[vehClass] or 1.0
            if modelConsumptionOverrides[vehModel] then 
                trackedVehConsumption = modelConsumptionOverrides[vehModel]
            end
        end
        
        
        if not trackedVehEntity then return end
        
        if GetVehicleClass(trackedVeh) ~= 13 and GetIsVehicleEngineRunning(trackedVeh) then 
            local currentFuel = trackedFuel
            local vehRPM = ARP.Round(GetVehicleCurrentRpm(trackedVeh), 1)
            --print(trackedVeh, 'rpm', vehRPM, trackedVehConsumption, GetVehicleCurrentRpm(trackedVeh, trackedVeh))
    
            local currentConsumption = ((vehRPM * 1.4) * trackedVehConsumption) / 5
            --print('consump', currentConsumption)
            -- do a speed check for vehicles going extra fast multiplyer
            local newFuel = currentFuel - currentConsumption
            if newFuel < 0.0 then newFuel = 0.0 end
            trackedFuel = ARP.Round(newFuel, 3)
            --print('tfuel', trackedFuel)
            if trackedFuel < 1.0 then 
                SetVehicleEngineOn(trackedVeh, false, false, true)
                SetVehicleFuelLevel(trackedVeh, 0.0)
            elseif trackedFuel <= 10.0 and trackedFuel >= 1.0 then 
                local multi = (trackedFuel <= 5.0) and 2 or 4
                if ARP.RandomNumber(1, ARP.Round(trackedFuel * multi, 0)) == 1 then 
                    SetVehicleEngineOn(trackedVeh, false, false, true)
                    SetVehicleFuelLevel(trackedVeh, 0.0)
                end
            end

            TriggerEvent('Vehicles:Client:UpdateFuel', trackedFuel)
        end
    else
        trackedVeh = 0
        trackedVehEntity = false
    end
end

