function IsInventoryTypeValid(t)
    if type(t) == 'string' and InventoryTypes[t] ~= nil then 
        return true 
    end
    return false
end

function ItemifyItemData(item)
    if item.item and item.slot and item.count then 
        return {
            slot = item.slot,
            item = item.item,
            count = item.count,
            meta = type(item.meta) == 'table' and item.meta or {}
        }
    else
        return false
    end
end

function GetTemplateDropzone(currentDropZoneIdentifier)
    return {
        type = 'dropzone',
        identifier = currentDropZoneIdentifier,
        maxSlots = 24,
        maxWeight = 1000.0,
        meta = {},
        items = {},
        currentWeight = 0
    }
end

function DoesItemExist(item)
    if ItemData[item] ~= nil then 
        return item 
    end
    return false
end

function RoundVectorToEven(vect)
    return vector3(
        ARP.RoundEven(vect.x),
        ARP.RoundEven(vect.y),
        ARP.Round(vect.z)
    )
end