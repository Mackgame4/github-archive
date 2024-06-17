VEHICLE_INSIDE = false
VEHICLE_DRIVER = false
VEHICLE_FUEL = 100
VEHICLE_ENGINE = false
VEHICLE_CANFLY = false
VEHICLE_SPEED = 0

local VEH_TICK = 0
local MMAP_TICK = 0

function getVehicleStateData(veh)
    local entity = Entity(veh)
    if entity and entity.state and entity.state.VIN then
        return entity.state
    else
        return {}
    end
end

function GetHUDVehicleData()
    if VEHICLE_INSIDE then 
        local vData = getVehicleStateData(VEHICLE_INSIDE)
        return {
            inside = VEHICLE_INSIDE,
            driver = VEHICLE_DRIVER,
            engine = GetIsVehicleEngineRunning(VEHICLE_INSIDE),
            cruise = false,
            indicators = 0,
            fuel = (vData.fuel ~= nil) and math.floor(vData.fuel) or 0,
            flying = VEHICLE_CANFLY,
            seatbelt = not Components.Vehicles:GetSeatbeltWarningState(),
            ems = false,
            emsLights = false,
        }
    else
        return {
            inside = false,
            driver = false,
            engine = false,
            cruise = false,
            seatbelt = true,
            indicators = 0,
            fuel = 100,
            flying = false,
            ems = false,
            emsLights = false,
        }
    end
end

Citizen.CreateThread(function() 
    while true do 
        if CHAR_LOADED and VEHICLE_INSIDE then 
            VEHICLE_SPEED = math.floor(GetEntitySpeed(VEHICLE_INSIDE) * 2.237)
            if VEHICLE_CANFLY then 
                sendNUI('updateVehicleSpeed', {
                    speed = VEHICLE_SPEED,
                    altitude = math.floor(GetEntityHeightAboveGround(VEHICLE_INSIDE) * 3.281),
                })
            else
                sendNUI('updateVehicleSpeed', {
                    speed = VEHICLE_SPEED,
                    altitude = 0,
                })
            end
        else
            Citizen.Wait(2500)
        end
        Citizen.Wait(150)
    end
end)


AddEventHandler('Vehicles:Client:ExitVeh', function()
    VEHICLE_INSIDE = false
    VEHICLE_DRIVER = false
    VEHICLE_CANFLY = false
    UpdateRadarState()
end)

AddEventHandler('Vehicles:Client:EnterVeh', function(VEH, SEAT)
    VEHICLE_INSIDE = VEH

    if SEAT == -1 then 
        VEHICLE_DRIVER = true
    else
        VEHICLE_DRIVER = false
    end

    VEHICLE_CANFLY = false
    local vehClass = GetVehicleClass(VEHICLE_INSIDE)
    if vehClass == 15 or vehClass == 16 then 
        VEHICLE_CANFLY = true
    end

    UpdateRadarState()

    --[[Citizen.CreateThread(function()
        --SetEntityMaxSpeed(VEHICLE_INSIDE, 32.0)
        SetEntityMaxSpeed(VEHICLE_INSIDE, 320.0)
        while VEHICLE_INSIDE do 
            if VEHICLE_SPEED > 66 then 
                SetVehicleCurrentRpm(VEHICLE_INSIDE, 0.5)
            end
            Citizen.Wait(0)
        end
    end)]]
end)

AddEventHandler('Vehicles:Client:SwitchVehSeat', function(VEH, SEAT)
    if SEAT == -1 then 
        VEHICLE_DRIVER = true
    else
        VEHICLE_DRIVER = false
    end
end)

AddEventHandler('Vehicles:Client:UpdateFuel', function(fuel)
    VEHICLE_FUEL = fuel
end)