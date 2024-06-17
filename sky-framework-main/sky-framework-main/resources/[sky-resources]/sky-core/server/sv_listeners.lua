local _listeners = {}

AddEventHandler('onResourceStart', function(resource)
    if Core.Modules.Proxy.ExportsReady then
        if resource ~= GetCurrentResourceName() then
            if _listeners[resource] then _listeners[resource] = nil end
            collectgarbage()
        end
    end
end)

Core.Modules.Listeners = {
    Trigger = function(self, event, source, ...)
        local eventsToTrigger = {}
        for k, v in pairs(_listeners) do
            if _listeners[k][event] then
                for evtid, e in pairs(_listeners[k][event]) do
                    table.insert(eventsToTrigger, _listeners[k][event][evtid])
                end
            end
        end

        table.sort(eventsToTrigger, function(a,b) return a.prio < b.prio end)
        
        for k, v in pairs(eventsToTrigger) do
            v.cb(source, ...)
        end
    end,
    Register = function(self, event, cb, prio)
        local resource = GetCurrentResourceName()
        if GetInvokingResource() ~= nil then
            resource = GetInvokingResource()
        end
        
        if _listeners[resource] == nil then _listeners[resource] = {} end
        if _listeners[resource][event] == nil then _listeners[resource][event] = {} end
        if prio == nil then prio = 1 end
        table.insert(_listeners[resource][event], {cb = cb, prio = prio, resource = resource})
    end
}

--[[ 
    The higher this number the less prio during execution, All executes start from Prio Level 1, It makes sense to have this high as as 
    soon as it executes the player will no longer be known to the server, if the number is omitted, it will default to Prio Level 1
]]--

Core.Modules.Listeners:Register('playerDropped', function(source, message)
    if Core.Players[source] then
        Core.Modules.Listeners:Trigger('Core:Shared:CharacterLogout', source)
        collectgarbage()
    end
end, 99998)

Core.Modules.Listeners:Register('playerDropped', function(source, message)
    if Core.Players[source] then
        Core.Modules.Queue.Dropped:Add(source, message)
        collectgarbage()
    end
end, 99999)

Core.Modules.Listeners:Register('playerDropped', function(source, message)
    if Core.Players[source] then
        Wait(500)
        Core.Players[source].Functions:Save(function(suc)
            if suc then
                local _name = Core.Players[source]:Get('Name')
                Wait(1000)
                Core.Players[source] = nil
                collectgarbage()
                if Core.Players[source] == nil then
                    Core.Modules.Logger:Info('Players', _name..' Disconnected')
                end
            end
        end)
    end
end, 100000)

AddEventHandler('playerDropped', function(message)
    local src = source
    Core.Modules.Listeners:Trigger('playerDropped', src, message)
end)