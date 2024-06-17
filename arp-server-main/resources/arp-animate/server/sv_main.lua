
function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        Components.Commands:Add('e', function(src, args)
            local emote = args[1]
            if emote == "c" or emote == "cancel" then
                TriggerClientEvent('Animate:Client:CharacterCancelEmote', src)
            else
                TriggerClientEvent('Animate:Client:CharacterDoAnEmote', src, emote)
            end
        end, 'Do An Emote or Dance', { { name = 'Emote', help = 'Name of The Emote/Dance to Do' } }, false)  
    end
end

AddEventHandler('Characters:Server:Login', function(src, cid)
    local Character = Components.Characters:Source(src)
    if not Character then return end
    local walk = Character:GetData('Walk')
    local expression = Character:GetData('Expression')
    if not walk then 
        Character:SetData('Walk', 'default')
        walk = 'default'
    end

    if not expression then 
        Character:SetData('Expression', 'default')
        expression = 'default'
    end

    TriggerClientEvent('Animate:Client:RecieveAnimFeatures', src, {
        walk = walk,
        expression = expression
    })
end)