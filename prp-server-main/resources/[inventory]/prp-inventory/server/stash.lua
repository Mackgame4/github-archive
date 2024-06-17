AddEventHandler("onDatabaseConnect", function()
    Wait(500)
    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'stash',
        label = 'Stash',
        slots = 200,
        weight = '2000'
    })
end)