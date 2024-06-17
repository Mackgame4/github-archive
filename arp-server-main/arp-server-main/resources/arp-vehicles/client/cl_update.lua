

function updateVehiclesPersistents() -- every 10 sec
    if VEHICLE_INSIDE_LAST and DoesEntityExist(VEHICLE_INSIDE_LAST) and (VEHICLE_SEAT == -1 or (GetPedInVehicleSeat(VEHICLE_INSIDE_LAST, -1) == 0 and NetworkHasControlOfEntity(VEHICLE_INSIDE_LAST))) then 
        local veh = Entity(VEHICLE_INSIDE_LAST)
        print('update', VEHICLE_INSIDE_LAST)
        local fuel = getTrackedVehicleFuel(VEHICLE_INSIDE_LAST)
        if veh.state.owned and veh.state.VIN then 
            if fuel then veh.state:set('fuel', fuel, true) end
            local bodyHealth = GetVehicleBodyHealth(VEHICLE_INSIDE_LAST)
            local dirtLevel = ARP.Round(GetVehicleDirtLevel(VEHICLE_INSIDE_LAST), 1)
            if bodyHealth >= 800.0 then bodyHealth = 1000.0 end
            veh.state:set('damage', {
                bodyHealth = bodyHealth,
                dirtLevel = dirtLevel,
                missingDoors = GetAllVehicleMissingDoors(VEHICLE_INSIDE_LAST),
                burstTyres = GetAllVehicleBurstTyres(VEHICLE_INSIDE_LAST)
            }, true)
        elseif fuel then
            veh.state:set('fuel', fuel)
        end
    end
end