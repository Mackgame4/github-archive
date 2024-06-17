ESX.NPCs = {}
Interact = exports['ui-interact']

function TriggerNPCEvent(npc, event)
    TriggerEvent(('_core:Client:NPC:%s:%s'):format(npc.name, event), npc)
end

RegisterNetEvent("_core:Client:RegisterNPC", function(npc)
    if ESX.NPCs[npc.name] then
        Logger.warning(("Overriding %s on Client"):format(npc.name))
        if npc.entity then
            DespawnNPC(npc.name)
        end
        TriggerNPCEvent(npc, "Overridden")
    end

    ESX.NPCs[npc.name] = npc
    Logger.info(("Registered %s on Client"):format(npc.name))
    TriggerNPCEvent(npc, "Registered")
end)

RegisterNetEvent("_core:Client:DeregisterNPC", function(name)
    local npc = ESX.NPCs[name]
    if npc.entity then
        DespawnNPC(npc.name)
    end
    ESX.NPCs[name] = nil
    Logger.info(("Deregistered %s on Client"):format(name))
    TriggerNPCEvent(npc, "Deregistered")
end)

RegisterNetEvent('esx:onPlayerSpawn', function()
    while true do
        Citizen.Wait(Config.NPCs.CheckTime)
        local player = GetEntityCoords(GetPlayerPed(-1))
        for k, npc in pairs(ESX.NPCs) do
            local distance = #(npc.render.location - player)
            if npc.entity and distance > npc.render.distance then
                DespawnNPC(npc.name)
                exports._core:info(("Despawned NPC %s"):format(npc.name))
                TriggerNPCEvent(npc, "Despawned")
            end
            if not npc.spawning and not npc.entity and distance < npc.render.distance then
                SpawnNPC(npc)
                exports._core:info(("Spawned NPC %s"):format(npc.name))
                TriggerNPCEvent(npc, "Spawned")
            end
        end
    end
end)

function SpawnNPC(npc)
    Citizen.CreateThread(function()
        ESX.NPCs[npc.name].spawning = true
        local pedGroup = GetPedRelationshipGroupHash(GetPlayerPed(-1))
        local model = tonumber(npc.render.model) or GetHashKey(npc.render.model)
        --Make sure model is hash
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        local entity = CreatePed(1, model, npc.render.location, npc.render.heading, false, false)
        ESX.NPCs[npc.name].entity = entity
        Citizen.Wait(2000)
        FreezeEntityPosition(entity, npc.render.freeze or true)
        SetBlockingOfNonTemporaryEvents(entity, npc.render.blockevents or false)

        SetEntityInvincible(entity, true)
        local ret, npcGroup = AddRelationshipGroup(("%s:npc"):format(npc.name))
        local rep = npc.friendly and 2 or 4
        SetRelationshipBetweenGroups(rep, pedGroup, npcGroup)
        SetRelationshipBetweenGroups(rep, npcGroup, pedGroup)
        ESX.NPCs[npc.name].group = npcGroup

        if Interact and npc.interact then
            Interact:AddTargetEntity(entity, npc.interact)
        end
        ESX.NPCs[npc.name].spawning = false
    end)
end

function DespawnNPC(name)
    local npc = ESX.NPCs[name]
    if npc then
        RemoveRelationshipGroup(npc.group)
        SetEntityAsNoLongerNeeded(npc.entity)
        DeleteEntity(npc.entity)
        npc.entity = nil
        npc.group = nil
    end
end