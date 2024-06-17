local MAX_PLAYERS = tonumber(GetConvar('sv_maxclients', '48'))

local initialised = false

local playerJoining = false

local _dbReady = false

local QUEUE_LOCK = true
local QUEUE_LOCK_MAN = false

local Data = {
    Session = {
        Count = 0,
        Players = {}
    },
    Dropped = {},
    Queue = {}
}

local QUEUE = {}

QUEUE.Queue = {
    Get = function(self, identifier)
        for k, v in ipairs(Data.Queue) do
            if v.Identifier == identifier then
                return k, v
            end
        end

        return nil
    end,
    Add = function(self, player)
        for k, v in ipairs(Data.Queue) do
            if player.Identifier == v.Identifier then -- These identifiers are already in the queue
                if v:IsInGracePeriod() then
                    v.Deferrals = player.Deferrals
                    v.Source = player.Source
                    v.State = States.QUEUED

                    v.Name = player.Name
                    v.URL = player.URL
                    v.Groups = player.Groups
                    v.Staff = player.Staff
                    v.StaffLevel = player.StaffLevel
                    v.GameData = player.GameData
                    v.Priority = player.Priority
                    v.StaffMessage = player.StaffMessage
                    --v.GraceBoost = true They don't get boost here because they just left the queue and joined back
                else
                    QUEUE.Queue:Remove(k)
                end
                return
            end
        end

        local prevDropped = QUEUE.Dropped:Get(player.Identifier)

        if prevDropped ~= nil then 
            player.Grace = Data.Dropped[prevDropped].Grace
            if player:IsInGracePeriod() then 
                if not player.StaffBoost then 
                    player.GraceBoost = true
                    player.Priority = player.Priority + 25
                end
            end
            QUEUE.Dropped:Remove(prevDropped)
        end

        if player.Priority > 0 then
            for k, v in ipairs(Data.Queue) do
                if player.Priority > v.Priority then
                    table.insert(Data.Queue, k, player)
                    QDebugLog(string.format(Config.Queue.Strings.PrioAdd, player.Name, player.SID, player.Identifier, k, #Data.Queue, player.Priority))
                    return
                end
            end
        end

        table.insert(Data.Queue, player)
        QDebugLog(string.format(Config.Queue.Strings.Add, player.Name, player.SID, player.Identifier, #Data.Queue, #Data.Queue))
    end,
    Remove = function(self, position)
        table.remove(Data.Queue, position)
    end,
    Join = function(self, count)
        local joined = 0
        for i = 1, #Data.Queue, 1 do
            if joined == count then break end

            if Data.Queue[i] ~= nil and Data.Queue[i].State == States.QUEUED and (not QUEUE_LOCK or (QUEUE_LOCK and Data.Queue[i]:IsPrivileged())) then
                if GetPlayerEndpoint(Data.Queue[i].Source) then
                    Data.Queue[i].Deferrals.update(Config.Queue.Strings.Joining)
                    Data.Queue[i].State = States.JOINING
                    Data.Queue[i].Deferrals.done()
                    QDebugLog(string.format(Config.Queue.Strings.Joined, Data.Queue[i].Name, Data.Queue[i].SID, Data.Queue[i].Identifier))
                    joined = joined + 1
                else
                    Data.Queue[i].State = States.DISCONNECTED
                    Data.Queue[i].Grace = (os.time() + (60 * Config.Queue.Settings.Grace))
                    QDebugLog(string.format(Config.Queue.Strings.Disconnected, Data.Queue[i].Name, Data.Queue[i].SID, Data.Queue[i].Identifier))
                    QDebugLog(string.format(Config.Queue.Strings.Grace, Data.Queue[i].Name, os.date('%I:%M:%S %p', Data.Queue[i].Grace)))
                end
            end
        end
        playerJoining = false
    end
}

QUEUE.Dropped = {
    Get = function(self, identifier)
        for k, v in ipairs(Data.Dropped) do
            if v.Identifier == identifier then
                return k
            end
        end

        return nil
    end,
    Add = function(self, source, message)
        if Data.Session.Players[source] == nil then
            return
        end
        
        QDebugLog('Player [' .. source .. '] Dropped: ' .. message)
        for _, v in ipairs(Config.Queue.ExcludeDrop) do
            if string.find(message, v) then
                QUEUE.Session:Remove(source)
                return
            end
        end

        Data.Session.Players[source].Grace = (os.time() + (60 * Config.Queue.Settings.Grace))
        QDebugLog(string.format(Config.Queue.Strings.Grace, Data.Session.Players[source].Name, os.date('%I:%M:%S %p', Data.Session.Players[source].Grace)))
        table.insert(Data.Dropped, Data.Session.Players[source])
        QUEUE.Session:Remove(source)
    end,
    Remove = function(self, position)
        table.remove(Data.Dropped, position)
    end
}

QUEUE.Session = {
    Add = function(self, player)
        Data.Session.Count = Data.Session.Count + 1
        Data.Session.Players[player.Source] = player
    end,
    Remove = function(self, source)
        Data.Session.Count = Data.Session.Count - 1
        Data.Session.Players[source] = nil
    end
}

QUEUE.Connect = function(self, source, playerName, setKickReason, deferrals)
    local steam = GetPlayerSteamDecimal(source)
    deferrals.defer()
    Citizen.Wait(1)
    
    Citizen.CreateThread(function()
        if not steam then
            deferrals.done(Config.Queue.Strings.NoSteam)
            CancelEvent()
            return
        end

        --local currentUser = Components.Users:Steam(steam)
        local currentUser = Components.Users:Source(src)
        if currentUser then 
            deferrals.done(Config.Queue.Strings.Error)
            CancelEvent()
            return
        end
    
        local ply = Player(steam, source, deferrals)
        if not ply then
            deferrals.done(Config.Queue.Strings.NoAccountData)
            CancelEvent()
            return
        end

        local banned = ply:IsBanned()
        if banned then
            if banned.expires == -1 then
                deferrals.done(string.format(Config.Queue.Strings.PermaBanned, banned.reason, banned._id))
            else
                deferrals.done(string.format(Config.Queue.Strings.Banned, banned.reason, os.date('%Y-%m-%d at %I:%M:%S %p', tostring(banned.expires)), banned._id))
            end
            CancelEvent()
            return
        end

        -- if Data.Session.Count < MAX_PLAYERS then
        --     self.Session:Add(ply)
        --     deferrals.update(Config.Strings.Joining)
        --     deferrals.done()
        --     return
        -- end
        
        self.Queue:Add(ply)

        local pos, plyr = self.Queue:Get(steam)

        while plyr == nil do
            self.Queue:Add(ply)
            pos, plyr = self.Queue:Get(steam)
            Citizen.Wait(100)
        end

        while plyr.State == States.QUEUED and GetPlayerEndpoint(source) do
            pos, plyr = self.Queue:Get(steam)

            local msg = ''
            if QUEUE_LOCK then 
                if QUEUE_LOCK_MAN then 
                    msg = msg .. '🔒 The queue is currently closed, waiting for it to open. 🔒\n\n'
                else
                    msg = msg .. '🔒 The queue is currently closed, waiting for the server to finish startup. 🔒\n\n'
                end
            end

            if plyr.StaffMessage then 
                msg = msg .. plyr.StaffMessage
            end

            msg = msg .. string.format(Config.Queue.Strings.QueuedTime, plyr.Timer:Output())

            if plyr.Priority > 0 then
                msg = msg .. '\nTotal Priority Points: ' .. tostring(plyr.Priority)
                if plyr.GraceBoost then 
                    msg = msg .. string.format('\n🤯 Crash Priority (25)')
                end
                if plyr.TimeBoost > 0 then
                    msg = msg .. string.format('\n⏳ Time Boosts (%s)', plyr.TimeBoost * 5)
                end
                msg = msg .. plyr.Message
            end

            plyr.Deferrals.update(string.format(Config.Queue.Strings.Queued, plyr.Timer:OutputEmoji(), pos, #Data.Queue, msg))
            plyr.Timer:Tick(plyr)
            Citizen.Wait(5000)
        end
        
        pos, plyr = self.Queue:Get(steam)
        if (plyr.State == States.QUEUED) then
            plyr.State = States.DISCONNECTED
            plyr.Grace = (os.time() + (60 * Config.Queue.Settings.Grace))
            QDebugLog(string.format(Config.Queue.Strings.Grace, plyr.Name, os.date('%I:%M:%S %p', plyr.Grace)))
            Data.Queue[pos] = plyr
            --self.Queue:Remove(pos)
        end
    end)
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals) 
    if _dbReady then 
        QUEUE:Connect(source, playerName, setKickReason, deferrals)
    else
        deferrals.done("AuthenticRP has not yet finished loading, please try again in a few minutes.")
        CancelEvent()
    end
end)

AddEventHandler('playerDropped', function(message) 
    QUEUE.Dropped:Add(source, message) 
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == 'arp-base' then
        while GetResourceState(resource) ~= "started" do Citizen.Wait(0) end
        for k, v in pairs(Data.Session.Players) do
            TriggerClientEvent('Queue:Client:SessionActive', k)
            TriggerEvent('Queue:Server:SessionActive', k, {
                SID = v.SID,
                Name = v.Name,
                Groups = v.Groups,
                URL = v.URL,
                SiteBanned = v.SiteBanned,
                Banned = v.Banned,
                Staff = v.Staff,
                StaffLevel = v.StaffLevel,
                SuperAdmin = v.SuperAdmin,
                Identifier = v.Identifier,
                GameData = v.GameData,
                Avatar = v.Avatar,
            })
        end
	end
end)

function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        Components.Commands:AddDeveloper('qLock', function(src, args)
            QUEUE_LOCK = true
            QUEUE_LOCK_MAN = true
            QDebugLog('Queue Lock Is Now Enabled')
        end, 'Lock the Queue and Stop Regular Players From Joining', false, true, true)

        Components.Commands:AddDeveloper('qUnlock', function(src, args)
            QUEUE_LOCK = false
            QUEUE_LOCK_MAN = false
            QDebugLog('Queue Lock Is Now Disabled - The Queue is Now Open')
        end, 'Unlock the Queue and Allow All Players to Join', false, true, true)
    end

    if not c then 
        Citizen.Wait(5000)
        _dbReady = true
        QDebugLog('Queue Started')

        Citizen.SetTimeout(20000, function()
            if not QUEUE_LOCK_MAN then 
                QUEUE_LOCK = false
                QDebugLog('Queue Lock Is Now Disabled - The Queue is Now Open')
            end
        end)
    end
end

RegisterServerEvent('ARP:Server:SessionStarted')
AddEventHandler('ARP:Server:SessionStarted', function()
    local src = source
    local steam = GetPlayerSteamDecimal(source)
    if steam then 
        local pos, ply = QUEUE.Queue:Get(steam)
        if ply ~= nil then
            ply.Source = src
            ply.State = States.JOINED
            QUEUE.Session:Add(ply)
            QUEUE.Queue:Remove(pos)
            TriggerClientEvent('Queue:Client:SessionActive', src)
            TriggerEvent('Queue:Server:SessionActive', src, {
                SID = ply.SID,
                Name = ply.Name,
                Groups = ply.Groups,
                URL = ply.URL,
                SiteBanned = ply.SiteBanned,
                Banned = ply.Banned,
                Staff = ply.Staff,
                StaffLevel = ply.StaffLevel,
                SuperAdmin = ply.SuperAdmin,
                Identifier = ply.Identifier,
                GameData = ply.GameData,
                Avatar = ply.Avatar,
            })
        end
    else
        DropPlayer(src, Config.Queue.Strings.NoSteam)
    end
end)

function QInfoLog(log)
    if not Components.Logging then return end
    Components.Logging:Info('Queue', log)
end

function QDebugLog(log)
    if not Components.Logging then return end
    Components.Logging:Debug('Queue', log)
end

Citizen.CreateThread(function()
    while not _dbReady do
        Citizen.Wait(1000)
    end
    
    while GetResourceState('hardcap') ~= 'stopped' do
        local state = GetResourceState('hardcap')
        if state == 'missing' then break end

        if state == 'started' then
            StopResource('hardcap')
            break
        end

        Citizen.Wait(5000)
    end

    while true do
        if (Data.Session.Count < MAX_PLAYERS and #Data.Queue > 0 and not playerJoining) then
            playerJoining = true
            QUEUE.Queue:Join(MAX_PLAYERS - Data.Session.Count) -- TODO: Limit connections to waves of people instead of everyone at once
        end

        Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in ipairs(Data.Queue) do
            if v.State == States.DISCONNECTED and not v:IsInGracePeriod() then
                QUEUE.Queue:Remove(k)
            end           
        end
        Citizen.Wait(10000)
    end
end)