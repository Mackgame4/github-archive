exports.mongodb:findOne({ collection="items", query = { name = 'radio' } }, function (success, result)
	if not success then
		return
	end
	if #result == 0 then
		exports.mongodb:insertOne({ collection="items", document = {name = 'radio', label = 'Radio', weight = 1, rare = 0, can_remove = 1}}, function (success, result, insertedIds)
			if not success then
				print("[^2MongoDB^7] Error in insertOne: "..tostring(result))
				return
			end
			ESX.Log("[^5"..GetCurrentResourceName().."^7]", "[^2MongoDB^7] New item: "..tostring(insertedIds[1]))
		end)
	end
end)

ESX.RegisterUsableItem('radio', function(source)
	TriggerClientEvent('_radio:use', source)
end)