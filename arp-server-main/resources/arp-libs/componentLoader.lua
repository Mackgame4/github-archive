Components = {}

AddEventHandler('ARP:Shared:Ready', function(resource)
    if resource == GetCurrentResourceName() or resource == 'all' then 
        Components = exports['arp-base']:FetchComponents()
        if OnComponentUpdate then OnComponentUpdate(false) end
    end
end)

AddEventHandler('ARP:Shared:Components:Update', function(component)
    if not component then return end
    Components[component] = exports['arp-base']:FetchComponent(component)
    if OnComponentUpdate then OnComponentUpdate(component) end
end)

AddEventHandler('ARP:Shared:Components:ExtendReady', function(component, resource)
    if component ~= nil or (component == nil and resource == GetCurrentResourceName()) then 
        if OnComponentExtendReady then OnComponentExtendReady(component) end
    end
end)