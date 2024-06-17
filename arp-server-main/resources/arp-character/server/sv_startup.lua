function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        Components.Commands:AddStaff('switch', function(src)
            Components.Characters:Switch(src)
            Components.Logging:Info('Admin', ('%s Force Switched Characters'):format(Components.Users:GenerateLogStringSrc(src)))
        end, 'Switch Characters', {}, false , false)
    
        Components.Commands:Add('outfits', function(src)
            TriggerClientEvent('Characters:Client:OpenOutfitManagement', src)
        end, 'Open Outfit Management', {}, false, false)
    end
    if not c or c == 'Callbacks' then 
        RegisterCallbacks()
    end

    if not c then 
        local res = Components.DB:Count('characters', {})
        if res.success and res.count then 
            Components.Logging:Info('Characters', ('Loaded %d Characters'):format(res.count))
        end
    end
end