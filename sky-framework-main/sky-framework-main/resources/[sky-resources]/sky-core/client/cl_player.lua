Core.Player = nil
RegisterNetEvent('Core:Client:PlayerLoaded', function(data)
    while not Core.Modules.Proxy.ScriptsReady do Citizen.Wait(10) end
    --[[ if Core.Player ~= nil or data == nil then return end ]]
    Core.Player = Core.Modules.DataStore:Create(1, 'Player', data)
    while GetIsLoadingScreenActive() do
        Citizen.Wait(10)
    end
    Core.Modules.Logger:Info('Core', 'Player Data Received')
    TriggerEvent('Core:Shared:PlayerLoaded')
    TriggerServerEvent('Core:Shared:PlayerLoaded')
    Core.Internal.Ipl:Init()
end)