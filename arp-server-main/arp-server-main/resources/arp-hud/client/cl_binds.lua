AddEventHandler('Interaction:KeyBindings:KeyDown', function(key)
    if key == 'HUDshowDetails' then 
        ToggleDetailState(true)
    elseif key == 'arp' then 
        TriggerEvent('Hud:Client:OpenSettings')
    elseif key == 'HUDcinematic' then 
        ToggleHUDCinematic(not HUD_CINEMATIC)
    end
end)

AddEventHandler('Interaction:KeyBindings:KeyUp', function(key)
    if key == 'HUDshowDetails' then 
        ToggleDetailState(false)
    end
end)
