obtainCraftStatus = {}

AddEventHandler("onDatabaseConnect", function()
    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'craft',
        label = 'Craft',
        slots = 35,
        weight = '2000'
     })
end)

RegisterServerEvent("erp-inventory:craft")
AddEventHandler("erp-inventory:craft", function(identifier)
    local src = source
    local type = 'craft'
    local presentItems = {}
    local identifier = identifier.target

    idk(identifier, type, function(inventory)
        for k, v in pairs(inventory) do
            local item = v.name
            if presentItems[item] then
                presentItems[item] = presentItems[item] + v.count
            else
                presentItems[item] = 0
                presentItems[item] = presentItems[item] + v.count
            end
        end
    end)  

    local blueprints = findRecipes(identifier, presentItems)

    if blueprints then
        -- LOCK INVENTORY ON client
        TriggerClientEvent("disc-inventoryhud:ForceDisable", src, true)
        TriggerClientEvent('closeInventory', src)

        for k,v in pairs(blueprints) do
        	TriggerEvent('prp-inventory:addItem', src, k, v)
        	Wait(100)    
        end

        loadedInventories[type][identifier] = nil

        TriggerClientEvent('erp-inventory:craftSuccess', src)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = 'Craft Successful!', length = 5000 })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = 'You do not have any necessary requirements!', length = 5000 })
    end

end)

function findRecipes(reference, list)
    counter = 0

    recipes = Config["Craft"][reference]["recipes"]
    return_table = {}

    for k, v in pairs(recipes) do
        count = list[v.required_item.name]

        if count then
        	counter = counter + 1

            for j, l in pairs(v.return_item) do
                return_table[l.name] = l.count * count
            end
        	-- return_table[v.return_item.name] = v.return_item.count * count
        end
    end

    if counter > 0 then
    	return return_table
    end

    return nil
end