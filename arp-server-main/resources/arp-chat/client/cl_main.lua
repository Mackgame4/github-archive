function OnComponentUpdate(c)
    if not c or c == 'Callbacks' then 
        Components.Callbacks:Register('Chat:Client:GetLocalPlayers', function(cb)
            local myCoords = GetEntityCoords(ARP.GblPed)
            local targets = {}
            if CHAR_LOADED then 
                for _, player in ipairs(GetActivePlayers()) do 
                    local ped = GetPlayerPed(player)
                    if DoesEntityExist(ped) then 
                        local pedCoords = GetEntityCoords(ped)
                        if #(myCoords - pedCoords) <= 15.0 then 
                            table.insert(targets, GetPlayerServerId(player))
                        end
                    end
                end
            end
            cb(targets)
        end)
    end
    if not c then 

    end
end

RegisterNetEvent('ARP:Chat:Message')
AddEventHandler('ARP:Chat:Message', function(title, message)
    TriggerEvent('chat:addMessage', {
        template = '<div class="arp-message"><span class="titleText">{0}</span> - {1}</div>',
        args = { title, message }
    })
end)

RegisterNetEvent('ARP:Chat:SystemMessage')
AddEventHandler('ARP:Chat:SystemMessage', function(title, message)
    TriggerEvent('chat:addMessage', {
        template = '<div class="arp-message arp-system"><span class="titleText">{0}</span> - {1}</div>',
        args = { title, message }
    })
end)

RegisterNetEvent('ARP:Chat:OOCMessage')
AddEventHandler('ARP:Chat:OOCMessage', function(fromSrc, name, message)
    if not CHAR_LOADED then return end
    local mySrc = GetPlayerServerId(PlayerId())
    if fromSrc == mySrc then 
        TriggerEvent('chat:addMessage', {
            template = '<div class="arp-message arp-ooc"><span class="titleText">OOC</span> - <span class="titleText"><b>{0}</b></span>: {1}</div>',
            args = { 'You', message }
        })
    else
        TriggerEvent('chat:addMessage', {
            template = '<div class="arp-message arp-ooc"><span class="titleText">OOC</span> - <span class="titleText">{0}</span>: {1}</div>',
            args = { name, message }
        })
    end
end)


RegisterNetEvent('ARP:Chat:LocalOOCMessage')
AddEventHandler('ARP:Chat:LocalOOCMessage', function(fromSrc, name, message)
    if not CHAR_LOADED then return end
    local mySrc = GetPlayerServerId(PlayerId())
    if fromSrc == mySrc then 
        TriggerEvent('chat:addMessage', {
            template = '<div class="arp-message arp-ooc"><span class="titleText">Local OOC</span> - <span class="titleText"><b>{0}</b></span>: {1}</div>',
            args = { 'You', message }
        })
    else
        TriggerEvent('chat:addMessage', {
            template = '<div class="arp-message arp-ooc"><span class="titleText">Local OOC</span> - <span class="titleText">{0}</span>: {1}</div>',
            args = { name, message }
        })
    end
end)

-- Move to server side
--[[RegisterCommand('system', function(source, args)
    local source = source
    if source == 0 then
        TriggerEvent('ARP:Chat:SystemMessage', 'System Message', table.concat(args, ' '))
    end
end)]]--