function RegisterCallbacks()
    Callbacks:Register('Inventory:Open', function(src, callback) -- for general opening (dropzones here )
        TriggerClientEvent('Inventory:Client:SetItemData', src, ItemData)
        local Character = exports['arp-base']:GetChar(src)
        if not Character then return callback(false) end
        local playerCoords = RoundVectorToEven(GetEntityCoords(GetPlayerPed(src)))
        local currentDropZoneIdentifier = ('%d_%d_%d'):format(playerCoords.x, playerCoords.y, playerCoords.z)
        local existingDropzone = LoadInventory('dropzone', currentDropZoneIdentifier)
        local remoteInventory = false
        if existingDropzone then
            remoteInventory = existingDropzone:GetDataForClient()
        else
            remoteInventory = GetTemplateDropzone(currentDropZoneIdentifier) -- use template data so we don't have to create the inventory when it is empty
        end

        local characterInventory = LoadInventory('character', tostring(Character.CID))
        if not characterInventory or not remoteInventory then 
            return callback(false)
        end

        local characterInventoryData = characterInventory:GetDataForClient()

        print('character opening inventory with dropzone')

        exports['arp-base']:SetCharTemp(src, 'Inventory', { type = remoteInventory.type, identifier = remoteInventory.identifier })
        AddAccessorToInventory('character',  tostring(Character.CID), src) -- this is just for dev to be lazy
        AddAccessorToInventory(remoteInventory.type, remoteInventory.identifier, src)

        callback(true, characterInventoryData, remoteInventory)
    end)
end

function OpenRemoteInventory(src, remType, remIdentifier)
    print(src, remType, remIdentifier)
    local Character = exports['arp-base']:GetChar(src)
    if not Character then return end
    local inInventory = exports['arp-base']:GetCharTemp(src, 'Inventory')
    if inInventory and inInventory.type then return end
    if IsInventoryTypeValid(remType) and remType ~= 'dropzone' and type(remIdentifier) == 'string' then 
        local remoteInventory = LoadInventory(remType, remIdentifier)
        local theirInventory = LoadInventory('character', tostring(Character.CID))
        if remoteInventory and theirInventory then 
            AddAccessorToInventory(remoteInventory.type, remoteInventory.identifier, src)
            exports['arp-base']:SetCharTemp(src, 'Inventory', { type = remoteInventory.type, identifier = remoteInventory.identifier })
            TriggerClientEvent('Inventory:Client:Open', Character.Source, theirInventory:GetDataForClient(), remoteInventory:GetDataForClient())
        end
    end
end

RegisterNetEvent('Inventory:Server:Close')
AddEventHandler('Inventory:Server:Close', function()
    print('close the inventory')
    local src = source
    local Character = exports['arp-base']:GetChar(src)
    if Character then 
        local inInventory = exports['arp-base']:GetCharTemp(src, 'Inventory')
        if inInventory then 
            RemoveAccessorFromInventory(inInventory.type, inInventory.identifier, src)
            exports['arp-base']:SetCharTemp(src, 'Inventory', false)
        end
    end
end)

AddEventHandler('ARP:Characters:Logout', function(src, cid, inventory)
    if inventory and inventory.type and inventory.identifier then 
        RemoveAccessorFromInventory(inInventory.type, inInventory.identifier, src)
        RemoveAccessorFromInventory('character', tostring(cid), src)
    end
end)

RegisterNetEvent('Inventory:Server:MoveItem')
AddEventHandler('Inventory:Server:MoveItem', function(fromRemote, fromSlot, toRemote, toSlot, amount)
    local src = source
    local Character = exports['arp-base']:GetChar(src)

    if Character then
        local remoteInventory = false
        local characterInventory = LoadInventory('character', tostring(Character.CID))
        local itemBeingMoved = false 
        local targetSlot = false
        local begin = os.clock()


        if fromRemote or toRemote then 
            local inRemote = exports['arp-base']:GetCharTemp(src, 'Inventory')
            if not inRemote then 
                return
            end
            remoteInventory = LoadInventory(inRemote.type, inRemote.identifier)
            if not remoteInventory and inRemote.type == 'dropzone' then -- the dropzone does not exist so make it now something is being moved to it and it is no longer empty
                local createdDropzone = CreateInventory(inRemote.type, inRemote.identifier)
                if createdDropzone then 
                    remoteInventory = LoadInventory(inRemote.type, inRemote.identifier)
                end
            end

            if not remoteInventory then 
                characterInventory:SendUpdates()
                TriggerClientEvent('UI:Client:Notify', src, 'error', 'Error')
                return 
            end
        end
        
        if fromRemote then 
            itemBeingMoved = remoteInventory:GetSlot(fromSlot)
        else
            itemBeingMoved = characterInventory:GetSlot(fromSlot)
        end

        if toRemote then
            targetSlot = remoteInventory:GetSlot(toSlot)
        else
            targetSlot = characterInventory:GetSlot(toSlot)
        end

        if itemBeingMoved then 
            if fromRemote == toRemote then -- within the same inventory


                local thisInventory = fromRemote and remoteInventory or characterInventory
                if targetSlot then -- there is an item in the target slot, need to add them if possible
                    local movingItemData = itemBeingMoved
                    local itemData = ItemData[movingItemData.item]
                    local targetItemData = targetSlot
                    if movingItemData.item == targetItemData.item and itemData.canMerge then
                        local newTotalCount = targetItemData.count + movingItemData.count -- the new if they are added
                        if newTotalCount <= itemData.max then -- can fit added together
                            thisInventory:ClearSlot(fromSlot)
                            thisInventory:SetSlot(toSlot, {
                                item = targetItemData.item,
                                count = newTotalCount,
                                meta = targetItemData.meta -- eh, it can have it  - doesn't really matter anyway, items like this will not have metadata
                            })
                        end
                    end
                else -- target slot is empty just move this item here and delete from old slot
                    local movingItemData = itemBeingMoved
                    if amount <= 0 or amount >= movingItemData.count then -- then we moving all of it bitch
                        thisInventory:ClearSlot(fromSlot)
                        thisInventory:SetSlot(toSlot, movingItemData)
                    else -- splitting the stack
                        local remaindingAmountInOld = movingItemData.count - amount
                        thisInventory:SetSlot(fromSlot, {
                            item = movingItemData.item,
                            count = remaindingAmountInOld,
                            meta = movingItemData.meta
                        })
                        thisInventory:SetSlot(toSlot, {
                            item = movingItemData.item,
                            count = amount,
                            meta = movingItemData.meta
                        })
                    end
                end


            elseif fromRemote ~= toRemote then -- across two inventories

                local fromInventory = fromRemote and remoteInventory or characterInventory
                local targetInventory = toRemote and remoteInventory or characterInventory
                if targetSlot then -- there is an item in the target slot, need to add them if possible
                    local movingItemData = itemBeingMoved
                    local itemData = ItemData[movingItemData.item]
                    local targetItemData = targetSlot

                    if movingItemData.item == targetItemData.item and itemData.canMerge then
                        if amount <= 0 or amount >= movingItemData.count then 
                            amount = movingItemData.count
                        end

                        local movingWeight = itemData.weight * amount
                        local newTotalCount = targetItemData.count + amount -- the new if they are added

                        if newTotalCount <= itemData.max then -- can fit added together
                            local targetCanHold = targetInventory:CanHoldWeight(movingWeight)

                            if targetCanHold then 
                                fromInventory:ClearSlot(fromSlot)
                                targetInventory:SetSlot(toSlot, {
                                    item = targetItemData.item,
                                    count = newTotalCount,
                                    meta = targetItemData.meta -- eh, it can have it  - doesn't really matter anyway, items like this will not have metadata
                                })

                                if targetInventory.type == 'character' then 
                                    local Character = exports['arp-base']:GetCharByCID(tonumber(targetInventory.identifier))
                                    TriggerClientEvent('Inventory:Client:ItemNotification', Character.Source, {
                                        item = targetItemData.item,
                                        count = newTotalCount
                                    })
                                end

                            else
                                -- error or something, the other inventory is full
                                TriggerClientEvent('UI:Client:Notify', src, 'error', 'Inventory Full')
                            end

                        end
                    end
                else
                    local movingItemData = itemBeingMoved
                    local itemData = ItemData[movingItemData.item]
                    if amount <= 0 or amount >= movingItemData.count then -- then we moving all of it bitch
                        local movingWeight = itemData.weight * amount
                        local targetCanHold = targetInventory:CanHoldWeight(movingWeight)
                        if targetCanHold then 
                            fromInventory:ClearSlot(fromSlot)
                            targetInventory:SetSlot(toSlot, movingItemData)

                            if targetInventory.type == 'character' then 
                                local Character = exports['arp-base']:GetCharByCID(tonumber(targetInventory.identifier))
                                TriggerClientEvent('Inventory:Client:ItemNotification', Character.Source, {
                                    item = movingItemData.item,
                                    count = movingItemData.count
                                })
                            end

                        else
                            -- the other inventory is full
                            TriggerClientEvent('UI:Client:Notify', src, 'error', 'Inventory Full')
                        end
                    else -- splitting the stack
                        local remaindingAmountInOld = movingItemData.count - amount
                        local movingWeight = itemData.weight * amount
                        local targetCanHold = targetInventory:CanHoldWeight(movingWeight)

                        if targetCanHold then 
                            fromInventory:SetSlot(fromSlot, {
                                item = movingItemData.item,
                                count = remaindingAmountInOld,
                                meta = movingItemData.meta
                            })
                            targetInventory:SetSlot(toSlot, {
                                item = movingItemData.item,
                                count = amount,
                                meta = movingItemData.meta
                            })

                            if targetInventory.type == 'character' then 
                                local Character = exports['arp-base']:GetCharByCID(tonumber(targetInventory.identifier))
                                TriggerClientEvent('Inventory:Client:ItemNotification', Character.Source, {
                                    item = movingItemData.item,
                                    count = amount
                                })
                            end

                        end
                    end
                end


            end
        end
        print(string.format("exec time: %.2fms\n", ((os.clock() - begin) * 1000)))
        characterInventory:SendUpdates()
        if remoteInventory then
            remoteInventory:SendUpdates()
        end
    end
end)

RegisterNetEvent('Inventory:Server:UseItem')
AddEventHandler('Inventory:Server:UseItem', function(slot)
    local src = source
    local Character = exports['arp-base']:GetChar(src)
    if Character then 
        local characterInventory = LoadInventory('character', tostring(Character.CID)) 
        if characterInventory then
            local item = characterInventory:GetSlot(slot)
            if item then 
                local itemData = ItemData[item.item]
                if itemData and itemData.usable then 

                    local function removeOneOfItemFromSlot()
                        if item.count > 1 then
                            characterInventory:SetSlot(slot, {
                                item = item.item,
                                count = item.count - 1,
                                meta = item.meta
                            })
                        else
                            characterInventory:ClearSlot(slot)
                        end
                        TriggerClientEvent('Inventory:Client:ItemNotification', src, {
                            item = item.item,
                            count = -1
                        })
                    end

                    if itemData.removeOnUse or (itemData.degradeOnUse and item.meta.health <= 0) then 
                        removeOneOfItemFromSlot()
                    else
                        if itemData.degradeOnUse and item.meta.health then 
                            local newMeta = item.meta
                            ARP.PrintTable(newMeta)
                            newMeta.health = newMeta.health - itemData.degradeOnUse
                            if newMeta.health > 0 then 
                                characterInventory:SetSlot(slot, {
                                    item = item.item,
                                    count = item.count,
                                    meta = newMeta
                                })
                                TriggerClientEvent('Inventory:Client:ItemNotification', src, {
                                    item = item.item,
                                    count = '-Health'
                                })
                            else
                                removeOneOfItemFromSlot()
                            end

                            TriggerClientEvent('Inventory:Client:ItemNotification', src, {
                                item = item.item,
                                count = '-Health'
                            })
                        else
                            TriggerClientEvent('Inventory:Client:ItemNotification', src, {
                                item = item.item,
                                count = 'Used'
                            })
                        end
                    end
                    TriggerEvent('Inventory:Server:CharacterUsedItem', Character, slot, item.item, item.meta)
                end
            end
            characterInventory:SendUpdates()
        end
    end
end)

AddEventHandler('Inventory:Server:CharacterUsedItem', function(Character, slot, item, meta)
    Logging.Debug(('Character %s Used Item %s From Slot %s'):format(exports['arp-base']:GetCharForLogging(Character), item, slot))
end)




--local begin = os.clock()
--print(string.format("total time:%.2fms\n", ((os.clock() - begin) * 1000)))