ESX.NPCs = {}

--[[
    Register an NPC to spawn when close
    returns final npc config
    Triggers Events as follows
    TriggerEvent('_core:Server:NPC:npc_name:event_name', entity)
    TriggerClientEvent('_core:Client:NPC:npc_name:event_name', source, entity)
    - Events
        - Registered
        - Deregistered
        - Created
        - Removed
        - Spawned
        - Despawned
    use the following interface to register
    {
        name = "npc_name",
        render = {
            location = vector3(0, 0, 0),
            heading = 255,
            distance = 50 -- this defaults to 50 if not specified
            model = "A_F_Y_Hipster_03",
            freeze = true -- default to true,
            blockevents = true -- defaults to true
        },
        interact = {
            --Interaction Config, if none specified won't load into Interact
        },
        radial = {
            --Radial Config, if none specified won't load into Targeting
        },
        friendly = true, --Will be friendly to Players by Default
        relationships = {
            GroupName = 1
            --Relationship types:
                --0 = Companion
                --1 = Respect
                --2 = Like
                --3 = Neutral
                --4 = Dislike
                --5 = Hate
                --255 = Pedestrians
        }
    }
]]--
function RegisterNPC(npc)
    if ESX.NPCs[npc.name] then
        Logger.warning(("NPC %s exists already. Recreating it..."):format(npc.name))
        DeregisterNPC(npc.name)
    end

    if not npc.name then
        Logger.error("No NPC name for NPC Registration")
        return
    end

    if not npc.render or not npc.render.model then
        Logger.error(("No NPC Model for NPC Registration for %s"):format(npc.name))
        return
    end

    if not npc.render or not npc.render.location then
        Logger.error(("No NPC Location for %s for NPC Registration"):format(npc.name))
        return
    end

    if not npc.render or not npc.render.heading then
        Logger.warning(("No NPC Heading for %s for NPC Registration"):format(npc.name))
    end

    if not npc.render or not npc.render.distance then
        Logger.warning(("No NPC Distance for NPC Registration, Defaulting to %s for %s"):format(Config.NPCs.DefaultDistance, npc.name))
        npc.render.distance = Config.NPCs.DefaultDistance
    end
    if npc.friendly == nil then
        Logger.warning(("No Friendly Sets for NPC Registration, Defaulting to true for %s"):format(npc.name))
        npc.friendly = true
    end
    if npc.render.blockevents == nil then
        Logger.warning(("No BlockEvents Sets for NPC Registration, Defaulting to true for %s"):format(npc.name))
        npc.render.blockevents = true
    end


    --Make Location a Vector3
    npc.render.location = vector3(npc.render.location.x, npc.render.location.y, npc.render.location.z)

    ESX.NPCs[npc.name] = npc
    Logger.info(("Registered NPC %s"):format(npc.name))
    TriggerClientEvent('_core:Client:RegisterNPC', -1, npc)
    TriggerNPCEvent(npc, "Registered")
    return npc
end

exports("RegisterNPC", RegisterNPC)

function DeregisterNPC(name)
    local npc = ESX.NPCs[name]
    ESX.NPCs[name] = nil
    Logger.info(("Deregistered NPC %s"):format(name))
    TriggerClientEvent('_core:Client:DeregisterNPC', -1, name)
    TriggerNPCEvent(npc, "Deregistered")
end

exports("DeregisterNPC", DeregisterNPC)

function TriggerNPCEvent(npc, event)
    TriggerEvent(('_core:Server:NPC:%s:%s'):format(npc.name, event), npc)
end

RegisterServerEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    local source = source
    for k, npc in pairs(ESX.NPCs) do
        TriggerClientEvent('_core:Client:RegisterNPC', source, npc)
    end
end)