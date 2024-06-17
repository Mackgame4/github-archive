local _targetingModels = {}
local _targetingEntities = {}
local holdingTargeting = false
local entityHitting = false
local targetingIcon = false
local uiTargetingState = false
local lastSent = false
local interactionZones = {}
local interactionComboZone = nil

function StartTargetingThread()
    Citizen.CreateThread(function()
        while holdingTargeting do
            local camPos = GetGameplayCamCoord()
            local targetCoords = s2w(camPos, 0, 0)
            local direction = targetCoords - camPos
            local fromCoords = camPos + (direction * 0.05)
            local toCoords = camPos + (direction * 300)
            local rayCast = StartShapeTestRay(fromCoords, toCoords, 27, ARP.GblPed, -1)
            local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayCast)
            local entityType = GetEntityType(entityHit)
            local reallyHitting = false
            local zoneData = nil

            if hit and entityType >= 1 then
                reallyHitting = true
            elseif hit and entityType == 0 then
                -- check pzones
                local isInside, insideZones = interactionComboZone:isPointInsideExhaustive(endCoords)
                if isInside and #insideZones > 0 then
                    reallyHitting = true
                    zoneData = insideZones[1]
                end
            end
            if hit then 
                local isInside, insideZones = interactionComboZone2:isPointInsideExhaustive(endCoords)
                if isInside and #insideZones > 0 then
                    reallyHitting = true
                    zoneData = insideZones[1]
                end
            end

            local entityCoords = GetEntityCoords(entityHit)
            if zoneData then 
                entityType = 0
                entityCoords = endCoords
                entityHit = zoneData.name
            end
            local entityDistance = #(entityCoords - GetEntityCoords(ARP.GblPed))
            if (reallyHitting and not entityHitting) or (reallyHitting and entityHitting and (entityHit ~= entityHitting.entity or math.abs(entityHitting.distance - entityDistance) > 1.0)) then 
                local targetable = false

                if entityType > 0 then
                    local entityModel = GetEntityModel(entityHit)

                    if entityType == 1 and entityDistance <= 3.5 then
                        targetable = 1
                        targetingIcon = 'mdi-human-male'
                    elseif entityType == 2 then 
                        local hasKeys = exports['arp-vehicles']:HasKeysToTargetVehicle(entityHit)
                        local isUnlocked = exports['arp-vehicles']:IsTargetVehicleUnlocked(entityHit)
                        if (hasKeys and entityDistance <= 25.0) or (entityDistance <= 10.0 and isUnlocked) then 
                            targetingIcon = GetIconForVehicle(entityHit)
                            targetable = 1
                        end
                    elseif _targetingModels[entityModel] or _targetingEntities[entityHit] then 
                        local entityData = _targetingModels[entityModel] and _targetingModels[entityModel] or _targetingEntities[entityHit]
                        if entityData and entityDistance <= entityData.proximity then
                            targetingIcon = entityData.icon
                            targetable = 1
                        end
                    end
                else
                    if zoneData and zoneData.name and interactionZones[zoneData.name] and interactionZones[zoneData.name].enabled and entityDistance <= interactionZones[zoneData.name].proximity then 
                        targetingIcon = interactionZones[zoneData.name].icon
                        targetable = 2
                    end
                end

                if targetable == 1 then 
                    entityHitting = {
                        model = GetEntityModel(entityHit),
                        type = entityType,
                        entity = entityHit,
                        endCoords = endCoords,
                        surfaceNormal = surfaceNormal,
                        icon = targetingIcon,
                        distance = entityDistance,
                        data = {}
                    }
                elseif targetable == 2 then
                    entityHitting = {
                        model = 0,
                        type = 0,
                        entity = zoneData.name,
                        endCoords = endCoords,
                        icon = targetingIcon,
                        distance = entityDistance,
                        data = zoneData.data,
                    }
                    Citizen.Wait(250)
                else
                    targetingIcon = false
                    if entityHitting then 
                        entityHitting = false
                    end
                end

            elseif entityHitting and not reallyHitting then
                entityHitting = false
                targetingIcon = false
            end
            updateTargetingUI()
            Citizen.Wait(200)
        end
    end)
end

function StopTargeting()
    holdingTargeting = false
    Components.UI:Send('targetingHide')
    targetingIcon = false
    entityHitting = false
end

function updateTargetingUI()
    if uiTargetingState ~= targetingIcon then
        uiTargetingState = targetingIcon
        if uiTargetingState then 
            Components.UI:Send('targetingHit', uiTargetingState)
        else
            Components.UI:Send('targetingUnHit')
        end
    end
end

INTERACTION.Targeting = {
    AddEntityModel = function(self, model, icon, proximity)
        _targetingModels[model] = {
            model = model,
            icon = icon,
            proximity = type(proximity) == 'number' and proximity or 10
        }
    end,
    AddEntity = function(self, entity, icon, proximity)
        _targetingEntities[entity] = {
            entity = entity,
            icon = icon,
            proximity = type(proximity) == 'number' and proximity or 10
        }
    end,
    -- Only has boxzones for now because that is all I can think of needing for interaction
    AddBoxZone = function(self, id, icon, center, length, width, options, proximity, data, special, enabled)
        if enabled == nil then enabled = true end -- true if not specified
        if special == nil then special = false end
        if data == nil then data = {} end
        if type(proximity) ~= 'number' then proximity = 10 end
        interactionZones[id] = {
            enabled = enabled,
            name = id,
            type = 'box',
            center = center,
            length = length,
            width = width,
            proximity = proximity,
            options = options,
            data = data,
            icon = icon,
            special = special,
        }
    end,
    AddCircleZone = function(self, id, icon, center, rad, options, proximity, data, special, enabled)
        if enabled == nil then enabled = true end -- true if not specified
        if special == nil then special = false end
        if data == nil then data = {} end
        if type(proximity) ~= 'number' then proximity = 10 end
        interactionZones[id] = {
            enabled = enabled,
            name = id,
            type = 'circle',
            center = center,
            radius = rad,
            proximity = proximity,
            options = options,
            data = data,
            icon = icon,
            special = special,
        }
    end,
    AddPolyZone = function(self, id, icon, points, options, proximity, data, special, enabled)
        if enabled == nil then enabled = true end -- true if not specified
        if special == nil then special = false end
        if data == nil then data = {} end
        if type(proximity) ~= 'number' then proximity = 10 end
        interactionZones[id] = {
            enabled = enabled,
            name = id,
            type = 'poly',
            points = points,
            proximity = proximity,
            options = options,
            data = data,
            icon = icon,
            special = special,
        }
    end,
    IsCoordsInAZone = function(self, coords)
        if interactionComboZone2 then -- "more important"
            local isInside, insideZones = interactionComboZone2:isPointInsideExhaustive(coords)
            if isInside and #insideZones > 0 then
                return insideZones[1]
            end
        end

        if interactionComboZone then 
            local isInside, insideZones = interactionComboZone:isPointInsideExhaustive(coords)
            if isInside and #insideZones > 0 then
                return insideZones[1]
            end
        end
        return false
    end,
    ToggleZone = function(self, id, newState)
        if interactionZones[id] then 
            interactionZones[id].enabled = newState
        end
    end
}

function InitializeInteractionZones()
    if interactionComboZone then return end
    local createdZones = {}
    local specialZones = {}

    for id, data in pairs(interactionZones) do
        local options = data.options
        options.name = data.name
        options.data = data.data

        options.debugPoly = false

        if data.type == 'box' and data.center and data.width and data.length then 
            if data.special then 
                table.insert(specialZones, BoxZone:Create(data.center, data.length, data.width, options))
            else
                table.insert(createdZones, BoxZone:Create(data.center, data.length, data.width, options))
            end
        elseif data.type == 'circle' and data.center and data.radius then 
            if data.special then 
                table.insert(specialZones, CircleZone:Create(data.center, data.radius, options))
            else
                table.insert(createdZones, CircleZone:Create(data.center, data.radius, options))
            end
        elseif data.type == 'poly' and data.points then 
            if data.special then 
                table.insert(specialZones, PolyZone:Create(data.points, options))
            else
                table.insert(createdZones, PolyZone:Create(data.points, options))
            end
        end
    end

    interactionComboZone = ComboZone:Create(createdZones, {
        name = "interaction_zones",
    })

    interactionComboZone2 = ComboZone:Create(specialZones, {
        name = "interaction_zones_2",
    })
end

-- INTERACTION.Targeting:AddEntityModel(-58485588, 'mdi-delete', 15)

AddEventHandler('Interaction:KeyBindings:KeyUp', function(key, holdingModifier)
    if key == 'interactionTargeting' then
        StopTargeting()
    end
end)

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, holdingModifier)
    if key == 'interactionTargeting' and not holdingTargeting and CHAR_LOADED and interactionComboZone then 
        holdingTargeting = true
        uiTargetingState = false
        targetingIcon = false
        entityHitting = false
        updateTargetingUI()
        StartTargetingThread()
        Components.UI:Send('targetingShow')
    elseif key == 'interactionPrimary' and entityHitting then 
        if entityHitting.type == 0 then -- Zone
            TriggerEvent('Interaction:Targeting:ZoneAction', entityHitting.entity, entityHitting.data, 1, holdingModifier, entityHitting.endCoords)
        elseif entityHitting.type == 1 then -- Ped
            TriggerEvent('Interaction:Targeting:PedAction', entityHitting, 1, holdingModifier)
        elseif entityHitting.type == 2 then -- Vehicle
            if entityHitting.distance <= 10.0 then 
                TriggerEvent('Interaction:Targeting:VehicleAction', entityHitting.entity, entityHitting.icon)
            end
        elseif entityHitting.type == 3 then --Object
            TriggerEvent('Interaction:Targeting:ObjectAction', entityHitting, 1)
        end
    elseif key == 'vehicleLocking' then 
        if entityHitting then 
            if entityHitting.type == 2 then -- Vehicle
                TriggerEvent('Vehicles:Client:TryKeys', entityHitting.entity)
            end
        elseif not holdingTargeting then
            TriggerEvent('Vehicles:Client:TryKeysOnClose')
        end
    end
end)

AddEventHandler('Interaction:Targeting:ZoneAction', function(zone, data, key, mod)
    print('zone', zone, data, key, mod)
end)

AddEventHandler('Interaction:Targeting:PedAction', function(entity, key, mod)
    print('ped', entity, key, mod)
end)

AddEventHandler('Interaction:Targeting:ObjectAction', function(entity, key, mod)
    print('object', entity, key, mod)
end)