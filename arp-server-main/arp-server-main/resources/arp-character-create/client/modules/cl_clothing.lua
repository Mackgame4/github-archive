function SetupCreationClothingMenu(creatorMode)
    if creatorMode then 
        PedMenu:SetTextHeader('Character Creation', 'Character\'s Clothing')
    else
        PedMenu:SetTextHeader('Clothing Store', 'The cost of clothing is $100. Press Right Click to Toggle Camera.')
    end

    local textureSliders = {}

    for _, clothingItem in ipairs(ClothingMenuDrawables) do 
        local drawableId = ClothingIDs[clothingItem.clothing]
        local maxDrawables = GetNumberOfPedDrawableVariations(ARP.GblPed, drawableId)
        local hasDrawables = maxDrawables > 0
        PedMenu.Add:Slider(CurrentOutfit.drawables[clothingItem.clothing].value, clothingItem.name, { readonly = not hasDrawables, min = 0, max = hasDrawables and maxDrawables or 1, showField = true }, function(el, newVal)
            CurrentOutfit.drawables[clothingItem.clothing].value = newVal
            CurrentOutfit.drawables[clothingItem.clothing].text = 0
            SetPedComponentVariation(ARP.GblPed, drawableId, CurrentOutfit.drawables[clothingItem.clothing].value, CurrentOutfit.drawables[clothingItem.clothing].texture, 0)
            if textureSliders[clothingItem.clothing] then 
                local maxTextures = GetNumberOfPedTextureVariations(ARP.GblPed, drawableId, CurrentOutfit.drawables[clothingItem.clothing].value) - 1
                local hasTextures = maxTextures > 0
                textureSliders[clothingItem.clothing]:Update(CurrentOutfit.drawables[clothingItem.clothing].text, clothingItem.name .. ' - Textures', { readonly = not hasTextures, min = 0, max = hasTextures and maxTextures or 1, showField = true })
            end
        end)


        local maxTextures = GetNumberOfPedTextureVariations(ARP.GblPed, drawableId, CurrentOutfit.drawables[clothingItem.clothing].value) - 1
        local hasTextures = maxTextures > 0
        textureSliders[clothingItem.clothing] = PedMenu.Add:Slider(CurrentOutfit.drawables[clothingItem.clothing].text, clothingItem.name .. ' - Textures', { readonly = not hasTextures, min = 0, max = hasTextures and maxTextures or 1, showField = true }, function(el, newVal)
            CurrentOutfit.drawables[clothingItem.clothing].text = newVal
            SetPedComponentVariation(ARP.GblPed, drawableId, CurrentOutfit.drawables[clothingItem.clothing].value, CurrentOutfit.drawables[clothingItem.clothing].text, 0)
        end)
        PedMenu.Add:MenuSpacer()
    end

    for _, clothingItem in ipairs(ClothingMenuProps) do 
        local propId = ClothingIDs[clothingItem.clothing]
        local maxProps = GetNumberOfPedPropDrawableVariations(ARP.GblPed, propId)
        local hasProps = maxProps > 0
        PedMenu.Add:Slider(CurrentOutfit.props[clothingItem.clothing].value, clothingItem.name, { readonly = not hasProps, min = -1, max = hasProps and maxProps or 0, showField = true }, function(el, newVal)
            CurrentOutfit.props[clothingItem.clothing].value = newVal
            CurrentOutfit.props[clothingItem.clothing].text = 0
            if tonumber(CurrentOutfit.props[clothingItem.clothing].value) >= 0 then 
                SetPedPropIndex(ARP.GblPed, propId, CurrentOutfit.props[clothingItem.clothing].value, CurrentOutfit.props[clothingItem.clothing].texture, 0)
                if textureSliders[clothingItem.clothing] then 
                    local maxTextures = GetNumberOfPedPropTextureVariations(ARP.GblPed, propId, CurrentOutfit.props[clothingItem.clothing].value) - 1
                    local hasTextures = maxTextures > 0
                    textureSliders[clothingItem.clothing]:Update(CurrentOutfit.props[clothingItem.clothing].text, clothingItem.name .. ' - Textures', { readonly = not hasTextures, min = 0, max = hasTextures and maxTextures or 1, showField = true })
                end
            else
                ClearPedProp(ARP.GblPed, propId)
            end
        end)

        local maxTextures = GetNumberOfPedPropTextureVariations(ARP.GblPed, propId, CurrentOutfit.props[clothingItem.clothing].value) - 1
        local hasTextures = maxTextures > 0

        textureSliders[clothingItem.clothing] = PedMenu.Add:Slider(CurrentOutfit.props[clothingItem.clothing].text, clothingItem.name .. ' - Textures', { readonly = not hasTextures, min = 0, max = hasTextures and maxTextures or 1, showField = true }, function(el, newVal)
            if tonumber(CurrentOutfit.props[clothingItem.clothing].value) >= 0 then 
                CurrentOutfit.props[clothingItem.clothing].text = newVal
                SetPedPropIndex(ARP.GblPed, propId, CurrentOutfit.props[clothingItem.clothing].value, CurrentOutfit.props[clothingItem.clothing].text, 0)
            else
                ClearPedProp(ARP.GblPed, propId)
            end
        end)
        PedMenu.Add:MenuSpacer()
    end

    --if creatorMode then 
    --    PedMenu.Add:MenuSpacer()
    --    PedMenu.Add:Button('Complete', { color = 'red darken-4', icon = "mdi-arrow-right" }, NextCreatorMenu)
    --end


    Citizen.Wait(100)
    PedMenu:Open()
end