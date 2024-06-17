

function AddAccessorToInventory(type, identifier, src)
    if IsInventoryTypeValid(type) then 
        if AccessingInventories[type][identifier] == nil then 
            AccessingInventories[type][identifier] = {}
        end
        if not IsAccessorInInventory(type, identifier, src) then 
            table.insert(AccessingInventories[type][identifier], src)
            ARP.PrintTable(AccessingInventories[type][identifier])
        end
    end
end

function RemoveAccessorFromInventory(type, identifier, src)
    if IsInventoryTypeValid(type) and AccessingInventories[type][identifier] ~= nil and IsAccessorInInventory(type, identifier, src) then 
        local accessor = ARP.GetPositionInOrderedTable(AccessingInventories[type][identifier], src)
        if accessor ~= nil then 
            AccessingInventories[type][identifier][accessor] = nil
        end
    end
end

function IsAccessorInInventory(type, identifier, src)
    if IsInventoryTypeValid(type) and AccessingInventories[type][identifier] ~= nil then 
        local found = ARP.GetPositionInOrderedTable(AccessingInventories[type][identifier], src)
        if found ~= nil then 
            return true
        end
    end
    return false
end

function GetAllAccessorsInInventory(type, identifier)
    if AccessingInventories[type][identifier] ~= nil then 
        return AccessingInventories[type][identifier]
    end
    return false
end

function SendAllAccessorsInInventoryEvent(type, identifier, event, ...)
    local accessors = GetAllAccessorsInInventory(type, identifier)
    if accessors then 
        for _, src in ipairs(accessors) do 
            TriggerClientEvent(event, src, ...)
        end
    end
end
