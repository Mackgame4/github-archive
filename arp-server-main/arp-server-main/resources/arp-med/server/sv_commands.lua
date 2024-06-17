function RegisterCommands()
    Components.Commands:AddDeveloper('kill', function(src, args)
        local target = args[1]
        if not args[1] then 
            local TargetChar = Components.Characters:Source(src)
            if TargetChar and TargetChar:GetData('_Loaded') and not TargetChar:GetData('Dead') then 
                Components.Medical:Kill(src)
                Components.Logging:Info('Admin', ('Character %s Killed By Themself (%s)'):format(Components.Characters:GenerateLogString(TargetChar), Components.Users:GenerateLogStringSrc(src)))
                TriggerClientEvent('Client:Notify', src, 'success', 'Killed Yourself', false, 'mdi-cog')
                return
            end
        elseif target == '*' or target == 'all' then 
            local allCharacters = Components.Characters:All()
            local killedNames = {}
            for cSource, Character in pairs(allCharacters) do 
                if Character and Character:GetData('_Loaded') and not Character:GetData('Dead') then 
                    Components.Medical:Kill(cSource)
                    table.insert(killedNames, Character:GetData('_FullName'))
                end
            end
            Logging:Info('Admin', ('Everyone Killed By %s'):format(Components.Users:GenerateLogStringSrc(src)))
            TriggerClientEvent('Client:Notify', src, 'success', 'Killed Everyone', table.concat(killedNames, "<br>"), 'mdi-cog')
            return
        else
            target = tonumber(args[1])
            if type(target) == 'number' and target > 0 then 
                local TargetChar = Components.Characters:Source(target)
                if TargetChar and TargetChar:GetData('_Loaded') and not TargetChar:GetData('Dead') then 
                    Components.Medical:Kill(target)
                    TriggerClientEvent('Client:Notify', src, 'success', 'Killed '.. tostring(target), TargetChar:GetData('_FullName'), 'mdi-cog')
                    Components.Logging:Info('Admin', ('Character %s Killed By %s'):format(Components.Characters:GenerateLogString(TargetChar), Components.Users:GenerateLogStringSrc(src)))
    
                    return
                end
            end
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Kill '.. tostring(target), false, 'mdi-cog')
    end, 'Brutally Murder Someone', { { name = 'ID', help = 'Targets Server ID' }}, true)

    Components.Commands:AddStaff('revive', function(src, args)
        local target = args[1]
        if not target then 
            local TargetChar = Components.Characters:Source(src)
            if TargetChar and TargetChar:GetData('_Loaded') then 
                Components.Medical:Heal(src)
                Components.Logging:Info('Admin', ('Character %s Revived By Themself (%s)'):format(Components.Characters:GenerateLogString(TargetChar), Components.Users:GenerateLogStringSrc(src)))
                TriggerClientEvent('Client:Notify', src, 'success', 'Revived Yourself', false, 'mdi-cog')
                return
            end
        elseif target == '*' or target == 'all' then 
            local allCharacters = Components.Characters:All()
            local killedNames = {}
            for cSource, Character in pairs(allCharacters) do 
                if Character and Character:GetData('_Loaded') and Character:GetData('Dead') then 
                    Components.Medical:Heal(cSource)
                    table.insert(killedNames, Character:GetData('_FullName'))
                end
            end
            Components.Logging:Info('Admin', ('Everyone Revived By %s'):format(Components.Users:GenerateLogStringSrc(src)))
            TriggerClientEvent('Client:Notify', src, 'success', 'Revived Everyone', table.concat(killedNames, "<br>"), 'mdi-cog')
            return
        else
            target = tonumber(args[1])
            if type(target) == 'number' and target > 0 then 
                local TargetChar = Components.Characters:Source(target)
                if TargetChar and TargetChar:GetData('_Loaded') then 
                    Components.Medical:Heal(target)
                    TriggerClientEvent('Client:Notify', src, 'success', 'Revived '.. tostring(target), TargetChar:GetData('_FullName'), 'mdi-cog')
                    Components.Logging:Info('Admin', ('Character %s Revived By %s'):format(Components.Characters:GenerateLogString(TargetChar), Components.Users:GenerateLogStringSrc(src)))
    
                    return
                end
            end
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Revive '.. tostring(target), false, 'mdi-cog')
    end, 'Revive Someone', { { name = 'ID', help = 'Targets Server ID' }}, true)
end