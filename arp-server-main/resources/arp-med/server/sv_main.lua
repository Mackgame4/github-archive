
AddEventHandler('Characters:Server:Login', function(src)

end)

AddEventHandler('Characters:Server:Logout', function(src, cid, name, state)
    print('aready gone mate')
    ARP.PrintTable(state)
end)


function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        RegisterCommands()
    end

    if not c or c == 'Callbacks' then 
        RegisterCallbacks()
    end
end

RegisterNetEvent('Medical:Server:FuckingDead')
AddEventHandler('Medical:Server:FuckingDead', function()
    local src = source
    local Character = Components.Characters:Source(src)
    if not Character then return end
    Character:SetData('Dead', true)

    local ply = Player(source)
    ply.state.dead = true
end)

RegisterNetEvent('Medical:Server:SyncDamage')
AddEventHandler('Medical:Server:SyncDamage', function(data)
    local src = source
    local Character = Components.Characters:Source(src)
    if Character and type(data) == 'table' and data.Bleed and data.Limbs then 
        Character:SetData('Damage', data)
    end
end)