COMPONENTS.Execute = {
    Source = function(self, src, component, method, ...)
        TriggerClientEvent('ARP:Client:Components:Execute', src, component, method, ...)
    end
}