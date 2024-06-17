AddEventHandler("onDatabaseConnect", function()
    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'drop',
        label = 'Drop',
        slots = 20,
        weight = '1000'
    })

    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'property',
        label = 'Property Inventory',
        slots = 100,
        weight = '1500'
    })

    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'player',
        label = 'ply',
        slots = 30,
        weight = 250,
        getInventory = function(identifier, cb)
            idk(identifier, 'player', cb)
        end,
        saveInventory = function(identifier, inventory)
            saveInventory(identifier, 'player', inventory)
        end
    })

    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'shop',
        label = 'Shop',
        slots = 40,
        weight = '1000',
        getInventory = function(identifier, cb)
            getShopInventory(identifier, cb)
        end,
        saveInventory = function(identifier, inventory)

        end,
        applyToInventory = function(identifier, f)
            getShopInventory(identifier, f)
        end,
        getDisplayInventory = function(identifier, cb, source)
            getShopDisplayInventory(identifier, cb, source)
        end
    })

    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'gunshop',
        label = 'Gunshop',
        slots = 40,
        weight = '1000',
        getInventory = function(identifier, cb)
            getGunshopInventory(identifier, cb)
        end,
        saveInventory = function(identifier, inventory)

        end,
        applyToInventory = function(identifier, f)
            getGunshopInventory(identifier, f)
        end,
        getDisplayInventory = function(identifier, cb, source)
            getGunshopDisplayInventory(identifier, cb, source)
        end
    })

    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'stash',
        label = 'Stash',
        slots = 200,
        weight = '2000'
    })

    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'evidence',
        label = 'Evidence Locker',
        slots = 50,
        weight = '2000'
    })

    for k, v in pairs(Config.VehicleSlot) do
        TriggerEvent('prp-inventory:RegisterInventory', {
            name = 'trunk' .. k,
            label = 'Trunk',
            slots = v,
            weight = '650'
        })
    end
    for k, v in pairs(Config.VehicleGloveSlot) do
        TriggerEvent('prp-inventory:RegisterInventory', {
            name = 'glovebox' .. k,
            label = 'Glove Box',
            slots = v,
            weight = '50'
        })
    end
end)