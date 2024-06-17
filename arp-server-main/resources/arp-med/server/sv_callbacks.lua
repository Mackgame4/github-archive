function RegisterCallbacks()
    Components.Callbacks:Register('Medical:Server:SyncDamage', function(src, cb, data)
        local Character = Components.Characters:Source(src)
        if Character and type(data) == 'table' and data.Blood and data.Limbs then 
            Character:SetData('Damage', data)
            cb(data)
        else
            cb(false)
        end
    end)
end