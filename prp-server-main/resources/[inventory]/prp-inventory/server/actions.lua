RegisterNetEvent('prp-inventory:GetItemsInSlotsDisplay')
AddEventHandler('prp-inventory:GetItemsInSlotsDisplay', function()
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
	    idk(xPlayer.identifier, 'player', function(inventory)
	        local slotItems = {}
	        for i = 1, 5, 1 do
	            local item = inventory[tostring(i)]
	            if item then
	                local ESXItem = inventoryItem(item.name)
	                slotItems[i] = {
	                    itemId = item.name,
	                    label = ESXItem.label,
	                    qty = item.count,
	                    slot = i
	                }
	            else
	                slotItems[i] = nil
	            end
	        end
	        TriggerClientEvent('prp-inventory:ShowSlotItems', src, slotItems)
	    end)
	end
end)


RegisterNetEvent('prp-inventory:UseItemSlot')
AddEventHandler('prp-inventory:UseItemSlot', function(slot)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
	    idk(xPlayer.identifier, 'player', function(inventory)
	        if inventory[tostring(slot)] then
	            local ESXItem = inventoryItem(inventory[tostring(slot)].name)
	            TriggerEvent("prp-inventory:itemUse", ESXItem.name, src, ESXItem)
	        end
	    end)
	end
end)