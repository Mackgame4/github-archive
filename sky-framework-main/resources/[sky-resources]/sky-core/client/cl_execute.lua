RegisterNetEvent('Execute:Client:Component')
AddEventHandler('Execute:Client:Component', function(module, method, ...)
    if Core.Modules[module] ~= nil then
        if Core.Modules[module][method] ~= nil then
            Core.Modules[module][method](Core.Modules[module][method], ...)
        else
            Core.Modules.Logger:Warn('Execute', 'Attempted To Execute Non-Method Attribute', { console = true })
        end
    else
        Core.Modules.Logger:Warn('Execute', 'Attempted To Execute Method Attribute In Non-Existing Module', { console = true })
    end
end)

RegisterNetEvent('Execute:Client:SubComponent')
AddEventHandler('Execute:Client:SubComponent', function(module, sub, method, ...)
    if Core.Modules[module] ~= nil then
        if Core.Modules[module][sub] ~= nil then
            if Core.Modules[module][sub][method] ~= nil then
                Core.Modules[module][sub][method](Core.Modules[module][sub][method], ...)
            else
                Core.Modules.Logger:Warn('Execute', 'Attempted To Execute Non-Method Attribute', { console = true })
            end
        else
            Core.Modules.Logger:Warn('Execute', 'Attempted To Execute Non-SubMethod', { console = true })
        end
    else
        Core.Modules.Logger:Warn('Execute', 'Attempted To Execute Method Attribute In Non-Existing Module', { console = true })
    end
end)