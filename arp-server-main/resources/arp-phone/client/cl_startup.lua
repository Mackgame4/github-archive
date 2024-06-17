RegisterCommand('phone-ui:refresh', function(src, args)
    SendNUIMessage({
        event = 'refresh',
        data = {
            src = args[1]
        }
    })
end)

RegisterCommand('phone-ui:focus', function()
    SetNuiFocus(true, true)
end)

RegisterCommand('phone-ui:unfocus', function()
    SetNuiFocus(false, false)
end)

AddEventHandler('ARP:Shared:Components:RequiredUpdate:Phone', function(c) FetchComponents(c) end)
function FetchComponents(c)
    Logging = exports['arp-base']:FetchComponent('Logging')
    Callbacks = exports['arp-base']:FetchComponent('Callbacks')
    Notify = exports['arp-base']:FetchComponent('Notify')
    Characters = exports['arp-base']:FetchComponent('Characters')
end

AddEventHandler('ARP:Shared:Ready', function(resource)
    if resource == GetCurrentResourceName() or resource == 'all' then 
        exports['arp-base']:RequestRequiredComponents('Phone', { 'Logging', 'Callbacks', 'UI', 'Notify', 'Characters' }, function(err)
            if #err > 0 then return end
            FetchComponents()
        end)
    end
end)

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    if resource == GetCurrentResourceName() or resource == 'all' then 
        --exports['arp-base']:RegisterComponent('Phone', PHONE)
    end
end)