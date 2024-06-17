CurrentPedData = BlankPedData
CurrentOutfit = {
    -- drawables
    drawables = {
        undershirt = { value = 0, text = 0 },
        overshirt = { value = 0, text = 0 },
        arms = { value = 0, text = 0 },
        pants = { value = 0, text = 0 },
        shoes = { value = 0, text = 0 },
        decals = { value = 0, text = 0 },
        mask = { value = 0, text = 0 },
        vests = { value = 0, text = 0 },
        bag = { value = 0, text = 0 },
        neck = { value = 0, text = 0 },
    },
    -- props
    props = {
        hat = { value = -1, text = 0 },
        glasses = { value = -1, text = 0 },
        earrings = { value = -1, text = 0 },
        watch = { value = -1, text = 0 },
        bracelet = { value = -1, text = 0 },
    }
}

PedMenu = false
PedMenuOpen = false

function ApplyPedToPlayer(pedData)
    if pedData.ped.model == 'mp_f_freemode_01' or pedData.ped.model == 'mp_m_freemode_01' or pedData.ped.custom then
        LoadAndSetPlayerModel(GetHashKey(pedData.ped.model))
        local playerPed = PlayerPedId() -- update globalPed now since it just changed
        ARP.GblPed = playerPed
        TriggerEvent('ARP:PlayerPedChanged', playerPed)
        Citizen.Wait(100)
        SetPedDefaultComponentVariation(ARP.GblPed)
        return true
    else return false end
end

function ApplyHeadBlendData(targetPed, pedData)
    SetPedHeadBlendData(targetPed, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, false)
    local headBlendData = pedData.headBlend 
    if not pedData.ped.custom and headBlendData ~= nil then 
        SetPedHeadBlendData(targetPed, headBlendData.face1, headBlendData.face2, 0, headBlendData.skin1, headBlendData.skin2, 0, headBlendData.shapeMix, headBlendData.skinMix, 0.0, false)
    end
end

function ApplyFaceStructureData(targetPed, pedData) 
    for index, value in ipairs(pedData.headStructure) do
        if type(value) == 'number' then 
            SetPedFaceFeature(targetPed, index - 1, value)
        else
            SetPedFaceFeature(targetPed, index - 1, 0.0)
        end
    end
end

function ApplyFaceOverlayData(targetPed, pedData)
    for feature, data in pairs(pedData.headOverlays) do 
        SetPedHeadOverlay(targetPed, OverlayIds[feature], data.value, data.opacity)
        if data.color1 ~= nil and type(data.color1) == 'number' then
            if data.color1 > 0 then 
                if data.color2 ~= nil and type(data.color2) == 'number' then 
                    SetPedHeadOverlayColor(targetPed, OverlayIds[feature], 2, data.color1, 0)
                else
                    SetPedHeadOverlayColor(targetPed, OverlayIds[feature], 2, data.color1, data.color2)
                end
            else
                SetPedHeadOverlayColor(targetPed, OverlayIds[feature], 0, 0, 0)
            end
        end

    end
end

function ApplyHairData(targetPed, pedData)
    ClearPedDecorations(targetPed);

    if not pedData.ped.custom then
        local headHair = pedData.headHair
        local facialHair = pedData.facialHair
        local eyebrowData = pedData.eyebrows
        local allHair = GetGenderFromDefaultPedModel(pedData.ped.model) and Hairs.Male or Hairs.Female
        local currentHair = allHair[headHair.value]
        if not currentHair then return end
        if currentHair.collection and currentHair.overlay then 
            AddPedDecorationFromHashes(targetPed, GetHashKey(currentHair.collection), GetHashKey(currentHair.overlay))
        end 
        SetPedComponentVariation(targetPed, 2, currentHair.hair, 0, 0);
        SetPedHairColor(targetPed, headHair.color1, headHair.color2);
        -- Facial Hair
        SetPedHeadOverlay(targetPed, 1, facialHair.value, facialHair.opacity + 0.0);
        SetPedHeadOverlayColor(targetPed, 1, 1, facialHair.color1, facialHair.color2);
        -- Eyebrows
        SetPedHeadOverlay(targetPed, 2, eyebrowData.value, 1.0);
        SetPedHeadOverlayColor(targetPed, 2, 1, eyebrowData.color1, eyebrowData.color1);
    else
        SetPedComponentVariation(targetPed, 2, pedData.headHair.value, 0, 0);
    end
end

function ApplyTattooData(targetPed, pedData, fromCreation, skipClear)
    if skipClear == nil or not skipClear then 
        ClearPedDecorations(targetPed);
    end
    if fromCreation then 
        ApplyHairData(ARP.GblPed, pedData)
    end
    local tattooConfigByKeys = GetTattooDataForKeys()
    for _, tattooKey in pairs(pedData.tattoos) do 
        local tattooData = string.split(tattooConfigByKeys[tattooKey].tattoo, '@')
        local collection = GetHashKey(tattooData[1])
        local overlay = GetHashKey(tattooData[2])
        AddPedDecorationFromHashes(targetPed, collection, overlay)
    end
end

function ApplyAllDataToCharacter(data)
    CurrentPedData = data
    local gender = GetGenderFromDefaultPedModel(data.ped.model)

    ApplyPedToPlayer(data)
    
    ClearPedBloodDamage(ARP.GblPed);
    ClearPedDecorations(ARP.GblPed);

    if data.ped.custom then 
        SetPedDefaultComponentVariation(ARP.GblPed)
        SetPedEyeColor(ARP.GblPed, 0)
    else
        ApplyNClothingToDefaultPed(ARP.GblPed, gender)
        ApplyHeadBlendData(ARP.GblPed, data)
        ApplyFaceStructureData(ARP.GblPed, data)
        ApplyFaceOverlayData(ARP.GblPed, data)
        ApplyHairData(ARP.GblPed, data)
        SetPedEyeColor(ARP.GblPed, data.eyeColor)
    end
    ApplyTattooData(ARP.GblPed, data, false, true)
end

function ApplyCosmeticsToPed(ped, data)
    local gender = GetGenderFromDefaultPedModel(data.ped.model)

    ClearPedBloodDamage(ped);
    ClearPedDecorations(ped);

    if data.ped.custom then 
        SetPedDefaultComponentVariation(ped)
        SetPedEyeColor(ped, 0)
    else
        ApplyNClothingToDefaultPed(ped, gender)
        ApplyHeadBlendData(ped, data)
        ApplyFaceStructureData(ped, data)
        ApplyFaceOverlayData(ped, data)
        ApplyHairData(ped, data)
        SetPedEyeColor(ped, data.eyeColor)
    end
    ApplyTattooData(ped, data, false, true)
end

function GetGenderFromDefaultPedModel(model)
    return model == 'mp_m_freemode_01' 
end

RegisterNetEvent('Characters:Client:ApplyData')
AddEventHandler('Characters:Client:ApplyData', ApplyAllDataToCharacter)

-- Clothing
function ApplyClothingOutfit(ped, clothing)
    if clothing.props and clothing.drawables then 
        CurrentOutfit = clothing
        ClearAllPedProps(ped)
        for drawable, drawableData in pairs(CurrentOutfit.drawables) do 
            SetPedComponentVariation(ped, ClothingIDs[drawable], drawableData.value, drawableData.text, 0)
        end

        if CurrentOutfit.drawables.undershirt then 
            SetPedComponentVariation(ped, ClothingIDs['undershirt'], CurrentOutfit.drawables.undershirt.value, CurrentOutfit.drawables.undershirt.text, 0)
        end
        if CurrentOutfit.drawables.overshirt then 
            SetPedComponentVariation(ped, ClothingIDs['overshirt'], CurrentOutfit.drawables.overshirt.value, CurrentOutfit.drawables.overshirt.text, 0)
        end

        for prop, propData in pairs(CurrentOutfit.props) do 
            if propData.value >= 0 then 
                SetPedPropIndex(ped, ClothingIDs[prop], propData.value, propData.text, 0)
            else
                ClearPedProp(ped, ClothingIDs[prop])
            end
        end
    end
end

RegisterNetEvent('Characters:Client:SetOutfit')
AddEventHandler('Characters:Client:SetOutfit', function(slot, data)
    ApplyClothingOutfit(ARP.GblPed, data)
end)

function ApplyNClothingToDefaultPed(ped, gender)
    if gender then 
        ApplyClothingOutfit(ped, DefaultNClothing.Male)
    else
        ApplyClothingOutfit(ped, DefaultNClothing.Female)
    end
end

exports('ApplyCosmeticsToPed', ApplyCosmeticsToPed)
exports('ApplyClothingOutfit', ApplyClothingOutfit)
exports('ApplyNClothingToDefaultPed', ApplyNClothingToDefaultPed)
exports('ApplyAllDataToCharacter', ApplyAllDataToCharacter)