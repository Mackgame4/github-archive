local avoidUpdate = { '_id', 'User', 'Source', 'FirstName', 'LastName', 'MiddleName', 'CID', 'Gender', 'Created', 'DOB' }

function SyncCharacter(Character, state)
    local CID = Character:GetData('CID')

    if state then 
        if type(state.health) == 'number' and state.health >= 0 and state.health <= 100 then 
            Character:SetData('Health', state.health)
        end

        if type(state.armour) == 'number' and state.armour >= 0 and state.armour <= 100 then 
            Character:SetData('Armour', state.armour)
        end
    end
    --local User = Character:GetData('User')
    local cData = Character:GetData()

    for _, avoid in ipairs(avoidUpdate) do cData[avoid] = nil end
    for key, data in pairs(cData) do
        if ARP.StringStartsWith(key, '_') then -- so we can have temp data
            cData[key] = nil
        end
    end

    cData.LastPlayed = os.time()

    local update = Components.DB:UpdateOne('characters', { CID = CID }, {
        ['$set'] = cData
    })
    
    return update.success
end

Citizen.CreateThread(function()
    repeat Citizen.Wait(1000) until DB ~= nil
    
    while true do 
        Citizen.Wait(240000) -- 4 mins
        local count = 0
        for s, c in pairs(SessionCharacters) do 
            SyncCharacter(c)
            count = count + 1
        end
        if count > 0 then 
            Logging:Info('Characters', ('Syncing %d Character\'s'):format(count), { skipDiscord = true })
        end
    end
end)

