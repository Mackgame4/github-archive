RegisterNetEvent('Doors:Server:ToggleDoorLocks')
AddEventHandler('Doors:Server:ToggleDoorLocks', function(door)
    local src = source
    local success, newState = UpdateDoorState(src, door)
    if success then 
        if newState then 
            TriggerClientEvent('Client:Notify', src, 'error', 'Locked Door', false, 'mdi-door-closed-lock', 2500)
        else
            TriggerClientEvent('Client:Notify', src, 'success', 'Unlocked Door', false, 'mdi-door', 2500)
        end
    elseif newState ~= nil then
        TriggerClientEvent('Client:Notify', src, 'warn', 'Locking Failed', 'No keys for this door', (newState and 'mdi-door-closed-lock' or 'mdi-door'), 3500)
    end
end)

function UpdateDoorState(src, door, newState, isDouble, skipPermissions)
    if CURRENT_DOORS[door] then 
        -- check permissions
        local doorData = CURRENT_DOORS[door]
        if PermissionsCheck(src, doorData.permissions) then 
            local currentState = doorData.locked
    
            if newState == nil then 
                newState = not currentState
            end
    
            if not isDouble and doorData.double and CURRENT_DOORS[doorData.double] and CURRENT_DOORS[doorData.double].locked ~= newState then 
                UpdateDoorState(src, doorData.double, newState, true)
            end
    
            if currentState ~= newState then 
                CURRENT_DOORS[door].locked = newState
                TriggerClientEvent('Doors:Client:DoorStateChange', -1, door, newState)
            end
            return true, newState
        else
            return false, CURRENT_DOORS[door].locked
        end
    end
    return false, nil
end

function PermissionsCheck(src, permissions)
    if not src or src <= 0 then return true end -- being triggered by server so of course it has permissions
    if not permissions then return true end
    if type(permissions) == 'string' then 
        local pTable = { permissions }
        permissions = pTable
    end

    if type(permissions) ~= 'table' or #permissions == 0 then return false end
    local Character = Characters:Source(src)
    if not Character then return false end

    local CID = Character:GetData('CID')
    local charGov = Gov.Active:Get(CID)
    for _, p in ipairs(permissions) do 
        local data = string.split(p, ':')
        local type = data[1]
        if type == 'government' and charGov then  
            local department, requiredRank, duty = data[2], tonumber(data[3]), tonumber(data[4])
            if not department then department = 'all' end
            local departmentId = tonumber(department)
            if department == 'all' or (not departmentId and department == charGov.Type) or (departmentId and departmentId == charGov.DepartmentId) then 
                if not requiredRank or department == 'all' or (requiredRank and charGov.RankId <= requiredRank) then 
                    if not duty or duty == 0 or (duty == 1 and charGov.Duty) then 
                        return true
                    end
                end
            end
        elseif type == 'character' then 
            local allowedCID = tonumber(data[2])
            if allowedCID and allowedCID == CID then 
                return true
            end
        end
    end
    return false
end