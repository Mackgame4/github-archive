RegisterNetEvent('Doors:Client:DoorStateChange')
AddEventHandler('Doors:Client:DoorStateChange', function(door, state)
    if DoorState[door] then 
        DoorState[door].locked = state
        DoorSystemSetDoorState(door, state and 1 or 0)
    end
end)

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'doorLocks' then 
        local pedCoords = GetEntityCoords(ARP.GblPed)
        local targetDoor, dist = GetDoorIdentifierWithCoords(pedCoords, 1.75)
        if targetDoor then 
            Components.Logging:Debug('Doors', 'Interacting With Door: '.. targetDoor .. ' Dist: '..dist)
            TriggerServerEvent('Doors:Server:ToggleDoorLocks', targetDoor)
        end
    end
end)

function GetDoorIdentifierWithCoords(coords, maxDist)
    if not maxDist then maxDist = 0.5 end
    for doorId, door in pairs(DoorState) do 
        local dist = #(door.coords - coords)
        if dist <= maxDist then 
            return doorId, dist 
        end
    end
    return false
end