
IN_CREATION = false
local currentCreatorMenu = false
local creatorMenus = {
    'inheritance',
    'structure',
    'features',
    'hair',
    'tattoos',
    'clothing'
}

local creationArea = BoxZone:Create(vector3(-534.13, -245.96, 35.94), 47.4, 28.6, {
    name="character_creation",
    heading=295,
})

creationArea:onPlayerInOut(function(isPointInside)
    if IN_CREATION and not isPointInside then 
        SetEntityCoords(ARP.GblPed, CreatorConfig.Location.xyz)
    end
end)

AddEventHandler('populationPedCreating', function(x, y, z, model)
    if IN_CREATION then 
        CancelEvent()
    end
end)

function StartCreation(gender)
    Citizen.CreateThread(function()
        if IN_CREATION then return end
        IN_CREATION = true
        Citizen.Wait(500)
        if not PedMenu then 
            PedMenu = Components.Menus:New('pedCharacterMenu', 'Character Creation', function() end, function() end)
            Citizen.Wait(100)
        end
    
        PedMenu:SetControlsAsDoubleButton('Back', { icon = 'mdi-arrow-left' }, 'Next', { color = 'red darken-4', icon = 'mdi-arrow-right' }, function(btn)
            if btn == 1 then 
                NextCreatorMenu()
            else
                PreviousCreatorMenu()
            end
        end)

        ToggleLookingAround(false)

        SetGameplayCamRelativeHeading(180.0)

        ClearAreaOfPeds(CreatorConfig.Location.x, CreatorConfig.Location.y, CreatorConfig.Location.z, 500.0)

        FreezeEntityPosition(ARP.GblPed, false)
        SetEntityCoords(ARP.GblPed, CreatorConfig.Location.xyz)
        SetEntityHeading(ARP.GblPed, CreatorConfig.Location.w)

        local model = 'mp_f_freemode_01'
        if gender then model = 'mp_m_freemode_01' end
        
        CurrentPedData = BlankPedData
        
        ApplyAllDataToCharacter(CurrentPedData)

        Components.Discord:SetText('Creating a Character')
        
        Components.Notify.Persistent:Set('s', 'Character Creation', 'Toggle your camera by right clicking.', 'mdi-card-account-details', false)
        PedMenu:ClearElements()

        DoScreenFadeIn(500)
        Citizen.Wait(500)
        --ApplyNClothingToDefaultPed(gender)
        ChangeToMenu('inheritance')
    end)
end

function GetCurrentMenu()
    local curMenu = ARP.GetPositionInOrderedTable(creatorMenus, currentCreatorMenu)
    if curMenu ~= nil then 
        return curMenu
    end
    return false
end

function ChangeToMenu(menu, next)
    currentCreatorMenu = menu
    if menu == 'inheritance' then 
        SetupModelAndInheritenceMenu(true, next)
    elseif menu == 'structure' then 
        SetupStructureMenu(true, next)
    elseif menu == 'features' then 
        SetupFeaturesMenu(true, next)
    elseif menu == 'hair' then 
        SetupHairMenu(true, next)
    elseif menu == 'tattoos' then 
        SetupTattooMenu(true, next)
    elseif menu == 'clothing' then 
        SetupCreationClothingMenu(true)
    end
end

function NextCreatorMenu()
    ToggleLookingAround(false)
    PedMenu:Close(true)
    Components.Notify.Persistent:Clear()
    local currentMenuPosition = GetCurrentMenu()
    if not currentMenuPosition then return end
    if currentMenuPosition == #creatorMenus then -- completed do something else
        local data = Components.Callbacks:Execute('Characters:Server:CompleteCreation', {
            ped = CurrentPedData, 
            outfit = CurrentOutfit
        })
        IN_CREATION = false
        if data and data.coords and data.ped and data.outfit then 
            exports['arp-character']:CompleteSpawn(data.coords, data.ped, data.outfit)
        end
    else
        local nextMenu = creatorMenus[currentMenuPosition + 1]
        PedMenu:ClearElements()
        ChangeToMenu(nextMenu, true)
    end
end

function PreviousCreatorMenu()
    local currentMenuPosition = GetCurrentMenu()
    if not currentMenuPosition then return end
    if currentMenuPosition > 1 then 
        PedMenu:Close(true)
        PedMenu:ClearElements()
        local prevMenu = creatorMenus[currentMenuPosition - 1]
        ChangeToMenu(prevMenu, false)
    end
end

RegisterNetEvent('Characters:Client:StartCreation')
AddEventHandler('Characters:Client:StartCreation', StartCreation)

--[[

"Outfits": [{
    "drawables": {
        "arms": {
            "value": 11,
            "text": 0
        },
        "mask": {
            "value": 0,
            "text": 0
        },
        "neck": {
            "value": 0,
            "text": 0
        },
        "undershirt": {
            "value": 15,
            "text": 0
        },
        "overshirt": {
            "value": 348,
            "text": 2
        },
        "vests": {
            "value": 15,
            "text": 0
        },
        "bag": {
            "value": 0,
            "text": 0
        },
        "decals": {
            "value": 0,
            "text": 0
        },
        "pants": {
            "value": 49,
            "text": 0
        },
        "shoes": {
            "value": 10,
            "text": 0
        }
    },
    "props": {
        "watch": {
            "value": -1,
            "text": 0
        },
        "bracelet": {
            "value": -1,
            "text": 0
        },
        "earrings": {
            "value": -1,
            "text": 0
        },
        "glasses": {
            "value": 5,
            "text": 0
        },
        "hat": {
            "value": -1,
            "text": 0
        }
    }
}],


"Ped": {
    "headOverlays": {
        "age": {
            "value": 1,
            "opacity": 0.15
        },
        "complexion": {
            "value": 1,
            "opacity": 0.35
        },
        "sun": {
            "value": -1,
            "opacity": 1
        },
        "body": {
            "value": 5,
            "opacity": 1
        },
        "lipstick": {
            "value": -1,
            "opacity": 1,
            "color1": 0
        },
        "blush": {
            "value": -1,
            "opacity": 1,
            "color1": 0
        },
        "makeup": {
            "value": -1,
            "opacity": 1,
            "color2": 0,
            "color1": 0
        },
        "blemish": {
            "value": 2,
            "opacity": 0.5
        },
        "freckles": {
            "value": 2,
            "opacity": 0.35
        }
    },
    "facialHair": {
        "value": 0,
        "opacity": 1,
        "color2": 0,
        "color1": 3
    },
    "ped": {
        "model": "mp_m_freemode_01",
        "custom": false
    },
    "eyeColor": 3,
    "headHair": {
        "value": 8,
        "color2": 12,
        "color1": 3
    },
    "eyebrows": {
        "value": 25,
        "color1": 3
    },
    "tattoos": ["mplowrider_12", "mplowrider_16"],
    "headStructure": {
        "1": 0.1,
        "2": 0.05,
        "3": 0,
        "4": -0.05,
        "5": 0.05,
        "6": 0,
        "7": -0.2,
        "9": 0,
        "10": -0.5,
        "11": -1,
        "12": 0.1,
        "13": -0.05,
        "14": 0.05,
        "15": -0.05,
        "16": 0.25,
        "17": 0.15,
        "18": -0.05,
        "19": -0.2,
        "20": -0.8
    },
    "headBlend": {
        "shapeMix": 0.25,
        "skin1": 0,
        "face2": 10,
        "skin2": 5,
        "face1": 0,
        "skinMix": 0.35
    }
},

]]--