function SetupModelAndInheritenceMenu(creatorMode)

    local function updateHeadBlendValue(key, value)
        CurrentPedData.headBlend[key] = value
        ApplyHeadBlendData(ARP.GblPed, CurrentPedData)
    end

    local function addHeadBlendElements()
        PedMenu.Add:Slider(0, 'Mother\'s Facial Shape', { min = 0, max = 45 }, function(el, newVal) updateHeadBlendValue('face1', newVal) end)
        PedMenu.Add:Slider(0, 'Father\'s Facial Shape', { min = 0, max = 45 }, function(el, newVal) updateHeadBlendValue('face2', newVal) end)
        PedMenu.Add:Slider(50, 'Facial Shape Mixer', { min = 0, max = 100, step = 5, thumbLabel = false, hint = 'The mix between the mother and father\'s facial shape.', persistentHint = true }, function(el, newVal) 
            updateHeadBlendValue('shapeMix', newVal / 100)
        end)
        PedMenu.Add:Slider(0, 'Mother\'s Skin Tone', { min = 0, max = 45 }, function(el, newVal) updateHeadBlendValue('skin1', newVal) end)
        PedMenu.Add:Slider(0, 'Father\'s Skin Tone', { min = 0, max = 45 }, function(el, newVal) updateHeadBlendValue('skin2', newVal) end)
        PedMenu.Add:Slider(50, 'Skin Tone Mixer', { min = 0, max = 100, step = 5, thumbLabel = false, hint = 'The mix between the mother and father\'s skin tones.', persistentHint = true }, function(el, newVal) 
            updateHeadBlendValue('skinMix', newVal / 100)
        end)
    end

    local function addModelElements()
        if CurrentPedData.ped.custom then 
            PedMenu.Add:TextDisplay('<b>Warning!</b> Custom character models are not recommended to be used. You won\'t have much choice of clothing or customization,  or be able to use any uniforms. Don\'t choose if you plan on being PD or EMS.')
            local formattedModels = {
                { id = 'default', name = 'Default' }
            }
            for k, v in ipairs(CustomModels) do 
                table.insert(formattedModels, { id = v, name = k .. ' - ' .. v })
            end

            PedMenu.Add:Picker(CurrentPedData.ped.model, formattedModels, 'Character Model', {}, function(el, newVal) 
                if newVal == 'default' then 
                    CurrentPedData.ped.custom = false
                    CurrentPedData.ped.model = 'mp_m_freemode_01'

                    ApplyPedToPlayer(CurrentPedData)
  
                    PedMenu:ClearElements()
                    addModelElements()
                    addHeadBlendElements()
                    ApplyHeadBlendData(ARP.GblPed, CurrentPedData)
                else
                    if newVal and newVal ~= CurrentPedData.ped.model then
                        CurrentPedData.ped.model = newVal

                        ApplyPedToPlayer(CurrentPedData)
                        SetPedDefaultComponentVariation(ARP.GblPed)

                        --ApplyNClothingToDefaultPed(ARP.GblPed, GetGenderFromDefaultPedModel(CurrentPedData.ped.model))

                        --ApplyHeadBlendData(ARP.GblPed, CurrentPedData.headBlend)
                    end
                end
            end)

        else
            PedMenu.Add:Picker(CurrentPedData.ped.model, {
                { id = 'mp_m_freemode_01', name = 'Male' },
                { id = 'mp_f_freemode_01', name = 'Female' },
                { id = 'custom', name = 'Custom - Experimental! Warning!' }, 
            }, 'Character Model', { persistentHint = true, hint = 'Choose your characters model, only use custom model\'s if aware of the issues that surround them.' }, function(el, newVal) 
                if newVal == 'custom' then 
                    CurrentPedData.ped.custom = true
                    CurrentPedData.ped.model = CustomModels[1]
                    ApplyPedToPlayer(CurrentPedData)
                    SetPedDefaultComponentVariation(ARP.GblPed)

                    PedMenu:ClearElements()
                    addModelElements()
                else
                    CurrentPedData.ped.model = newVal
                    ApplyPedToPlayer(CurrentPedData)
                    SetPedConfigFlag(ARP.GblPed, 292, true)

                    ApplyNClothingToDefaultPed(ARP.GblPed, GetGenderFromDefaultPedModel(CurrentPedData.ped.model))

                    ApplyHeadBlendData(ARP.GblPed, CurrentPedData)
                end
            end)
        end
    end

    addModelElements()
    
    if not CurrentPedData.ped.custom then 
        ApplyHeadBlendData(ARP.GblPed, CurrentPedData)

        addHeadBlendElements()
    end


    if creatorMode then 
        PedMenu:SetTextHeader('Character Creation', 'Character\'s Inheritance & Model')
    else

    end

    PedMenu:Open()
end