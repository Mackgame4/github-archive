function PlaySound(sound, volume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = sound,
        transactionVolume   = volume
    })
end

exports('Play', PlaySound)

function StopSound()
    SendNUIMessage({
        transactionType     = 'stopSound',
    })
end

exports('Stop', StopSound)

RegisterNetEvent('Sounds:Client:Play')
AddEventHandler('Sounds:Client:Play', function(soundFile, soundVolume)
    PlaySound(soundFile, soundVolume)
end)

RegisterNetEvent('Sounds:Client:Stop')
AddEventHandler('Sounds:Client:Stop', function()
    StopSound()
end)

RegisterNetEvent('Sounds:Client:PlayInDistance')
AddEventHandler('Sounds:Client:PlayInDistance', function(coords, maxDistance, soundFile, soundVolume)
    local pedCoords = GetEntityCoords(ARP.GblPed)
    if #(pedCoords - coords) <= maxDistance then
        PlaySound(soundFile, soundVolume)
    end
end)