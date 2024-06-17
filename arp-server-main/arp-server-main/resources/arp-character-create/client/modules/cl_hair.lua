

function SetupHairMenu(creatorMode)
    if creatorMode then 
        PedMenu:SetTextHeader('Character Creation', 'Character\'s Hair')
    else
        PedMenu:SetTextHeader('Hairdressers', 'The cost of a haircut is $50. Press Right Click to Toggle Camera.')
    end
    --currentCreatorMenu = 'hair'

    if CurrentPedData.ped.custom then 
        PedMenu.Add:Slider(CurrentPedData.headHair.value, 'Hair', { min = 1, max = GetNumberOfPedDrawableVariations(ARP.GblPed, 2) }, function(el, newVal)
            CurrentPedData.headHair.value = newVal
            ApplyHairData(ARP.GblPed, CurrentPedData)    
        end)
    else
        local modelGender = GetGenderFromDefaultPedModel(CurrentPedData.ped.model)

        ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
        ApplyHairData(ARP.GblPed, CurrentPedData)

        local availableHairs = modelGender and Hairs.Male or Hairs.Female

        local currentHairName = PedMenu.Add:TextDisplay('<b>Hair</b>: ' .. availableHairs[CurrentPedData.headHair.value].name)

        PedMenu.Add:Slider(CurrentPedData.headHair.value, 'Hair', { min = 1, max = #availableHairs }, function(el, newVal)
            CurrentPedData.headHair.value = newVal
            currentHairName:Update('<b>Hair</b>: ' .. availableHairs[CurrentPedData.headHair.value].name)
            ApplyHairData(ARP.GblPed, CurrentPedData)    
        end)

        PedMenu.Add:Palette(HairColors[CurrentPedData.headHair.color1 - 1], HairColors, 'Hair Colour', {}, function(el, newVal)
            local foundHair = ARP.GetPositionInOrderedTable(HairColors, newVal)
            CurrentPedData.headHair.color1 = foundHair - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
        end)

        PedMenu.Add:Palette(HairColors[CurrentPedData.headHair.color2 - 1], HairColors, 'Hair Highlight Colour', {}, function(el, newVal)
            local foundHair = ARP.GetPositionInOrderedTable(HairColors, newVal)
            CurrentPedData.headHair.color2 = foundHair - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
        end)

        PedMenu.Add:MenuSpacer()

        local currentFacialHairName = PedMenu.Add:TextDisplay('<b>Current Facial Hair</b>: ' .. FacialHair[CurrentPedData.facialHair.value + 1])

        PedMenu.Add:Slider(CurrentPedData.facialHair.value + 1, 'Facial Hair', { min = 1, max = #FacialHair }, function(el, newVal)
            CurrentPedData.facialHair.value = newVal - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
            currentFacialHairName:Update('<b>Current Facial Hair</b>: ' .. FacialHair[CurrentPedData.facialHair.value + 1])
        end)

        PedMenu.Add:Slider(CurrentPedData.facialHair.opacity * 100, 'Facial Hair Opacity', { min = 0, max = 100, step = 5 }, function(el, newVal)
            CurrentPedData.facialHair.opacity = newVal / 100
            ApplyHairData(ARP.GblPed, CurrentPedData)
        end)

        PedMenu.Add:Palette(HairColors[CurrentPedData.facialHair.color1 - 1], HairColors, 'Facial Hair Colour', {}, function(el, newVal)
            local foundHair = ARP.GetPositionInOrderedTable(HairColors, newVal)
            CurrentPedData.facialHair.color1 = foundHair - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
        end)

        PedMenu.Add:Palette(HairColors[CurrentPedData.facialHair.color2 - 1], HairColors, 'Facial Hair Highlight Colour ', {}, function(el, newVal)
            local foundHair = ARP.GetPositionInOrderedTable(HairColors, newVal)
            CurrentPedData.facialHair.color2 = foundHair - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
        end)

        PedMenu.Add:MenuSpacer()

        local currentFacialHairName = PedMenu.Add:TextDisplay('<b>Current Eyebrows</b>: ' .. Eyebrows[CurrentPedData.eyebrows.value + 1])

        PedMenu.Add:Slider(CurrentPedData.eyebrows.value + 1, 'Eyebrows', { min = 1, max = #Eyebrows }, function(el, newVal)
            CurrentPedData.eyebrows.value = newVal - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
            currentFacialHairName:Update('<b>Current Eyebrows</b>: ' .. Eyebrows[CurrentPedData.eyebrows.value + 1])
        end)

        PedMenu.Add:Palette(HairColors[CurrentPedData.eyebrows.color1 - 1], HairColors, 'Eyebrows Colour', {}, function(el, newVal)
            local foundHair = ARP.GetPositionInOrderedTable(HairColors, newVal)
            CurrentPedData.eyebrows.color1 = foundHair - 1
            ApplyHairData(ARP.GblPed, CurrentPedData)
        end)

        PedMenu.Add:MenuSpacer()



        for k, v in ipairs(MakeupOverlays) do 
            PedMenu.Add:Slider(CurrentPedData.headOverlays[v.type].value, v.label, { min = v.min, max = v.max, showField = true }, function(el, newVal)
                CurrentPedData.headOverlays[v.type].value = newVal
                ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
            end)

            PedMenu.Add:Slider(CurrentPedData.headOverlays[v.type].opacity * 100, v.label .. ' - Opacity', { min = 0, max = 100, step = 5 }, function(el, newVal)
                CurrentPedData.headOverlays[v.type].opacity = newVal / 100
                ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
            end)

            PedMenu.Add:Slider(CurrentPedData.headOverlays[v.type].color1, v.label .. ' - Primary Color', { min = 0, max = 64, }, function(el, newVal)
                CurrentPedData.headOverlays[v.type].color1 = newVal
                ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
            end)

            if v.color2 then 
                PedMenu.Add:Slider(CurrentPedData.headOverlays[v.type].color2, v.label .. ' - Secondary Color', { min = 0, max = 64, persistentHint = true, hint = 'For this to have an effect, it requires the primary color to be greater than 1.' }, function(el, newVal)
                    CurrentPedData.headOverlays[v.type].color2 = newVal
                    ApplyFaceOverlayData(ARP.GblPed, CurrentPedData)
                end)
            end
            PedMenu.Add:MenuSpacer()
        end
    end


    Citizen.Wait(100)
    PedMenu:Open()
end