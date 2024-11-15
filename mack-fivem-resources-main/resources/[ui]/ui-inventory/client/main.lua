local isFocused = false

RegisterNetEvent('ui-inventory:loadPlayerInventory')
AddEventHandler('ui-inventory:loadPlayerInventory', function(playerInventory)
    loadInvItems()
	Wait(1)
	SendNUIMessage({
		action = "loadItems", -- TODO: Add action to NUI
		playerInventory = playerInventory
	})
end)

function loadInvItems()
	ML.Shared.Log("Loading inventory items...", "log", GetCurrentResourceName())
	SendNUIMessage({
		action = "loadItems",
		items = Config.Items
	})
end

RegisterCommand("spawnObject", function() -- Debug Only
	TriggerServerEvent('ui-inventory:dropItem', "prop_cs_heist_bag_01")
end, false)

RegisterNetEvent('ui-inventory:spawnItem')
AddEventHandler('ui-inventory:spawnItem', function(prop)
	ML.Client.SpawnObject(prop)
end)

RegisterNUICallback('useInventoryItem', function(data, cb)
	TriggerEvent('ui-inventory:onItemUsage', data.name)
	cb('ok')
end)

RegisterNetEvent('ui-inventory:onItemUsage')
RegisterNUICallback('giveInventoryItem', function(data, cb)
	TriggerEvent('ui-inventory:onItemUsage', data.name)
	cb('ok')
end)

RegisterNUICallback('dropInventoryItem', function(data, cb)
	TriggerEvent('ui-inventory:onItemUsage', data.name)
	cb('ok')
end)

RegisterCommand("toggleInv", function()
    isFocused = not isFocused
	SetNuiFocus(isFocused, isFocused)
	SetNuiFocusKeepInput(isFocused)
	if isFocused then
		SendNUIMessage({
			action = "show"
		})
	else
		SendNUIMessage({
			action = "hide"
		})
	end
end, false)

-- Disable camera rotation when player is focused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		if isFocused then
			DisableAllControlActions(0)
		end
	end
end)

RegisterKeyMapping("toggleInv", "Opens and closes the inventpory", "keyboard", "TAB")