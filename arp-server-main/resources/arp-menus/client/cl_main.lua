
function OnComponentUpdate(c)
    if not c or c == 'UI' then 
        RegisterMenuUICallbacks()
    end
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Menus', MENUS)
end)