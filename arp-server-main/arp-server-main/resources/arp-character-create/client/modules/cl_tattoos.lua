

function SetupTattooMenu(creatorMode)
    if not PedMenu then return end
    if creatorMode then 
        PedMenu:SetTextHeader('Character Creation', 'Character\'s Tattoos')
    else
        PedMenu:SetTextHeader('Tattoo Parlour', 'Tattoo Changes Cost $200. Press Right Click to Toggle Camera.')
    end

    local formattedTattooList = {}

    for index, tattoo in ipairs(Tattoos) do 
        formattedTattooList[index] = { id = tattoo.key, name = tattoo.label }
        --print(index, tattoo.label, ARP.FormatTable(string.split(tattoo.tattoo, '@')))
    end


    local pickerOptions = { multiple = true, multipleLimiter = 25, hint = 'You can have up to 25 tattoos at one given time.', persistentHint = true }

    local tattooCounter = PedMenu.Add:TextDisplay('Current Tattoo Count: '.. #CurrentPedData.tattoos .. '/25')


    local pickerID = PedMenu.Add:Picker(CurrentPedData.tattoos, formattedTattooList, '', pickerOptions, function(el, newVal)
        CurrentPedData.tattoos = newVal
        ApplyTattooData(ARP.GblPed, CurrentPedData, true)
        tattooCounter:Update('Current Tattoo Count: '.. #CurrentPedData.tattoos)
    end)




    PedMenu.Add:Button('Remove All Tattoos', { color = 'red darken-4'}, function()
        CurrentPedData.tattoos = {}
        ApplyTattooData(ARP.GblPed, CurrentPedData, true)
        pickerID:Update(CurrentPedData.tattoos, formattedTattooList, '', pickerOptions)
        tattooCounter:Update('Current Tattoo Count: '.. #CurrentPedData.tattoos)
    end)


    Citizen.Wait(300)
    PedMenu:Open()
end