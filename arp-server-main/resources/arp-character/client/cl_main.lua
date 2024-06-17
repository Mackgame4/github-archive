
function OnComponentUpdate(c)
    if not c or c == 'UI' then 
        RegisterSelectionUICallbacks()
    end

    if not c then 
        DoScreenFadeOut(1)
        Citizen.Wait(500)
        Components.Characters.Selection:Begin()
    end
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function()
    exports['arp-base']:RegisterComponent('Characters', CHARACTERS)
end)