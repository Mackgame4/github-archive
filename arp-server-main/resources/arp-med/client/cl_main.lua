local enabledDeathControls = { 0, 1, 2, 3, 4, 5, 6, 7, 249, 199, 200 }

LAST_PED = 0
LAST_HEALTH = 200
LAST_ARMOUR = 0

PLAYER_DEAD = false
PLAYER_DAMAGE = nil
DAMAGED_LIMBS_COUNT = 0
DAMAGED_LIMBS_MOST_SEVERE = 0
VEHICLE_INSIDE = false
VEHICLE_SEAT = -1

-- Timers
FADEOUT_TIMER, BLACKOUT_TIMER, BLEED_TIMER, ADV_BLEED_TIMER = 0, 0, 0, 0

-- Medicines
MEDS_PAINKILLERS = 0
MEDS_PAINKILLERS_PREV = false
MEDS_DRUGS = 0
MEDS_DRUGS_PREV = false

function GetDefaultPlayerDamage()
    return {
        Bleed = 0,
        Limbs = {
            ['HEAD'] = { label = 'Head', isDamaged = false, severity = 0 },
            ['NECK'] = { label = 'Neck', isDamaged = false, severity = 0 },
            ['SPINE'] = { label = 'Spine', isDamaged = false, severity = 0 },
            ['UPPER_BODY'] = { label = 'Upper Body', isDamaged = false, severity = 0 },
            ['LOWER_BODY'] = { label = 'Lower Body', isDamaged = false, severity = 0 },
            ['LARM'] = { label = 'Left Arm', isDamaged = false, severity = 0 },
            ['LHAND'] = { label = 'Left Hand', isDamaged = false, severity = 0 },
            ['LLEG'] = { label = 'Left Leg', isDamaged = false, severity = 0 },
            ['LFOOT'] = { label = 'Left Foot', isDamaged = false, severity = 0 },
            ['RARM'] = { label = 'Right Arm', isDamaged = false, severity = 0 },
            ['RHAND'] = { label = 'Right Hand', isDamaged = false, severity = 0 },
            ['RLEG'] = { label = 'Right Leg', isDamaged = false, severity = 0 },
            ['RFOOT'] = { label = 'Right Foot', isDamaged = false, severity = 0 },
        }
    }
end


-- All Main Threads Running

function StartThreads()
    PLAYER_DAMAGE = GetDefaultPlayerDamage()

    -- Timers
    FADEOUT_TIMER, BLACKOUT_TIMER, BLEED_TIMER, ADV_BLEED_TIMER = 0, 0, 0, 0

    -- Medicines
    MEDS_PAINKILLERS = 0
    MEDS_PAINKILLERS_PREV = false
    MEDS_DRUGS = 0
    MEDS_DRUGS_PREV = false

    SetEntityHealth(ARP.GblPed, 200)
    SetPlayerInvincible(ARP.GblPed, false)

    LocalPlayer.state:set('dead', false, false)
    
    local Character = Components.Characters:Current()

    local isAlreadyDead = Character:GetData('Dead')
    print('Initial Death State: ', isAlreadyDead)
    if isAlreadyDead then 
        KillPlayer(true)
    end

    if Character:GetData('Damage') ~= nil then 
        PLAYER_DAMAGE = Character:GetData('Damage')
    else
        PLAYER_DAMAGE = GetDefaultPlayerDamage()
    end

    local health = Character:GetData('Health')
    print('Initial Health: ', health)

    if health ~= nil then 
        local totalHealth = 100 + health
        print('Initial Total Health: ', totalHealth)
        LocalPlayer.state:set('health', totalHealth, true)
        SetEntityHealth(ARP.GblPed, totalHealth)
        LAST_HEALTH = totalHealth
    else
        SetEntityHealth(ARP.GblPed, 200)
        LAST_HEALTH = 200
        LocalPlayer.state:set('health', 100, true)
    end

    local armour = Character:GetData('Armour')

    if armour ~= nil then 
        SetPedArmour(ARP.GblPed, armour)
        LocalPlayer.state:set('armour', armour, true)
        LAST_ARMOUR = armour
    else
        SetPedArmour(ARP.GblPed, 0)
        LAST_ARMOUR = 0
        LocalPlayer.state:set('armour', 0, true)
    end

    Citizen.CreateThread(function()
        while CHAR_LOADED and PLAYER_DAMAGE ~= nil do
            if DAMAGED_LIMBS_COUNT > 0 and DAMAGED_LIMBS_MOST_SEVERE > 0 then
                SetPedMoveRateOverride(ARP.GblPed, Config.MovementRate[DAMAGED_LIMBS_MOST_SEVERE])
                Citizen.Wait(5)
            else
                Citizen.Wait(2000)
            end
        end
    end)

    Citizen.CreateThread(function()
        while CHAR_LOADED do 
            Citizen.Wait(250)

            if LAST_PED ~= ARP.GblPed then -- The Ped changed
                SetEntityHealth(ARP.GblPed, LAST_HEALTH)
                SetPedArmour(ARP.GblPed, LAST_ARMOUR)

                Components.Medical.Apply:Movement(ARP.GblPed)
            end

            LAST_PED = ARP.GblPed

            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0) -- Disable Health Regen

            local newHealth = GetEntityHealth(LAST_PED)
            local newArmour = GetPedArmour(LAST_PED)

            local armorDamaged = (LAST_ARMOUR ~= newArmour and newArmour < (LAST_ARMOUR - Config.ArmorDamage) and newArmour > 0) -- Players armor was damaged significantly since last tick
            local healthDamaged = (newHealth < LAST_HEALTH) -- Players health was damaged since last tick
            local healthDamageAmount = (LAST_HEALTH - newHealth)

            if armorDamaged or healthDamaged then
                local hit, bone = GetPedLastDamageBone(LAST_PED)
                local bodypart = Config.Bones[bone]
                local weapon = GetDamagingWeapon(LAST_PED)
    
                if hit and bodypart ~= 'NONE' then
                    if healthDamageAmount >= Config.HealthDamage then
                        local checkDamage = true
                        if weapon ~= nil then
                            if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                                checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                            end
        
                            if checkDamage then
        
                                if IsDamagingEvent(healthDamageAmount, weapon) then
                                    Components.Medical:CheckDamage(LAST_PED, bone, weapon, healthDamageAmount)
                                end
                            end
                        end
                    elseif Config.AlwaysBleedChanceWeapons[weapon] then
                        if math.random(100) < Config.AlwaysBleedChance then
                            print('bleed')
                            Components.Medical.Apply:Bleed(1)
                        end
                    end
                end
            end


            ProcessDamage(ARP.GblPed)

            LAST_HEALTH = newHealth
            LAST_ARMOUR = newArmour

            --print(LAST_HEALTH)
            LocalPlayer.state:set('health', LAST_HEALTH - 100, true) -- -100 for health as %
            LocalPlayer.state:set('armour', LAST_ARMOUR, true)

            if PLAYER_DEAD then
                SetEntityHealth(ARP.GblPed, 200)
            else
                SetPlayerInvincible(ARP.GblPed, false)
            end

            if not PLAYER_DEAD and IsPedFatallyInjured(ARP.GblPed) then -- If they are not already dead
                KillPlayer()
            end
        end
    end)


    local prevPos = nil
    Citizen.CreateThread(function()
        prevPos = GetEntityCoords(ARP.GblPed, true)
        while CHAR_LOADED and PLAYER_DAMAGE ~= nil do
            -- ARP.PrintTable(PLAYER_DAMAGE)
            if PLAYER_DAMAGE.Bleed > 0 then
                if BLEED_TIMER >= Config.BleedTickRate then
                    if not PLAYER_DEAD then
                        if PLAYER_DAMAGE.Bleed > 0 then
                            if PLAYER_DAMAGE.Bleed == 1 then
                                SetFlash(0, 0, 100, 100, 100)
                            elseif PLAYER_DAMAGE.Bleed == 2 then
                                SetFlash(0, 0, 100, 250, 100)
                            elseif PLAYER_DAMAGE.Bleed == 3 then
                                SetFlash(0, 0, 100, 500, 100)
                            elseif PLAYER_DAMAGE.Bleed == 4 then
                                SetFlash(0, 0, 100, 500, 100)
                            end
    
                            if FADEOUT_TIMER + 1 == Config.FadeOutTimer then
                                if BLACKOUT_TIMER + 1 == Config.BlackoutTimer then
                                    -- Notification:Custom('You Suddenly Black Out', 5000, Config.NotifStyle)
                                    SetFlash(0, 0, 100, 7000, 100)
    
                                    DoScreenFadeOut(500)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(0)
                                    end
    
                                    if not IsPedRagdoll(ARP.GblPed) and IsPedOnFoot(ARP.GblPed) and not IsPedSwimming(ARP.GblPed) then
                                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                        SetPedToRagdollWithFall(ARP.GblPed, 7500, 9000, 1, GetEntityForwardVector(ARP.GblPed), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                                    end
    
                                    Citizen.Wait(1500)
                                    DoScreenFadeIn(1000)
                                    BLACKOUT_TIMER = 0
                                else
                                    DoScreenFadeOut(500)
                                    while not IsScreenFadedOut() do
                                        Citizen.Wait(0)
                                    end
                                    DoScreenFadeIn(500)
    
                                    if PLAYER_DAMAGE.Bleed > 3 then
                                        BLACKOUT_TIMER = BLACKOUT_TIMER + 2
                                    else
                                        BLACKOUT_TIMER = BLACKOUT_TIMER + 1
                                    end
                                end
    
                                FADEOUT_TIMER = 0
                            else
                                FADEOUT_TIMER = FADEOUT_TIMER + 1
                            end
    
                            local bleedDamage = tonumber(PLAYER_DAMAGE.Bleed) * Config.BleedTickDamage
                            ApplyDamageToPed(ARP.GblPed, bleedDamage, false)
                            SetEntityHealth(ARP.GblPed, LAST_HEALTH - bleedDamage)
    
                            if ADV_BLEED_TIMER >= Config.AdvanceBleedTimer then
                                Components.Medical.Apply:Bleed(1)
                                ADV_BLEED_TIMER = 0
                            else
                                ADV_BLEED_TIMER = ADV_BLEED_TIMER + 1
                            end
                        end
                    end
                    BLEED_TIMER = 0
                else
                    if math.floor(BLEED_TIMER % (Config.BleedTickRate / 10)) == 0 then
                        local currPos = GetEntityCoords(ARP.GblPed, true)
                        local moving = #(vector2(prevPos.x, prevPos.y) - vector2(currPos.x, currPos.y))
                        if (moving > 1 and not IsPedInAnyVehicle(ARP.GblPed)) and PLAYER_DAMAGE.Bleed > 2 then
                            -- Notification.Persistent:Custom(bleedMoveNotifId, 'You notice blood oozing from your wounds faster when you\'re moving', Config.NotifStyle)
                            ADV_BLEED_TIMER = ADV_BLEED_TIMER + Config.BleedMovementAdvance
                            BLEED_TIMER = BLEED_TIMER + Config.BleedMovementTick
                            prevPos = currPos
                        else
                            -- Notification.Persistent:Remove(bleedMoveNotifId)
                            BLEED_TIMER = BLEED_TIMER + 1
                        end
    
                    else
    
                    end
                    BLEED_TIMER = BLEED_TIMER + 1
                end
            end

            Components.Medical.Apply:Movement(ARP.GblPed)
    
            Citizen.Wait(1000)
        end
    end)
end

function KillPlayer(force)
    if not PLAYER_DEAD then 
        PLAYER_DEAD = true
        StartDeathAnimation()

        SetPedCanBeTargetted(ARP.GblPed, false)

        LocalPlayer.state:set('dead', true, false)

        TriggerEvent('Medical:Client:DeadState', true)
        if not force then 
            TriggerServerEvent('Medical:Server:FuckingDead')
        end
    else
        RefreshDeathAnim()
    end
end

function RevivePlayer(partial)
    if partial then SetEntityHealth(ARP.GblPed, 150) else SetEntityHealth(ARP.GblPed, 200) end
    SetPedArmour(ARP.GblPed, 0)
    ClearPedBloodDamage(ARP.GblPed)
    SetPlayerInvincible(ARP.GblPed, false)
    SetPedCanBeTargetted(ARP.GblPed, true)
    if PLAYER_DEAD then 
        StopDeathAnim()
    end

    PLAYER_DEAD = false
    LocalPlayer.state:set('dead', false, false)
    TriggerEvent('Medical:Client:DeadState', false)

    SetPlayerSprint(PlayerId(), true)
    PLAYER_DAMAGE = GetDefaultPlayerDamage()
    TriggerServerEvent('Medical:Server:SyncDamage', PLAYER_DAMAGE)

    Components.Medical.Apply:Movement(ARP.GblPed)

    -- Timers
    FADEOUT_TIMER, BLACKOUT_TIMER, BLEED_TIMER, ADV_BLEED_TIMER = 0, 0, 0, 0
    DAMAGED_LIMBS_COUNT, DAMAGED_LIMBS_MOST_SEVERE = 0, 0

    -- Medicines
    MEDS_PAINKILLERS = 0
    MEDS_PAINKILLERS_PREV = false
    MEDS_DRUGS = 0
    MEDS_DRUGS_PREV = false
    
    SetPlayerControl(PlayerId(), true, false)
end

RegisterNetEvent('Medical:Client:ForceDeath')
AddEventHandler('Medical:Client:ForceDeath', function()
    KillPlayer(true)
end)

RegisterNetEvent('Medical:Client:Revive')
AddEventHandler('Medical:Client:Revive', function()
    RevivePlayer()
end)

AddEventHandler('Vehicles:Client:ExitVeh', function()
    VEHICLE_INSIDE = false
    RefreshDeathAnim()
end)

AddEventHandler('Vehicles:Client:EnterVeh', function(VEH, SEAT)
    VEHICLE_INSIDE = VEH
    VEHICLE_SEAT = SEAT
    RefreshDeathAnim()
end)

AddEventHandler('Vehicles:Client:SwitchVehSeat', function(VEH, SEAT)
    VEHICLE_SEAT = SEAT
end)

function StartDeathAnimation()
    print('Dead - Start Threads')

    Citizen.CreateThread(function()
        while PLAYER_DEAD do
            DisableAllControlActions(0)
            for _, key in ipairs(enabledDeathControls) do 
                EnableControlAction(0, key, true)
            end
            DisableFirstPersonCamThisFrame()
            DisableVehicleFirstPersonCamThisFrame()
            Citizen.Wait(1)
        end
    end)

    Citizen.CreateThread(function()
        -- Citizen.Wait(500)
        while not VEHICLE_INSIDE and GetEntitySpeed(ARP.GblPed) > 0.5 do -- For when flying down a mountain or out of a car or something 😎🤣
            Citizen.Wait(250)
        end

        SetPlayerInvincible(ARP.GblPed, true)
        SetEntityHealth(ARP.GblPed, 200)

        local lastCoord = GetEntityCoords(ARP.GblPed)
        local wasInVehicle = VEHICLE_INSIDE
        local wasInVehicleSeat = VEHICLE_SEAT
        NetworkResurrectLocalPlayer(lastCoord.x, lastCoord.y, lastCoord.z, false, true, true, false)
        SetPlayerControl(PlayerId(), true, false)
        ClearPedTasksImmediately(ARP.GblPed)

        if wasInVehicle and wasInVehicleSeat then 
            SetPedIntoVehicle(ARP.GblPed, wasInVehicle, wasInVehicleSeat)
        end

        local tick = 10

        while CHAR_LOADED and PLAYER_DEAD do

            if tick == 10 then 
                tick = 0

                print('Refresh Death Animation Fully')

                lastCoord = GetEntityCoords(ARP.GblPed)
    
                local wasInVehicle = VEHICLE_INSIDE
                local wasInVehicleSeat = VEHICLE_SEAT
    
                if wasInVehicle and wasInVehicleSeat then 
                    SetPedIntoVehicle(ARP.GblPed, wasInVehicle, wasInVehicleSeat)
                else
                    SetEntityCoords(ARP.GblPed, lastCoord)
                end

            else
                tick = tick + 1 
            end

            RefreshDeathAnim()
            Citizen.Wait(1000)
        end
    end)
end

function RefreshDeathAnim()
    if PLAYER_DEAD then 
        if VEHICLE_INSIDE then 
            Components.Animate.Emotes:Play('deadveh', false, -1, true)
        else
            Components.Animate.Emotes:Play('dead', false, -1, true)
        end
    end
end

function StopDeathAnim()
    local wasInVehicle = VEHICLE_INSIDE
    local wasInVehicleSeat = VEHICLE_SEAT
    SetPlayerInvincible(ARP.GblPed, false)
    Components.Animate.Emotes:ForceCancel()
    Citizen.Wait(10)
    if wasInVehicle and wasInVehicleSeat then 
        SetPedIntoVehicle(ARP.GblPed, wasInVehicle, wasInVehicleSeat)
    else
        SetPedToRagdoll(ARP.GblPed, 1, 1, 0, 0, 0, 0)
    end
end