DoorState = {}

function OnComponentUpdate(c)
    if not c or c == 'Callbacks' then
        local fetchedState = Components.Callbacks:Execute('Doors:Server:GetState', {})
        if fetchedState then 
            DoorState = fetchedState 
            for doorId, door in pairs(DoorState) do 
                AddDoorToSystem(doorId, door.hash, door.coords.x, door.coords.y, door.coords.z)
                DoorSystemSetDoorState(doorId, door.locked and 1 or 0)

                if door.autoRate and type(door.autoRate) == 'number' then 
                    DoorSystemSetAutomaticRate(doorId, door.autoRate + 0.0)
                else
                    DoorSystemSetAutomaticRate(doorId, 10.0)
                end
            end
        end
    end
end