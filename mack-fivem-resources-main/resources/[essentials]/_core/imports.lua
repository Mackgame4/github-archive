ESX = exports['_core']:getSharedObject()
FirstStart = exports['_core']:ServerFirstStart()
Debug = exports['_core']:getDebug()

if not IsDuplicityVersion() then
    -- Only register this event for the client
    AddEventHandler('esx:setPlayerData', function(key, val, last)
        if GetInvokingResource() == '_core' then
            ESX.PlayerData[key] = val
            if OnPlayerData ~= nil then
                OnPlayerData(key, val, last)
            end
        end
    end)
end

-- Locales
Config = {}
Config.Locale = ESX.GetConfig().Locale

Locales = {}

function _(str, ...)
    -- Translate string

    if Locales[Config.Locale] ~= nil then

        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
        end

    else
        return 'Locale [' .. Config.Locale .. '] does not exist'
    end

end

function _U(str, ...)
    -- Translate string first char uppercase
    return tostring(_(str, ...):gsub("^%l", string.upper))
end

AddEventHandler('esx:languageChanged', function(locale)
    Config.Locale = locale
end)

Helpers = {
    LoadToDbIfNotExists = function(fileName, collectionName)
        local success, res = table.unpack(exports.mongodb:collectionExists(collectionName))
        if not res then
            Helpers.LoadToDb(fileName, collectionName)
        end
    end,
    LoadToDb = function(fileName, collectionName)
        local fileData = LoadResourceFile(GetCurrentResourceName(), fileName)
        local docs = json.decode(fileData)
        local success, res = exports.mongodb:insert({
            collection = collectionName,
            documents = docs
        })
        if success then
            print("Loaded " .. fileName .. " to " .. collectionName .. ". Added " .. tostring(#docs) .. " entries successfully")
        else
            print("Failed to load " .. fileName .. " to " .. collectionName .. ".")
        end
    end
}