SessionCharacters = {}
--CachedOfflineCharacters = {}
CachedLocations = {}

CHARACTERS = {
    Source = function(self, src)
        return SessionCharacters[src]
    end,
    CID = function(self, cid)
        for _, Character in ipairs(SessionCharacters) do 
            if Character:GetData('CID') == cid then 
                return Character
            end
        end
        return false
    end,
    All = function(self)
        return SessionCharacters
    end,
    GenerateLogString = function(self, Character)
        local characterData = Character:GetData()
        return ('%q [%s] (CID: %d, SID: %s)'):format(characterData._FullName, characterData.Source, characterData.CID, characterData.User)
    end,
    Switch = function(self, src, onDrop)
        local ply = Player(src)
        
        local cachedState = {}
        for _, state in ipairs(_importantCharacterPlayerState) do 
            cachedState[state] = ply.state[state]
        end
        
        local Character = Components.Characters:Source(src)
        if Character then 
            local CID = Character:GetData('CID')
            local Name = Character:GetData('_FullName')
            
            SyncCharacter(Character, cachedState)
            SessionCharacters[src] = nil
            collectgarbage()
            
            TriggerEvent('Characters:Server:Logout', src, CID, Name, cachedState)
            
            if not onDrop then 
                local User = Components.Users:Source(src)
                User:SetData('Character', false)
                TriggerClientEvent('Characters:Client:Logout', src, CID)
                TriggerClientEvent('Characters:Client:CharacterSelection', src)
            end
        end
    end,
    IsValid = function(self, cid)
        local fetch = Components.DB:FindOne('characters', { CID = cid })
        if fetch.success and #fetch.docs > 0 then 
            return true
        end
        return false
    end
}

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(8000)
        if #SessionCharacters > 0 then 
            for s, c in ipairs(SessionCharacters) do 
                local cid = c:GetData('CID')
                local ped = GetPlayerPed(s)
                local pedCoords = GetEntityCoords(ped)
                CachedLocations[cid] = pedCoords
            end
        end
    end
end)

AddEventHandler('Characters:Server:Login', function(src)
    local Character = Components.Characters:Source(src)
    local ply = Player(src)
    ply.state.health = 900
    if Character then 
        Components.Logging:Info('Characters', 'Logged In Character ' .. Components.Characters:GenerateLogString(Character))
    end
end)

AddEventHandler('Characters:Server:Logout', function(src, cid, name)
    local sid = Components.Users:Source(src):GetData('SID')
    Components.Logging:Info('Characters', ('Logged Out Character %q [%s] (CID: %d, SID: %s)'):format(name, src, cid, sid))
end)

AddEventHandler('playerDropped', function()
    local src = source
    Components.Characters:Switch(src, true)
end)

function RegisterCallbacks()
    Components.Callbacks:Register('Characters:Server:GetSelectionData', function(src, cb)
        SetPlayerRoutingBucket(src, 63)
        local User = Components.Users:Source(src)
        if User then 
            local allCharacters = {}
            local characterFetch = Components.DB:Find('characters', { User = User:GetData('SID') })
            if characterFetch.success and #characterFetch.docs > 0 then allCharacters = characterFetch.docs end
            cb({ success = true, characters = allCharacters })
        end
        cb({ success = false })
    end)

    Components.Callbacks:Register('Characters:Server:CreateNew', function(src, cb, new)
        local User = Components.Users:Source(src)
        if User and new.lastname and new.firstname and new.dob then 
            local sid = User:GetData('SID')
            local characterFetch = Components.DB:Count('characters', { User = sid })
            if characterFetch.success and characterFetch.count < 5 then -- you can have 5 characters maximum
                local newCharacter = {
                    User = sid,
                    LastName = new.lastname,
                    FirstName = new.firstname,
                    DOB = new.dob,
                    Gender = new.gender,
                    CID = false,
                    Created = os.time(),
                    Ped = false,
                    Outfits = {},
                    CurrentOutfit = 1,
                    Health = 100,
                    Armour = 0,
                    Dead = false,
                }

                local existingNamesFetch = Components.DB:FindOne('characters', { -- Cannot Have Same Firstname AND Lastname AND MiddleName
                    ['$and'] = { 
                        { FirstName = newCharacter.FirstName },
                        { LastName = newCharacter.LastName },
                    } 
                })

                if existingNamesFetch.success and #existingNamesFetch.docs > 0 then return cb(false) end

                local newCID = ARP.RandomNumber(10000, 99999)
                while IsCIDTaken(newCID) do 
                    newCID = ARP.RandomNumber(10000, 99999)
                    Citizen.Wait(100)
                end

                newCharacter.CID = newCID
                if newCharacter.CID then 
                    local insertedNewCharacter = Components.DB:InsertOne('characters', newCharacter)
                    if insertedNewCharacter.success and #insertedNewCharacter.inserted > 0 then 
                        cb(true)
                        SelectCharacter(src, newCharacter.CID, function() end)
                        return
                    end
                end
            end
        end
        cb(false)
    end)
    
    Components.Callbacks:Register('Characters:Server:Select', function(src, cb, cid)
        SelectCharacter(src, cid, function(data)
            cb(data)
        end)
    end)

    Components.Callbacks:Register('Characters:Server:CompleteCreation', function(src, cb, data)
        local Character = Components.Characters:Source(src)
        if Character and Character:GetData('_Creation') then
            Character:SetData('Ped', data.ped)
            OUTFITS:Save(src, 1, data.outfit, true)
            SyncCharacter(Character)
            Character:SetData('_Creation', false)
            cb({
                coords = FirstSpawn.pos,
                outfit = OUTFITS:CurrentData(src),
                ped = Character:GetData('Ped')
            })

            Character:SetData('_Loaded', true)
            TriggerEvent('Characters:Server:Login', src)
            TriggerClientEvent('Characters:Client:Login', src, Character:GetData())
        end
        cb(false)
    end)

    Components.Callbacks:Register('Characters:Server:ChooseSpawn', function(src, cb, location)
        local Character = Components.Characters:Source(src)
        if not Character then return cb(false) end
        local spawns = Character:GetData('_Spawns')
        if spawns[location] then
            cb({
                coords = spawns[location].pos,
                outfit = OUTFITS:CurrentData(src),
                ped = Character:GetData('Ped')
            })
            Character:SetData('_Loaded', true)
            TriggerEvent('Characters:Server:Login', src)
            TriggerClientEvent('Characters:Client:Login', src, Character:GetData())
            SetPlayerRoutingBucket(src, 0)
        end
    end)

    Components.Callbacks:Register('Characters:Server:OutfitsGetCurrent', function(src, cb)
        local outfitData, outfitId, allData, named = OUTFITS:CurrentData(src)
        cb({ current = outfitId, all = allData, named = named })
    end)

    Components.Callbacks:Register('Characters:Server:OutfitsSaveNew', function(src, cb, data)
        if data.slot and data.data then 
            local success = OUTFITS:Save(src, data.slot, data.data)
            cb(success)
        else
            cb(false)
        end
    end)

    Components.Callbacks:Register('Characters:Server:HairSave', function(src, cb, data)
        local Character = Components.Characters:Source(src)
        if Character and type(data) == 'table' and data.headHair and data.facialHair and data.eyebrows and data.headOverlays then 
            local ped = Character:GetData('Ped')
            ped.headHair = data.headHair
            ped.facialHair = data.facialHair
            ped.eyebrows = data.eyebrows
            ped.headOverlays = data.headOverlays
            Character:SetData('Ped', ped)
            cb(true)

            TriggerClientEvent('Characters:Client:ApplyData', src, ped)
            local outfitData, outfitId = OUTFITS:CurrentData(src)
            Citizen.Wait(1000)
            TriggerClientEvent('Characters:Client:SetOutfit', src, outfitId, outfitData)
        else
            cb(false)
        end
    end)

    Components.Callbacks:Register('Characters:Server:TattoosSave', function(src, cb, data)
        local Character = Components.Characters:Source(src)
        if Character and type(data) == 'table' and data.tattoos then 
            local ped = Character:GetData('Ped')
            ped.tattoos = data.tattoos
            Character:SetData('Ped', ped)
            cb(true)

            TriggerClientEvent('Characters:Client:ApplyData', src, ped)
            local outfitData, outfitId = OUTFITS:CurrentData(src)
            Citizen.Wait(1000)
            TriggerClientEvent('Characters:Client:SetOutfit', src, outfitId, outfitData)
        else
            cb(false)
        end
    end)
end

function SelectCharacter(src, cid, cb)
    local User = Components.Users:Source(src)
    if not User then return cb({ success = false }) end
    local foundCharacter = Components.DB:FindOne('characters', { 
        CID = cid, 
        User = User:GetData('SID') 
    })
    if foundCharacter.success and #foundCharacter.docs > 0 then 
        local char = foundCharacter.docs[1]
        char.Source = src
        local _characterStore = Components.Store:Create(src, 'Character', char, function(retard, newVal)
            TriggerClientEvent('Characters:Client:Update', src, retard, newVal)
        end)

        _characterStore:SetData('_Loaded', false)
        _characterStore:SetData('_FullName', ('%s %s'):format(char.FirstName, char.LastName))

        SessionCharacters[src] = _characterStore
        User:SetData('Character', _characterStore)
        

        -- Spawn Locations
        local PossibleSpawns = {}
        if CachedLocations[char.CID] then 
            table.insert(PossibleSpawns, { type = 'last', name = 'Last Known Location', pos = CachedLocations[char.CID] })
        elseif char.Dead then -- Server must have restarted since they died
            _characterStore:SetData('Dead', false)
            _characterStore:SetData('Health', 100)
            _characterStore:SetData('Damage', nil)
            table.insert(PossibleSpawns, { type = 'spawn', name = DeadSpawn.name, pos = DeadSpawn.pos })
        end

        if not char.Dead then
            for k, v in ipairs(DefaultCharacterSpawns) do 
                table.insert(PossibleSpawns, { type = 'spawn', name = v.name, pos = v.pos })
            end

            -- Properties
        end

        SetPlayerRoutingBucket(src, 0)

        _characterStore:SetData('_Spawns', PossibleSpawns)

        if _characterStore:GetData('Ped') then 
            TriggerClientEvent('Characters:Client:StartSpawnSelect', src, _characterStore:GetData('_Spawns'))
            return cb({ success = true, close = false })
        else
            _characterStore:SetData('_Creation', true)
            cb({ success = true, close = true })
            Citizen.Wait(2000)
            TriggerClientEvent('Characters:Client:StartCreation', src, _characterStore:GetData('Gender'))
            return
        end
    end
    cb({ success = false })
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Characters', CHARACTERS)
end)

function IsCIDTaken(generated)
    local res = Components.DB:FindOne('characters', { CID = generated })
    if res.success and #res.docs <= 0 then -- operation should also have to be successful just in case
        return false
    end
    return true
end