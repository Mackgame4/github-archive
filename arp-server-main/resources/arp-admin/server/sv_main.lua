function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        RegisterCommands()
    end

    if not c or c == 'Callbacks' then 
        RegisterCallbacks()
    end
end

function RegisterCallbacks()
    Components.Callbacks:Register('Admin:ValidateStaff', function(src, cb)
        local User = Components.Users:Source(src)
        if User and User.Permissions.IsStaff then 
            cb(true)
        else
            cb(false)
        end
    end)

    Components.Callbacks:Register('Admin:Server:GetPlayerMenuData', function(src, cb)
        local returnData = {
            recentDisconnects = Components.Users:GetRecentDisconnects()
        }
        local User = Components.Users:Source(src)
        if User then
            if User.Permissions.IsStaff then 
                returnData.isStaff = true
                local playerData = {}
                local allPlayers = Components.Users:All()
                playerData.total = 0
                playerData.totalStaff = 0
                playerData.players = {}
                local unixTime = ARP.GetUnix()
                for pSrc, pUser in pairs(allPlayers) do
                    playerData.total = playerData.total + 1
                    local thisUserData = pUser:GetData()
                    local savedUserData = thisUserData.UserData:GetData()
                    local thisUserStaff = pUser.Permissions.IsStaff

                    if thisUserStaff then 
                        playerData.totalStaff = playerData.totalStaff + 1
                    end

                    local lastLogin = savedUserData.LastLogin or unixTime
                    local playTime = savedUserData.Playtime or 0

                    local sessionTime = unixTime - lastLogin
                    local totalTime = sessionTime + playTime

                    local thisUser = {
                        source = pSrc,
                        name = thisUserData.Name,
                        avatar = thisUserData.Avatar,
                        url = thisUserData.URL,
                        SID = thisUserData.SID,
                        steam = thisUserData.Steam,
                        staff = thisUserStaff,
                        staffLevel = pUser.Permissions:GetLevel(),
                        sessionTime = sessionTime,
                        totalTime = totalTime,
                        character = false,
                        vehicle = false,
                    }

                    local userCharacter = Components.Characters:Source(pSrc)

                    if userCharacter and userCharacter:GetData('_Loaded') then 
                        local playerPed = GetPlayerPed(pSrc)
                        thisUser.character = {
                            name = userCharacter:GetData('_FullName'),
                            CID = userCharacter:GetData('CID'),
                            dead = userCharacter:GetData('Dead'),
                            health = GetEntityHealth(playerPed) - 100,
                        }

                        local inVehicle = GetVehiclePedIsIn(playerPed, false)
                        local insideReally = true

                        if inVehicle <= 0 then 
                            inVehicle = GetVehiclePedIsIn(playerPed, true)
                            insideReally = false
                        end

                        if inVehicle > 0 and DoesEntityExist(inVehicle) then 
                            local veh = Entity(inVehicle)
                            if veh and veh.state and veh.state.VIN then 
                                thisUser.vehicle = {
                                    plate = GetVehicleNumberPlateText(inVehicle),
                                    VIN = veh.state.VIN,
                                    id = inVehicle,
                                    inside = insideReally,
                                }
                            end
                        end
                    end

                    table.insert(playerData.players, thisUser)
                end

                returnData.staffPlayerData = playerData
            end
        end

        cb(returnData)
    end)
end

function RegisterCommands()
    Components.Commands:AddStaff('noclip', function(src, args, raw)
        TriggerClientEvent('Admin:Client:NoClip', src, args[1] ~= nil and true or false)
        Components.Logging:Info('Admin', ('%s Toggled NoClip'):format(Users:GenerateLogStringSrc(src)))
    end, 'Toggle noclipping')
    Components.Commands:AddDeveloper('noclip:info', function(src, args, raw)
        TriggerClientEvent('Admin:Client:NoClipInfo', src)
    end, 'Get info regarding current noclip state')

    Components.Commands:AddStaff('coords', function(src, args, raw)
        TriggerClientEvent('Admin:Client:Coords', src)
    end, 'Get current coordinates in different formats')

    Components.Commands:Add('arp', function(src, args, raw)
        TriggerClientEvent('Hud:Client:OpenSettings', src)
    end, 'Open the AuthenticRP Menu')

    Components.Commands:AddStaff('kick', function(src, args, raw)
        local executor = Components.Users:Source(src)
        local target = tonumber(args[1])
        local reason = args[2]
        if reason == nil then reason = 'No Reason Provided' end
        local targetUser = Components.Users:Source(target)
        if target and target > 0 and reason and target ~= src and GetPlayerEndpoint(target) and targetUser and targetUser.Permissions:GetLevel() < 99 then 
            DropPlayer(target, string.format('You were Kicked from AuthenticRP.com\n\nStaff Member: %s\nReason: %s', executor and executor:GetData('Name') or 'Console', reason))
            if executor then 
                Components.Logging:Info('Admin', ('%s Kicked %s From the Server'):format('Console', Components.Users:GenerateLogStringSrc(src)))
            else
                Components.Logging:Info('Admin', ('%s Kicked %s From the Server'):format(Components.Users:GenerateLogStringSrc(target), Components.Users:GenerateLogStringSrc(src)))
            end
            return
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Kick Player', 'Invalid Target', 'mdi-cog') 
    end, 'Kick Player from Server', {
        { name = 'ID', help = 'Server ID', required = true },
    })

    Components.Commands:AddStaff('delent', function(src, args, raw)
        local target = Components.Callbacks:Execute(src, 'Admin:Client:GetEntityLookingAt', false)
        if target and target.entity and (target.type == 1 or target.type == 3) then 
            local entity = NetworkGetEntityFromNetworkId(target.entity)
            local entityModel = GetEntityModel(entity)
            if entity and DoesEntityExist(entity) and not IsPedAPlayer(entity) then 
                DeleteEntity(entity)
                Components.Logging:Info('Admin', ('Entity: %s (Model: %s, Type: %s) Deleted By %s'):format(entity, entityModel, target.type, Users:GenerateLogStringSrc(src)))
                TriggerClientEvent('Client:Notify', src, 'success', 'Deleted Entity', false, 'mdi-cog')
                return
            end
        end
        TriggerClientEvent('Client:Notify', src, 'error', 'Failed to Delete Entity', false, 'mdi-cog')
    end, 'Delete the networked object or pedestrian you are looking at')

    RegisterTPCommands()
end
