local drops = {}
obtainDrops = {}

RegisterServerEvent('prp-inventory:modifiedInventory')
AddEventHandler('prp-inventory:modifiedInventory', function(identifier, type, data)
    if type == 'drop' then
        drops[identifier] = data
        TriggerClientEvent('prp-inventory:updateDrops', -1, drops)
    end
end)

RegisterServerEvent('prp-inventory:addDrop')
AddEventHandler('prp-inventory:addDrop', function(location, data)
    obtainDrops[location] = data
end)