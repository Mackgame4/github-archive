RegisterServerEvent("getPlayerVehicles")
AddEventHandler("getPlayerVehicles", function()
	local _source = source
	local identifier = ESX.GetIdentifier(source)
	exports.mongodb:find({ collection="users", query = { identifier = identifier }, options = { projection = { ownedVehicles = 1, _id = 0 } } }, function (success, result)
		if not success then
			print("[MongoDB] Error in find: "..tostring(result))
			return
		end
		if #result > 0 then
			TriggerClientEvent("RetrieveVehicles", _source, result)
		else
			print("Couldnt found any avaliable vehicles.")
		end
	end)
end)