function OnComponentUpdate(c)
    if not c or c == 'Commands' then
        Components.Commands:AddStaff('staff', function(src, args)
            if #args > 0 then 
                local announcementType = 'Staff'
                if src == 0 then announcementType = 'Console' end
                local fullMessage = table.concat(args, ' ')
                TriggerClientEvent('ARP:Chat:SystemMessage', -1, announcementType, fullMessage)
            else
                Components.Commands.CommandFailure(src, 'Cannot Send Empty Message')
            end
        end, 'Send an Staff Message', {
            { name = 'Message' },
        }, true)

        Components.Commands:Add('ooc', function(src, args)
            local Character = Components.Characters:Source(src)
            if #args > 0 and Character and Character:GetData('_Loaded') then
                local fullMessage = table.concat(args, ' ')
                TriggerClientEvent('ARP:Chat:OOCMessage', -1, src, Character:GetData('_FullName'), fullMessage)
            else
                Components.Commands.CommandFailure(src, 'Cannot Send Empty Message')
            end
        end, 'Send an OOC Message', {
            { name = 'Message' },
        }, true)

        Components.Commands:Add('looc', function(src, args)
            local Character = Components.Characters:Source(src)
            if #args > 0 and Character and Character:GetData('_Loaded') then
                local fullMessage = table.concat(args, ' ')
                local targetList = Components.Callbacks:Execute(src, 'Chat:Client:GetLocalPlayers')
                for _, tsrc in ipairs(targetList) do 
                    TriggerClientEvent('ARP:Chat:LocalOOCMessage', tsrc, src, Character:GetData('_FullName'), fullMessage)
                end
            else
                Components.Commands.CommandFailure(src, 'Cannot Send Empty Message')
            end
        end, 'Send a Local OOC Message', {
            { name = 'Message' },
        }, true)

        Components.Commands:Add('clear', function(src)
            TriggerClientEvent('chat:clear', src)
        end, 'Clear Your Chat', false)
    end
    
    if not c then -- So init things don't happen time a component updates
    
    end
end