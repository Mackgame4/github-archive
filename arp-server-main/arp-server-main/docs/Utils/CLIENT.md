# Client Utils - Global Variables

## Global Ped Variable
This will be updated whenever the players ped changes and is much better then calling the `PlayerPedId()` function, especially in loops. It is stored in the `ARP.GblPed` variable.
### Example
```lua
local playerCoords = GetEntityCoords(ARP.GblPed)
print(playerCoords)
```

# Client Utils - Functions

## Model Loading

Instead of adding a function to every resource to wait for a model to load use the `AwaitLoadModel(hash)` function.

### Example
```lua
local hash = `test`
local loaded = AwaitLoadModel(hash)
if loaded then 
    -- Do something with the model
else -- The model must not be valid...
    print('fuck')
end
```

## Entity Enumeration
All Entity Enumeration functions are also included

```lua
EnumerateObjects()
EnumeratePeds()
EnumerateVehicles()
```