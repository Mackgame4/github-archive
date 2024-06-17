local dependencies = {}
local hasInitialised = false

AddEventHandler('ARP:Shared:Components:Init', function()
    TriggerEvent('ARP:Shared:Components:RegisterReady', 'all')
    hasInitialised = true
end)

function RegisterComponent(name, component)
    if type(name) ~= 'string' or component == nil then return end
    local overriding = false

    if COMPONENTS[name] then 
        if COMPONENTS[name]._protected then 
            COMPONENTS.Logging:Warn('Components', ('Failed to Override Component: %s'):format(name), { skipDiscord = true })
            return
        else
            if COMPONENTS[name]._required and #COMPONENTS[name]._required > 0 then 
                for k, v in ipairs(COMPONENTS[name]._required) do 
                    if component[v] == nil then 
                        COMPONENTS.Logging:Warn('Components', 'Cannot Override Component Without It\'s Required Attributes.', { skipDiscord = true })
                        return
                    end
                end
            end
        end

        overriding = true
        COMPONENTS.Logging:Warn('Components', 'Overriding Existing Component: '.. name, { skipDiscord = true })
    end

    COMPONENTS[name] = component
    HandleComponentUpdate(name)
    TriggerEvent('ARP:Shared:Components:ExtendReady', name)
end

function ExtendComponent(name, extension)
    if COMPONENTS[name] then 
        if not COMPONENTS[name]._protected then 
            for k, v in pairs(extension) do 
                COMPONENTS[name][k] = v
            end
            HandleComponentUpdate(name)
            COMPONENTS.Logging:Warn('Components', 'Extending Component: '.. name, { skipDiscord = true })
        else
            COMPONENTS.Logging:Warn('Components', 'Cannot Extend Protected Component: '.. name, { skipDiscord = true })
        end
    else
        COMPONENTS.Logging:Warn('Components', 'Cannot Extend Non-Existent Component: '.. name, { skipDiscord = true })
    end
end

function FetchComponent(name)
    if not COMPONENTS[name] then 
        COMPONENTS.Logging:Warn('Components', 'Cannot Fetch Non-Existent Component: '.. name, { skipDiscord = true })
        return nil
    end

    return COMPONENTS[name]
end

function FetchComponents()
    return COMPONENTS
end

-- function UpdateDependers(componentName)
--     if dependencies[componentName] then 
--         for _, v in ipairs(dependencies[componentName]) do 
--             TriggerEvent('ARP:Shared:Components:RequiredUpdate:'.. v, componentName)
--         end
--     end
-- end

function HandleComponentUpdate(componentName)
    if hasInitialised then 
        TriggerEvent('ARP:Shared:Components:Update', componentName)
    end
end

-- function RequestRequiredComponents(depender, requiredComponents, callback)
--     Citizen.CreateThread(function()
--         local completed = false
--         local attempts = {}
--         local errored = {}
--         while not completed do 
--             for k, v in pairs(requiredComponents) do 
--                 if COMPONENTS[v] then 
--                     requiredComponents[k] = nil
--                     if dependencies[v] == nil then dependencies[v] = {} end
--                     table.insert(dependencies[v], depender)
--                 else
--                     if attempts[v] == nil then
--                         attempts[v] = 1
--                     elseif attempts[v] > 50 then
--                         table.insert(errored, v)
--                         COMPONENTS.Logging:Error('Components', ('Component: ^4%s^7 Failed To Load For: ^4%s^7'):format(v, depender), { skipDiscord = true })
--                         d[k] = nil
--                     else
--                         attempts[v] = attempts[v] + 1
--                     end
--                 end
--             end

--             if #requiredComponents == 0 then 
--                 completed = true
--             end

--             Citizen.Wait(100)
--         end

--         callback(errored)
--         collectgarbage()
--     end)
-- end

function AreComponentsLoaded(c)
    local found = 0
    for _, component in ipairs(c) do 
        if COMPONENTS[component] then 
            found = found + 1
        end
    end

    if found == #c then 
        return true
    else
        return false
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then 
        if GetGameTimer() > 10000 then 
            TriggerEvent('ARP:Shared:Components:RegisterReady', resource)
            TriggerEvent('ARP:Shared:Ready', resource)
            TriggerEvent('ARP:Shared:Components:ExtendReady', resource)
        end
    end
end)

exports('RegisterComponent', RegisterComponent)
exports('FetchComponent', FetchComponent)
exports('FetchComponents', FetchComponents)
exports('ExtendComponent', ExtendComponent)
-- exports('RequestRequiredComponents', RequestRequiredComponents)
-- exports('AreComponentsLoaded', AreComponentsLoaded)