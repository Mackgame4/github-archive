local vehicles = {}

local _vehicles = {}
local _particles = {}

local INPUT_CHARACTER_WHEEL = 21
local INPUT_VEH_ACCELERATE = 71
local INPUT_VEH_DUCK = 73

local exhaustNames = {
    "exhaust",    "exhaust_2",  "exhaust_3",  "exhaust_4",
    "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8",
    "exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12",
    "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"
}

function SetNitroBoostScreenEffectsEnabled(enabled)
    if enabled then
        SetTimecycleModifier('rply_motionblur')
    else
        SetTransitionTimecycleModifier('default', 0.35)
    end
end

function IsVehicleNitroBoostEnabled(vehicle)
    return vehicles[vehicle] == true
end

function SetVehicleNitroBoostEnabled(vehicle, enabled)
    if IsVehicleNitroBoostEnabled(vehicle) == enabled then
        return
    end
    if IsPedInVehicle(PlayerPedId(), vehicle) or not enabled then
        SetNitroBoostScreenEffectsEnabled(enabled)
    end
    SetVehicleBoostActive(vehicle, enabled)
    if enabled then
        CreateVehicleExhaustBackfire(vehicle, 1.75)
        SetVehicleEnginePowerMultiplier(vehicle, 30.0)
    else
        for k, v in ipairs(exhaustsBackfireFx) do
            StopParticleFxLooped(v, true)
        end
        SetVehicleEnginePowerMultiplier(vehicle, 0.0)
    end
    vehicles[vehicle] = enabled or nil
end

local function IsNitroControlPressed()
    if not IsInputDisabled(2) then
        DisableControlAction(2, INPUT_VEH_DUCK)
        return IsDisabledControlPressed(2, INPUT_VEH_DUCK)
    end
        return IsControlPressed(0, INPUT_CHARACTER_WHEEL)
    end
    local function IsDrivingControlPressed()
        return IsControlPressed(0, INPUT_VEH_ACCELERATE)
    end
    local function NitroLoop(lastVehicle)
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player)
        local driver = GetPedInVehicleSeat(vehicle, -1)
        local isEnabled = IsNitroControlPressed()
        local isDriving = IsDrivingControlPressed()
        local isRunning = GetIsVehicleEngineRunning(vehicle)
        local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
        local isPurging = IsVehicleNitroPurgeEnabled(vehicle)

        if lastVehicle ~= 0 and lastVehicle ~= vehicle then
            SetVehicleNitroBoostEnabled(lastVehicle, false)
            SetVehicleNitroPurgeEnabled(lastVehicle, false)
            TriggerServerEvent('Vehicles:Client:NitroSync', false, false, true)
        end

        if vehicle == 0 or driver ~= player then
            return 0
        end

        local model = GetEntityModel(vehicle)

        if not IsThisModelACar(model) or IsVehicleElectric(vehicle) then
            return 0
        end

        if isRunning and isEnabled then
            if isDriving then
            if not isBoosting then
                SetVehicleNitroBoostEnabled(vehicle, true)
                SetVehicleNitroPurgeEnabled(vehicle, false)
                TriggerServerEvent('Vehicles:Client:NitroSync', true, false, false)
            end
            else
            if not isPurging then
                SetVehicleNitroBoostEnabled(vehicle, false)
                SetVehicleNitroPurgeEnabled(vehicle, true)
                TriggerServerEvent('Vehicles:Client:NitroSync', false, true, false)
            end
            end
        elseif isBoosting or isPurging then
            SetVehicleNitroBoostEnabled(vehicle, false)
            SetVehicleNitroPurgeEnabled(vehicle, false)
            TriggerServerEvent('Vehicles:Client:NitroSync', false, false, false)
        end
    return vehicle
end

Citizen.CreateThread(function ()
    local lastVehicle = 0
    while true do
        Citizen.Wait(1)
        lastVehicle = NitroLoop(lastVehicle)
    end
end)

RegisterNetEvent('Vehicles:Client:NitroUpdate')
AddEventHandler('Vehicles:Client:NitroUpdate', function (playerServerId, boostEnabled, purgeEnabled, lastVehicle)
    local playerId = GetPlayerFromServerId(playerServerId)
    local player = GetPlayerPed(playerId)
    local vehicle = GetVehiclePedIsIn(player, lastVehicle)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    
    if not NetworkIsPlayerConnected(playerId) then
        return
    end

    SetVehicleNitroBoostEnabled(vehicle, boostEnabled)
    SetVehicleNitroPurgeEnabled(vehicle, purgeEnabled)
end)

-- https://gist.github.com/alexguirre/af70f0122957f005a5c12bef2618a786
function CreateVehicleExhaustBackfire(vehicle, scale)
    exhaustsBackfireFx = {}
    for _, exhaustName in ipairs(exhaustNames) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, exhaustName)
        if boneIndex ~= -1 then
            local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
            local dict = 'veh_xs_vehicle_mods'
            RequestNamedPtfxAsset(dict)
            while not HasNamedPtfxAssetLoaded(dict) do
                Citizen.Wait(1)
            end
            UseParticleFxAssetNextCall(dict)
            local particleEffect = StartParticleFxLoopedOnEntity('veh_nitrous', vehicle, off.x, off.y-0.2, off.z, 0.0, 0.0, 0.0, scale, false, false, false)
            --SetParticleFxLoopedColour(particleEffect, 250.0, 0.2, 0.2, false)
            table.insert(exhaustsBackfireFx, particleEffect)
        end
    end
end

function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
    UseParticleFxAssetNextCall('core')
    return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end

function IsVehicleNitroPurgeEnabled(vehicle)
    return _vehicles[vehicle] == true
end

function SetVehicleNitroPurgeEnabled(vehicle, enabled)
    if IsVehicleNitroPurgeEnabled(vehicle) == enabled then
        return
    end

    if enabled then
        local bone = GetEntityBoneIndexByName(vehicle, 'wheel_rf')
        local pos = GetWorldPositionOfEntityBone(vehicle, bone)
        local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
        local ptfxs = {}

        for i=0,3 do
            local leftPurge = CreateVehiclePurgeSpray(vehicle, -2*off.x + 0.8, off.y + 0.33, off.z+0.15, 35.0, -40.0, 0.0, 0.6)
            local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x, off.y + 0.33, off.z+0.15, 50.0, 35.0, 0.0, 0.6)
            table.insert(ptfxs, leftPurge)
            table.insert(ptfxs, rightPurge)
        end

        _vehicles[vehicle] = true
        _particles[vehicle] = ptfxs
    else
        if _particles[vehicle] and #_particles[vehicle] > 0 then
            for _, particleId in ipairs(_particles[vehicle]) do
                StopParticleFxLooped(particleId)
            end
        end

        _vehicles[vehicle] = nil
        _particles[vehicle] = nil
    end
end

local ELECTRIC_VEHICLES = {
    [GetHashKey('AIRTUG')] = true,
    [GetHashKey('CYCLONE')] = true,
    [GetHashKey('CADDY')] = true,
    [GetHashKey('CADDY2')] = true,
    [GetHashKey('CADDY3')] = true,
    [GetHashKey('DILETTANTE')] = true,
    [GetHashKey('IMORGON')] = true,
    [GetHashKey('KHAMEL')] = true,
    [GetHashKey('NEON')] = true,
    [GetHashKey('RAIDEN')] = true,
    [GetHashKey('SURGE')] = true,
    [GetHashKey('VOLTIC')] = true,
    [GetHashKey('VOLTIC2')] = true,
    [GetHashKey('TEZERACT')] = true
}

function IsVehicleElectric(vehicle)
    local model = GetEntityModel(vehicle)
    return ELECTRIC_VEHICLES[model] or false
end