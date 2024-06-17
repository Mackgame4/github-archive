local interactionOpen = false
local interactionCallback
local canOpenInteraction = true

function OnComponentUpdate(c)
    if not c or c == 'UI' then 
        Components.UI:RegisterCallback('interactionClick', function(data, cb)
            if interactionOpen then 
                Components.UI:SetFocus(false)
                interactionOpen = false
                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false, false, true)
                
                if interactionCallback and data.id ~= nil and data.secondary ~= nil then 
                    interactionCallback(data.id, data.secondary)
                    interactionCallback = nil
                end
                Citizen.SetTimeout(500, function() canOpenInteraction = true end)
            end
            cb({ success = true })
        end)
    end

    if not c then 
        if GlobalState.ARP.development then 
            RegisterCommand('debugTargets', function(src, args)
                if args[1] then 
                    StartDebugTargetting()
                else
                    StopDebugTargetting()
                end
            end)
        end
    end
end

function OnCharacterLoad()
    Citizen.Wait(2500)
    InitializeInteractionZones() -- move to character load
end

function OnCharacterUnload()
    StopTargeting()
end

function OnCharacterDeath()
    StopTargeting()
end

INTERACTION = {
    Menu = function(self, title, items, cb)
        if not interactionOpen and canOpenInteraction then 
            interactionCallback = cb
            interactionOpen = true
            canOpenInteraction = false
            SetCursorLocation(0.7, 0.15)
            Components.UI:Send('interactionMenuCreate', {
                menuTitle = title,
                menuItems = items
            })
            Components.UI:SetFocus(true)
        else
            cb(false)
        end
    end
}

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Interaction', INTERACTION)
    exports['arp-base']:RegisterComponent('Blips', BLIPS)
end)