Citizen.CreateThread(function()
    if GetResourceState(Config.DBMode) ~= "running" and GetResourceState(Config.DBMode) ~= "started" then
        ML.Shared.Log(Config.DBMode.." is not running, please start it before using this framework.", "error")
        StartResource(Config.DBMode)
        return
    end

    if Config.DBMode == "mongodb" then
        --[[AddEventHandler("onDatabaseConnect", function (databaseName)
            ML.Shared.Log("MongoDB Connected: "..tostring(databaseName), "success")
        end)]]--

        ML.DB.IsConnected = function()
            return exports.mongodb.isConnected()
        end
        
        ML.DB.Execute = function(action, params, callback)
            if action == "find" then
                exports.mongodb:find(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in find: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Found "..tostring(#result).." documents")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "findOne" then
                exports.mongodb:findOne(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in findOne: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Found "..tostring(#result).." documents")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "count" then
                exports.mongodb:count(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in count: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Found "..tostring(#result).." documents")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "insert" then
                exports.mongodb:insert(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in insert: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Inserted "..tostring(#result).." documents")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "insertOne" then
                exports.mongodb:insertOne(params, function (success, result, insertedIds)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in insertOne: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Inserted document with ID: "..tostring(insertedIds[1]))
                    if callback then
                        callback(success, result, insertedIds)
                    end
                end)
            elseif action == "update" then
                exports.mongodb:update(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in update: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Updated "..tostring(#result).." documents")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "updateOne" then
                exports.mongodb:updateOne(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in updateOne: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Updated document")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "delete" then
                exports.mongodb:delete(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in delete: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Deleted document")
                    if callback then
                        callback(success, result)
                    end
                end)
            elseif action == "deleteOne" then
                exports.mongodb:deleteOne(params, function (success, result)
                    if not success then
                        ML.Shared.Log("[MongoDB] Error in deleteOne: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MongoDB] Deleted document")
                    if callback then
                        callback(success, result)
                    end
                end)
            end
        end
    elseif Config.DBMode == "mysql" then
        ML.Shared.Log("MySQL is not supported yet. (WIP)", "error")
        --MySQL:open(Config.DB.host, Config.DB.name, Config.DB.user, Config.DB.pass)

        ML.DB.IsConnected = function()
            return MySQL:isConnected()
        end

        ML.DB.Execute = function(action, params, callback)
            if action == "find" then
                MySQL.Async.fetchAll(params, function (result)
                    if not result then
                        ML.Shared.Log("[MySQL] Error in find: "..tostring(result), "error")
                        return
                    end
                    ML.Shared.Log("[MySQL] Found "..tostring(#result).." rows")
                    if callback then
                        callback(true, result)
                    end
                end)
            elseif action == "findOne" then
            elseif action == "count" then
            elseif action == "insert" then
            elseif action == "insertOne" then
            elseif action == "update" then
            elseif action == "updateOne" then
            elseif action == "delete" then
            elseif action == "deleteOne" then
            end
        end
    end
end)

-- Example
RegisterCommand("test", function(source, args, raw)
    ML.DB.Execute("find", {
        collection = "users",
        query = {
            group = "admin"
        }
    }, function(success, result)
        if not success then
            ML.Shared.Log("[MongoDB] Error in find: "..tostring(result), "error")
            return
        end
        ML.Shared.Log("[MongoDB] Found "..tostring(#result).." documents")
    end)
end)