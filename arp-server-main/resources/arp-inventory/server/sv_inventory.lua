function LoadInventory(invType, id)
    if not IsInventoryTypeValid(invType) or type(id) ~= 'string' then 
        return false
    end

    if CachedInventories[invType] ~= nil and CachedInventories[invType] and CachedInventories[invType][id] ~= nil then
        return CachedInventories[invType][id]
    end

    local invData = DB:FindOne('inventories', { type = invType, identifier = id }, {})

    if not invData.success or #invData.docs ~= 1 then -- make sure both operations were successful, and that inventory does exist
        return false
    end

    local inventoryData = invData.docs[1]
    
    _inv = {
        type = inventoryData.type,
        identifier = inventoryData.identifier,
        maxSlots = inventoryData.maxSlots,
        maxWeight = inventoryData.maxWeight,
        meta = inventoryData.meta,
        items = {},
        busy = false
    }

    _inv.SetBusy = function(self, toggle)
        self.busy = toggle
    end

    _inv.IsBusy = function(self)
        return self.busy
    end

    _inv.FetchSlots = function(self)
        local fetchedInventoryItems = DB:Find('items', { inventoryType = self.type, inventoryIdentifier = self.identifier }, {})
        if fetchedInventoryItems.success then 
            self.items = {}
            for _, item in ipairs(fetchedInventoryItems.docs) do
                if item.item and item.count and item.slot then 
                    self.items[item.slot] = ItemifyItemData(item)
                end
            end
            return self.items
        else
            return {}
        end
    end

    _inv.GetMaxSlots = function(self)
        return self.maxSlots
    end

    _inv.GetMaxWeight = function(self)
        return self.maxWeight
    end

    _inv.GetAllMeta = function(self)
        return self.meta
    end

    _inv.GetMeta = function(self, key)
        return self.meta[key]
    end

    _inv.SetMeta = function(self, key, value)
        local newMeta = self.meta
        newMeta[key] = value
        local updated = DB:UpdateOne('inventories', { type = self.type, identifier = self.identifier }, { 
            ['$set'] = { 
                meta = newMeta
            }
        })
        if updated.success then 
            self.meta = newMeta
            return true
        else
            return false
        end
    end

    _inv.GetSlots = function(self, force)
        if force then 
            self:FetchSlots()
        end
        return self.items
    end 

    _inv.GetSlot = function(self, slot)
        if slot >= 1 and slot <= self:GetMaxSlots() then 
            if self.items[slot] ~= nil then 
                return self.items[slot]
            end
        end
        return false
    end

    _inv.SetSlot = function(self, slot, itemData)
        if type(itemData) == 'table' then 
            if self:GetSlot(slot) then 
                local slotUpdate = DB:UpdateOne('items', { inventoryType = self.type, inventoryIdentifier = self.identifier, slot = slot }, { ['$set'] = itemData })
                return slotUpdate.success
            else
                itemData.inventoryType = self.type 
                itemData.inventoryIdentifier = self.identifier
                itemData.slot = slot
                local slotAdd = DB:InsertOne('items', itemData)
                if slotAdd.success and #slotAdd.inserted >= 1 then 
                    return true
                end
            end
            self:FetchSlots()
        end
        return false
    end

    _inv.ClearSlot = function(self, slot)
        if self:GetSlot(slot) then 
            local slotDelete = DB:DeleteOne('items', { inventoryType = self.type, inventoryIdentifier = self.identifier, slot = slot })
            if slotDelete.success and slotDelete.deleted >= 1 then
                return true 
            else
                return false
            end
            self:FetchSlots()
        else -- already doesn't exist
            return true
        end
    end

    _inv.GetCurrentWeight = function(self)
        local inventoryItems = self.items
        local weight = 0.0
        for slot, item in pairs(inventoryItems) do 
            local itemWeight = ItemData[item.item].weight
            local slotWeight = itemWeight * item.count
            weight = weight + slotWeight
        end
        return weight
    end

    _inv.CanHoldWeight = function(self, weight)
        local maxWeight = self:GetMaxWeight()
        local currentWeight = self:GetCurrentWeight()
        local newWeight = currentWeight + weight
        if newWeight <= maxWeight then 
            return true
        else
            return false
        end
    end

    _inv.GetFreeSlotForItem = function(self, item, count, ignoreSlots) 
        if ignoreSlots == nil then ignoreSlots = {} end
        local inventoryItems = self.items
        local itemData = ItemData[item]
        for slot = 1, self:GetMaxSlots() do
            if not ignoreSlots[slot] then 
                if inventoryItems[slot] == nil then
                    return slot, count
                elseif inventoryItems[slot].item == item then
                    local newCount = inventoryItems[slot].count + count
                    if newCount <= itemData.max then
                        return slot, newCount
                    end
                end
            end
        end
        return false, false
    end

    _inv.GetAllOfItem = function(self, item)
        local allOfItem = {}
        local completeInventory = self:GetSlots()
        for slot, itemData in ipairs(completeInventory) do
            if itemData.item == item then
                table.insert(allOfItem, ItemifyItemData(itemData)) 
            end
        end
        return allOfItem
    end

    _inv.GetAmountOfItem = function(self, item)
        local allOfItem = self:GetAllOfItem(item)
        if #allOfItem <= 0 then
            return 0
        end
        local itemCount = 0
        for _, itemData in pairs(allOfItem) do
            itemCount = itemCount + itemData.count
        end
        return itemCount
    end

    _inv.HasAmountOfItem = function(self, item, count)
        local amountOfItem = self:GetAmountOfItem(item)
        if amountOfItem >= count then 
            return true
        end
        return false
    end
    
    _inv.GetDataForClient = function(self)
        return {
            type = self.type,
            identifier = self.identifier,
            maxSlots = self.maxSlots,
            maxWeight = self.maxWeight,
            meta = self.meta,
            items = self.items,
            currentWeight = self:GetCurrentWeight()
        }
    end

    _inv.SendUpdates = function(self)
        self:FetchSlots()
        local data = self:GetDataForClient() 
        SendAllAccessorsInInventoryEvent(self.type, self.identifier, 'Inventory:Client:UpdateInventory', data)
    end

    _inv.RemoveAmountOfItem = function(self, item, count)
        local itemData = ItemData[item]
        if self:HasAmountOfItem(item, count) then
            local removedItemCount = 0
            local allOfItem = self:GetAllOfItem(item)
            for _, anItem in pairs(allOfItem) do 
                if removedItemCount < count then 
                    self:ClearSlot(anItem.slot)
                    removedItemCount = removedItemCount + anItem.count
                end
                if removedItemCount == count then 
                    self:SendUpdates()
                    return true
                end
            end
        else
            return false
        end
    end

    _inv.AddItems = function(self, item, count, meta)
        if meta == nil then meta = {} end
        local itemData = ItemData[item]
        local maxWeight = self:GetMaxWeight()
        local currentWeight = self:GetCurrentWeight()
        local addingItemWeight = itemData.weight * count
        local newTotalWeight = currentWeight + addingItemWeight
        
        if newTotalWeight <= maxWeight then
            local completelyFullItems = math.floor(count / itemData.max)
            local remaindingItems = count % itemData.max
            local slotsToAddInto = {}

            local theMeta = {}

            if itemData.degradation then 
                theMeta.health = 100
            end

            for i = 1, completelyFullItems do 
                local targetSlot, newTotal = self:GetFreeSlotForItem(item, itemData.max, ARP.GetTableKeys(slotsToAddInto))
                if targetSlot then
                    slotsToAddInto[targetSlot] = {
                        slot = remainderTargetSlot,
                        count = itemData.max
                    }
                else
                    return false
                end
            end
            if remaindingItems > 0 then 
                local remainderTargetSlot, remainderNewTotal = self:GetFreeSlotForItem(item, remaindingItems, ARP.GetTableKeys(slotsToAddInto))
    
                if not remainderTargetSlot then 
                    return false
                end
    
                slotsToAddInto[remainderTargetSlot] = {
                    slot = remainderTargetSlot,
                    count = remainderNewTotal
                }
            end

            for slot, itemToAdd in pairs(slotsToAddInto) do 
                self:SetSlot(slot, {
                    item = item,
                    count = itemToAdd.count,
                    meta = theMeta,
                })
            end

            self:SendUpdates()

            local Character = exports['arp-base']:GetCharByCID(tonumber(self.identifier))
            TriggerClientEvent('Inventory:Client:ItemNotification', Character.Source, {
                item = item,
                count = count
            })

            return true
        else
            return false
        end
    end

    _inv:FetchSlots()

    return _inv
end

function UnloadInventory(invType, id)
    if IsInventoryTypeValid(invType) and type(id) == 'string' and CachedInventories[invType] ~= nil and CachedInventories[invType] and CachedInventories[invType][id] ~= nil then
        CachedInventories[invType][id] = nil
        TriggerClientEvent('Inventory:Client:InventoryUnloaded', invType, id)
        TriggerEvent('Inventory:Server:InventoryUnloaded', invType, id)
        collectgarbage()
    end
end

function CreateInventory(invType, id, optionals)
    if IsInventoryTypeValid(invType) and type(id) == 'string' then 
        local existingInventory = LoadInventory(invType, id)
        if existingInventory ~= nil and existingInventory then 
            return true, false
        else
            local inventoryData = InventoryTypes[invType]

            local maxSlots = inventoryData.maxSlots
            local maxWeight = inventoryData.maxWeight
            if optionals and type(optionals) == 'table' then 
                if optionals.maxSlots and type(optionals.maxSlots) == 'number' then 
                    maxSlots = optionals.maxSlots
                end
                if optionals.maxWeight and type(optionals.maxWeight) == 'number' then 
                    maxWeight = optionals.maxWeight
                end
            end
            local createdInventory = DB:InsertOne('inventories', {
                type = invType,
                identifier = id,
                maxSlots = maxSlots,
                maxWeight = maxWeight,
                meta = {
                    createdAt = os.time()
                },
            })
            if createdInventory.success and #createdInventory.inserted > 0 then 
                return true, true
            end
        end
    end
    return false, false
end

function DeleteInventory(invType, id)
    UnloadInventory(invType, id)
    local deletedInv = DB:DeleteOne('inventories', { type = invType, identifier = id })
    if deletedInv.success then 
        DB:Delete('items', { inventoryType = invType, inventoryIdentifier = id })
    end
end