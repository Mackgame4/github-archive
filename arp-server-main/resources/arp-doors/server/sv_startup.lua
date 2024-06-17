CURRENT_DOORS = {}

function OnComponentUpdate(c)
    if not c or c == 'Callbacks' or c == 'Commands' then
        local currentDoorId = 0
        for _, door in ipairs(_doors) do 
            if door.doorHash and door.coords then 
                local doorId
                if door.id then 
                    doorId = door.id
                else
                    currentDoorId = currentDoorId + 1
                    doorId = tostring(currentDoorId)
                end

                CURRENT_DOORS[doorId] = {
                    id = doorId,
                    hash = door.doorHash,
                    coords = door.coords,
                    locked = door.defaultLock,
                    double = door.double,
                    permissions = door.permissions
                }

            end
        end

        Components.Callbacks:Register('Doors:Server:GetState', function(src, cb)
            cb(CURRENT_DOORS)
        end)

        Components.Commands:AddDeveloper('doors:lock', function(src, args)
            local newState = false
            local targetDoor = args[1]
            local lockArgs = args[2]
            if string.lower(lockArgs) == 'true' or lockArgs == '1' then newState = true end
            if targetDoor then 
                UpdateDoorState(src, targetDoor, newState, false, true)
            end
        end, 'Force Locks For a Door', {
            { name = 'Door', help = 'ID of the target door' },
            { name = 'Lock/Unlock', help = 'True or False' }
        }, true)
    end
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Doors', DOORS)
end)