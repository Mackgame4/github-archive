Core.Modules.Execute = {
    _name = 'base',
    Client = function(self, source, component, method, ...)
        TriggerClientEvent('Execute:Client:Component', source, component, method, ...)
    end,
    ClientSub = function(self, source, component, sub, method, ...)
        TriggerClientEvent('Execute:Client:SubComponent', source, component, sub, method, ...)
    end,
}