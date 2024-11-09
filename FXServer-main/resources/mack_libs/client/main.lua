ML = {}
ML.Client = {}
ML.Shared = {}

AddEventHandler('mack_libs:getObject', function(cb)
    cb(ML)
end)

function getObject()
    return ML
end

RegisterCommand('emujoin', function(source, args, rawCommand) -- Debug Only
	TriggerServerEvent('mack_libs:playerSpawned')
end, false)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('mack_libs:playerSpawned')
end)

RegisterNetEvent('mack_libs:playerLoaded')
AddEventHandler("mack_libs:playerLoaded", function(player)
    ML.Client.Player = player
    ML.Shared.Log('Spawned player: '..player.identifier..' ('..player.name..') with ID: ^4'..player.id..'^0', 'info')
end)

RegisterNetEvent('OnInteract')
RegisterCommand("interact", function()
    TriggerEvent('OnInteract')
end, false)

RegisterKeyMapping("interact", "Interact with objects", "keyboard", "e")

RegisterNetEvent('OnSecondaryInteract')
RegisterCommand("secundaryinteract", function()
    TriggerEvent('OnSecondaryInteract')
end, false)

RegisterKeyMapping("secundaryinteract", "Second interact with objects", "keyboard", "g")