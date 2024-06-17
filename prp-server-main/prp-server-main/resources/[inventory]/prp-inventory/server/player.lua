ESX.RegisterServerCallback('prp-inventory:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    getPlayerDisplayInventory(identifier, cb)
    --idk(identifier, 'player', cb)
end)

RegisterServerEvent('prp-inventory:getPlayerInventory')
AddEventHandler('prp-inventory:getPlayerInventory', function(type, playerId)
    local src = source

    if playerId ~= nil then
        src = playerId 
    end
    
    if src ~= nil then
        local xPlayer = ESX.GetPlayerFromId(src)
        local identifier = xPlayer.identifier
        idk(identifier, 'player', function(inventory)
            local itemsObject = {}

            if inventory ~= nil then
                for k, v in pairs(inventory) do
                    local ItemInfo = inventoryItem(v.name)
                    local item = createDisplayItem(v, ItemInfo, tonumber(k), nil, 'item', identifier)
                    table.insert(itemsObject, item)
                end
            end

            inv = {
                invId = identifier,
                invTier = InvType['player'],
                inventory = itemsObject,
            }
            TriggerClientEvent('prp-inventory:givePlayerInventory', src, inv, src, identifier)
        end)
    end
end)


AddEventHandler("onDatabaseConnect", function()
    Wait(10)
    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'player',
        label = 'ply',
        slots = 30,
        weight = 250,
        getInventory = function(identifier, cb)
            idk(identifier, 'player', cb)
        end,
        saveInventory = function(identifier, inventory)
            saveInventory(identifier, 'player', inventory)
        end
    })
end)

function getPlayerDisplayInventory(identifier, cb)
    idk(identifier, 'player', function(inventory)
        local itemsObject = {}

        for k, v in pairs(inventory) do
            local ItemInfo = inventoryItem(v.name)
            local item = createDisplayItem(v, ItemInfo, tonumber(k), nil, 'item', identifier)
            table.insert(itemsObject, item)
        end

        local inv = {
            invId = identifier,
            invTier = InvType['player'],
            inventory = itemsObject,
        }
        cb(inv)
    end)
end

function ensurePlayerInventory(player)
end

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local refreshed = false

--  if not string.find(item.name, 'ammo') then
        TriggerClientEvent('prp-inventory:showItemUse', source, {
            { id = item.name, label = item.label, qty = count, msg = 'Removed' }
        })
--  end

    applyToInventory(identifier, 'player', function(inventory)
        removeItemFromInventory(item, count, inventory)

        TriggerClientEvent('prp-inventory:refreshInventory', source)
    end)
    
end)

AddEventHandler('esx:onAddInventoryItem', function(source, ESXItem, count)
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    
--  if not string.find(ESXItem.name, 'ammo') then
        TriggerClientEvent('prp-inventory:showItemUse', source, {
            { id = ESXItem.name, label = ESXItem.label, qty = count, msg = 'Added' }
        })
--  end

    applyToInventory(identifier, 'player', function(inventory)        
        local item = createItem(ESXItem.name, count)
        addToInventory(item, 'player', inventory, source)

        TriggerClientEvent('prp-inventory:refreshInventory', source)
    end)

end)

RegisterServerEvent("prp-inventory:addItem")
AddEventHandler("prp-inventory:addItem", function(src, name, count)
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    applyToInventory(identifier, 'player', function(inventory)
        local item = createItem(name, count)
        addToInventory(item, 'player', inventory, src)
    end)
end)

RegisterServerEvent("prp-inventory:removeItem")
AddEventHandler("prp-inventory:removeItem", function(src, name, count)
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    applyToInventory(identifier, 'player', function(inventory)
        removeItemFromInventory(name, count, inventory)
    end)
end)

itemUsages = {}

RegisterServerEvent("prp-inventory:registerItemUse")
AddEventHandler("prp-inventory:registerItemUse", function(name, cb)
    itemUsages[name] = {}
    
    table.insert(itemUsages[name], cb)
end)

RegisterServerEvent("prp-inventory:itemUse")
AddEventHandler("prp-inventory:itemUse", function(name, id, ESXItem)
    local source = source

    if id ~= nil and id > 0 then
        source = id
    end
    
    if source ~= nil then
        if itemUsages[name] ~= nil then
            for k, v in ipairs(itemUsages[name]) do
                TriggerClientEvent('prp-inventory:handleUsedItem', source, name, ESXItem)
                itemUsages[name][k](source)
            end
        end
    end
end)

ESX.RegisterServerCallback('prp-inventory:hasItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    idk(identifier, 'player', function(inventory)
        for k, v in pairs(inventory) do
            if v.name == item then
                cb(true)
                return
            end
        end
        cb(false)
    end)
end)