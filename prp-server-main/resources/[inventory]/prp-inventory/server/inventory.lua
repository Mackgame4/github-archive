--[[
	The 6 Stages of Aids:
	
	SplitStack EmptySplitStack TopoffStack 
	CombineStack SwapItems MoveToEmpty

	MAIN PROBLEMS TO FIX = {
		- Adding to inventory doesn't merge correctly and sometimes adds less then it should
		- Cross Server Duping Eventually
	} 
	
    local ESXitem = inventoryItem(data.originItem.id) ESXitem.label ===>>>> data.originItem.label apparently
]]--

local openInventory = {}
loadedInventories = {}

RegisterServerEvent("prp-inventory:openInventory")
AddEventHandler("prp-inventory:openInventory", function(inventory)
    local src = source
    local inv = inventory

    --    print('prp-inventory:openInventory', src, inv.type, inv.owner)
    if openInventory[inventory.owner] == nil then
        openInventory[inventory.owner] = {}
    end

    openInventory[inventory.owner][src] = true
end)

RegisterServerEvent("prp-inventory:closeInventory")
AddEventHandler("prp-inventory:closeInventory", function(inventory)
    local src = source
    local inv = inventory
    --    print('prp-inventory:closeInventory', src, inv.type, inv.owner)
    if string.find(inv.type, "trunk") or string.find(inv.type, 'glovebox') or inv.type == 'stash' or string.find(inv.type, "property-") then
        --    	print('prp-inventory:closeInventory saveLoadedInventory', inv.owner, inv.type)
        --		print(loadedInventories[inv.type][inv.owner])
        saveLoadedInventory(inv.owner, inv.type, loadedInventories[inv.type][inv.owner], true)
    end
    Wait(350)

    if openInventory[inv.owner] == nil then
        openInventory[inv.owner] = {}
        openInventory[inv.owner][src] = nil
    end

    if openInventory[inv.owner][src] then
        openInventory[inv.owner][src] = nil
    end

    openInventory[inv.owner][src] = nil
    openInventory[inv.owner] = {}
end)

function closeAllOpenInventoriesForSource(source)
    for k, inv in pairs(openInventory) do
        openInventory[k][source] = nil
    end
end

RegisterServerEvent("prp-inventory:refreshInventory")
AddEventHandler("prp-inventory:refreshInventory", function(owner)
    if openInventory[owner] == nil then
        openInventory[owner] = {}
    end

    for k, v in pairs(openInventory[owner]) do
        TriggerClientEvent("prp-inventory:refreshInventory", k)
    end
end)

RegisterServerEvent("prp-inventory:MoveToEmpty")
AddEventHandler("prp-inventory:MoveToEmpty", function(data)
    local source = source

    if data.originOwner == data.destinationOwner and data.originTier.name == data.destinationTier.name then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(inventory)
            inventory[tostring(data.destinationSlot)] = inventory[tostring(data.originSlot)]
            inventory[tostring(data.originSlot)] = nil
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]

        if data.destinationTier.name == 'shop' or data.destinationTier.name == 'gunshop' then
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
            TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            return
        end

        if data.originTier.name == 'shop' or data.originTier.name == 'gunshop' then
            local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
            if player.getMoney() >= data.originItem.price * data.originItem.qty then
                player.removeMoney(data.originItem.price * data.originItem.qty)
                if (data.originOwner == 'Bean Machine') then
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_beanmachine', function(account)
                        account.addMoney(data.originItem.price * data.originItem.qty)
                    end)
                elseif (data.originOwner == 'Yellow Jack') then
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_harmony', function(account)
                        account.addMoney(data.originItem.price * data.originItem.qty)
                    end)
                end
                -- TriggerEvent('prp-inventory:Random',data)
            else
                TriggerClientEvent('prp-inventory:refreshInventory', source)
                TriggerClientEvent('prp-inventory:refreshInventory', data.target)
                return
            end
        end

        originInvHandler.applyToInventory(data.originOwner, function(originInventory)
            destinationInvHandler.applyToInventory(data.destinationOwner, function(destinationInventory)
                destinationInventory[tostring(data.destinationSlot)] = originInventory[tostring(data.originSlot)]
                originInventory[tostring(data.originSlot)] = nil
                local count = destinationInventory[tostring(data.destinationSlot)].count

                if data.originTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = count, msg = 'Removed' }
                    })
                end

                if data.destinationTier.name == 'player' then
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = count, msg = 'Added' }
                    })
                end

                TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
                TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            end)
        end)
    end
end)

RegisterServerEvent("prp-inventory:SwapItems")
AddEventHandler("prp-inventory:SwapItems", function(data)
    local source = source

    if data.originTier.name == 'shop' or data.destinationTier.name == 'shop' then
        TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
        return
    end

    if data.originTier.name == 'gunshop' or data.destinationTier.name == 'gunshop' then
        TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
        return
    end

    if data.originOwner == data.destinationOwner and data.originTier.name == data.destinationTier.name then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(inventory)
            local tempItem = inventory[tostring(data.originSlot)]
            inventory[tostring(data.originSlot)] = inventory[tostring(data.destinationSlot)]
            inventory[tostring(data.destinationSlot)] = tempItem
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(originInventory)
            destinationInvHandler.applyToInventory(data.destinationOwner, function(destinationInventory)
                local tempItem = originInventory[tostring(data.originSlot)]
                originInventory[tostring(data.originSlot)] = destinationInventory[tostring(data.destinationSlot)]
                destinationInventory[tostring(data.destinationSlot)] = tempItem

                if data.originTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.originItem.qty, msg = 'Added' }
                    })
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.destinationItem.id, label = data.destinationItem.label, qty = data.destinationItem.qty, msg = 'Removed' }
                    })
                end

                if data.destinationTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.destinationItem.qty, msg = 'Added' }
                    })
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.destinationItem.id, label = data.destinationItem.label, qty = data.originItem.qty, msg = 'Removed' }
                    })
                end

                TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
                TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            end)
        end)
    end
end)

RegisterServerEvent("prp-inventory:CombineStack")
AddEventHandler("prp-inventory:CombineStack", function(data)
    local source = source

    if data.destinationTier.name == 'shop' or data.destinationTier.name == 'gunshop' then
        TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
        return
    end

    if data.originTier.name == 'shop' or data.originTier.name == 'gunshop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.originQty then
            player.removeMoney(data.originItem.price * data.originQty)
            if (data.originOwner == 'Bean Machine') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_beanmachine', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            elseif (data.originOwner == 'Yellow Jack') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_harmony', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            end
            -- print('The table data:')
            -- print(table.unpack(data))
        else
            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
            return
        end
    end

    if data.originOwner == data.destinationOwner and data.originTier.name == data.destinationTier.name then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)] = nil
            inventory[tostring(data.destinationSlot)].count = data.destinationQty
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(originInventory)
            destinationInvHandler.applyToInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)] = nil
                destinationInventory[tostring(data.destinationSlot)].count = data.destinationQty
                if data.originTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.originQty, msg = 'Removed' }
                    })
                end

                if data.destinationTier.name == 'player' then
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.originQty, msg = 'Added' }
                    })
                end

                TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
                TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            end)
        end)
    end
end)

RegisterServerEvent("prp-inventory:TopoffStack")
AddEventHandler("prp-inventory:TopoffStack", function(data)
    local source = source

    if data.destinationTier.name == 'shop' or data.destinationTier.name == 'gunshop' then
        TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
        return
    end

    if data.originTier.name == 'shop' or data.originTier.name == 'gunshop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.originQty then
            player.removeMoney(data.originItem.price * data.originQty)
            if (data.originOwner == 'Bean Machine') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_beanmachine', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            elseif (data.originOwner == 'Yellow Jack') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_harmony', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            end
        else
            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
            return
        end
    end

    if data.originOwner == data.destinationOwner and data.originTier.name == data.destinationTier.name then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)].count = data.originItem.qty
            inventory[tostring(data.destinationSlot)].count = data.destinationItem.qty
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(originInventory)
            destinationInvHandler.applyToInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)].count = data.originItem.qty
                destinationInventory[tostring(data.destinationSlot)].count = data.destinationItem.qty

                if data.originTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = '', msg = 'Removed' }
                    })
                end

                if data.destinationTier.name == 'player' then
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = '', msg = 'Added' }
                    })
                end

                TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
                TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            end)
        end)
    end
end)

RegisterServerEvent("prp-inventory:EmptySplitStack")
AddEventHandler("prp-inventory:EmptySplitStack", function(data)

    if data.destinationTier.name == 'shop' or data.destinationTier.name == 'gunshop' then
        TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
        return
    end

    if data.originTier.name == 'shop' or data.originTier.name == 'gunshop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.moveQty then
            player.removeMoney(data.originItem.price * data.moveQty)
            if (data.originOwner == 'Bean Machine') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_beanmachine', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            elseif (data.originOwner == 'Yellow Jack') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_harmony', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            end
        else
            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
            return
        end
    end

    local source = source
    if data.originOwner == data.destinationOwner and data.originTier.name == data.destinationTier.name then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)].count = inventory[tostring(data.originSlot)].count - data.moveQty
            local item = inventory[tostring(data.originSlot)]
            inventory[tostring(data.destinationSlot)] = {
                name = item.name,
                count = data.moveQty
            }
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(originInventory)
            destinationInvHandler.applyToInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)].count = originInventory[tostring(data.originSlot)].count - data.moveQty
                local item = originInventory[tostring(data.originSlot)]
                destinationInventory[tostring(data.destinationSlot)] = {
                    name = item.name,
                    count = data.moveQty
                }

                if data.originTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.moveQty, msg = 'Removed' }
                    })
                end

                if data.destinationTier.name == 'player' then
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.moveQty, msg = 'Added' }
                    })
                end

                TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
                TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            end)
        end)
    end
end)

RegisterServerEvent("prp-inventory:SplitStack")
AddEventHandler("prp-inventory:SplitStack", function(data)
    local source = source

    if data.destinationTier.name == 'shop' or data.destinationTier.name == 'gunshop' then
        TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
        return
    end

    if data.originTier.name == 'shop' or data.originTier.name == 'gunshop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.moveQty then
            player.removeMoney(data.originItem.price * data.moveQty)
            if (data.originOwner == 'Bean Machine') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_beanmachine', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            elseif (data.originOwner == 'Yellow Jack') then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_harmony', function(account)
                    account.addMoney(data.originItem.price * data.originItem.qty)
                end)
            end
        else
            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
            return
        end
    end

    if data.originOwner == data.destinationOwner and data.originTier.name == data.destinationTier.name then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)].count = inventory[tostring(data.originSlot)].count - data.moveQty
            inventory[tostring(data.destinationSlot)].count = inventory[tostring(data.destinationSlot)].count + data.moveQty
            TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.applyToInventory(data.originOwner, function(originInventory)
            destinationInvHandler.applyToInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)].count = originInventory[tostring(data.originSlot)].count - data.moveQty
                destinationInventory[tostring(data.destinationSlot)].count = destinationInventory[tostring(data.destinationSlot)].count + data.moveQty

                if data.originTier.name == 'player' then
                    local originPlayer = ESX.GetPlayerFromIdentifier(data.originOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', originPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.moveQty, msg = 'Removed' }
                    })
                end

                if data.destinationTier.name == 'player' then
                    local destinationPlayer = ESX.GetPlayerFromIdentifier(data.destinationOwner)
                    TriggerClientEvent('prp-inventory:showItemUse', destinationPlayer.source, {
                        { id = data.originItem.id, label = data.originItem.label, qty = data.moveQty, msg = 'Added' }
                    })
                end
                TriggerEvent('prp-inventory:refreshInventory', data.originOwner)
                TriggerEvent('prp-inventory:refreshInventory', data.destinationOwner)
            end)
        end)
    end
end)

RegisterServerEvent("prp-inventory:GiveItem")
AddEventHandler("prp-inventory:GiveItem", function(data)

    local targetPlayer = ESX.GetPlayerFromId(data.target)
    local sourcePlayer = ESX.GetPlayerFromId(source)

    local sourceItem = sourcePlayer.getInventoryItem(data.originItem.id)
    local targetItem = targetPlayer.getInventoryItem(data.originItem.id)

    if data.count > 0 and sourceItem.count >= data.count then

        if targetItem.limit ~= -1 and (targetItem.count + data.count) > targetItem.limit then
            TriggerClientEvent('esx:showNotification', _source, 'That player cannot hold enough ' .. sourceItem.label .. '\'s')
        else
            handleGiveWeaponRemoval(data, source)
            TriggerEvent('prp-inventory:notifyImpendingRemoval', data.originItem, data.count, source)
            TriggerEvent('prp-inventory:notifyImpendingAddition', data.originItem, data.count, data.target)

            targetPlayer.addInventoryItem(data.originItem.id, data.count)
            sourcePlayer.removeInventoryItem(data.originItem.id, data.count)

            TriggerEvent('DiscordBot:ToDiscord', 'transfer', 'Item', sourcePlayer.identifier .. ' ' .. sourcePlayer.getName()
                    .. ' gave x' .. data.count .. ' ' .. data.originItem.id .. ' to ' .. targetPlayer.identifier .. ' ' .. targetPlayer.getName(), 'IMAGE_URL', true)

            TriggerClientEvent('esx:showNotification', _source, 'You gave ' .. data.target .. ' x' .. data.count .. ' ' .. sourceItem.label)
            TriggerClientEvent('esx:showNotification', target, 'You received x' .. data.count .. ' ' .. sourceItem.label .. ' from ' .. source)

            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
        end

    end
end)

RegisterServerEvent("prp-inventory:GiveCash")
AddEventHandler("prp-inventory:GiveCash", function(data)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(data.target)
    if data.item == 'cash' then
        if sourcePlayer.getMoney() >= data.count then
            sourcePlayer.removeMoney(data.count)
            targetPlayer.addMoney(data.count)
            TriggerEvent('DiscordBot:ToDiscord', 'transfer', 'Money', sourcePlayer.identifier .. ' ' .. sourcePlayer.getName()
                    .. ' gave $' .. data.count .. ' to ' .. targetPlayer.identifier .. ' ' .. targetPlayer.getName(), 'IMAGE_URL', true)
            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
        end
    elseif data.item == 'black_money' then
        if sourcePlayer.getAccount('black_money').money >= data.count then
            sourcePlayer.removeAccountMoney('black_money', data.count)
            targetPlayer.addAccountMoney('black_money', data.count)
            TriggerEvent('DiscordBot:ToDiscord', 'transfer', 'Money', sourcePlayer.identifier .. ' ' .. sourcePlayer.getName()
                    .. ' gave $' .. data.count .. ' dirty to ' .. targetPlayer.identifier .. ' ' .. targetPlayer.getName(), 'IMAGE_URL', true)
            TriggerClientEvent('prp-inventory:refreshInventory', source)
            TriggerClientEvent('prp-inventory:refreshInventory', data.target)
        end
    end
end)

function removeItemFromSlot(inventory, slot, count)
    if inventory[tostring(slot)] ~= nil and inventory[tostring(slot)].count - count > 0 then
        inventory[tostring(slot)].count = inventory[tostring(slot)].count - count
        return
    else
        inventory[tostring(slot)] = nil
        return
    end
end

function removeItemFromInventory(item, count, inventory)
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if v.count - count < 0 then
                local tempCount = inventory[k].count
                inventory[k] = nil
                count = count - tempCount
            elseif v.count - count > 0 then
                inventory[k].count = inventory[k].count - count
                return
            elseif v.count - count == 0 then
                inventory[k] = nil
                return
            end
        end
    end
end

function addToInventory(item, type, inventory, max)
    if max == -1 then
        max = 9999
    end
    local toAdd = item.count
    toAdd = AttemptMerge(item, inventory, toAdd, max)
    while toAdd > 0 do
        if toAdd > 0 then
            toAdd = AddToEmpty(item, type, inventory, toAdd, max)
        else
            toAdd = 0
        end
    end
end

function AttemptMerge(item, inventory, count)
    local max = getItemDataProperty(item.name, "max") or 100
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if v.count + count > max then
                local tempCount = max - inventory[k].count
                inventory[tostring(k)].count = max
                count = count - tempCount
            elseif v.count + count <= max then
                inventory[tostring(k)].count = v.count + count
                return 0
            end
        end
    end
    return count
end

function AddToEmpty(item, type, inventory, count)
    local max = getItemDataProperty(item.name, "max") or 100
    for i = 1, InvType[type].slots, 1 do
        if inventory[tostring(i)] == nil then
            if count > max then
                inventory[tostring(i)] = item
                inventory[tostring(i)].count = max
                return count - max
            else
                inventory[tostring(i)] = item
                inventory[tostring(i)].count = count
                return 0
            end
        end
    end
    return 0
end

function createDisplayItem(item, ESXItem, slot, price, type, identifier, kind, secondary)
    local max = getItemDataProperty(item.name, 'max') or 100
    local usage
    local kind = tostring(kind)

    if string.find(kind, "glovebox") or string.find(kind, "trunk") or string.find(kind, "stash") or string.find(kind, "drop") or kind == "evidence" or kind == "drop" or string.find(kind, "property-") or secondary then
        return {
            id = ESXItem.name,
            itemId = ESXItem.name,
            qty = item.count,
            slot = slot,
            label = ESXItem.label,
            type = type or 'item',
            max = getItemDataProperty(ESXItem.name, 'max') or max,
            stackable = true,
            unique = 0,
            usable = false,
            giveable = false,
            description = getItemDataProperty(item.name, 'description'),
            weight = item.weight or ESXItem.weight,
            metadata = item.metadata or {},
            staticMeta = item.staticMeta or {},
            canRemove = 0,
            price = price or 0,
            needs = false,
            closeUi = getItemDataProperty(ESXItem.name, 'closeonuse'),
        }
    else
        return {
            id = ESXItem.name,
            itemId = ESXItem.name,
            qty = item.count,
            slot = slot,
            label = ESXItem.label,
            type = type or 'item',
            max = getItemDataProperty(ESXItem.name, 'max') or max,
            stackable = true,
            unique = 0,
            usable = itemUsages[ESXItem.name] ~= nil,
            giveable = true,
            description = getItemDataProperty(item.name, 'description'),
            weight = item.weight or ESXItem.weight,
            metadata = item.metadata or {},
            staticMeta = item.staticMeta or {},
            canRemove = 1,
            price = price or 0,
            needs = false,
            closeUi = getItemDataProperty(ESXItem.name, 'closeonuse'),
        }
    end
end

function createDisplayItemShop(item, esxItem, slot, price, type)
    local max = getItemDataProperty(item.name, 'max') or 100
    local desc = getItemDataProperty(item.name, 'description')
    return {
        id = esxItem.name,
        itemId = esxItem.name,
        qty = item.count,
        slot = slot,
        label = esxItem.label,
        type = type or 'item',
        max = getItemDataProperty(esxItem.name, 'max') or max,
        stackable = true,
        unique = 0,
        usable = false,
        giveable = false,
        description = desc,
        weight = getItemDataProperty(esxItem.name, 'weight'),
        metadata = item.metadata or {},
        staticMeta = item.staticMeta or {},
        canRemove = 0,
        price = price or 0,
        needs = false,
        closeUi = getItemDataProperty(esxItem.name, 'closeonuse'),
    }
end

function createDisplayItemGunshop(item, esxItem, slot, price, type)
    local max = getItemDataProperty(item.name, 'max') or 100
    local desc = getItemDataProperty(item.name, 'description')
    return {
        id = esxItem.name,
        itemId = esxItem.name,
        qty = item.count,
        slot = slot,
        label = esxItem.label,
        type = type or 'item',
        max = getItemDataProperty(esxItem.name, 'max') or max,
        stackable = true,
        unique = 0,
        usable = false,
        giveable = false,
        description = desc,
        weight = getItemDataProperty(esxItem.name, 'weight'),
        metadata = item.metadata or {},
        staticMeta = item.staticMeta or {},
        canRemove = 0,
        price = price or 0,
        needs = false,
        closeUi = getItemDataProperty(esxItem.name, 'closeonuse'),
    }
end

function createItem(name, count)
    if isWeapon(name) then
        local staticMeta = {}
        local metadata = {}
        staticMeta.serial = RegisterSerial(9)
        return { name = name, count = 1, staticMeta = staticMeta, metadata = metadata }
    else
        return { name = name, count = count }
    end
end

RegisterServerEvent("prp-inventory:openSecondInventory")
AddEventHandler("prp-inventory:openSecondInventory", function(type, identifier, saveme)
    local src = source
    local canOpen = not (table.length(openInventory[identifier]) > 0) or openInventory[identifier][source]

    if canOpen and src ~= nil and type ~= nil and identifier ~= nil then
        TriggerEvent('prp-inventory:getSecondoryInventory', src, type, identifier, saveme)
    else
        TriggerClientEvent('prp-inventory:denySecondaryInventory', src)
    end

end)

RegisterServerEvent("prp-inventory:getSecondoryInventory")
AddEventHandler("prp-inventory:getSecondoryInventory", function(source, type, identifier, saveme)

    if type == 'shop' then
        local player = ESX.GetPlayerFromId(source)
        InvType['shop'].getInventory(identifier, function(inventory)
            local itemsObject = {}

            for k, v in pairs(inventory) do
                local ESXItem = inventoryItem(v.name)
                local item = createDisplayItemShop(v, ESXItem, tonumber(k), v.price)
                local addItem = true

                if v.grade ~= nil then
                    if player.job.grade < v.grade then
                        addItem = false
                    end
                end

                if addItem then
                    table.insert(itemsObject, item)
                end
            end

            local inv = {
                invId = identifier,
                invTier = InvType['shop'],
                inventory = itemsObject,
            }
            TriggerClientEvent('prp-inventory:giveClientSecondary', source, inv, saveme)
        end)
        return
    end
    if type == 'gunshop' then
        local player = ESX.GetPlayerFromId(source)
        InvType['gunshop'].getInventory(identifier, function(inventory)
            local itemsObject = {}

            for k, v in pairs(inventory) do
                local ESXItem = inventoryItem(v.name)
                local item = createDisplayItemGunshop(v, ESXItem, tonumber(k), v.price)
                local addItem = true

                if v.grade ~= nil then
                    if player.job.grade < v.grade then
                        addItem = false
                    end
                end

                if addItem then
                    table.insert(itemsObject, item)
                end
            end

            local inv = {
                invId = identifier,
                invTier = InvType['gunshop'],
                inventory = itemsObject,
            }
            TriggerClientEvent('prp-inventory:giveClientSecondary', source, inv, saveme)
        end)
        return
    end
    idk(identifier, type, function(inventory)
        local itemsObject = {}
        for k, v in pairs(inventory) do
            local esxItem = inventoryItem(v.name)
            local item = createDisplayItem(v, esxItem, tonumber(k), nil, 'item', identifier, type, true)
            table.insert(itemsObject, item)
        end

        local inv
        if type == "player" then
            inv = {
                invId = identifier,
                invTier = InvType[type],
                inventory = itemsObject,
            }
        else
            inv = {
                invId = identifier,
                invTier = InvType[type],
                inventory = itemsObject,
            }

        end
        TriggerClientEvent('prp-inventory:giveClientSecondary', source, inv, saveme)
    end)
end)

RegisterCommand("savedata", function(source, args, rawCommand)
    saveInventories()
end, true) -- set this to false to allow anyone.

RegisterCommand("saveInventories", function(src, args, raw)
    if src == 0 then
        saveInventories()
    end
end)

local haltLoopedSaveTask = false
-- Function to save player money to the database every 10 mins.
local function SaveOnTime()
    SetTimeout(1200000, function()
        Citizen.CreateThread(function()
            saveInventories()
            SaveOnTime()
        end)
    end)
end

--SaveOnTime()

CreateThread(function()
    while true do
        Wait(1200000)
        local thisData = loadedInventories['player']

        for identifier, inventory in pairs(thisData) do
            if loadedInventories['player'][identifier] ~= nil then
                if type ~= 'drop' or type ~= 'evidence' and haltLoopedSaveTask == false then
                    saveLoadedInventory(identifier, type, inventory, true)
                end
            end
            Wait(250)
        end
        print('^1[CityLife Core] ^7- ^4All Player ^7have been ^2successfully ^7saved.^7')
    end
end)

function saveInventories()
    for type, inventories in pairs(loadedInventories) do
        for identifier, inventory in pairs(inventories) do
            if inventory ~= nil then
                if loadedInventories[type][identifier] ~= nil then
                    if type ~= 'drop' or type ~= 'evidence' and haltLoopedSaveTask == false then
                        saveLoadedInventory(identifier, type, inventory, true)
                    end
                end
            end
            Wait(330)
        end
        Wait(500)
    end

    print('^1[CityLife Core] ^7- ^4All Inventories ^7have been ^2successfully ^7saved.^7')
end

function saveInventoriesNow()
    haltLoopedSaveTask = true
    for type, inventories in pairs(loadedInventories) do
        for identifier, inventory in pairs(inventories) do
            if inventory ~= nil then
                if loadedInventories[type][identifier] ~= nil then
                    if type ~= 'drop' or type ~= 'evidence' then
                        saveLoadedInventory(identifier, type, inventory, true)
                    end
                end
            end
        end
    end

    print('^1[CityLife Core] ^7- ^4All Inventories ^7have been ^2successfully ^7saved.^7')
end

RegisterNetEvent('CityLife:Disc:StartSync')
AddEventHandler('CityLife:Disc:StartSync', function()
    saveInventoriesNow()
end)

RegisterCommand("listInventories", function(src, args, raw)
    if src == 0 then
        for type, inventories in pairs(loadedInventories) do
            print(type, inventories, json.encode(inventories))
            for identifier, inventory in pairs(inventories) do
                print(identifier, inventory)
            end
        end
    end
end)

function saveInventory(identifier, type, save)
    local data = json.encode(loadedInventories[type][identifier])
    if data ~= "null" then
        saveLoadedInventory(identifier, type, loadedInventories[type][identifier], save)
    end
end

function saveLoadedInventory(identifier, type, data, save)
    local type = type
    local identifier = identifier

    --	print('saveLoadedInventory', identifier, type, data, save)
    if openInventory[identifier] ~= nil then
        if #openInventory[identifier] > 0 then
            --	    	print("Tried saving a opened inventory")
            return
        end
    end

    if loadedInventories[type][identifier] == nil then
        print("Tried saving a unloaded inventory")
        return
    end

    if type == 'drop' then
        return
    end

    if table.length(data) > 0 then
        local saveData = data

        if saveData == "null" or saveData == nil then
            print("null inv save")
            TriggerEvent('DiscordBot:ToDiscord', 'staff-inventory', 'Null Inventory ' .. type .. ' ' .. identifier, 'IMAGE_URL', true)
            return
        end

        if type == 'player' then
            if save == true then
                local success, result = table.unpack(exports.mongodb:updateOne({ collection = "inventory", query = { owner = identifier, type = type }, update = { ["$set"] = { data = saveData } } }))
                if result == 0 then
                    createInventory(identifier, type, data)
                else
                    loadedInventories[type][identifier] = nil
                end
            end
        else
            if save == true then
                local success, result = table.unpack(exports.mongodb:updateOne({ collection = "inventory", query = { owner = identifier, type = type }, update = { ["$set"] = { data = saveData } } }))
                if result == 0 then
                    createInventory(identifier, type, data)
                else
                    loadedInventories[type][identifier] = nil
                end
            end
            if type == 'evidence' then
                deleteInventory(identifier, type)
            end
        end
    else
        deleteInventory(identifier, type)
    end
end

function createInventory(identifier, type, data)
    if type == 'drop' then
        if table.length(data) > 0 then
            TriggerEvent("prp-inventory:addDrop", identifier, json.encode(data))
        end
        return
    end

    local success, result = table.unpack(exports.mongodb:insertOne({
        collection = "inventory",
        document = {
            owner = identifier,
            type = type,
            data = data
        }
    }))
    TriggerEvent("prp-inventory:createdInventory", identifier, type, data)
    loadedInventories[type][identifier] = nil
end

function deleteInventory(identifier, type, supress, source)
    if supress == true and type == 'player' and source ~= nil then
        idk(identifier, type, function(inventory)
            for k, v in pairs(inventory) do
                for j, h in pairs(weapons) do
                    if v.name == h then
                        TriggerEvent('prp-inventory:removeItem', source, v.name, v.count)
                    end
                end
            end
        end)
        return
    end
    local success, result = table.unpack(exports.mongodb:deleteOne({
        collection = "inventory",
        query = {
            owner = identifier,
            type = type
        }
    }))
    loadedInventories[type][identifier] = nil
    TriggerEvent("prp-inventory:deletedInventory", identifier, type)
end

function getDisplayInventory(identifier, type, cb, source)
    idk(identifier, type, function(inventory)
        local itemsObject = {}
        for k, v in pairs(inventory) do
            local esxItem = inventoryItem(v.name)
            local item = createDisplayItem(v, esxItem, tonumber(k), nil, 'item', identifier, type)
            table.insert(itemsObject, item)
        end

        local inv
        if type == "player" then
            inv = {
                invId = identifier,
                invTier = InvType[type],
                inventory = itemsObject,
            }
        else
            inv = {
                invId = identifier,
                invTier = InvType[type],
                inventory = itemsObject,
            }
        end
        cb(inv)
    end)
end

function getInventory(identifier, type, cb)
    if loadedInventories[type][identifier] ~= nil then
        cb(loadedInventories[type][identifier])
    else
        loadInventory(identifier, type, cb)
    end
end

function idk(identifier, type, cb)
    if loadedInventories[type][identifier] ~= nil then
        cb(loadedInventories[type][identifier])
    else
        loadInventory(identifier, type, cb)
    end
end

function applyToInventory(identifier, type, f)
    if loadedInventories[type][identifier] ~= nil then
        f(loadedInventories[type][identifier])
    else
        loadInventory(identifier, type, function()
            applyToInventory(identifier, type, f)
        end)
    end
    if loadedInventories[type][identifier] and table.length(loadedInventories[type][identifier]) > 0 then
        TriggerEvent("prp-inventory:modifiedInventory", identifier, type, loadedInventories[type][identifier])
    else
        TriggerEvent("prp-inventory:modifiedInventory", identifier, type, nil)
    end
end

function loadInventory(identifier, type, cb)
    if type == 'drop' then
        if obtainDrops[identifier] then
            local inventory = json.decode(obtainDrops[identifier])
            loadedInventories[type][identifier] = inventory
            cb(inventory)
        else
            loadedInventories[type][identifier] = {}
            cb({})
        end
        return
    end

    if type == 'shop' then
        local shop = Config.Shops[identifier]
        local items = {}
        for k, v in pairs(shop.items) do
            v.usable = false
            items[tostring(k)] = v
        end
        cb(items)
        loadedInventories[type][identifier] = items
        return
    end
    if type == 'gunshop' then
        local shop = Config.Shops[identifier]
        local items = {}
        for k, v in pairs(shop.items) do
            v.usable = false
            items[tostring(k)] = v
        end
        cb(items)
        loadedInventories[type][identifier] = items
        return
    end
    if type == 'craft' then
        if obtainCraftStatus[identifier] then
            local inventory = json.decode(obtainCraftStatus[identifier])
            loadedInventories[type][identifier] = inventory
            cb(inventory)
        else
            loadedInventories[type][identifier] = {}
            cb({})
        end
        return
    end
    local success, load = table.unpack(exports.mongodb:findOne({
        collection = 'inventory',
        query = {
            owner = identifier,
            type = type
        }
    }))
    if not success or #load == 0 then
        print('Failed loading inventory for ' .. tostring(identifier) .. ' and type ' .. tostring(type))
        loadedInventories[type][identifier] = {}
        cb({})
        return
    end
    inventory = load[1].data
    loadedInventories[type][identifier] = inventory
    cb(inventory)
    --TriggerEvent("prp-inventory:loadedInventory", identifier, type, inventory)
end

function itemCount(item, identifier)
    if item ~= nil and identifier ~= nil then
        local actualamount = 0
        idk(identifier, 'player', function(inventory)
            for k, v in pairs(inventory) do
                if v.name == item then
                    actualamount = actualamount + v["count"]
                end
            end
        end)
        return actualamount
    end
end

function hasItem(item, identifier)
    if item ~= nil then
        local Item = false
        idk(identifier, 'player', function(inventory)
            for k, v in pairs(inventory) do
                if v.name == item then
                    Item = true
                    break
                end
            end
        end)
        return Item
    end
end

function getWeight(identifier)
    local weight = 0
    idk(identifier, 'player', function(inventory)
        if inventory then
            for k, v in pairs(inventory) do
                local itemForWeight = inventoryItem(v.name).weight * v.count
                weight = weight + itemForWeight
            end
        end
    end)
    return weight
end

function itemWeight(item, count, identifier)
    local weight = inventoryItem(item).weight
    local final = weight * count
    return final
end

function canCarryItem(item, count, source)
    local player = ESX.GetPlayerFromId(source)
    local identifier = player.identifier
    local itemWeight = inventoryItem(item).weight * count

    local something = itemWeight + getWeight(identifier)

    if something < 250 then
        return true
    else
        return false
    end
end

RegisterNetEvent("prp-inventory:checkWeight")
AddEventHandler("prp-inventory:checkWeight", function()
    local src= source
    if src ~= nil then
        local player = ESX.GetPlayerFromId(src)

        local identifier = player.identifier
        local currentWeight = getWeight(identifier)
        TriggerClientEvent('prp-inventory:overweight', src, currentWeight)
    end
end)

RegisterNetEvent("prp-inventory:removeItems")
AddEventHandler("prp-inventory:removeItems", function(identifier)
    if identifier ~= nil then
        local success, result = table.unpack(exports.mongodb:deleteOne({
            query = {
                owner = identifier,
                type = 'player'
            }
        }))
        if result == 0 then
            createInventory(identifier, type, data)
        else
            loadedInventories[type][identifier] = nil
        end
    end
end)

RegisterNetEvent("prp-inventory:wipeInventory")
AddEventHandler("prp-inventory:wipeInventory", function()
    local src = source
    local player = ESX.GetPlayerFromId(src)

    closeAllOpenInventoriesForSource(src)
    local identifier = player.identifier

    if identifier ~= nil then
        deleteInventory(identifier, 'player')
        --[[
        MySQL.Async.execute("DELETE FROM prp-inventory WHERE owner = @owner AND type = @type", {["@owner"] = identifier, ["@type"] = 'player' }, function(result)
            if result == 0 then
                createInventory(identifier, 'player', data)
            elseif loadedInventories['player'][identifier] then
                loadedInventories['player'][identifier] = nil
            end
        end)]]--
    end
end)

function GetInventoryItem(identifier, type, name)
    local item = nil
    local p = promise.new()
    idk(identifier, type, function(inv)
        for k, v in pairs(inv) do
            if v.name == name then
                if item == nil then
                    item = v
                else
                    item.count = item.count + v.count
                end
            end
        end
        p:resolve(item)
    end)
    return Citizen.Await(p)
end

exports('getInventory', idk)
exports('GetInventoryItem', GetInventoryItem)
exports('itemCount', itemCount)
exports('getWeight', getWeight)
exports('canCarryItem', canCarryItem)
exports('hasItem', hasItem)
exports('deleteInventory', deleteInventory)
