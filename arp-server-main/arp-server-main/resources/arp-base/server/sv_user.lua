SessionUsers = {}
RecentDisconnects = {}
local avoidUpdate = { '_id', 'SID' }

AddEventHandler('Queue:Server:SessionActive', function(src, data)  
    Citizen.CreateThread(function()
        local User = NewUser(src, data)
        if User then
            SessionUsers[src] = User
            COMPONENTS.Logging:Info('Users', ('User %s Logged In %s'):format(COMPONENTS.Users:GenerateLogString(SessionUsers[src]), SessionUsers[src].Permissions:IsSuperAdmin() and '[Privileged]' or ''))
            TriggerEvent('ARP:Server:UserJoined', src)

            UpdateUserCount()

            local sid = data.SID
            for k, v in ipairs(RecentDisconnects) do 
                if v.SID == sid then 
                    table.remove(RecentDisconnects, k)
                    break
                end
            end
        else
            DropPlayer(src, 'Error Joining, Please Rejoin')
        end
    end)
end)

AddEventHandler('ARP:Server:UserJoined', function(src)
    local User = COMPONENTS.Users:Source(src)
    local UserData = User:GetData('UserData')
    UserData:SetData('LastLogin', ARP.GetUnix())
end)

function SaveUserData(src)
    local User = COMPONENTS.Users:Source(src)
    if User then 
        local sid = User:GetData('SID')
        local gameData = User:GetData('UserData'):GetData()
        for _, v in ipairs(avoidUpdate) do gameData[v] = nil end
        local worked = COMPONENTS.DB:UpdateOne('users', { SID = sid }, { ['$set'] = gameData })
    end
end

AddEventHandler('playerDropped', function(message)
    local src = source
    local User = COMPONENTS.Users:Source(src)
    if not User then return end
    local UserData = User:GetData('UserData')
    --LogoutCharacter(src)
    -- Do Playtimes
    local now = os.time()
    local connectTime = UserData:GetData('LastLogin')
    local currentPlaytime = UserData:GetData('Playtime') or 0
    local sessionTime = now - connectTime
    local newPlaytime = currentPlaytime + sessionTime
    UserData:SetData('Playtime', newPlaytime)
    SaveUserData(src)

    table.insert(RecentDisconnects, {
        source = src,
        name = User:GetData('Name'),
        SID = User:GetData('SID'),
    })

    COMPONENTS.Logging:Info('Users', ('User %s Logged Out, Reason: %s'):format(COMPONENTS.Users:GenerateLogString(User), message))
    -- Add Recent Disconnects or Whatever
    SessionUsers[src] = nil 
    COMPONENTS.Store:Delete(src, 'User')
    COMPONENTS.Store:Delete(src, 'UserData')

    UpdateUserCount()
end)

COMPONENTS.Users = {
    _protected = true,
    Source = function(self, src)
        src = tonumber(src)
        if SessionUsers[src] then 
            return SessionUsers[src]
        end
        return false
    end,
    All = function(self)
        return SessionUsers
    end,
    GetRecentDisconnects = function(self)
        return RecentDisconnects
    end,
    GenerateLogString = function(self, user)
        local userData = user:GetData()
        return ('%q [%s] (SID: %s, Steam: %s, Staff: %s)'):format(userData.Name, userData.Source, userData.SID, userData.Steam, user.Permissions.GetLevel())
    end,
    GenerateLogStringSrc = function(self, src)
        local User = COMPONENTS.Users:Source(src)
        if not User then return false end
        return COMPONENTS.Users:GenerateLogString(User)
    end
}

function NewUser(source, pdata)
    local gameData = {}
    if not (pdata.SID and pdata.Identifier and pdata.Name) then return false end
    local _data = COMPONENTS.Store:Create(source, 'User', pdata)
    _data:SetData('Source', source)
    local fetchedData = COMPONENTS.DB:FindOne('users', { SID = _data:GetData('SID') })
    if fetchedData.success and #fetchedData.docs > 0 then fetchedData = fetchedData.docs[1] else
        fetchedData = {} 
        COMPONENTS.DB:InsertOne('users', {
            SID = pdata.SID
        })
    end
    _data:SetData('UserData', COMPONENTS.Store:Create(source, 'UserData', fetchedData))
    _data:SetData('Steam', GetPlayerSteamDecimal(source))

    _data.Permissions = {
        HasGroups = function(self, grps)
            if type(grps) == 'string' then 
                grps = { grps }
            end
            local userGroups = _data:GetData('Groups')
            for _, group in ipairs(userGroups) do
                for _, findingGroup in ipairs(grps) do 
                    if findingGroup == group then return true end
                end
            end
            return false
        end,
        GetLevel = function(self)
            return _data:GetData('StaffLevel')
        end,
        IsStaff = false,
        IsDev = false,
        IsSuperAdmin = function(self)
            return _data:GetData('SuperAdmin')
        end
    }

    if _data.Permissions:HasGroups(Config.StaffGroups) then
        _data.Permissions.IsStaff = true
    end
    if _data.Permissions:HasGroups(Config.DevGroups) then
        _data.Permissions.IsDev = true
    end
    if _data.Permissions:IsSuperAdmin() or _data.Permissions:HasGroups('admin') then 
        ExecuteCommand(('add_principal identifier.steam:%s group.admin'):format(GetPlayerSteam(source)))
    end
    return _data
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(600000) -- 10 mins
        local userCount = 0
        for src, v in pairs(SessionUsers) do 
            userCount = userCount + 1
            SaveUserData(src)
        end
        if userCount > 0 then 
            COMPONENTS.Logging:Debug('ARP', string.format('Saving %s User\'s Player Data', userCount))
        end
    end
end)

function UpdateUserCount()
    GlobalState.UserCount = ARP.GetTableLength(SessionUsers);
end






--[[ Emulate for testing
AddEventHandler('ARP:Shared:Ready', function()
    TriggerEvent('Queue:Server:SessionActive', 1, {
        SID = 1,
        Name = 'Dr Dick',
        Groups = { 'admin' },
        URL = 'cunt',
        SiteBanned = false,
        Banned = false,
        Staff = true,
        StaffLevel = 100,
        SuperAdmin = true,
        Identifier = 'steam',
    })
end)]]
