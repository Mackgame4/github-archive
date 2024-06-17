exports('Play', function(src, sound, volume)
    TriggerClientEvent('Sounds:Client:Play', src, sound, volume)
end)

exports('PlayInDistance', function(coords, max, sound, volume)
    TriggerClientEvent('Sounds:Client:PlayInDistance', -1, coords, max, sound, volume)
end)