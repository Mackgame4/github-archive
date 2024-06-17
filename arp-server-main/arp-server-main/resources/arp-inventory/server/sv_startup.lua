CachedInventories = {}
AccessingInventories = {}
Initialized = false

AddEventHandler('ARP:Shared:Ready', function(resource)
    if resource == GetCurrentResourceName() or resource == 'all' then
        Callbacks = exports['arp-base']:Component('Callbacks')
        CachedInventories = {}
        for type, typeData in pairs(InventoryTypes) do 
            CachedInventories[type] = {}
            AccessingInventories[type] = {}
        end
        
        -- ? Deleted Dropzones because they aren't persistent -- maybe change their persistence and make them last a day or 2? - cba
        
        local deletedDropzoneInventories = DB:DeleteOne('inventories', { type = 'dropzone' })
        local deletedDropzoneItems =  DB:Delete('items', { inventoryType = 'dropzone' })
        if deletedDropzoneInventories then
            Logging:Debug('Inventory', ('Deleted %s Dropzone Inventories'):format(deletedDropzoneInventories.deleted))
        end
        if deletedDropzoneItems then 
            Logging:Debug('Inventory', ('Deleted %s Dropzone Items'):format(deletedDropzoneItems.deleted))
        end
        
        local inventories = DB:Count('inventories', {}, {})
        local items = DB:Count('items', {}, {})
        if inventories.success and items.success then 
            Logging:Info('Inventory', ('Successfully Loaded %s Total Inventories and %s Total Items.'):format(inventories.count, items.count))
        else
            Logging:Error('Inventory', 'Failed to Load Inventories and Inventory Items.')
        end

        Initialized = true 
        
        RegisterCallbacks()
        RegisterCommands()
        TriggerEvent('Inventory:Server:Ready')
    end
end)

AddEventHandler('ARP:Characters:LoggedIn', function(src, cid)
    TriggerClientEvent('Inventory:Client:SetItemData', src, ItemData)
    local Character = exports['arp-base']:GetChar(src)
    if not Character then return end
    AddAccessorToInventory('character',  tostring(Character.CID), src) -- * the owner of the inventory is 'always' accessing it
    local success, justCreated = CreateInventory('character', tostring(Character.CID))
    if success and justCreated then 
        Logging:Debug('Inventory', ('Created Initial Character Inventory For %s'):format(exports['arp-base']:GetCharForLogging(Character)))
        -- TODO: Add Fucking First Items here would be cool
    end
end)

AddEventHandler('Inventory:Server:Ready', function() -- * some default inventories are here
    CreateInventory('storage', 'dev', {
        maxWeight = 10000.0,
        maxSlots = 360,
    })
end)