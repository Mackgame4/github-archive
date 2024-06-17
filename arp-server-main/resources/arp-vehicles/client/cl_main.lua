VEHICLE_INSIDE = false
VEHICLE_INSIDE_LAST = false
VEHICLE_INSIDE_CLASS = 0
VEHICLE_SEAT = false
VEHICLE_BELT = false
garageZone = false
local lastVehFetch = 0
local lastVehDamageUpdate = 0
local lastVehFuelUpdate = 0
local fetchedVehicles = false

function OnComponentUpdate(c)
    if not c then 
        AddInteractionPoints()
    end
end

function OnCharacterLoad()
    Citizen.CreateThread(function() -- main thread
        while CHAR_LOADED do 
            if VEHICLE_INSIDE then 
                if VEHICLE_SEAT == 0 then 
                    if GetIsTaskActive(ARP.GblPed, 165) then
                        SetPedIntoVehicle(ARP.GblPed, VEHICLE_INSIDE, 0)
                    end
                end
                if not IsPedInAnyVehicle(ARP.GblPed, false) then 
                    TriggerEvent('Vehicles:Client:ExitVeh', VEHICLE_INSIDE)
                    updateVehiclesPersistents()
                    VEHICLE_BELT = false
                    VEHICLE_INSIDE = false
                    VEHICLE_SEAT = false
                end
    
                if VEHICLE_SEAT ~= GetPedSeatInVehicle(VEHICLE_INSIDE, ARP.GblPed) then 
                    VEHICLE_SEAT = GetPedSeatInVehicle(VEHICLE_INSIDE, ARP.GblPed)
                    TriggerEvent('Vehicles:Client:SwitchVehSeat', VEHICLE_INSIDE, VEHICLE_SEAT)
                    if VEHICLE_SEAT == -1 then 
                        TriggerEvent('Vehicles:Client:BecameDriver')
                    end
                end
            elseif not VEHICLE_INSIDE and IsPedInAnyVehicle(ARP.GblPed, false) then 
                VEHICLE_INSIDE = GetVehiclePedIsIn(ARP.GblPed, false)
                VEHICLE_SEAT = GetPedSeatInVehicle(VEHICLE_INSIDE, ARP.GblPed)
                VEHICLE_INSIDE_LAST = VEHICLE_INSIDE
                VEHICLE_INSIDE_CLASS = GetVehicleClass(VEHICLE_INSIDE)
                VEHICLE_BELT = false
                TriggerEvent('Vehicles:Client:EnterVeh', VEHICLE_INSIDE, VEHICLE_SEAT)
                vehicleFuelUpdateThread()
                if VEHICLE_SEAT == -1 then 
                    TriggerEvent('Vehicles:Client:BecameDriver')
                end
            end
    
            if not VEHICLE_INSIDE then 
                local enter = GetVehiclePedIsTryingToEnter(ARP.GblPed)
                if enter ~= 0 then 
                    SetVehicleNeedsToBeHotwired(enter, false)
                end
            end
    
    
            local time = GetGameTimer()
            
            if (time - lastVehFuelUpdate) >= 1500 then 
                lastVehFuelUpdate = time
                vehicleFuelUpdateThread()
            end
    
            if (time - lastVehDamageUpdate) >= 10000 then 
                lastVehDamageUpdate = time
                updateVehiclesPersistents()
            end
    
            Citizen.Wait(250)
        end
    end)

    Citizen.CreateThread(function()
        while CHAR_LOADED do
            if VEHICLE_INSIDE and VEHICLE_SEAT == 0 then 
                if GetIsTaskActive(ARP.GblPed, 165) then
                    SetPedIntoVehicle(ARP.GblPed, VEHICLE_INSIDE, 0)
                end
            else
                Citizen.Wait(1000)
            end
            Citizen.Wait(10)
        end
    end)

    Citizen.CreateThread(function()
        local speedBuffers = {}
        local velBuffers = {}
        local minSpeed = 65
        while CHAR_LOADED do 
            if VEHICLE_INSIDE and IsVehicleClassACar(VEHICLE_INSIDE_CLASS) and not VEHICLE_BELT then
                speedBuffers[2] = speedBuffers[1]
                speedBuffers[1] = GetEntitySpeed(VEHICLE_INSIDE)

                if speedBuffers[2] ~= nil and GetEntitySpeedVector(VEHICLE_INSIDE, true).y > 1.0 and speedBuffers[1] > (minSpeed / 3.6) and (speedBuffers[2] - speedBuffers[1]) > (speedBuffers[1] * 0.255) then
                    local pedCoords = GetEntityCoords(ARP.GblPed)
                    local fw = Fwv(ARP.GblPed)
                    SetEntityCoords(ARP.GblPed, pedCoords.x + fw.x, pedCoords.y + fw.y, pedCoords.z - 0.4, true, true, true)
                    SetEntityVelocity(ARP.GblPed, velBuffers[2].x, velBuffers[2].y, velBuffers[2].z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(ARP.GblPed, 1000, 1000, 0, 0, 0, 0)
                end

                velBuffers[2] = velBuffers[1]
                velBuffers[1] = GetEntityVelocity(VEHICLE_INSIDE)
                Citizen.Wait(50)
            else
                speedBuffers = {}
                velBuffers = {}
                Citizen.Wait(4000)
            end
        end
    end)
end

function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

AddEventHandler('Vehicles:Client:BecameDriver', function() -- fired when entering vehc
    if VEHICLE_INSIDE then 
        if not GetIsVehicleEngineRunning(VEHICLE_INSIDE) then -- Engine is Not On
            ToggleVehiclesEngine()
        else
            local veh = VEHICLE_INSIDE
            local vehEnt = Entity(veh)
            if vehEnt.state.VIN and not vehEnt.state.owned and not vehEnt.state.hotwired and not vehEnt.state.keysFound then 
                TriggerServerEvent('Vehicles:Server:StolenTraffic', VehToNet(veh))
            end
        end
    end
end)


AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'vehicleToggleEngine' then 
        ToggleVehiclesEngine()
    elseif key == 'vehicleSeatbelt' then
        if CHAR_LOADED and VEHICLE_INSIDE then 
            VEHICLE_BELT = not VEHICLE_BELT
            if VEHICLE_BELT then 
                exports['arp-sounds']:Play('seatbelt-on', 0.4)
                Components.Notify:Success('Seatbelt On', false, 'mdi-seatbelt')
                Citizen.CreateThread(function()
                    while VEHICLE_BELT do 
                        DisableControlAction(0, 75, true)
                        Citizen.Wait(5)
                    end
                end)
            else
                exports['arp-sounds']:Play('seatbelt-off', 0.2)
                Components.Notify:Error('Seatbelt Off', false, 'mdi-seatbelt')
            end
        end
    end
end)

function ToggleVehiclesEngine()
    if CHAR_LOADED and not CHAR_DEAD and VEHICLE_INSIDE and VEHICLE_SEAT == -1 then 
        local fuelLevel = getTrackedVehicleFuel(VEHICLE_INSIDE)
        local engineOn = GetIsVehicleEngineRunning(VEHICLE_INSIDE)
        if engineOn then -- you don't need the keys to turn off the engine
            SetVehicleEngineOn(VEHICLE_INSIDE, false, false, true)
            SetVehicleFuelLevel(VEHICLE_INSIDE, 0.0)
            Components.Notify:Error('Engine Stopped', false, 'mdi-engine')
        else
            local vehEnt = Entity(VEHICLE_INSIDE)
            if not vehEnt or not vehEnt.state then return end
            local hasKeys = HasKeysToTargetVehicle(vehEnt.state.VIN)
            local prevHotwired = vehEnt.state.hotwired
            if hasKeys or prevHotwired then 
                exports['arp-sounds']:Play('seatbelt-alarm', 0.2)
                local fuckedEngine = false
                if fuelLevel then 
                    if fuelLevel < 1.0 then 
                        fuckedEngine = true
                    elseif fuelLevel <= 8.0 and fuelLevel >= 1 then
                        if ARP.RandomNumber(1, ARP.Round(fuelLevel * 2, 0)) == 1 then 
                            fuckedEngine = true
                        end
                    end
                end

                Citizen.Wait(400)
                
                if fuckedEngine then 
                    SetVehicleFuelLevel(VEHICLE_INSIDE, 0.0)
                    SetVehicleEngineOn(VEHICLE_INSIDE, true, false, true) -- still attept start for fucked sound effects
                    Components.Notify:Error('Engine Start Failed', 'There is no fuel left in this vehicle.', 'mdi-engine-off')
                else
                    SetVehicleFuelLevel(VEHICLE_INSIDE, 100.0)
                    SetVehicleEngineOn(VEHICLE_INSIDE, true, false, true)
                    if prevHotwired then 
                        Components.Notify:Success('Engine Started', 'This vehicle has clearly been hotwired.', 'mdi-engine')
                    else
                        Components.Notify:Success('Engine Started', false, 'mdi-engine')
                    end
                end
            else
                Components.Notify:Error('Engine Start Failed', 'You don\'t have the keys.', 'mdi-engine-off')
                SetVehicleFuelLevel(VEHICLE_INSIDE, 0.0)
                local veh = VEHICLE_INSIDE
                local blocking = true
                Citizen.SetTimeout(1500, function() blocking = false end)
                Citizen.CreateThread(function()
                    while CHAR_LOADED and blocking do 
                        SetVehicleEngineOn(veh, false, false, true)
                        Citizen.Wait(5)
                    end
                end)
            end
        end
    end
end

RegisterNetEvent('Vehicles:Client:FunEjection')
AddEventHandler('Vehicles:Client:FunEjection', function()
    TaskLeaveAnyVehicle(ARP.GblPed)
end)