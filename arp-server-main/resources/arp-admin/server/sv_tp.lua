function RegisterTPCommands()
    Components.Commands:AddStaff('tp', function(src, args)
        local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        SetEntityCoords(GetPlayerPed(src), x +0.0, y +0.0, z +0.0)
    end, 'Teleport to a specific location.', {
        { name = 'X', help = 'X Coordinate', required = true },
        { name = 'Y', help = 'Y Coordinate', required = true },
        { name = 'Z', help = 'Z Coordinate', required = true },
    })

    Components.Commands:AddStaff('goto', function(src, args)
        local target = tonumber(args[1])
        if target ~= nil and target > 0 then 
            local adminCharacter = Components.Characters:Source(src) 
            local targetCharacter
            if target >= 10000 then 
                targetCharacter = Components.Characters:CID(target)
            else
                targetCharacter = Components.Characters:Source(target)
            end
            if targetCharacter and targetCharacter:GetData('_Loaded') and adminCharacter and adminCharacter:GetData('_Loaded') then
                if targetCharacter:GetData('CID') == adminCharacter:GetData('CID') then 
                    TriggerClientEvent('Client:Notify', src, 'error', 'Teleport Failed', 'Can\'t Teleport to Yourself 🤣', 'mdi-cog')
                    return
                end
                local myPed = GetPlayerPed(src)
                local tSrc = targetCharacter:GetData('Source')
                local tPed = GetPlayerPed(tSrc)
                local tCoords = GetEntityCoords(tPed)
                Components.Logging:Info('Admin', ('%s Teleported to %s'):format(Components.Users:GenerateLogStringSrc(src), Components.Characters:GenerateLogString(targetCharacter)))
                SetEntityCoords(myPed, tCoords.x + 1.0, tCoords.y + 1.0, tCoords.z + 0.25)
                TriggerClientEvent('Client:Notify', src, 'success', 'Teleported Successfully', ('Teleported to %s (%s)'):format(target, targetCharacter:GetData('_FullName')), 'mdi-cog')
            else
                TriggerClientEvent('Client:Notify', src, 'error', 'Teleport Failed', 'Failed to Target Player', 'mdi-cog')
            end
        else
            TriggerClientEvent('Client:Notify', src, 'error', 'Teleport Failed', 'Invalid Target', 'mdi-cog')
        end
    end, 'Teleport to Player', {
        { name = 'ID', help = 'Server ID or Character ID', required = true },
    })

    Components.Commands:AddStaff('bring', function(src, args)
        local target = tonumber(args[1])
        if target ~= nil and target > 0 then 
            local adminCharacter = Components.Characters:Source(src) 
            local targetCharacter
            if target >= 10000 then 
                targetCharacter = Components.Characters:CID(target)
            else
                targetCharacter = Components.Characters:Source(target)
            end
            if targetCharacter and targetCharacter:GetData('_Loaded') and adminCharacter and adminCharacter:GetData('_Loaded') then
                if targetCharacter:GetData('CID') == adminCharacter:GetData('CID') then 
                    TriggerClientEvent('Client:Notify', src, 'error', 'Teleport Failed', 'Can\'t Bring Yourself 🤣', 'mdi-cog')
                    return
                end
                local myPed = GetPlayerPed(src)
                local myCoords = GetEntityCoords(myPed)
                local tSrc = targetCharacter:GetData('Source')
                local tPed = GetPlayerPed(tSrc)
                Components.Logging:Info('Admin', ('%s was Brought by %s'):format(Components.Characters:GenerateLogString(targetCharacter), Components.Users:GenerateLogStringSrc(src)))
                SetEntityCoords(tPed, myCoords.x + 0.5, myCoords.y + 0.5, myCoords.z + 0.25)
                TriggerClientEvent('Client:Notify', src, 'success', 'Bring Successful', ('Brought %s (%s)'):format(target, targetCharacter:GetData('_FullName')), 'mdi-cog')
            else
                TriggerClientEvent('Client:Notify', src, 'error', 'Bring Failed', 'Failed to Target Player', 'mdi-cog')
            end
        else
            TriggerClientEvent('Client:Notify', src, 'error', 'Bring Failed', 'Invalid Target', 'mdi-cog')
        end
    end, 'Bring a Player', {
        { name = 'ID', help = 'Server ID or Character ID', required = true },
    })
end