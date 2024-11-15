-- Save status to database
RegisterServerEvent("savePlayerStatus")
AddEventHandler("savePlayerStatus", function(hunger, thirst)
	local _source = source
	local identifier = ESX.GetIdentifier(source)
	exports.mongodb:updateOne({ collection="users", query = { identifier = identifier }, update = { ["$set"] = { hunger = hunger, thirst = thirst } } })
end)

-- Get status from database at spawn
RegisterServerEvent("getPlayerStatus")
AddEventHandler("getPlayerStatus", function()
	local _source = source
	local identifier = ESX.GetIdentifier(source)
	exports.mongodb:find({ collection="users", query = { identifier = identifier }, options = { projection = { hunger = 1, thirst = 1, _id = 0 } } }, function (success, result)
		if not success then
			print("[MongoDB] Error in find: "..tostring(result))
			return
		end
		if #result > 0 then
			TriggerClientEvent("PlayerStatus", _source, result)
		else
			TriggerClientEvent("PlayerStatus", _source, {{hunger = 100, thirst = 100}})
		end
	end)
end)

Citizen.CreateThread(function()
	for k, v in ipairs(Config.Consumables) do
--[[		exports.mongodb:findOne({ collection="items", query = { name = v.name } }, function (success, result)
			if not success then
				return
			end
			if #result == 0 then
				exports.mongodb:insertOne({ collection="items", document = {name = v.name, label = v.label, weight = v.weight, rare = v.rare, can_remove = v.can_remove}}, function (success, result, insertedIds)
					if not success then
						print("[^2MongoDB^7] Error in insertOne: "..tostring(result))
						return
					end
					ESX.Log("[^5"..GetCurrentResourceName().."^7]", "[^2MongoDB^7] New item: "..tostring(insertedIds[1]))
				end)
			end
		end)]]

		ESX.RegisterUsableItem(v.name, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeInventoryItem(v.name, 1)

			TriggerClientEvent('UpdateFoodDrink', v.hunger, v.thirst)
			ESX.Log("[^5"..GetCurrentResourceName().."^7]", "Used item: "..v.name)
		end)
	end
end)

ESX.RegisterCommand('revive', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('revivePlayer')
	args.playerId.triggerEvent('chat:addMessage', {args = {'^5REVIVE', 'You have been healed.'}})
end, true, {help = 'Revive a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {{name = 'playerId', help = 'the player id', type = 'player'}}})