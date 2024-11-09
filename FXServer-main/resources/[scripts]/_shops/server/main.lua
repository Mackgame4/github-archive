RegisterServerEvent("givePlayerTattoos")
AddEventHandler("givePlayerTattoos", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    exports.mongodb:find({collection="users", query = {identifier = xPlayer.getIdentifier()}}, function (success, result)
        if success then
            if result[1] ~= nil then
                    TriggerClientEvent('getPlayerTattoos', _source, result[1].tattoos) 
            end
        end
    end)
end)


RegisterServerEvent("addPlayerTattoos")
AddEventHandler("addPlayerTattoos", function(PedTattooList)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
    exports.mongodb:find({collection="users", query = {identifier = xPlayer.getIdentifier()}}, function (success, result)
        if success then
            if result[1].tattoos == nil then
                exports.mongodb:updateOne({ collection="users", query = {identifier = xPlayer.getIdentifier()}, update = { ["$set"] = { tattoos = {}} } })
            end
        end
    end)
    exports.mongodb:updateOne({ collection="users", query = {identifier = xPlayer.getIdentifier()}, update = { ["$set"] = { tattoos = PedTattooList } } })
end)


RegisterServerEvent("addPlayerSkin")
AddEventHandler("addPlayerSkin", function(PlayerSkin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    exports.mongodb:updateOne({ collection="users", query = { identifier = xPlayer.getIdentifier() }, update = { ["$set"] = { skin = PlayerSkin }}})
end)

RegisterServerEvent("getPlayerSkin")
AddEventHandler("getPlayerSkin", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    exports.mongodb:find({ collection="users", query = { identifier = xPlayer.getIdentifier()}}, function(success, result)
        if  not success then 
            return
        else
            TriggerClientEvent("clotheShops:getPlayerSkin", _source, result[1].skin)
        end
    end)
end)

RegisterServerEvent("RemoveMoney")
AddEventHandler("RemoveMoney", function(cost)
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        xPlayer.removeAccountMoney('bank', cost)
    end
end)