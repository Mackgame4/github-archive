local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
local IsInAnimation = false
local MovementType = 0
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
local isRequestAnim = false

local PersistentEmote = false

ANIMATE.Emotes = {
    Play = function(self, emote, fromUserInput, time, persist)
        if (not PersistentEmote or PersistentEmote and persist) and emote ~= nil then
            local name = string.lower(emote)
            local animInfo

            if AnimData.Emotes[name] ~= nil then
                animInfo = AnimData.Emotes[name]
            elseif AnimData.Dances[name] ~= nil then
                animInfo = AnimData.Dances[name]
            elseif AnimData.PropEmotes[name] ~= nil then
                animInfo = AnimData.PropEmotes[name]
            elseif fromUserInput then
                Notify:Error('Invalid Emote', false, 'mdi-human-female-dance')
            end
            local animTime = (time ~= nil and tonumber(time) or nil)
            if animInfo ~= nil then
                DoAnEmote(animInfo, fromUserInput, animTime, persist)
            end
        end
    end,
    Cancel = function(self)
        if not PersistentEmote then
            CancelEmote()
        end
    end,
    ForceCancel = function(self) -- Force Cancel Regardless of If They Can
        CancelEmote()
        PersistentEmote = false
    end,
}

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local x,y,z = table.unpack(GetEntityCoords(ARP.GblPed))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, ARP.GblPed, GetPedBoneIndex(ARP.GblPed, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

function DestroyAllProps()
    for _,v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
end

function DoAnEmote(emoteData, fromUserInput, length, persist)

    if (fromUserInput and emoteData.AdditionalOptions.AvailableToChar) or (not fromUserInput) then
        if persist then 
            PersistentEmote = true
        else
            PersistentEmote = false
        end
        local InVehicle = IsPedInAnyVehicle(ARP.GblPed, true)

        if IsPedArmed(ARP.GblPed, 7) then
            SetCurrentPedWeapon(ARP.GblPed, GetHashKey('WEAPON_UNARMED'), true)
        end
        ChosenDict, ChosenAnimation = emoteData.AnDictionary, emoteData.AnAnim
        AnimationDuration = -1

        if PlayerHasProp then
            DestroyAllProps()
        end

        if ChosenDict == "MaleScenario" or "Scenario" then 
            if ChosenDict == "MaleScenario" then 
                if InVehicle then 
                    return 
                end
                ClearPedTasks(ARP.GblPed)
                TaskStartScenarioInPlace(ARP.GblPed, ChosenAnimation, 0, true)
                IsInAnimation = true
                return
            elseif ChosenDict == "ScenarioObject" then 
                if InVehicle then 
                    return 
                end
                BehindPlayer = GetOffsetFromEntityInWorldCoords(ARP.GblPed, 0.0, 0 - 0.5, -0.5);
                ClearPedTasks(ARP.GblPed)
                TaskStartScenarioAtPosition(ARP.GblPed, ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(ARP.GblPed), 0, 1, false)
                IsInAnimation = true
                return
            elseif ChosenDict == "Scenario" then 
                if InVehicle then 
                    return 
                end
                ClearPedTasks(ARP.GblPed)
                TaskStartScenarioInPlace(ARP.GblPed, ChosenAnimation, 0, true)
                IsInAnimation = true
                return 
            end 
        end

        LoadAnim(ChosenDict)

        MovementType = 0
        -- Mess around with this if things break
        if emoteData.AdditionalOptions.EmoteMoving then 
            MovementType = MovementType + 50
        end

        if emoteData.AdditionalOptions.EmoteLoop then 
            MovementType = MovementType + 1
        end

        if emoteData.AdditionalOptions.UpperBody then 
            MovementType = MovementType + 16
        end

        
        if InVehicle == 1 then
            MovementType = 51
        end
        
        if emoteData.AdditionalOptions.FlagOverride and type(emoteData.AdditionalOptions.FlagOverride) == 'number' then 
            MovementType = emoteData.AdditionalOptions.FlagOverride
        end

        if emoteData.AdditionalOptions then
            if emoteData.AdditionalOptions.EmoteDuration == nil then 
                emoteData.AdditionalOptions.EmoteDuration = -1
                AttachWait = 0
            else
                AnimationDuration = emoteData.AdditionalOptions.EmoteDuration
                AttachWait = emoteData.AdditionalOptions.EmoteDuration
            end

            if emoteData.AdditionalOptions.PtfxAsset then
                    PtfxAsset = emoteData.AdditionalOptions.PtfxAsset
                    PtfxName = emoteData.AdditionalOptions.PtfxName
                if emoteData.AdditionalOptions.PtfxNoProp then
                    PtfxNoProp = emoteData.AdditionalOptions.PtfxNoProp
                else
                    PtfxNoProp = false
                end
                Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(emoteData.AdditionalOptions.PtfxPlacement)
                PtfxInfo = emoteData.AdditionalOptions.PtfxInfo
                PtfxWait = emoteData.AdditionalOptions.PtfxWait
                PtfxPrompt = true
                Notify.Persistent:Set('info', 'Emote Particles', PtfxInfo, 'mdi-human-female-dance')
                Citizen.CreateThread(function()
                    while PtfxPrompt do
                        if IsControlPressed(0, 47) then
                            PtfxStart()
                            Wait(PtfxWait)
                            PtfxStop()
                        end
                        Citizen.Wait(5)
                    end
                end)
                PtfxThis(PtfxAsset)
            else
                PtfxPrompt = false
            end
        end

        TaskPlayAnim(ARP.GblPed, ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
        RemoveAnimDict(ChosenDict)
        IsInAnimation = true
        MostRecentDict = ChosenDict
        MostRecentAnimation = ChosenAnimation

        if emoteData.AdditionalOptions then
            if emoteData.AdditionalOptions.Prop then
                PropName = emoteData.AdditionalOptions.Prop
                PropBone = emoteData.AdditionalOptions.PropBone
                PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(emoteData.AdditionalOptions.PropPlacement)
                if emoteData.AdditionalOptions.SecondProp then
                    SecondPropName = emoteData.AdditionalOptions.SecondProp
                    SecondPropBone = emoteData.AdditionalOptions.SecondPropBone
                    SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(emoteData.AdditionalOptions.SecondPropPlacement)
                    SecondPropEmote = true
                else
                    SecondPropEmote = false
                end
                Wait(AttachWait)
                AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
                if SecondPropEmote then
                    AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
                end
            end
        end

        if length ~= nil and length > 0 then
            Citizen.SetTimeout(length, function()
                Components.Animate.Emotes:ForceCancel()
            end)
        end
    else
        Notify:Error('Invalid Emote', false, 'mdi-human-female-dance')
    end
end

function CancelEmote()
    if ChosenDict == "MaleScenario" and IsInAnimation then
        ClearPedTasksImmediately(ARP.GblPed)
        IsInAnimation = false
    elseif ChosenDict == "Scenario" and IsInAnimation then
        ClearPedTasksImmediately(ARP.GblPed)
        IsInAnimation = false
    end
    if PtfxPrompt then Notify.Persistent:Clear() end
    PtfxPrompt = false
    if IsInAnimation then
        ClearPedTasks(ARP.GblPed)
        DestroyAllProps()
        PtfxStop()
        IsInAnimation = false
    end
end

function PtfxStart()
    if PtfxNoProp then
        PtfxAt = ARP.GblPed
    else
        PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStop()
    for a,b in pairs(PlayerParticles) do
        StopParticleFxLooped(b, false)
        table.remove(PlayerParticles, a)
    end
end

RegisterNetEvent('Animate:Client:CharacterDoAnEmote')
AddEventHandler('Animate:Client:CharacterDoAnEmote', function(emote)
    if CHAR_LOADED then
        Components.Animate.Emotes:Play(emote, true)
    end
end)

RegisterNetEvent('Animate:Client:CharacterCancelEmote')
AddEventHandler('Animate:Client:CharacterCancelEmote', function()
    if CHAR_LOADED then
        Components.Animate.Emotes:Cancel()
    end
end)