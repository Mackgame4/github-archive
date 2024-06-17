RegisterCommand('search', function(source, args, raw)
    TriggerClientEvent('prp-inventory:search', source)
end)

-- location moved to clrp_base/server/loot.lua

-- RegisterCommand('steal', function(source, args, raw)
--     TriggerClientEvent('prp-inventory:steal', source)
-- end)

ESX.RegisterServerCallback('prp-inventory:getIdentifier', function(source, cb, serverid)
    cb(ESX.GetPlayerFromId(serverid).identifier)
end)

RegisterServerEvent('prp-inventory:StealCash')
AddEventHandler('prp-inventory:StealCash', function(data)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromIdentifier(data.target)

    local playerCash = target.getMoney()
    local playerDirty = target.getAccount('black_money').money

    if player and target then
        target.setMoney(0)
        target.setAccountMoney('black_money', 0)

        player.addMoney(playerCash)
        player.addAccountMoney('black_money', playerDirty)

        
        local searchMSG = GetPlayerName(src) .. ' ' .. player.identifier ..' has searched ' ..GetPlayerName(id) ..' ' .. identifier .." for Cash: ".. playerCash..' and Dirty:' ..playerDirty
        TriggerEvent('DiscordBot:ToDiscord', 'steal-logs', searchMessages["false"], searchMSG, 'IMAGE_URL', true)

        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You stole $'..playerCash, length = 10000 })
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You stole $'..playerDirty..' (dirty)', length = 10000 })
    end
end)

RegisterServerEvent('prp-inventory:SeizeCash')
AddEventHandler('prp-inventory:SeizeCash', function(data)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromIdentifier(data.target)

    local playerCash = target.getMoney()
    local playerDirty = target.getAccount('black_money').money

    if player and target then  
        target.setMoney(0)
        target.setAccountMoney('black_money', 0)

        
        local searchMSG = GetPlayerName(src) .. ' ' .. player.identifier ..' has seized ' ..GetPlayerName(id) ..' ' .. identifier .." for Cash: ".. playerCash..' and Dirty:' ..playerDirty
        TriggerEvent('DiscordBot:ToDiscord', 'steal-logs', searchMessages["true"], searchMSG, 'IMAGE_URL', true)
        
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You seized $'..playerCash, length = 10000 })
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You seized DIRTY $'..playerDirty, length = 10000 })
    end
end)

searchMessages = {
    ["true"] = 'Search Logs',
    ["false"] = 'Steal Logs'
}

RegisterServerEvent('prp-inventory:SearchLog')
AddEventHandler('prp-inventory:SearchLog', function(police, id, identifier)
    local src = source
    local srcidentifier = GetPlayerIdentifiers(src)[1]

    local searchMSG = GetPlayerName(src) .. ' ' .. srcidentifier ..' has searched ' ..GetPlayerName(id) ..' ' .. identifier 

    TriggerEvent('DiscordBot:ToDiscord', 'steal-logs', searchMessages[tostring(police)], searchMSG, 'IMAGE_URL', true)

end)