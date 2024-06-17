local keysToDisabled = {
    21, -- 
    24, -- attack,
    25, -- aim,
    30,
    31,
    32, 
    33, 
    34, 
    35,
    59, -- veh d
    63, -- veh a
    64, -- veh d
    71, -- veh accelerate
    72, -- veh brakes
    75, -- veh exit
    77,
    78,
}

local _hotwireAttempts = {}
local _keySeachAttempts = {}

CURRENTLY_HOTWIRING = false
CURRENTLY_SEARCHING = false

RegisterNetEvent('Vehicles:Client:TryHotwire')
AddEventHandler('Vehicles:Client:TryHotwire', function()
    if VEHICLE_INSIDE and VEHICLE_SEAT == -1 and not CURRENTLY_HOTWIRING and not CURRENTLY_SEARCHING then -- should proably make sure the vehicle is a car, you can't really hotwire a plane
        local veh = Entity(VEHICLE_INSIDE)
        if veh.state and veh.state.VIN and not veh.state.hotwired and not HasKeysToTargetVehicle(veh.state.VIN) then 
            local attempts = 1
            if not _hotwireAttempts[VEHICLE_INSIDE] then _hotwireAttempts[VEHICLE_INSIDE] = 1 else attempts = _hotwireAttempts[VEHICLE_INSIDE] end
    
            if attempts < 3 then 
    
                print(_hotwireAttempts[VEHICLE_INSIDE])
                local totalHotwireTime = 8000 + (5000 * attempts)
                CURRENTLY_HOTWIRING = true
                local progress = Components.Notify.Progress:Start(totalHotwireTime, 'error', 'Attempting Hotwire', 'mdi-car-cog', keysToDisabled, 'vehhotwiring')
                if progress then 
                    if ARP.RandomNumber(0, 100) >= 40 then -- 60% chance of success
                        print('success')
                        veh.state:set('hotwired', true, true)
                        ToggleVehiclesEngine()
                    else
                        Components.Notify:Error('Hotwire Failed', false, 'mdi-car-cog')
                    end
                    _hotwireAttempts[VEHICLE_INSIDE] = attempts + 1
                end
                CURRENTLY_HOTWIRING = false
            end
        end
    end
end)

RegisterNetEvent('Vehicles:Client:TryKeySearch')
AddEventHandler('Vehicles:Client:TryKeySearch', function()
    if VEHICLE_INSIDE and VEHICLE_SEAT == -1 and not CURRENTLY_HOTWIRING and not CURRENTLY_SEARCHING then
        local veh = Entity(VEHICLE_INSIDE)
        if veh.state and veh.state.VIN and not veh.state.hotwired and not HasKeysToTargetVehicle(veh.state.VIN) then 
            if not _keySeachAttempts[VEHICLE_INSIDE] then
                CURRENTLY_SEARCHING = true
                local progress = Components.Notify.Progress:Start(10000, 'error', 'Seaching Vehicle For Keys', 'mdi-car-key', keysToDisabled, false)
                if progress then 
                    if ARP.RandomNumber(0, 100) >= 85 then -- 15% chance of success
                        TriggerServerEvent('Vehicles:Server:FoundKeys', VehToNet(VEHICLE_INSIDE))
                    else
                        Components.Notify:Error('Couldn\'t find keys', false, 'mdi-car-key')
                    end
                    _keySeachAttempts[VEHICLE_INSIDE] = true
                end
                CURRENTLY_SEARCHING = false
            else
                Components.Notify:Error('Already searched vehicle', false, 'mdi-car-key')
            end
        end
    end
end)

function CanSeachVehicleForKeys(veh)
    if not _keySeachAttempts[veh] then 
        return true
    end
    return false
end

function CanHotwireAVehicle(veh) 
    if not _hotwireAttempts[veh] then 
        return true
    elseif _hotwireAttempts[veh] and _hotwireAttempts[veh] < 3 then 
        return true
    end
    return false
end