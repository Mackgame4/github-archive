# AuthenticRP Basic Documentation

# Utils (`arp-libs`)
All/most utility functions are all part of the `arp-libs` resource which has files that can be imported into all scripts.

**Util Files should be loaded first and before all other files**

**I highly recommend just importing ALL util files into every resource.**


## Shared Utils
Import this into the resource by adding the shared utils file (`@arp-libs/util.lua`) into the resources `fxmanifest.lua`.

*See all the functions by going to `./Utils/SHARED.md`*

## Client Utils
Import this into the resource by adding the shared utils file (`@arp-libs/client/util.lua`) into the resources `fxmanifest.lua`.

*See all the functions by going to `./Utils/CLIENT.md`*
## Server Utils
Import this into the resource by adding the shared utils file (`@arp-libs/server/functions.lua`) into the resources `fxmanifest.lua`.

*See all the functions by going to `./Utils/SERVER.md`*

# Components
Components are a key part of the AuthenticRP Framework and will be used everywhere.
All Components are part of the `Components` Global Variable if it is imported in the `fxmanifest`.

## Fetching/Using Components
Import `@arp-libs/componentLoader.lua` 

**The global `Components` variable will now be available in the code e.g. `Components.Logging:Info('Test', 'Test')`**

### You can also listen for when components load or update with the `OnComponentUpdate` function.

```lua
function OnComponentUpdate(c)
    if not c or c == 'Commands' then -- For example on the server reregister commands on update
        Components.Commands:Add('atm', function(src, args)
            -- Bla bla bla bla whatever
        end, 'Bla Bla Bla')
    end

    if not c then -- No component is updating, this is the initial load of everything.
        -- Do Init Stuff Here
    end
end
```

## Registering Components
You need to wait for the base to be ready before you can register components.
**Make sure that the component name is not taken.**

```lua
EXAMPLECOMPONENT = {
    OneFunction = function(self, arg)
        print(arg)
    end,
}

AddEventHandler('ARP:Shared:Components:RegisterReady', function()
    exports['arp-base']:RegisterComponent('ExampleComponent', EXAMPLECOMPONENT)
end)
```

## Extending Components
I'll be honest - I need to make sure this actually works first... I don't see them as being needed anyway so who knows???


## Basic Components

The components that are included in the base are are:
- Commands *(Server)*
- Logging *(Shared - Sort Of)*
- DB (Database - MongoDB) *(Server)*
- Callbacks (Client -> Server and Server -> Client) *(Shared)*
- *API (Probably Won't be Documented - Nick Only 😃) *(Server)**
- Discord *(Client)*
- Execute *(Server)*
- Store (Datastores) *(Shared)*
- User *(Server)*

# Example For Including All Base Imports Needed
## Or just use the `ARP.Manifest` VS Code Snippet.

```lua
server_scripts {
    '@arp-libs/util.lua', -- Shared
    '@arp-libs/server/functions.lua', -- Server Specific
    '@arp-libs/componentLoader.lua', -- For Using Components
}

client_scripts {
    '@arp-libs/util.lua', -- Shared
    '@arp-libs/client/util.lua', -- Client Specific
    '@arp-libs/componentLoader.lua', -- For Using Components
    '@arp-libs/client/character.lua', -- For Anything Character Related
}