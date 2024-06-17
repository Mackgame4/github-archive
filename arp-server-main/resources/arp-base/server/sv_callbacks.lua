RegisteredCallbacks = {}

RegisterNetEvent('ARP:Callbacks:Server')
AddEventHandler('ARP:Callbacks:Server', function(eventName, ticket, ...)
	local s = source
	local p = promise.new()

    TriggerEvent('ARP:Callbacks:Server:'..eventName, function(...)
		p:resolve({...})
	end, s, ...)

    local result = Citizen.Await(p)
	TriggerClientEvent('ARP:Callbacks:Client:Awaiting:' .. eventName .. ':'.. ticket, s, table.unpack(result))
end)

COMPONENTS.Callbacks = {
    _protected = true,
    Register = function(self, eventName, cbFunc)
        if RegisteredCallbacks[eventName] then
            RemoveEventHandler(RegisteredCallbacks[eventName])
            RegisteredCallbacks[eventName] = nil
        end

        RegisteredCallbacks[eventName] = AddEventHandler('ARP:Callbacks:Server:' .. eventName, function(cb, s, ...)
            cbFunc(s, function(...)
                cb(...)  
            end, ...)
        end)
    end,
    Execute = function(self, src, eventName, ...)
        local p = promise.new()

        RegisterNetEvent('ARP:Callbacks:Server:Awaiting:'..eventName)
        local handler = AddEventHandler('ARP:Callbacks:Server:Awaiting:'..eventName, function(...)
            local s = source
            if src == s then
                p:resolve({...})
            end
        end)

        TriggerClientEvent('ARP:Callbacks:Client', src, eventName, ...)

        local result = Citizen.Await(p)
        RemoveEventHandler(handler)
        return table.unpack(result)
    end
}