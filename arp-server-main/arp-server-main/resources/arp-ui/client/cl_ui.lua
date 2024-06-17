local UIFocused = false
local UIKeepInput = false
local UIDevLogs = false
UICallbacks = {}

function OnComponentUpdate(c)
    if GlobalState.ARP.development then 
        RegisterCommand('ui:focus', function(src, args, raw)
            Components.UI:ToggleFocus()
        end)
    end
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('UI', UI)
    exports['arp-base']:RegisterComponent('Notify', NOTIFY)
end)

UI = {
    RegisterCallback = function(self, event, cbFunc)
        if not UICallbacks[event] then
            RegisterNUICallback(event, function(data, cb)
                TriggerEvent('UI:Events:'.. event, data)
                local callback = UICallbacks[event]
                if callback then 
                    callback(data, function(uiCB)
                        cb(uiCB)
                    end)
                end
            end)
        end
        UICallbacks[event] = cbFunc
    end,
    Send = function(self, event, data)
        SendNUIMessage({
            event = event,
            data = data
        })
    end,
    SetFocus = function(self, toggle)
        UIFocused = toggle
        SetNuiFocus(toggle, toggle)
    end,
    ToggleFocus = function(self)
        Components.UI:SetFocus(not UIFocused)
    end,
    SetFocusedWithNoCursor = function(self)
        SetNuiFocus(true, false)
    end,
    SetKeepInput = function(self, toggle)
        UIKeepInput = toggle
        SetNuiFocusKeepInput(toggle)
    end,
    ToggleKeepInput = function(self)
        Components.UI:SetKeepInput(not UIKeepInput)
    end,
    Copy = function(self, string)
        if type(string) == 'string' then 
            Components.UI:Send('clipboardCopy', string)
        end
    end
}

RegisterNetEvent('UI:Client:Send')
AddEventHandler('UI:Client:Send', function(event, data)
    Components.UI:Send(event, data)
end)

RegisterNUICallback('mouseClick', function(data, cb)
    TriggerEvent('UI:Client:MouseClick', data)
    cb('ok')
end)

RegisterNUICallback('escapeButton', function(data, cb)
    TriggerEvent('UI:Client:Escape')
    cb('ok')
end)

RegisterNUICallback('interactionDialogClick', function(data, cb)
    TriggerEvent('UI:Client:DialogClick', data)
    cb('ok')
end)