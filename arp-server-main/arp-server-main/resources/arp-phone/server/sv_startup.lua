AddEventHandler('ARP:Shared:Components:RequiredUpdate:COMPONENT', function(c) FetchComponents(c) end)
function FetchComponents()
    Logging = exports['arp-base']:FetchComponent('Logging')
    Callbacks = exports['arp-base']:FetchComponent('Callbacks')
    Commands = exports['arp-base']:FetchComponent('Commands')
    DB = exports['arp-base']:FetchComponent('DB')
    Store = exports['arp-base']:FetchComponent('Store')
    Characters = exports['arp-base']:FetchComponent('Characters')
end

AddEventHandler('ARP:Shared:Ready', function(resource)
    if resource == GetCurrentResourceName() or resource == 'all' then 
        exports['arp-base']:RequestRequiredComponents('COMPONENT', { 'Logging', 'Callbacks', 'Commands', 'DB', 'Store', 'Characters' }, function(err)
            if #err > 0 then return end
            FetchComponents()
            
            -- Register Callbacks etc
        end)
    end
end)

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    -- exports['arp-base']:RegisterComponent('COMPONENT', COMPONENT)
end)

AddEventHandler('Characters:Server:Login', function(src)

end)

AddEventHandler('Characters:Server:Logout', function(src, cid)

end)