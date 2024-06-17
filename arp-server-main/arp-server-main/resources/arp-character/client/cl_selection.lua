LocationMenu = false
local selectionLocation = vector3(-511.651, -263.260, 19.191)
local selectCam = { coords = vector3(-515.016, -256.043, 36.219), rot = vector3(-1.834, 0.0, 30.406) }
local selectData = false
local selectPeds = {}
local characterPoints = {
    vector3(-516.852, -252.923, 34.653), -- front middle
    vector3(-515.968, -251.656, 34.661), -- middle right
    vector3(-518.349, -253.036, 34.661), -- middle left
    vector3(-515.138, -250.416, 34.669), -- back far right
    vector3(-519.884, -253.119, 34.669) -- back far left
}
local inSelection = false
local selectionInteraction = false
local selectCamera = false
local hoveringCharacter = false
local makeAllPlayersInvisible = false

CHARACTERS.Selection = {
    Begin = function(self)
        if not inSelection then 
            inSelection = true
            local SelectData = Components.Callbacks:Execute('Characters:Server:GetSelectionData')
            selectData = SelectData
            SetEntityCoords(ARP.GblPed, selectionLocation)
            FreezeEntityPosition(ARP.GblPed, true)
            MakeAllPlayersInvisible()
            ClearAreaOfPeds(selectionLocation.x, selectionLocation.y, selectionLocation.z, 500.0)

            if not selectCamera then 
                selectCamera = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', selectCam.coords, selectCam.rot, 60.0, true, 2)
                RenderScriptCams(true, false, 1, true, true);
                SetCamActive(selectCamera, true);
            end

            Components.UI:SetFocus(true)
            Components.UI:Send('listenForClicks', true)
            --UI:SetKeepInput(true)

            AwaitLoadModel(`mp_m_freemode_01`)
            AwaitLoadModel(`mp_f_freemode_01`)
            AwaitLoadModel(`a_c_cow`)

            if selectData.success and selectData.characters then
                local extraSelector = false
                local actuallyActualCharacters = false
                for i = 1, 5 do
                    if selectData.characters[i] then 
                        actuallyActualCharacters = true
                        if selectData.characters[i].Ped then 
                            local char = selectData.characters[i]
                            local ped = char.Ped
                            local hash = GetHashKey(ped.ped.model)
                            AwaitLoadModel(hash)
                            selectPeds[i] = CreatePed(0, hash, characterPoints[i], 210.0, false, false)
    
                            exports['arp-character-create']:ApplyCosmeticsToPed(selectPeds[i], ped)
    
                            if char.Outfits and char.CurrentOutfit and char.Outfits[char.CurrentOutfit] then 
                                exports['arp-character-create']:ApplyClothingOutfit(selectPeds[i], char.Outfits[char.CurrentOutfit])
                            end
                        else
                            selectPeds[i] = CreatePed(0, `mp_m_freemode_01`, characterPoints[i], 210.0, false, false)
                            exports['arp-character-create']:ApplyNClothingToDefaultPed(selectPeds[i], true)
                        end
                    else
                        if not extraSelector then 
                            extraSelector = true
                            local ped = `mp_m_freemode_01`
                            if i > 1 then 
                                ped = `a_c_cow`
                            end
                            selectPeds[i] = CreatePed(0, ped, characterPoints[i], 210.0, false, false)
                            SetPedDefaultComponentVariation(selectPeds[i])
                            if not selectData.characters[i] then 
                                --SetEntityAlpha(selectPeds[i], 200, false)
                            end
                        end
                    end
                end

                if not actuallyActualCharacters then 
                    Components.UI:Send('characterCreateToggle', true)
                end

                Citizen.Wait(1500)
                DoScreenFadeIn(1000)
                Citizen.Wait(1000)

                StartHovering()
            end
        end
    end,
    StopCam = function(self)
        if selectCamera then 
            SetCamActive(selectCamera, false);
            DestroyCam(selectCamera, true)
            RenderScriptCams(false, false, 1, false, false);
            selectCamera = false
        end
    end,
    ClearPeds = function(self)
        for k, v in ipairs(selectPeds) do 
            DeletePed(v)
            selectPeds[k] = nil
        end
    end,
    SetAsOnlyPed = function(self, ped)
        for k, v in ipairs(selectPeds) do 
            if k == ped then 
                SetEntityCoords(v, characterPoints[1])
            else
                DeletePed(v)
                selectPeds[k] = nil
            end
        end
    end,
    Stop = function(self)
        StopHovering()
        Components.Characters.Selection:StopCam()
        Components.Characters.Selection:ClearPeds()
        inSelection = false
    end
}


function StartHovering()
    if selectionInteraction then return end

    selectionInteraction = true
    Citizen.CreateThread(function()
        
        while selectionInteraction do 
            local absoluteX, absoluteY = GetNuiCursorPosition()
            local processedCoords = processCoordinates(absoluteX, absoluteY)
            local targetCoords = s2w(selectCam.coords, processedCoords.x, processedCoords.y, selectCam.rot)
            
            local direction = targetCoords - selectCam.coords
            local fromCoords = selectCam.coords + (direction * 0.05)
            local toCoords = selectCam.coords + (direction * 300)
            
            local rayCast = StartShapeTestRay(fromCoords, toCoords, 8, ARP.GblPed, -1)
            local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayCast)
            hit = hit == 1
            if hit and entityHit then 
                local hoveringCharacter = ARP.GetPositionInOrderedTable(selectPeds, entityHit)
                if hoveringCharacter then 
                    local screenX, screenY = GetActiveScreenResolution()
                    local coords = GetEntityCoords(entityHit)
                    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 1.2)
                    UpdateHovering(hoveringCharacter, _x * screenX, _y * screenY)
                end
            else
                ClearHovering()
            end

            Citizen.Wait(250)
        end
    end)
end

function StopHovering()
    selectionInteraction = false
    ClearHovering()
end

function UpdateHovering(newCharacter, x, y)
    if newCharacter ~= hoveringCharacter then 
        hoveringCharacter = newCharacter
        if selectData.characters and selectData.characters[newCharacter] then 
            local char = selectData.characters[newCharacter]
            Components.UI:Send('hoverInteraction', {
                title = ('%s %s'):format(char.FirstName, char.LastName),
                x = x,
                y = y,
                text = ('CID: %s<br>Born %s'):format(char.CID, exports['arp-libs']:FormatUnixForBirthday(char.DOB))
            })
        else
            Components.UI:Send('hoverInteraction', {
                title = 'Create',
                x = x,
                y = y,
                text = 'Create a New Character',
            })
        end
    end
end

function ClearHovering()
    if hoveringCharacter then 
        Components.UI:Send('hoverInteraction', false)
        hoveringCharacter = false
    end
end

AddEventHandler('UI:Client:MouseClick', function()
    if inSelection and hoveringCharacter then 
        local characterHovering = hoveringCharacter
        StopHovering()
        --UI:SetKeepInput(false)
        if selectData.characters and selectData.characters[characterHovering] then 
            local char = selectData.characters[characterHovering]

            local selectedSuccess = Components.Callbacks:Execute('Characters:Server:Select', char.CID)

            if selectedSuccess.success then
                Components.UI:Send('interactionDialog', false)
                if selectedSuccess.close then 
                    DoScreenFadeOut(300)
                    Citizen.Wait(350)
                    Components.Characters.Selection:Stop()
                else
                    Components.Characters.Selection:SetAsOnlyPed(characterHovering)
                end
            else
                -- Send Notification or something
                Components.UI:Send('interactionDialog', false)
            end
        else
            -- start to create charcater
            Components.UI:Send('characterCreateToggle', true)
        end
    end
end)

function RegisterSelectionUICallbacks()
    Components.UI:RegisterCallback('createNewCharacter', function(data, cb)
        if inSelection then 
            if data then 
                local createdCharacter = Components.Callbacks:Execute('Characters:Server:CreateNew', data)
                cb({ success = createdCharacter })
                if createdCharacter then 
                    -- stop selection
                    DoScreenFadeOut(500)
                    Citizen.Wait(500)
                    Components.Characters.Selection:Stop()
                end
            else
                cb({ success = false })
                --UI:SetKeepInput(true)
                StartHovering()
            end
        else
            cb({ success = false })
        end
    end)
end

RegisterNetEvent('Characters:Client:StartSpawnSelect')
AddEventHandler('Characters:Client:StartSpawnSelect', function(locations)
    if not inSelection then return end
    if not LocationMenu then 
        LocationMenu = Components.Menus:New('LocationSelection', 'Spawn Location', function() end, function() end, 'Where would you like to spawn?')
    end
    
    LocationMenu:ClearElements()
    for locationID, location in ipairs(locations) do 
        local buttonOptions = {}
        if location.type == 'last' then 
            buttonOptions.color = 'cyan darken-4'
        end

        LocationMenu.Add:Button(location.name, buttonOptions, function()
            LocationMenu:Close()
            local data = Components.Callbacks:Execute('Characters:Server:ChooseSpawn', locationID)
            if data and data.coords and data.ped and data.outfit then 
                CompleteSpawn(data.coords, data.ped, data.outfit)
            end
        end)
    end
    LocationMenu:DisableControl()
    LocationMenu:Open()
end)

RegisterNetEvent('Characters:Client:CharacterSelection', function()
    Components.Characters.Selection:Begin()
end)

function CompleteSpawn(coords, ped, outfit)
    DoScreenFadeOut(300)
    Citizen.Wait(300)
    exports['arp-character-create']:ApplyAllDataToCharacter(ped)
    exports['arp-character-create']:ApplyClothingOutfit(ARP.GblPed, outfit)
    Citizen.Wait(100)
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 200)
    FreezeEntityPosition(playerPed, true)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z + 1.0, false, false, false, true)
    local time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(playerPed) and (GetGameTimer() - time) < 8000) do
        Citizen.Wait(100)
    end

    StopMakeAllPlayersInvisible()

    Components.UI:SetFocus(false)

    FreezeEntityPosition(playerPed, false)
    Components.Characters.Selection:Stop()
    Citizen.Wait(200)
    DoScreenFadeIn(350)

    TriggerEvent('Characters:Client:FullyLoaded')
end

function MakeAllPlayersInvisible()
    if makeAllPlayersInvisible then return end
    makeAllPlayersInvisible = true
    Citizen.CreateThread(function() -- performance - na mate not anymore
        while makeAllPlayersInvisible do
            for _, p in ipairs(GetActivePlayers()) do
                local playerPed = GetPlayerPed(p)
                if playerPed ~= ARP.GblPed then 
                    SetEntityLocallyInvisible(playerPed)
                end
            end
            Citizen.Wait(10)
        end
    end)
end

function StopMakeAllPlayersInvisible()
    if makeAllPlayersInvisible then 
        makeAllPlayersInvisible = false
    end
end

AddEventHandler('onClientResourceStop', function(res)
    if res == GetCurrentResourceName() then 
        Components.Characters.Selection:StopCam()
        Components.Characters.Selection:ClearPeds()
    end
end)

AddEventHandler('populationPedCreating', function(x, y, z, model)
    if inSelection then 
        CancelEvent()
    end
end)

exports('CompleteSpawn', CompleteSpawn)