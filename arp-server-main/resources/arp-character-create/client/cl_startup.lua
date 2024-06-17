function OnComponentUpdate(c)
    if not c then 
        AddZones()
    end
end

-- AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
--     if resource == GetCurrentResourceName() or resource == 'all' then 
--         exports['arp-base']:RegisterComponent('CharactersCreate', CHARACTERS)
--     end
-- end)