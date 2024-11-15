RegisterServerEvent("ui-inventory:savePlayerInventory")
AddEventHandler("ui-inventory:savePlayerInventory", function(player, playerInventory)
	local id = player.id
    local identifier = ML.Server.GetIdentifier(player.id)
    ML.Shared.Log('Saving player inventory: '..id..' ('..identifier..')', 'log')
end)

RegisterNetEvent('mack_libs:playerSpawned')
AddEventHandler("mack_libs:playerSpawned", function()
    local _source = source
    local identifier = ML.Server.GetIdentifier(source)
    ML.Shared.Log('Loading player inventory: '..source..' ('..identifier..')', 'log')
    ML.DB.Execute("find", {
        collection = "inventory",
        query = { identifier = identifier }
    }, function(success, result)
        if #result > 0 then
            local inventory = result[1]
            TriggerClientEvent("ui-inventory:loadPlayerInventory", _source, inventory)
        else
            ML.Shared.Log("No inventory found creating/adding one for the player...", "warn")
            local playerInventory = {
                { name = 'id', quantity = 1, slot = 1 },
                { name = 'bread', quantity = 2, slot = 2 },
                { name = 'water', quantity = 4, slot = 3 }
            }
            ML.DB.Execute("insertOne", {
                collection = "inventory",
                document = { identifier = identifier, playerInventory = playerInventory }
            }, function(success, result, insertedIds)
                if success and result then
                    ML.Shared.Log("Successfully created inventory for player"..identifier, "warn")
                    TriggerClientEvent("ui-inventory:loadPlayerInventory", _source, playerInventory)
                else
                    ML.Shared.Log("Failed to create inventory for player"..identifier, "error")
                end
            end)
        end
    end)
end)

AddEventHandler('mack_libs:playerDropped', function(player, reason)
    -- TODO: get player inventory
    print(player)
    TriggerEvent('ui-inventory:savePlayerInventory', player)
end)

RegisterServerEvent("ui-inventory:dropItem")
AddEventHandler("ui-inventory:dropItem", function(prop) -- TODO: Add itemName and itemData
    --ML.Shared.Log('Dropping item: '..itemName..' ('..identifier..')', 'info')
    TriggerClientEvent('ui-inventory:spawnItem', -1, prop)
end)