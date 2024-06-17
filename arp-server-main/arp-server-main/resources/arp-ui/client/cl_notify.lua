SHOWING_PERSISTENT = false
CURRENT_PERSISTENT = false
IN_PROGRESS = false
DISABLE_KEYS = false

NOTIFY = {
    Send = function(self, type, title, text, icon, time)
        Components.UI:Send('arpNotification', {
            type = type, -- info, warning, error, success
            title = title,
            text = text,
            icon = icon,
            time = time,
        })
    end,
    Info = function(self, title, text, icon, time)
        NOTIFY:Send('info', title, text, icon, time)
    end,
    Warn = function(self, title, text, icon, time)
        NOTIFY:Send('warn', title, text, icon, time)
    end,
    Error = function(self, title, text, icon, time)
        NOTIFY:Send('error', title, text, icon, time)
    end,
    Success = function(self, title, text, icon, time)
        NOTIFY:Send('success', title, text, icon, time)
    end,
    Persistent = {
        Set = function(self, type, title, text, icon, progress)
            CURRENT_PERSISTENT = {
                type = string.lower(type),
                title = title,
                text = text,
                icon = icon,
                progress = progress
            }
            SHOWING_PERSISTENT = true
            Components.UI:Send('updatePersistentNotif', CURRENT_PERSISTENT)
        end,
        Clear = function(self)
            Components.UI:Send('removePersistentNotif', {})
            SHOWING_PERSISTENT = false
            CURRENT_PERSISTENT = false
        end,
        HasCurrent = function(self)
            return SHOWING_PERSISTENT
        end
    },
    Progress = {
        Start = function(self, time, type, title, icon, keysDisabled, emote)
            if not IN_PROGRESS then 
                local p = promise.new()

                IN_PROGRESS = true
                DISABLE_KEYS = keysDisabled

                NOTIFY.Persistent:Set(type, title, text, icon, time + 50)
                if emote then 
                    Components.Animate.Emotes:Play(emote, false, false, true)
                end

                Citizen.CreateThread(function()
                    while IN_PROGRESS do 
                        if DISABLE_KEYS then 
                            for _, key in ipairs(DISABLE_KEYS) do 
                                DisableControlAction(0, key, true)
                            end
                        end
                        Citizen.Wait(5)
                    end
                end)

                Citizen.SetTimeout(time, function()
                    if IN_PROGRESS then -- it wasn't cancelled
                        IN_PROGRESS = false
                        p:resolve(true)
                        if emote then Components.Animate.Emotes:ForceCancel() end
                        NOTIFY.Persistent:Clear()
                    else -- must have been cancelled
                        p:resolve(false)
                    end
                end)

                local result = Citizen.Await(p)
                return result
            end
            return false
        end,
        IsInProgress = function(self)
            return IN_PROGRESS
        end,
        Cancel = function(self)
            if IN_PROGRESS then 
                IN_PROGRESS = false
                Components.Animate.Emotes:ForceCancel()
                NOTIFY.Persistent:Clear()
            end
        end
    } 
}

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key)
    if key == 'interactionCancel' and IN_PROGRESS then 
        NOTIFY.Progress:Cancel()
    end
end)

RegisterNetEvent('Client:Notify')
AddEventHandler('Client:Notify', function(type, title, text, icon, time)
    NOTIFY:Send(type, title, text, icon, time)
end)