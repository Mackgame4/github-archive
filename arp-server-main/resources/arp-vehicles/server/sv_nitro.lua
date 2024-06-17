RegisterNetEvent('Vehicles:Client:NitroSync')
AddEventHandler('Vehicles:Client:NitroSync', function (boostEnabled, purgeEnabled, lastVehicle)
    local source = source
    for _, player in ipairs(GetPlayers()) do
        if player ~= tostring(source) then
            TriggerClientEvent('Vehicles:Client:NitroUpdate', player, source, boostEnabled, purgeEnabled, lastVehicle)
        end
    end
end)