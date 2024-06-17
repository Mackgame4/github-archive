

OUTFITS = {
    Save = function(self, src, slot, outfitData, skip)
        local Character = Components.Characters:Source(src)
        if not Character then return false end
        local Outfits = Character:GetData('Outfits')
        if type(Outfits) ~= 'table' then Outfits = {} end
        local CurrentOutfit = Character:GetData('CurrentOutfit')
        if type(slot) == 'number' and slot >= 1 and slot <= 10 and type(outfitData) == 'table' then
            Outfits[slot] = outfitData
            Character:SetData('Outfits', Outfits)

            if not skip then
                OUTFITS:Switch(src, slot)
            end
            return true
        else
            return false
        end
    end,
    Delete = function(self, src, slot)
        local Character = Components.Characters:Source(src)
        if not Character then return end
        local Outfits = Character:GetData('Outfits')
        local CurrentOutfit = Character:GetData('CurrentOutfit')
        if type(slot) == 'number' and slot > 1 and slot <= 10 then 
            Outfits[slot] = false
            Character:SetData('Outfits', Outfits)

            if slot == CurrentOutfit then -- go to default outfit
                Character:SetData('CurrentOutfit', 1)
                TriggerClientEvent('Characters:Client:SetOutfit', src, 1, Outfits[1])
            end
        end
    end,
    Switch = function(self, src, slot)
        local Character = Components.Characters:Source(src)
        if not Character then return end
        local Outfits = Character:GetData('Outfits')
        local CurrentOutfit = Character:GetData('CurrentOutfit')
        if Outfits[slot] then 
            Character:SetData('CurrentOutfit', slot)
            TriggerClientEvent('Characters:Client:SetOutfit', src, slot, Outfits[slot])
        end
    end,
    CurrentData = function(self, src)
        local Character = Components.Characters:Source(src)
        if not Character then return end
        local Outfits = Character:GetData('Outfits')
        local CurrentOutfit = Character:GetData('CurrentOutfit')
        local OutfitsNamed = Character:GetData('OutfitsNamed')
        if OutfitsNamed == nil then OutfitsNamed = {} end
        if not Outfits[CurrentOutfit] then 
            return Outfits[1], 1, Outfits, OutfitsNamed
        else
            return Outfits[CurrentOutfit], CurrentOutfit, Outfits, OutfitsNamed
        end
    end,
    SetOutfitSlotName = function(self, src, slot, name)
        local Character = Components.Characters:Source(src)
        if not Character or slot == 1 then return false end
        local OutfitsNamed = Character:GetData('OutfitsNamed')
        if OutfitsNamed == nil then OutfitsNamed = {} end
        OutfitsNamed[slot] = name
        Character:SetData('OutfitsNamed', OutfitsNamed)
        return true
    end,
}

RegisterNetEvent('Characters:Creation:Server:CancelClothingStore')
AddEventHandler('Characters:Creation:Server:CancelClothingStore', function()
    local src = source
    local Character = Components.Characters:Source(src)
    local ped = Character:GetData('Ped')
    TriggerClientEvent('Characters:Client:ApplyData', src, ped)
    local outfitData, outfitId = OUTFITS:CurrentData(src)
    Citizen.Wait(1000)
    TriggerClientEvent('Characters:Client:SetOutfit', src, outfitId, outfitData)
end)

RegisterNetEvent('Characters:Creation:Server:CompleteClothingStore')
AddEventHandler('Characters:Creation:Server:CompleteClothingStore', function(slot, outfitData)
    local src = source
    -- CHECK FOR MONEY AND IF HAS ENOUGH CONTINUE

end)

RegisterNetEvent('Characters:Server:SaveOutfitSlotName')
AddEventHandler('Characters:Server:SaveOutfitSlotName', function(slot, name)
    local src = source
    local success = OUTFITS:SetOutfitSlotName(src, slot, name)
    if name then 
        TriggerClientEvent('Client:Notify', src, 'success', 'Outfits', 'Slot '.. slot .. ' Name was Set', 'mdi-hanger')
    else
        TriggerClientEvent('Client:Notify', src, 'success', 'Outfits', 'Slot '.. slot .. ' Name was Reset', 'mdi-hanger')
    end
end)

RegisterNetEvent('Characters:Server:OutfitManagementAction')
AddEventHandler('Characters:Server:OutfitManagementAction', function(slot, action)
    local src = source
    if slot and slot >= 1 and slot <= 10 then 
        if action == 'switch' then 
            OUTFITS:Switch(src, slot)
            exports['arp-sounds']:Play(src, 'outfit', 0.5)
        elseif action == 'delete' then 
            OUTFITS:Delete(src, slot)
        end
    end
end)