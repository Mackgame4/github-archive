RegisterNetEvent('ARP:Client:Components:Execute')
AddEventHandler('ARP:Client:Components:Execute', function(component, method, ...)
    if COMPONENTS[component] ~= nil then
        if COMPONENTS[component][method] ~= nil then
            COMPONENTS[component][method](COMPONENTS[component][method], ...)
        end
    end
end)