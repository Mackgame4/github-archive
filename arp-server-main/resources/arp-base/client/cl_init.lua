COMPONENTS = {}
COMPONENTS_REQUIRED = { 'Logging', 'UI', 'Menus', 'Characters' }

Citizen.CreateThread(function()
    repeat Wait(10) until exports and exports[GetCurrentResourceName()] ~= nil
    repeat Wait(10) until GlobalState.ARP and GlobalState.ARP.loaded
    TriggerEvent('ARP:Shared:Components:Init')
    repeat Wait(500) until AreComponentsLoaded(COMPONENTS_REQUIRED)
    Citizen.Wait(1800)
    
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    DoScreenFadeOut(1)

    Citizen.CreateThread(function()
        while true do
            if NetworkIsPlayerActive(PlayerId()) then
                TriggerEvent('ARP:Client:SessionStarted')
                TriggerServerEvent('ARP:Server:SessionStarted')
                break
            end
            Citizen.Wait(100)
        end
    end)
    
    TriggerEvent('ARP:PlayerPedChanged', PlayerPedId())

    Citizen.CreateThread(function() 

        for i = 1, 25 do
            EnableDispatchService(i, false)
        end

        SetMaxWantedLevel(0)
        SetCanAttackFriendly(ARP.GblPed, true, false)
        NetworkSetFriendlyFireOption(true)
        
        while true do
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()
            ---- Not sure whether these need to be ran every frame or not
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCops(false)
            SetCreateRandomCopsOnScenarios(false)
            Citizen.Wait(25000)
        end
    end)

    --[[Citizen.CreateThread(function()
        while true do
            SetPedHelmet(ped, false) do it as a flag
            if IsPedInAnyVehicle(ARP.GblPed, false) then -- probably should at this to some vehicle events when vehicles get done
                if GetPedInVehicleSeat(GetVehiclePedIsIn(ARP.GblPed, false), 0) == ARP.GblPed then
                    if GetIsTaskActive(ARP.GblPed, 165) then
                        SetPedIntoVehicle(ARP.GblPed, GetVehiclePedIsIn(ARP.GblPed, false), 0)
                    end
                end
            else
                Citizen.Wait(2000)
            end

            Citizen.Wait(5)
        end
    end)]]

    COMPONENTS.Logging:Info('ARP', 'AuthenticRP Base Has Started')
    COMPONENTS.Logging:Debug('ARP', 'Development Mode Active')
    TriggerEvent('ARP:Shared:Ready', 'all')
end)

AddEventHandler('playerSpawned', function()
    DoScreenFadeOut(500)
    local playerPed = PlayerPedId()
    TriggerEvent('ARP:PlayerPedChanged', playerPed)
    SetEntityCoords(playerPed, -1044.84, -2749.85, 21.36)
    SetEntityHeading(playerPed, 0)
    ShutdownLoadingScreen()
    DoScreenFadeIn(500)

    while not IsScreenFadingIn() do
        Citizen.Wait(10)
    end
end)

AddEventHandler('onClientMapStart', function()
    exports['spawnmanager']:setAutoSpawn(true)
    exports['spawnmanager']:forceRespawn()

    exports['spawnmanager']:spawnPlayer()
    Citizen.Wait(2500)
    --exports['spawnmanager']:setAutoSpawn(false)
end)