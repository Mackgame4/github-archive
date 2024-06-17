AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'interactionCancel' then 
        TriggerEvent('Animate:Client:CharacterCancelEmote')
    elseif key == 'emote_1' then 
        print('emote 1')
    elseif key == 'emote_2' then 
        print('emote 2')
    elseif key == 'emote_3' then 
        print('emote 3')
    elseif key == 'emote_4' then
        print('emote 4')
    end
end)