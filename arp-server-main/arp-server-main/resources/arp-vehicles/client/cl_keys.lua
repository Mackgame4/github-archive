local _myKeys = {}
local lastLock = 0

RegisterNetEvent('Vehicles:Client:InitialKeys')
AddEventHandler('Vehicles:Client:InitialKeys', function(keys)
    _myKeys = keys
end)

RegisterNetEvent('Vehicles:Client:RecieveKey')
AddEventHandler('Vehicles:Client:RecieveKey', function(vin)
    print('recieved key', vin)
    table.insert(_myKeys, vin)
end)

RegisterNetEvent('Vehicles:Client:RemoveKey')
AddEventHandler('Vehicles:Client:RemoveKey', function(vin)
    local keysExist = ARP.GetPositionInOrderedTable(_myKeys, vin)
    if keysExist ~= nil then 
        _myKeys[keysExist] = nil
    end
end)

function HasKeysToTargetVehicle(vin)
    if type(vin) == 'number' then -- a vehiclegw id was passed instead
        local veh = Entity(vin)
        if veh.state and veh.state.VIN then 
            vin = veh.state.VIN
        end
    end
    if type(vin) == 'string' then 
        if ARP.GetPositionInOrderedTable(_myKeys, vin) ~= nil then 
            return true
        end
    end
    return false
end

function IsTargetVehicleUnlocked(entity)
    if IsEntityAVehicle(entity) then 
        local veh = Entity(entity)
        if veh.state and veh.state.VIN then 
            if veh.state.locked then 
                return false
            else
                return true
            end
        end
    end
    return false
end

exports('HasKeysToTargetVehicle', HasKeysToTargetVehicle)
exports('IsTargetVehicleUnlocked', IsTargetVehicleUnlocked)

AddEventHandler('Vehicles:Client:TryKeys', function(veh)
    local now = GetGameTimer()
    if (now - lastLock) >= 1500 then 
        lastLock = now
        local vehEnt = Entity(veh)
        if vehEnt.state and vehEnt.state.VIN and HasKeysToTargetVehicle(vehEnt.state.VIN) then 
            if veh ~= VEHICLE_INSIDE then 
                Components.Animate.Emotes:Play('usekeys', false, false, true)
            end
            local lockState = Components.Callbacks:Execute('Vehicles:Server:ToggleLocks', VehToNet(veh))
            if lockState then 
                DoVehicleLockShit(veh)
                Components.Notify:Error('Vehicle Locked', false, 'mdi-car-key')
            else
                DoVehicleUnlockShit(veh)
                Components.Notify:Success('Vehicle Unlocked', false, 'mdi-car-key')
            end
        end
    end
end)

AddEventHandler('Vehicles:Client:TryKeysOnClose', function()
    if VEHICLE_INSIDE then 
        TriggerEvent('Vehicles:Client:TryKeys', VEHICLE_INSIDE)
    else
        local nearVeh = GetClosestVehicle(GetEntityCoords(ARP.GblPed), 4.0, 0, 71)
        if nearVeh > 0 then 
            TriggerEvent('Vehicles:Client:TryKeys', nearVeh)
        end
    end
end)