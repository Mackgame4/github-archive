local _req = { 'ExportsReady' }
local _deps = {}
if IsDuplicityVersion() then _req = { 'ExportsReady', 'DatabaseReady' } end

Core.Modules.Proxy = {
    _required = _req,
    _name = 'core',
    _protected = true,
    ExportsReady = false,
}

AddEventHandler('onResourceStart', function(resource)
    if Core.Modules.Proxy.ExportsReady then
        if resource ~= GetCurrentResourceName() then
            TriggerEvent('Proxy:Shared:RegisterReady')

            if GetGameTimer() > 10000 then
                TriggerEvent('Core:Shared:Ready')
            end
            collectgarbage()
        end
    end
end)

function NotifyDependencyUpdate(module)
    if _deps[module] ~= nil then
        for k, v in ipairs(_deps[module]) do
            TriggerEvent(v .. ':Shared:DependencyUpdate')
        end
    end
end

exports('RegisterModule', function(module, data)
    local _overriding = false

    if Core.Modules[module] ~= nil then
        if Core.Modules[module]._protected then
            Core.Modules.Logger:Warn('Proxy', 'Attempt To Override Protected Module: ' .. tostring(module), { console = true })
            return
        else
            if Core.Modules[module]._required and #Core.Modules[module]._required > 0 then
                for k, v in ipairs(Core.Modules[module]._required) do
                    if data[v] == nil then
                        Core.Modules.Logger:Warn('Proxy', 'Attempt To Extend Module While Missing Required Attribute: ' .. tostring(v), { console = true })
                        return
                    end
                end
            end
        end

        _overriding = true
        Core.Modules.Logger:Trace('Proxy', 'Overriding Existing Module: ' .. tostring(module), { console = true })
    end

    Core.Modules[module] = data

    if _overriding then
        if Core.Modules[module]._name ~= nil then 
            NotifyDependencyUpdate(Core.Modules[module]._name)
        else
            NotifyDependencyUpdate(module)
        end
    end
    TriggerEvent('Proxy:Shared:ExtendReady', module)
end)

exports('FetchConfig', function(sub)
    if Core.Config[sub] then
        return Core.Config[sub]
    else
        return Core.Config
    end
end)

exports('FetchModule', function(module)
    if not Core.Modules[module] then
        Core.Modules.Logger:Warn('Proxy', 'Attempt To Fetch Non-Existent Module: ' .. tostring(module), { console = true })
        return nil
    end

    return Core.Modules[module]
end)

exports('ExtendModule', function(module, data)
    if Core.Modules[module] ~= nil then
        if Core.Modules[module]._protected == nil then
            for k, v in pairs(data) do
                Core.Modules[module][k] = v
            end

            if Core.Modules[module]._name ~= nil then 
                NotifyDependencyUpdate(Core.Modules[module]._name)
            else
                NotifyDependencyUpdate(module)
            end
        else
            Core.Modules.Logger:Warn('Proxy', 'Attempt To Extend Protected Module: ' .. tostring(module), { console = true })
        end
    else
        Core.Modules.Logger:Warn('Proxy', 'Attempt To Extend Non-Existent Module: ' .. tostring(module), { console = true })
    end
end)

exports('RequestDependencies', function(c, d, cb)
    Citizen.CreateThread(function()
        local _loaded = false
        local _attempts = {}
        local _errs = {}
        while not _loaded do
            for k, v in pairs(d) do
                if Core.Modules[v] ~= nil then
                    d[k] = nil
                    
                    if _deps[v] == nil then _deps[v] = {} end
                    table.insert(_deps[v], c)
                else
                    if _attempts[v] == nil then
                        _attempts[v] = 1
                    elseif _attempts[v] > 50 then
                        table.insert(_errs, v)
                        Core.Modules.Logger:Error('Proxy', ('[^2%s^7] Failed To Load For [^3%s^7]'):format(v, c), { console = true })
                        d[k] = nil
                    else
                        _attempts[v] = _attempts[v] + 1
                    end
                end
            end

            if #d == 0 then
                _loaded = true
            end

            Citizen.Wait(100)
        end

        cb(_errs)
        collectgarbage()
    end)
end)