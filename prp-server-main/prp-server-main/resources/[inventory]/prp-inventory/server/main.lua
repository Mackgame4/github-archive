ESX = nil
InvType = {
    ['unknown'] = { slots = 1, label = 'Unknown' },
}

Citizen.CreateThread(function()
    Helpers.LoadToDbIfNotExists("/database/itemdata.json", "itemdata")
    Helpers.LoadToDbIfNotExists("/database/items.json", "items")
end)

RegisterServerEvent('prp-inventory:RegisterInventory')
AddEventHandler('prp-inventory:RegisterInventory', function(inventory)
    if inventory.name == nil then
        print('Requires inv name')
        return
    end

    if inventory.slots == nil then
        inventory.slots = 4
    end

    if inventory.getInventory == nil then
        inventory.getInventory = function(identifier, cb)
            idk(identifier, inventory.name, cb)
        end
    end

    if inventory.applyToInventory == nil then
        inventory.applyToInventory = function(identifier, f)
            applyToInventory(identifier, inventory.name, f)
        end
    end

    if inventory.saveInventory == nil then
        inventory.saveInventory = function(identifier, toSave)
            if table.length(toSave) > 0 then
                saveInventory(identifier, inventory.name, toSave)
            else
                --deleteInventory(identifier, inventory.name)

            end
        end
    end

    if inventory.getDisplayInventory == nil then
        inventory.getDisplayInventory = function(identifier, cb, source)
            getDisplayInventory(identifier, inventory.name, cb, source)
        end
    end

    InvType[inventory.name] = inventory
    loadedInventories[inventory.name] = {}
end)

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

--[[
RegisterCommand('ensureInv', function(source)
    local owner = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll('DELETE FROM prp-inventory WHERE data = @data AND owner = @owner',{['@data'] = "null",['@owner'] = owner})
    ensureInventories(source)
end)]]

function ensureInventories(source)
    local player = ESX.GetPlayerFromId(source)
    ensurePlayerInventory(player)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        saveInventories()
    end
end)

-- I wonder if all this is really needed, I guess we see.
AddEventHandler('esx:playerLoaded', function(data)
    local xPlayer = ESX.GetPlayerFromId(data)
    local identifier = xPlayer.identifier
    loadInventory(identifier, 'player', function()
    end)
end)

-- Also required, and useful.
AddEventHandler('esx:playerDropped', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    saveInventory(identifier, 'player', true)
    closeAllOpenInventoriesForSource(source)
end)


-- RegisterCommand("pay", function(source, args, rawCommand)
--     local id = tonumber(args[1])
--     local amount = tonumber(args[2])

--     if id ~= nil then
--         if GetPlayerPing(id) then
--             if id ~= source then
--                 if amount ~= nil then
--                     if amount > 0 then 
--                         local tPos = GetEntityCoords(GetPlayerPed(id))
--                         local distance = #(vector3(tPos.x, tPos.y, tPos.z) - GetEntityCoords(GetPlayerPed(source)))

--                         if distance > 4 then
--                             TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Too far away', length = 5000 })
--                             return
--                         end

--                         local target = ESX.GetPlayerFromId(id)

--                         if target ~= nil then
--                             local player = ESX.GetPlayerFromId(source)
--                             if player ~= nil then
--                             	if player.getMoney() >= amount then
-- 	                                player.removeMoney(amount)
-- 	                                target.addMoney(amount)
-- 	                                TriggerClientEvent('pay:animation', source)
-- 	                            else
-- 					                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t have enough cash bozo', length = 7500 })
-- 					            end
--                             end
--                         end
--                     else
--                         TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Please provide an amount over $0', length = 7500 })
--                     end
--                 else
--                     TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Please provide an amount over $0', length = 7500 })
--                 end
--             else
--                 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You cannot send money to yourself', length = 7500 })
--             end
--         else
--             TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'This person is not available.', length = 5000 })
--         end
--     else
--         TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Please provide a target, such as /pay 1 500', length = 5000 })
--     end
-- end, false)

RegisterServerEvent('prp-inventory:invlog')
AddEventHandler('prp-inventory:invlog', function(data)
    if data.inv1 ~= data.inv2 then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local t = os.date('*t')
        local date = t.month .. '.' .. t.day .. '.' .. t.year .. ' - ' .. os.date('%H') .. ':' .. os.date('%M') .. ':' .. os.date('%S')
        local text = xPlayer.name .. ' `' .. xPlayer.identifier .. '` ' .. data.action .. ' ' .. tostring(data.item_count) .. ' ' .. data.item .. ' from ' .. data.inv1 .. ' to ' .. data.inv2 .. '   `' .. date .. '`'
        TriggerEvent('DiscordBot:ToDiscord', 'inventory', 'Inventory', text, 'IMAGE_URL', src, true)
    end
end)

