ESX = {}
ESX.Players = {}
ESX.UsableItemsCallbacks = {}
ESX.Items = {}
ESX.ServerCallbacks = {}
ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}
ESX.Pickups = {}
ESX.PickupId = 0
ESX.RegisteredCommands = {}

AddEventHandler('esx:getSharedObject', function(cb)
    cb(ESX)
end)

function getSharedObject()
    return ESX
end

local function StartDBSync()
    Logger.info("Starting DB Sync")
    Citizen.CreateThread(function()
        Citizen.Wait(1 * 60 * 1000)
        Logger.info("Saving Players")
        ESX.SavePlayers()
    end)
end

local FirstStart = true

AddEventHandler("onDatabaseConnect", function(databaseName)
    print("[^2INFO^7] onDatabaseConnect: " .. tostring(databaseName))
    StartDBSync()
    StartPayCheck()
    exports.mongodb:findOne({ collection = "users", query = {} }, function(success, result)
        if not success then
            print("[MongoDB][^1ERROR^7] Error in findOne: " .. tostring(result))
            return
        end

        if #result > 0 then
            if Config.EnableDebug then
                print("[MongoDB][^3Warning^7] DB is already created")
            end
            FirstStart = false
        else
            print("[MongoDB][^1Warning^7] DB does not exist. Creating...")
            FirstStart = true
        end
    end)

    local success, result = table.unpack(exports.mongodb:find({ collection = "items", query = {} }))
    for k, v in ipairs(result) do
        ESX.Items[v.name] = {
            label = v.label,
            name = v.name,
            weight = v.weight,
            rare = v.rare,
            canRemove = v.can_remove
        }
    end
end)

function getDebug()
    return Config.EnableDebug
end

-- Adding other resources data to DB
function ServerFirstStart()
    return tostring(FirstStart)
end

-- On restart
if Config.EnableDebug then
    RegisterCommand("status", function(source, args, rawCommand)
        print(exports['_core']:ServerFirstStart())
    end, false)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)

            if exports.mongodb.isConnected then

                print("[_core] [^2INFO^7] Debug Mode is Enable")

                exports.mongodb:find({ collection = "items", query = {} }, function(success, result)
                    if not success then
                        return
                    end

                    for k, v in ipairs(result) do
                        ESX.Items[v.name] = {
                            label = v.label,
                            name = v.name,
                            weight = v.weight,
                            rare = v.rare,
                            canRemove = v.can_remove
                        }
                    end
                end)

                --[[                local Jobs = {}
                                exports.mongodb:find({ collection = "jobs", query = {} }, function(success, jobs)
                                    if not success then
                                        return
                                    end

                                    for k, v in ipairs(jobs) do
                                        Jobs[v.name] = v
                                        Jobs[v.name].grades = {}
                                    end

                                    exports.mongodb:find({ collection = "job_grades", query = {} }, function(success, jobGrades)
                                        if not success then
                                            return
                                        end

                                        for k, v in ipairs(jobGrades) do
                                            if Jobs[v.job_name] then
                                                Jobs[v.job_name].grades[tostring(v.grade)] = v
                                            else
                                                print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
                                            end
                                        end

                                        for k2, v2 in pairs(Jobs) do
                                            if ESX.Table.SizeOf(v2.grades) == 0 then
                                                Jobs[v2.name] = nil
                                                print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v2.name))
                                            end
                                        end
                                        ESX.Jobs = Jobs
                                        StartDBSync()
                                        StartPayCheck()
                                    end)
                                end)]]
            end
            break
        end
    end)
end

RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
    if Config.EnableDebug then
        print(('[^2TRACE^7] %s^7'):format(msg))
    end
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
    local playerId = source

    ESX.TriggerServerCallback(name, requestId, playerId, function(...)
        TriggerClientEvent('esx:serverCallback', playerId, requestId, ...)
    end, ...)
end)
