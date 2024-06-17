PHONE_OPEN = false
PHONE_OPEN_TIMEOUT = false


function openPhone()
    if not PHONE_OPEN and not PHONE_OPEN_TIMEOUT then 
        PHONE_OPEN = true
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        SetCursorLocation(0.9, 0.5)
        sendNUI('open')
        exports['arp-interaction']:DisableKeyMappingsForPhone(true)
        Citizen.CreateThread(function()
            while PHONE_OPEN or PHONE_OPEN_TIMEOUT do 
                Citizen.Wait(10)
                DisableAllControlActions(1)
            end
        end)
    end
end

function closePhone(forced)
    if PHONE_OPEN then
        --PHONE_OPEN_TIMEOUT = true
        PHONE_OPEN = false
        SetNuiFocus(false, false) 
        SetNuiFocusKeepInput(false)
        exports['arp-interaction']:DisableKeyMappingsForPhone(false)
        --Citizen.SetTimeout(1000, function()
            --PHONE_OPEN_TIMEOUT = false
        --end)
        sendNUI('close')
    end
end

function togglePhone()
    if PHONE_OPEN then closePhone() else openPhone() end
end

RegisterNUICallback('startClose', function(data, cb)
    closePhone()
    cb({ success = true })
end)

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'phoneOpen' then 
        togglePhone()
    end
end)
