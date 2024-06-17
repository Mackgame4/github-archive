local _sCallbacks = {}
local _cCallbacks = {}

Core.Modules.Callbacks = {
    _required = { 'ServerCallback', 'RegisterClientCallback', 'DoClientCallback' },
    _name = 'base',
    ServerCallback = function(self, event, data, cb)
        while Core.Config.SecurityToken == nil do Citizen.Wait(1) end
        if data == nil then data = {} end
        id = event
        _sCallbacks[id] = cb
        TriggerServerEvent('Callbacks:Server:TriggerEvent', Core.Config.SecurityToken, event, data)
    end,
    RegisterClientCallback = function(self, event, cb)
        _cCallbacks[event] = cb
    end,
    DoClientCallback = function(self, event, data)
        if _cCallbacks[event] ~= nil then
            Citizen.CreateThread(function()
                _cCallbacks[event](data, function(...)
                    TriggerServerEvent('Callbacks:Server:ReceiveCallback', Core.Config.SecurityToken, event, ...)
                end)
            end)
        end
    end,
}

RegisterNetEvent('Callbacks:Client:TriggerEvent')
AddEventHandler('Callbacks:Client:TriggerEvent', function(event, data)
    if data == nil then data = {} end
    Core.Modules.Callbacks:DoClientCallback(event, data)
end)

RegisterNetEvent('Callbacks:Client:ReceiveCallback')
AddEventHandler('Callbacks:Client:ReceiveCallback', function(event, ...)
    local id = event
    if _sCallbacks[id] ~= nil then
        _sCallbacks[id](...)
        _sCallbacks[id] = nil
        collectgarbage()
    end
end)