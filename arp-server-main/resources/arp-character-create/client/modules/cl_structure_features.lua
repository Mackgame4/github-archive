
function SetupStructureMenu(creatorMode, next)

    if creatorMode and CurrentPedData.ped.custom then 
        if next then 
            NextCreatorMenu()
        else
            PreviousCreatorMenu()
        end
        return
    end

    if creatorMode then 
        PedMenu:SetTextHeader('Character Creation', 'Character\'s Facial Structure')
    end

    ApplyFaceStructureData(ARP.GblPed, CurrentPedData)

    for k, v in ipairs(Structures) do 
        PedMenu.Add:Slider(0, v, { min = -100, max = 100, step = 5 }, function(el, newVal)
            local newScale = newVal / 100
            CurrentPedData.headStructure[k] = newScale
            SetPedFaceFeature(ARP.GblPed, k - 1, newScale)
        end)
    end

    Citizen.Wait(300)
    PedMenu:Open()
end


function SetupFeaturesMenu(creatorMode, next)

    if creatorMode and CurrentPedData.ped.custom then 
        if next then 
            NextCreatorMenu()
        else
            PreviousCreatorMenu()
        end
        return
    end

    if creatorMode then 
        PedMenu:SetTextHeader('Character Creation', 'Character\'s Features')
    
        PedMenu.Add:Button('Go Back', { icon = "mdi-arrow-left" }, PreviousCreatorMenu)
        PedMenu.Add:MenuSpacer()
    end


    ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
    SetPedEyeColor(ARP.GblPed, CurrentPedData.eyeColor)

    PedMenu.Add:Slider(CurrentPedData.eyeColor, 'Eye Colour', { min = 0, max = 29 }, function(el, newVal)
        CurrentPedData.eyeColor = newVal
        SetPedEyeColor(ARP.GblPed, CurrentPedData.eyeColor)
    end)

    PedMenu.Add:MenuSpacer()

    for k, v in ipairs(Overlays) do 
        PedMenu.Add:Slider(CurrentPedData.headOverlays[v.type].value, v.label, { min = v.min, max = v.max }, function(el, newVal)
            CurrentPedData.headOverlays[v.type].value = newVal
            ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
        end)
        PedMenu.Add:Slider(CurrentPedData.headOverlays[v.type].opacity * 100, v.label .. ' - Opacity', { min = 0, max = 100, step = 5 }, function(el, newVal)
            CurrentPedData.headOverlays[v.type].opacity = newVal / 100
            ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
        end)
        PedMenu.Add:MenuSpacer()
    end

    if creatorMode then 
        PedMenu.Add:Button('Next', { color = 'red darken-4', icon = "mdi-arrow-right"  }, NextCreatorMenu)
    end


    Citizen.Wait(300)
    PedMenu:Open()
end
