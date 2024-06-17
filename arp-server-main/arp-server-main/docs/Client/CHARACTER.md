# Characters - Client Functions & Global Variables

## Global Variables

```lua
CHAR_LOADED -- boolean, is that character loaded in or not.
```
```lua
CHAR_DATA -- table, all character data, same as serverside but in a table. nil if not loaded
```
```lua
CHAR_DEAD -- boolean, is that character dead
```

## Functions

### Listen for when the character first loads in

```lua
function OnCharacterLoad()

    -- Start Threads or Something E.G
    Citizen.CreateThread(function()
        while CHAR_LOADED do -- This loop will stop when the character logs out!
            print('fuck')
            Citizen.Wait(1000)
        end
    end)

end
```
### Listen for when the characters death state changes
```lua
function OnCharacterDeath(isDead)
    print('Character Dead:', isDead)
end
```

### Listen for when any character data is updated

```lua
function OnOnCharacterDataUpdate(key, newVal)
    if key == 'Cash' then 
        print('new $$$:', newVal)
    end
end
```

### Listen for when the character logs out

```lua
function OnCharacterUnload()
    -- Delete Blips or Something Idk
end
```

### Listen for when the character is fully loaded with their ped
#### This is only useful in very specific situations

```lua
function OnCharacterLoadFull()
    -- Apply Things or Something
end
```