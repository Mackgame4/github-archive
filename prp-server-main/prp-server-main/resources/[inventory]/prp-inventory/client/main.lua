ESX = nil
ESXLoaded = false
local tempDisableAnim = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(50)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    Citizen.Wait(500)
    ESXLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    if not tempDisableAnim then
        loadAnimDict('pickup_object')
        TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
        Wait(1000)
        ClearPedSecondaryTask(PlayerPedId())
    end
end)

RegisterNetEvent('prp-inventory:tempDisableAnim')
AddEventHandler('prp-inventory:tempDisableAnim', function()
    if not tempDisableAnim then
        CreateThread(function()
            tempDisableAnim = true
            Wait(10000)
            tempDisableAnim = false
        end)
    end
end)

local dropSecondaryInventory = {
    type = 'drop',
    owner = 'x123y123z123'
}

local isInInventory = false

local trunkSecondaryInventory = {
    type = 'trunk',
    owner = 'XYZ123'
}

local openVehicle

local gloveBoxSecondaryInventory = {
    type = 'glovebox',
    owner = 'XYZ123'
}

RegisterNUICallback('NUIFocusOff', function(data)
    closeInventory()
end)

RegisterCommand('closeinv', function(source, args, raw)
    closeInventory()
end)

local canOpenInventoryToggle = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESXLoaded and canOpenInventoryToggle then
            if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
                local playerPed = PlayerPedId()
                local isDead = IsPedDeadOrDying(playerPed)
                if IsPedInAnyVehicle(playerPed) and not isDead then
                    tryglovebox()
                else
                    trytrunk()
                end
            end
        end
    end
end)

function tryglovebox()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed)
    if DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        local class = GetVehicleClass(vehicle)

        gloveBoxSecondaryInventory.owner = plate
        gloveBoxSecondaryInventory.type = 'glovebox'..class
        openInventory(gloveBoxSecondaryInventory)
        TriggerEvent('prp-inventory:removeCurrentWeapon')
    end
end

function trytrunk()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) and GetVehiclePedIsIn(playerPed) == 0 then
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        local _, floorZ = GetGroundZFor_3dCoord(x, y, z)
        dropSecondaryInventory.owner = getOwnerFromCoords(vector3(x, y, floorZ))
        Citizen.Wait(50) 
        openInventory(dropSecondaryInventory) 
        TriggerEvent('prp-inventory:removeCurrentWeapon')
        local locked = GetVehicleDoorLockStatus(vehicle) == 2
        local hasBoot = DoesVehicleHaveDoor(vehicle, 5)
        if not locked then
            local boneIndex = GetEntityBoneIndexByName(vehicle, 'platelight')
            local vehicleCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(vehicleCoords - playerCoords)
            if distance < 3 then
                local plate = GetVehicleNumberPlateText(vehicle)
                trunkSecondaryInventory.owner = plate
                openVehicle = vehicle
                local class = GetVehicleClass(vehicle)
                trunkSecondaryInventory.type = 'trunk' .. class
                SetVehicleDoorOpen(openVehicle, 5, false)
                openInventory(trunkSecondaryInventory)
                local playerPed = GetPlayerPed(-1)
                if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
                    ESX.Streaming.RequestAnimDict('mini@repair', function()
                        TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
                    end)
                end
            end
        else
            print("Target vehicle is locked.")
        end
    else
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        local _, floorZ = GetGroundZFor_3dCoord(x, y, z)
        dropSecondaryInventory.owner = getOwnerFromCoords(vector3(x, y, floorZ))
        Citizen.Wait(50) 
        openInventory(dropSecondaryInventory) 
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        closeInventory()
    end
end)

RegisterNetEvent('closeInventory')
AddEventHandler('closeInventory', function()
    closeInventory()
end)

RegisterNUICallback('NUIFocusOff', function()
    if openVehicle ~= nil then
        SetVehicleDoorShut(openVehicle, 5, false)
        openVehicle = nil
        ClearPedSecondaryTask(GetPlayerPed(-1))
    end
end)




function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
  end


RegisterNetEvent('pay:animation')
AddEventHandler('pay:animation', function()
    local player = GetPlayerPed(-1)
    ESX.Streaming.RequestAnimDict('mp_common', function()
        TaskPlayAnim( player, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    end)
    Citizen.Wait(2400)
    ClearPedTasksImmediately(player)
end)

RegisterNetEvent("disc-inventoryhud:TempDisable")
AddEventHandler("disc-inventoryhud:TempDisable", function()
    CreateThread(function()
        canOpenInventoryToggle = false
        Wait(15000)
        canOpenInventoryToggle = true
    end)
end)

RegisterNetEvent("disc-inventoryhud:ForceDisable")
AddEventHandler("disc-inventoryhud:ForceDisable", function(bool)
    canOpenInventoryToggle = not bool
end)

RegisterNUICallback('invlog', function(data, cb)
    TriggerServerEvent('prp-inventory:invlog', data)
    cb()
end)

RegisterCommand("invsee", function(source, args, rawCommand)
    openInventory({type = args[1], owner = args[2]})
end)