local carClasses = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20 }

function IsVehicleClassACar(class)
    if ARP.DoesTableHaveValue(carClasses, class) then 
        return true 
    end
    return false
end

function GetVehicleNameForModel(model)
    if _vehNames[model] then return _vehNames[model] end
    if IsModelValid(model) then
        local display = GetDisplayNameFromVehicleModel(model)
        local name = GetLabelText(display)
        if name and name ~= 'NULL' then 
            return name 
        end
    end
    return false
end

function GetPedSeatInVehicle(veh, ped)
    local totalSeats = GetVehicleMaxNumberOfPassengers(veh)
    for i = -1, totalSeats do
        if GetPedInVehicleSeat(veh, i) == ped then 
            return i
        end
    end
    return false
end

function GetAllVehicleMissingDoors(veh)
    local broken = {}
    for door = 0, GetNumberOfVehicleDoors(veh) do 
        if IsVehicleDoorDamaged(veh, door) then 
            table.insert(broken, door)
        end
    end
    return broken
end

function SetAllVehicleMissingDoors(veh, missing)
    for door, _ in ipairs(missing) do 
        SetVehicleDoorBroken(veh, door, true)
    end
end

function GetAllVehicleBurstTyres(veh)
    local burst = {}
    for tyre = 0, 8 do 
        if IsVehicleTyreBurst(veh, tyre, true) then 
            table.insert(burst, tyre)
        end
    end
    return burst
end

function SetAllVehicleBurstTyres(veh, burst)
    for tyre, _ in ipairs(burst) do 
        SetVehicleTyreBurst(veh, tyre, false, 500.0)
    end
end

function SetAllVehicleTyresBurst(veh)
    for wheel = 0, 8 do 
        SetVehicleTyreBurst(veh, wheel, true, 1000.0)
    end
end

function GetClosestCoordPointToCoords(coords, coordPoints) 
    table.sort(coordPoints, function(a, b) 
        local distA = #(a.xyz - coords)
        local distB = #(b.xyz - coords)
        return distA < distB
    end)

    return coordPoints[1]
    --ARP.PrintTable(coordPoints)
end

function BlipVehicleHorn(veh, ms)
    local sounding = true
    Citizen.SetTimeout(ms, function() sounding = false end)
    Citizen.CreateThread(function()
        while sounding do 
            Citizen.Wait(0)
            SoundVehicleHornThisFrame(veh)
        end
    end)
end

function DoVehicleUnlockShit(veh)
    StartVehicleHorn(veh, 80, "HELDDOWN", false)
    SetVehicleLights(veh, 2)
    Citizen.Wait(200)
    SetVehicleLights(veh, 0)
    Citizen.Wait(200)
    SetVehicleLights(veh, 2)
    Citizen.Wait(200)
    SetVehicleLights(veh, 0)
end

function DoVehicleLockShit(veh)
    StartVehicleHorn(veh, 80, "HELDDOWN", false)
    Citizen.Wait(160)
    StartVehicleHorn(veh, 350, "HELDDOWN", false)
    SetVehicleLights(veh, 2)
    Citizen.Wait(200)
    SetVehicleLights(veh, 0)
    Citizen.Wait(200)
    SetVehicleLights(veh, 2)
    Citizen.Wait(200)
    SetVehicleLights(veh, 0)
end


--[[GetClosestCoordPoint(_publicVehStorage[1].spaces)

local drawCoords = GetClosestCoordPoint(_publicVehStorage[1].spaces)

RegisterCommand('veh:cl', function()
    drawCoords = GetClosestCoordPoint(_publicVehStorage[1].spaces)
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        print('s')
        if drawCoords then 
            DrawMarker(28, drawCoords.x, drawCoords.y, drawCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 255, 50, false, true, 2, nil, nil, false)
        end
    end
end)]]