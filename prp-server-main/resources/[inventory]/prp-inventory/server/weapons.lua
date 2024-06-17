weapons = {}

AddEventHandler("onDatabaseConnect", function()
    for name,item in pairs(Config.Weapons) do
        for k, v in pairs(item) do
            table.insert(weapons, v)
            TriggerEvent('prp-inventory:registerItemUse', v, function(source)
                TriggerClientEvent('prp-inventory:useWeapon', source, name)
            end)
        end
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    for k,v in pairs(weapons) do
        if v == item.name then
            TriggerClientEvent('prp-inventory:handleWeapons', source)
            break
        end
    end
end)

RegisterServerEvent('prp-inventory:updateAmmoCount')
AddEventHandler('prp-inventory:updateAmmoCount', function(hash, count)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE disc_ammo SET count = @count WHERE hash = @hash AND owner = @owner LIMIT 1', {
        ['@owner'] = player.identifier,
        ['@hash'] = hash,
        ['@count'] = count
    }, function(results)
        if results == 0 then
            MySQL.Async.execute('INSERT INTO disc_ammo (owner, hash, count) VALUES (@owner, @hash, @count)', {
                ['@owner'] = player.identifier,
                ['@hash'] = hash,
                ['@count'] = count
            })
        end
    end)
end)

ESX.RegisterServerCallback('prp-inventory:getAmmoCount', function(source, cb, hash)
    local player = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT count FROM disc_ammo WHERE owner = @owner and hash = @hash LIMIT 1', {
        ['@owner'] = player.identifier,
        ['@hash'] = hash
    }, function(results)
        if #results == 0 then
            cb(nil)
        else
            cb(results[1].count)
        end
    end)
end)

function RegisterSerial(n) 
    local serial = ''
    for i=1,n,1 do
        serial = serial..tostring(math.random(1, 10))
    end
    return serial
end