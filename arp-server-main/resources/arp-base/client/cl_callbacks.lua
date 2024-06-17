RegisteredCallbacks = {}

RegisterNetEvent('ARP:Callbacks:Client')
AddEventHandler('ARP:Callbacks:Client', function(eventName, ...)
	local p = promise.new()

	TriggerEvent('ARP:Callbacks:Client:' .. eventName, function(...)
		p:resolve({...})
	end, ...)

    local result = Citizen.Await(p)
	TriggerServerEvent('ARP:Callbacks:Server:Awaiting:' .. eventName, table.unpack(result))
end)

COMPONENTS.Callbacks = {
    _protected = true,
    Execute = function(self, eventName, ...) 
        local p = promise.new()
        local ticket = GetGameTimer()

        RegisterNetEvent('ARP:Callbacks:Client:Awaiting:' .. eventName .. ':' .. ticket)
        local handler = AddEventHandler('ARP:Callbacks:Client:Awaiting:' .. eventName .. ':' .. ticket, function(...)
            p:resolve({...})
        end)

        TriggerServerEvent('ARP:Callbacks:Server', eventName, ticket, ...)

        local result = Citizen.Await(p)
        RemoveEventHandler(handler)
        return table.unpack(result)
    end,
    Register = function(self, eventName, cbFunc)
        if RegisteredCallbacks[eventName] then
            RemoveEventHandler(RegisteredCallbacks[eventName])
            RegisteredCallbacks[eventName] = nil
        end

        RegisteredCallbacks[eventName] = AddEventHandler('ARP:Callbacks:Client:' .. eventName, function(cb, ...)
            cbFunc(function(data)
                cb(data)
            end, ...)
        end)
    end,
}