ML = {}
ML.DB = {}
ML.Server = {}
ML.Shared = {}

ML.Players = {}

AddEventHandler('mack_libs:getObject', function(cb)
    cb(ML)
end)

function getObject()
    return ML
end

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    ML.Shared.Log('Checking player: '..ML.Server.GetIdentifier(source)..' ('..name..')', 'info')
    Wait(1)
    if Config.WelcomeText ~= "" then
        deferrals.update(string.format(Config.WelcomeText, name, GetConvar("sv_projectName", "Mack's Library")))
        Wait(1000)
    end
    deferrals.done()
    --TriggerEvent('mack_libs:playerConnecting', name, setKickReason, deferrals)
end)
--RegisterNetEvent('mack_libs:playerConnecting')

RegisterNetEvent('mack_libs:playerSpawned')
AddEventHandler("mack_libs:playerSpawned", function()
    local _source = source
    local player = {
        id = tostring(source),
        name = GetPlayerName(source),
        identifier = ML.Server.GetIdentifier(source),
        ped = GetPlayerPed(source)
    }
    table.insert(ML.Players, player)
    TriggerClientEvent('mack_libs:playerLoaded', source, player)
    ML.Shared.Log('Joined player: '..player.identifier..' ('..player.name..') with ID: ^4'..player.id..'^0', 'info')
end)

AddEventHandler('playerDropped', function (reason)
    local _source = source
    local player = ML.Server.GetPlayer(source)
    if player ~= nil then
        ML.Shared.Log('Player ' .. player.name .. ' - '..player.identifier..' dropped (Reason: ' .. reason .. ')', 'info')
        TriggerEvent('mack_libs:playerDropped', source, player, reason)
    else
        ML.Shared.Log('^1Player^0 ' .. GetPlayerName(source) .. ' ^1not found^0 - '..ML.Server.GetIdentifier(source)..' dropped (Reason: ' .. reason .. ')', 'error')
    end
end)
RegisterNetEvent('mack_libs:playerDropped')

RegisterNetEvent('mack_libs:getPlayer')
AddEventHandler("mack_libs:getPlayer", function(player)
    local _source = source
    local player = ML.Server.GetPlayer(source)
    TriggerClientEvent('mack_libs:playerLoaded', source, player)
end)