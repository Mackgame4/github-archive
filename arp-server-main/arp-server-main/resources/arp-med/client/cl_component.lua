MEDICAL = {
    GetDamage = function(self)
        return PLAYER_DAMAGE
    end,
    IsLimping = function(self)
        return IsInjuryCausingLimp()
    end,
    Alerts = {
        Bleed = function(self)
            local player = PlayerPedId()
            if not PLAYER_DEAD and PLAYER_DAMAGE.Bleed > 0 then
                -- Notification.Persistent:Custom(bleedNotifId, string.format(Config.Strings.BleedAlert, Config.BleedingStates[PLAYER_DAMAGE.Bleed]), Config.NotifStyle)
            else
                -- Notification.Persistent:Remove(bleedNotifId)
            end
        end,
        Limbs = function(self)
            local player = PlayerPedId()
            if not IsEntityDead(player) then
                if #_damagedLimbs > 0 then
                    local limbDamageMsg = ''
                    if #_damagedLimbs <= Config.AlertShowInfo then
                        for k, v in pairs(_damagedLimbs) do
                            limbDamageMsg = string.format(Config.Strings.LimbAlert, v.label, Config.WoundStates[v.severity])
                            if k < #_damagedLimbs then
                                limbDamageMsg = limbDamageMsg .. Config.Strings.LimbAlertSeperator
                            end
                        end
                    else
                        limbDamageMsg = Config.Strings.LimbAlertMultiple
                    end

                    -- Notification.Persistent:Custom(limbNotifId, limbDamageMsg, Config.NotifStyle)
                else
                    -- Notification.Persistent:Remove(limbNotifId)
                end
            else
                -- Notification.Persistent:Remove(limbNotifId)
            end
        end,
        --[[ Debug = function(self, ped, bone, weapon, damageDone)
            -- Notification:Standard('Bone: ' .. Config.Bones[bone])
            if (Config.MinorInjurWeapons[weapon] ~= nil) then
                Notification:Standard('Minor Weapon : ' .. weapon, 10000)
            else
                Notification:Standard('Major Weapon : ' .. weapon, 10000)
            end]]
            -- Notification:Standard('Crit Area: ' .. tostring(Config.CriticalAreas[Config.Bones[bone]] ~= nil), 10000)
            -- Notification:Standard('Stagger Area: ' .. tostring(Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or GetPedArmour(ped) <= 0)), 10000)
            -- Notification:Standard('Dmg Done: ' .. damageDone, 10000)
        --end,
    },
    CheckDamage = function(self, ped, bone, weapon, damageDone)
        if weapon == nil or PLAYER_DAMAGE == nil then return end
    
        if Config.Bones[bone] ~= nil then
            if Config.Debug then
                -- MEDICAL.Alerts:Debug(ped, bone, weapon, damageDone)
            end
    
            Components.Medical.Apply:Effects(ped, bone, weapon, damageDone)

            local severity = 1
            if damageDone >= 15 then 
                severity = 2
            elseif damageDone >= 30 then 
                severity = 3
            elseif damageDone >= 50 then 
                severity = 4
            end

            local boneName = Config.Bones[bone]
            print(boneName, 'Damaged By Weapon', weapon, 'With Force: ', damageDone)
            if not PLAYER_DAMAGE.Limbs[boneName].isDamaged then 
                PLAYER_DAMAGE.Limbs[boneName].isDamaged = true
                PLAYER_DAMAGE.Limbs[boneName].severity = severity
            else
                local newSeverity = PLAYER_DAMAGE.Limbs[boneName].severity + severity
                if newSeverity > 4 then 
                    newSeverity = 4
                end

                PLAYER_DAMAGE.Limbs[boneName].severity = newSeverity
            end

            DAMAGED_LIMBS_COUNT, DAMAGED_LIMBS_MOST_SEVERE = GetDamagedLimbCount()

            TriggerServerEvent('Medical:Server:SyncDamage', PLAYER_DAMAGE)

            Components.Medical.Alerts:Bleed()
            -- MEDICAL.Alerts:Limbs()
            Components.Medical.Apply:Movement(ped)
        else
            if not PLAYER_DEAD then
                print('Bone Not In Index - Report This! - ' .. bone)
            end
        end
    end,
    Apply = {
        StandardDamage = function(self, value, armorFirst)
            ApplyDamageToPed(ARP.GblPed, value, armorFirst)
        end,
        Bleed = function(self, level)
            PLAYER_DAMAGE.Bleed = PLAYER_DAMAGE.Bleed + level
            if PLAYER_DAMAGE.Bleed > 4 then 
                PLAYER_DAMAGE.Bleed = 4
            end
            TriggerServerEvent('Medical:Server:SyncDamage', PLAYER_DAMAGE)

            Components.Medical.Alerts:Bleed()
        end,
        Effects = function(self, ped, bone, weapon, damageDone)
            local armor = GetPedArmour(ped)
        
            if Config.MinorInjurWeapons[weapon] and damageDone < Config.DamageMinorToMajor then
                if Config.CriticalAreas[Config.Bones[bone]] then
                    if armor <= 0 then
                        Components.Medical.Apply:Bleed(1)
                    end
                end
        
                if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
                    if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].minor) then
                        SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
                    end
                end
            elseif Config.MajorInjurWeapons[weapon] or (Config.MinorInjurWeapons[weapon] and damageDone >= Config.DamageMinorToMajor) then
                if Config.CriticalAreas[Config.Bones[bone]] ~= nil then
                    if armor > 0 and Config.CriticalAreas[Config.Bones[bone]].armored then
                        if math.random(100) <= math.ceil(Config.MajorArmoredBleedChance) then
                            Components.Medical.Apply:Bleed(1)
                        end
                    else
                        Components.Medical.Apply:Bleed(1)
                    end
                else
                    if armor > 0 then
                        if math.random(100) < (Config.MajorArmoredBleedChance) then
                            Components.Medical.Apply:Bleed(1)
                        end
                    else
                        if math.random(100) < (Config.MajorArmoredBleedChance * 2) then
                            Components.Medical.Apply:Bleed(1)
                        end
                    end
                end
        
                if Config.StaggerAreas[Config.Bones[bone]] ~= nil and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0) then
                    if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].major) then
                        SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
                    end
                end
            end
        end,
        Movement = function(self, ped)
            if IsInjuryCausingLimp() and MEDS_PAINKILLERS <= 0 then
                RequestAnimSet('move_m@injured')
                while not HasAnimSetLoaded('move_m@injured') do
                    Citizen.Wait(10)
                end
                SetPedMovementClipset(ped, 'move_m@injured', 1 )
                SetPlayerSprint(PlayerId(), false)
        
                if MEDS_PAINKILLERS_PREV then
                    SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
                    MEDS_PAINKILLERS_PREV = false
                    -- Notification:Custom(Config.Strings.PainKillersExpired, 5000, Config.NotifStyle)
                end
            else
                SetPedMoveRateOverride(ped, 1.0)
                ResetPedMovementClipset(ped, 1.0)
        
                if not MEDS_PAINKILLERS_PREV and MEDS_PAINKILLERS > 0 then 
                    MEDS_PAINKILLERS_PREV = true 
                end
        
                if MEDS_PAINKILLERS > 0 then
                    MEDS_PAINKILLERS = MEDS_PAINKILLERS - 1
                end
            end
        end,
    },
}

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Medical', MEDICAL)
end)

function GetDamagedLimbCount()
    local count = 0
    local highestSeverity = 0
    if PLAYER_DAMAGE and PLAYER_DAMAGE.Limbs then 
        for k, v in pairs(PLAYER_DAMAGE.Limbs) do
            if v.isDamaged then
                count = count + 1

                if v.severity > highestSeverity then 
                    highestSeverity = v.severity
                end
            end
        end
    end
    return count, highestSeverity
end