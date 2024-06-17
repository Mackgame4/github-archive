local _cachedCharacterCarKeys = {}
local _cachedOrgCarKeys = {}

function AddVehicleKeysToChar(src, vin)
    local Character = Components.Characters:Source(src)
    if not Character then return end
    local cid = Character:GetData('CID')

    if not _cachedCharacterCarKeys[cid] then 
        _cachedCharacterCarKeys[cid] = {}
    end

    if not ARP.GetPositionInOrderedTable(_cachedCharacterCarKeys[cid], vin) then 
        table.insert(_cachedCharacterCarKeys[cid], vin)

        TriggerClientEvent('Vehicles:Client:RecieveKey', src, vin)
    end
end

function RemoveVehicleKeysFromChar(src, vin)
    local Character = Components.Characters:Source(src)
    if not Character then return end
    local cid = Character:GetData('CID')

    if _cachedCharacterCarKeys[cid] then 
        local keysExist = ARP.GetPositionInOrderedTable(_cachedCharacterCarKeys[cid], vin)
        if keysExist ~= nil then 
            _cachedCharacterCarKeys[cid][keysExist] = nil
            TriggerClientEvent('Vehicles:Client:RemoveKey', src, vin)
        end
    end
end

function DoesCharacterHaveKeys(src, vin)
    local Character = Components.Characters:Source(src)
    if Character then 
        local cid = Character:GetData('CID')
        if _cachedCharacterCarKeys[cid] then 
            if ARP.GetPositionInOrderedTable(_cachedCharacterCarKeys[cid], vin) ~= nil then 
                return true
            end
            -- Check for org keys
        end
    end
    return false
end

AddEventHandler('Characters:Server:Login', function(src, cid)
    if _cachedCharacterCarKeys[cid] then 
        TriggerClientEvent('Vehicles:Client:InitialKeys', src, _cachedCharacterCarKeys[cid])
    end
end)

function VehicleKeysRegisterCallbacks()
    Components.Callbacks:Register('Vehicles:Server:ToggleLocks', function(src, cb, vehNet)
        local veh = NetworkGetEntityFromNetworkId(vehNet)
        local vehEnt = Entity(veh)
        if vehEnt.state and vehEnt.state.VIN then 
            if DoesCharacterHaveKeys(src, vehEnt.state.VIN) then 
                exports['arp-sounds']:Play(src, 'central-locking', 0.08)
                if vehEnt.state.locked then 
                    vehEnt.state.locked = false
                    SetVehicleDoorsLocked(veh, 1)
                    return cb(false)
                else
                    vehEnt.state.locked = true
                    SetVehicleDoorsLocked(veh, 2)
                    return cb(true)
                end
            end
        end
        cb(true)
    end)
end

local keysFoundMessages = {
    'They were in the glovebox',
    'They were in the backseat',
    'They were under the driver\'s seat',
    'They were just sitting on the passenger seat...',
    'They were left in the ignition...',
    'They were in the center console',
    'They were left on the dashboard'
}

RegisterNetEvent('Vehicles:Server:FoundKeys')
AddEventHandler('Vehicles:Server:FoundKeys', function(netId)
    local src = source
    local veh = NetworkGetEntityFromNetworkId(netId)
    local vehEnt = Entity(veh)
    if DoesEntityExist(veh) and vehEnt and vehEnt.state and vehEnt.state.VIN and not vehEnt.state.owned and not veh.state.keysFound then 
        veh.state.keysFound = true
        AddVehicleKeysToChar(src, vehEnt.state.VIN)
        local randomMessageId = ARP.RandomNumber(1, #keysFoundMessages)
        local randomMessage = keysFoundMessages[randomMessageId]
        TriggerClientEvent('Client:Notify', src, 'success', 'You found the keys', randomMessage, 'mdi-car-key')
    end
end)

RegisterNetEvent('Vehicles:Server:StolenTraffic')
AddEventHandler('Vehicles:Server:StolenTraffic', function(netId)
    local src = source
    local veh = NetworkGetEntityFromNetworkId(netId)
    local vehEnt = Entity(veh)
    if DoesEntityExist(veh) and vehEnt.state.VIN and not vehEnt.state.owned and not vehEnt.state.keysFound and not vehEnt.state.hotwired then 
        vehEnt.state.keysFound = true
        AddVehicleKeysToChar(src, vehEnt.state.VIN)
        TriggerClientEvent('Client:Notify', src, 'success', 'You stole the keys', false, 'mdi-car-key')
    end
end)