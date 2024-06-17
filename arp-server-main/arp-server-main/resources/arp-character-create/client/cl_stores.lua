local haveAddedZones = false
local inZone = false

local inClothingStore = false

function AddZones()
    if haveAddedZones then return end
    haveAddedZones = true
    local shopZones = {}
    for k, shop in ipairs(_clothingStores) do 
        if shop.type == 'clothing' then 
            Components.Blips:Add("clothing_store_".. k, shop.coords, 'Clothing Store', 73, 0.7, 7)
        elseif shop.type == 'hair' then 
            Components.Blips:Add("clothing_store_".. k, shop.coords, 'Hairdresser', 71, 0.8, 47)
        elseif shop.type == 'tattoos' then 
            Components.Blips:Add("clothing_store_".. k, shop.coords, 'Tattoo Parlour', 75, 0.6, 1)
        end
        if shop.type == 'clothing' then 
            table.insert(shopZones, 
                PolyZone:Create(shop.points, {
                    name = "clothing_store_".. k,
                    minZ = shop.minZ,
                    maxZ = shop.maxZ,
                    data = { 
                        id = k,
                        type = shop.type 
                    },
                })
            )
        else
            table.insert(shopZones, 
                BoxZone:Create(shop.coords, shop.length, shop.width, {
                    name = "clothing_store_".. k,
                    data = { 
                        id = k,
                        type = shop.type 
                    },
                    heading = shop.heading
                })
            )
        end
    end

    local storeCombo = ComboZone:Create(shopZones, { name="clothing_stores" })

    storeCombo:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside and zone and zone.name then 
            inZone = zone.data.type
            if zone.data.type == 'clothing' then 
                inClothingStore = true
                Components.Notify.Persistent:Set('s', 'Clothing Store', 'Buy Clothes For <span style="color: #b40000"><b>$100</b></span>', 'mdi-tshirt-crew', false)
            elseif zone.data.type == 'hair' then
                Components.Notify.Persistent:Set('s', 'Hairdressers', 'Get a Haircut For <span style="color: #b40000"><b>$50</b></span>', 'mdi-content-cut', false)
            elseif zone.data.type == 'tattoos' then 
                Components.Notify.Persistent:Set('s', 'Tattoo Parlour', 'Change Tattoos For <span style="color: #b40000"><b>$300</b></span>', 'mdi-needle', false)
            end
        elseif inZone then
            ExitStore()
            inZone = false
            inClothingStore = false
            Components.Notify.Persistent:Clear()
        end
    end)
end

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key)
    if key == 'interactionPrimary' and inZone then 
        OpenStore(inZone)
    end
end)

local withinStoreMenu = false
local lookingAround = false

AddEventHandler('UI:Client:MouseClick', function(data)
    if (IN_CREATION or withinStoreMenu) and data and data.button == 2 then 
        ToggleLookingAround()
    end
end)

function ToggleLookingAround(toggle)
    if toggle == nil then 
        toggle = not lookingAround
    end

    if toggle ~= lookingAround then 
        lookingAround = toggle
        if lookingAround then 
            Components.UI:SetKeepInput(true)
            Components.UI:SetFocusedWithNoCursor()
            Citizen.CreateThread(function()
                while lookingAround do 
                    DisableControlAction(0, 22, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 199, true)
                    DisableControlAction(0, 200, true)
                    DisableControlAction(0, 202, true)
                    Citizen.Wait(5)
                end
            end)
        else
            Components.UI:SetKeepInput(false)
            Components.UI:SetFocus(true)
        end
    end
end

AddEventHandler('UI:Client:Escape', function()
    ExitStore()
end)

function OpenStore(type)
    if withinStoreMenu then return end
    withinStoreMenu = type
    if not PedMenu then 
        PedMenu = Components.Menus:New('pedCharacterMenu', 'Character Creation', function() end, function() end)
        Citizen.Wait(100)
    end

    SetGameplayCamRelativeHeading(180.0)
    SetFollowPedCamViewMode(0)

    PedMenu:ClearElements()

    PedMenu:SetControlsAsDoubleButton('Cancel', { color = 'red darken-4', icon = 'mdi-cancel' }, 'Pay', { color = 'green darken-4', icon = 'mdi-currency-usd' }, function(btn)
        if btn == 1 then 
            CompleteStore()
        else
            ExitStore()
        end
    end)

    if type == 'clothing' then 
        SetupCreationClothingMenu(false)
    elseif type == 'hair' then 
        SetupHairMenu(false)
    elseif type == 'tattoos' then 
        if not CurrentPedData.ped.custom then 
            local gender = GetGenderFromDefaultPedModel(CurrentPedData.ped.model)
            ApplyNClothingToDefaultPed(ARP.GblPed, gender)
        end
        SetupTattooMenu(false)
    end

    ToggleLookingAround(false)
end

function ExitStore()
    if withinStoreMenu then 
        ToggleLookingAround(false)
        PedMenu:Close()
        -- REset ped shit
        withinStoreMenu = false

        TriggerServerEvent('Characters:Creation:Server:CancelClothingStore')
    end
end

function CompleteStore()
    if withinStoreMenu then 
        PedMenu:Close()
        ToggleLookingAround(false)

        if withinStoreMenu == 'clothing' then 
            local data = Components.Callbacks:Execute('Characters:Server:OutfitsGetCurrent', {})
            local pMenu = {}

            table.insert(pMenu, {
                id = 1,
                title = (data.current == 1 and '(Current)' or '') .. ' Default Slot',
            })

            for i = 2, 10 do 
                local hasOutfit = data.all[i]
                local isCurrent = i == data.current
                local hasName = data.named[i]
                table.insert(pMenu, {
                    id = i,
                    title = (isCurrent and '(Current) ' or '') .. 'Slot ' .. i .. ((hasName and hasOutfit) and ' - ' .. hasName .. '' or ''),
                })
            end
    
            Interaction:Menu({ title = 'Save In an Outfit Slot', icon = 'mdi-hanger', text = 'Slot 1 will be chosen if not specified' }, pMenu, function(p, s)
                if not p then p = 1 end
                -- Server Callback
                local success = Components.Callbacks:Execute('Characters:Server:OutfitsSaveNew', { slot = p, data = CurrentOutfit })
                if success then 
                    Notify:Success('Clothing Store', 'Purchased Outfit - Saving to Slot '.. p, 'mdi-tshirt-crew')
                    if p > 1 then -- Cannot Rename 1
                        StartRenamingClothingSlot(p, data.named[p])
                    end
                else
                    Notify:Error('Clothing Store', 'Failed to Purchase Outfit', 'mdi-tshirt-crew')
                end
            end)
        elseif withinStoreMenu == 'hair' then 
            local success = Components.Callbacks:Execute('Characters:Server:HairSave', CurrentPedData)
            if not success then 
                Notify:Error('Hairdressers', 'Error Purchasing Haircut', 'mdi-content-cut')
            end
        elseif withinStoreMenu == 'tattoos' then 
            local success = Components.Callbacks:Execute('Characters:Server:TattoosSave', CurrentPedData)
            if not success then 
                Notify:Error('Tattoo Parlour', 'Error Purchasing Tattoos', 'mdi-needle')
            end
        end
        withinStoreMenu = false
        --TriggerServerEvent('Characters:Creation:Server:CancelClothingStore')
    end
end


-- Outfits Stuff

local renamingClothing = false
local renamingClothingSlot = 10

function StartRenamingClothingSlot(slot, currentName)
    if not renamingClothing then 
        local subTitle = 'This slot is not currently named'
        if type(currentName) == 'string' then 
            subTitle = 'This slot is currently named: '.. currentName
        end
        renamingClothing = true
        renamingClothingSlot = slot
        Components.UI:SetFocus(true)
        Components.UI:Send('interactionDialog', {
            title = 'Naming Slot '.. slot,
            text = subTitle,
            inputs = {
                { id = 'slotName', value = '', type = 'text', color = 'red darken-4', label = 'Slot Name' },
            },
            actions = {
                { id = 'slotNameDefault', color = 'red darken-4', text = 'Reset Name' },
                { id = 'slotNameKeep', color = 'red darken-4', text = 'Keep Name' },
                { id = 'slotNameSet', color = 'green', text = 'Save Name' }
            }
        })
    end
end

AddEventHandler('UI:Client:DialogClick', function(data)
    if renamingClothing and data and type(data.action) == 'string' and type(data.inputs) == 'table' then 
        if data.action == 'slotNameSet' then 
            local nameInput = data.inputs[1]
            if nameInput and nameInput.id == 'slotName' and type(nameInput.value) and #nameInput.value > 0 then 
                TriggerServerEvent('Characters:Server:SaveOutfitSlotName', renamingClothingSlot, nameInput.value)
            else
                Components.Notify:Error('Outfits', 'Cannot Save Without a Name', 'mdi-hanger')
            end
        --elseif data.action == 'slotNameKeep' then 
        elseif data.action == 'slotNameDefault' then 
            TriggerServerEvent('Characters:Server:SaveOutfitSlotName', renamingClothingSlot, nil)
        end
        Citizen.Wait(300)
        Components.UI:Send('interactionDialog', false)
        Components.UI:SetFocus(false)
        Components.UI:SetKeepInput(false)
        renamingClothing = false
    end
end)

-- Outfits Stuff

function OpenOutfitManagement()
    local data = Components.Callbacks:Execute('Characters:Server:OutfitsGetCurrent', {})
    local pMenu = {}

    local subMenu = {
        { id = 'switch', title = 'Switch to Outfit', icon = 'mdi-hanger' },
        { id = 'rename', title = 'Rename', icon = 'mdi-rename-box' },
        { id = 'delete', title = 'Delete Outfit', text = 'This is not reversible', icon = 'mdi-delete' },
    }

    table.insert(pMenu, {
        id = 1,
        title = (data.current == 1 and '(Current)' or '') .. ' Default Slot',
        secondary = {
            { id = 'switch', title = 'Switch to Outfit', icon = 'mdi-hanger' },
        }
    })

    for i = 2, 10 do 
        local hasOutfit = data.all[i]
        local isCurrent = i == data.current
        local hasName = data.named[i]
        table.insert(pMenu, {
            id = i,
            title = (isCurrent and '(Current) ' or '') .. 'Slot ' .. i .. ((hasName and hasOutfit) and ' - ' .. hasName .. '' or ''),
            disabled = not hasOutfit,
            secondary = subMenu
        })
    end

    Components.Interaction:Menu({ title = 'Outfit Management', icon = 'mdi-hanger', text = 'Select, delete or rename outfits.' }, pMenu, function(p, s)
        if p and type(p) == 'number' and p >= 1 and p <= 10 then
            if s == 'switch' then 
                TriggerServerEvent('Characters:Server:OutfitManagementAction', p, 'switch')
            elseif s == 'rename' then 
                StartRenamingClothingSlot(p, data.named[p])
            elseif s == 'delete' then 
                TriggerServerEvent('Characters:Server:OutfitManagementAction', p, 'delete')
            end
        end
    end)
end



RegisterNetEvent('Characters:Client:OpenOutfitManagement')
AddEventHandler('Characters:Client:OpenOutfitManagement', function(skip)
    if inClothingStore or skip then 
        OpenOutfitManagement()
    end
end)