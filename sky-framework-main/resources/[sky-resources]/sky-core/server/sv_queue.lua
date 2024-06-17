local playerJoining = false
Core.Modules.Queue = {}
Core.Queue = {
    Queued = {},
    Session = {},
    SessionCount = 0,
    ConnectingCount = 0,
    Dropped = {},
    States = {
        QUEUED = 1,
        JOINING = 2,
        JOINED = 3,
        DISCONNECTED = 4
    }
}

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	local _src = source
    deferrals.defer()
    Wait(2)

    while not Core.Modules.Proxy.QueueOpen do
        Core.Modules.DeferralCards:TextCard(deferrals, 'Recovering', 'Thy old west is still recovering')
        Wait(500)
    end

    Core.Modules.DeferralCards:TextCard(deferrals, 'Welcome', 'Welcome to the Old West... Please wait')
    Wait(5000)

    local hasRequired = Core.Modules.Functions:GetIdentifiers(_src)

    if not hasRequired.error then
        local user = CreatePlayer(_src, hasRequired, deferrals)
        if user ~= nil then
            Core.Modules.Queue:StartQueue(user, _src, deferrals, hasRequired)
            return
        end
        deferrals.done("There was a problem loading your user profile.")
    else
        deferrals.done(hasRequired.error)
    end
end)

function CreatePlayer(src, license, deferrals)
    local member = nil
    local processed = false

    Core.Modules.Database.Auth:find({
        collection = 'Users',
        query = {
            Steam = license['Steam']
        }
    }, function(suc, res)
        if not suc then DropPlayer(src, 'There was an error processing your connection') return end 
        if res and res[1] then
            if deferrals then
                Core.Modules.DeferralCards:TextCard(deferrals, 'Profile Loaded - Hey '..res[1].Name, 'Welcome Back!, We\'re just getting a few things ready and checking a few final pre connection details')
            end
            res[1].SID = res[1]._id
            res[1]._id = nil
            member = res[1]
            if deferrals then
                Wait(2500)
            end
            processed = true
        else
            -- create
            if deferrals then
                Core.Modules.DeferralCards:TextCard(deferrals, 'Registering New Profile', 'No profile found, Generating a new profile | Steam: '..license["Steam"])
            end
            local member1 = {
                Name = GetPlayerName(src),
                Steam = license['Steam'],
                Identifiers = license,
                Dates = {
                    Registered = {
                        Human = os.date('%c'),
                        Unix = os.time()
                    },
                    LastActive = {
                        Human = os.date('%c'),
                        Unix = os.time()
                    },
                    LastSave = {
                        Human = os.date('%c'),
                        Unix = os.time()
                    }
                },
                BannedDetails = {
                    Reason = "",
                    Active = false,
                    IssuedBy = "",
                    Expiry = 0,
                },
                Game = Core.Modules.Proxy.ServerMeta.Game,
                GameName = Core.Modules.Proxy.ServerMeta.GameName,
                Permission = "User",
                Boosts = {},
            }
            Core.Modules.Database.Auth:insertOne({
                collection = "Users",
                document = member1
            }, function(suc, res, ins)
                if not suc then DropPlayer(src, 'There was an error processing your connection') return end
                if ins[1] == nil then DropPlayer(src, 'There was an error processing your connection') return end
                member1.SID = ins[1]
                member = member1
                if deferrals then   
                    Core.Modules.DeferralCards:TextCard(deferrals, 'New Profile Registered', 'Profile has been created successfully | SID: '..ins[1])
                    Wait(3500)
                end
                if deferrals then
                    Core.Modules.DeferralCards:TextCard(deferrals, 'Profile Linked', 'SID '..ins[1]..' <<->> '..license["Steam"]..' Steam')
                    Wait(3500)
                end
                processed = true
            end)
            
        end
    end)
    repeat Wait(1) until processed == true
    return member
end

function BuildPlayer(user, src, deferrals, identifiers)
    local _userData = {
        User = user,
        State = Core.Queue.States.QUEUED,
        Source = src,
        Identifier = identifiers['Steam'],
        QueueSelected = "standard",
        Priority = 0,
        ConnectTime = os.time(),
        Message = "",
        TimeBoost = 0,
        Deferrals = deferrals,
        Grace = nil,
        Boosts = user.Boosts or {},
        QueueBoosts = {},
        IsConnecting = false
    }

    _userData.GetBoosts = function(self)
        local newBoosts = {}
        local personalBoosts = _userData.User.Boosts
        if personalBoosts ~= nil then 
            for k, v in pairs(personalBoosts) do
                if v.Active then
                    table.insert(newBoosts, { Label = v.Label, Prio = v.Prio, Active = v.Active } )
                end
            end
        end

        for k, v in pairs(_userData.QueueBoosts) do
            if v.Active then
                table.insert(newBoosts, { Label = v.Label, Prio = v.Prio, Active = v.Active } )
            end
        end
        return newBoosts
    end

    _userData.ProcessPriority = function(self)
        local Boosts = self:GetBoosts()
        _userData.Priority = 0
        for k, v in pairs(Boosts) do
            _userData.Priority = (_userData.Priority + v.Prio)
        end
    end

    _userData.AddBoost = function(self, desc, boost)
        if desc and boost then
            table.insert(_userData.QueueBoosts, { Label = desc, Prio = boost, Active = true } )
        end
    end

    _userData.Timer = {
        Hour = 0,
        Minute = 0,
        Second = 0,
        Tick = function(self, plyr)
            if self.Second == 59 then
                if self.Minute == 59 then
                    self.Second = 0
                    self.Minute = 0
                    self.Hour = self.Hour + 1
                else
                    self.Second = 0
                    self.Minute = self.Minute + 1
                end
                if (GetGameTimer() > (Core.Modules.Proxy.QueueOpenTime + (Core.Config.Queue.Settings.InitialWaitTimes[_userData.QueueSelected] * 60000))) then
                    if plyr.TimeBoost < Core.Config.Queue.Settings.MaxTimeBoost then
                        plyr.TimeBoost = plyr.TimeBoost + 1
                        plyr.Priority = plyr.Priority + 1
                    end
                end
            else
                self.Second = self.Second + 1
            end
        end,
        Output = function(self)
            return string.format("%02d:%02d:%02d", self.Hour, self.Minute, self.Second)
        end
    }

    _userData.HasJobQueue = function(self)
        
        return false
    end

    _userData.HasStaffQueue = function(self)
        if string.lower(_userData.User.Permission) == "admin" or string.lower(_userData.User.Permission) == "staff" or string.lower(_userData.User.Permission) == "developer" or string.lower(_userData.User.Permission) == "moderator" or string.lower(_userData.User.Permission) == "god" then
            return true
        end
        return false
    end

    _userData.HasDevelopmentQueue = function(self)
        if GetConvar('ServerMode', 'Live') == "Development" and self:HasStaffQueue() then
            return true
        end
        return false
    end

    _userData.IsWhitelisted = function(self)
        return true
    end

    _userData.RestrictToJobs = function(self)
        _userData.User.JobsOnly = true
        return _userData.User.JobsOnly
    end

    _userData.SelectQueue = function(self, queue)
        _userData.QueueSelected = queue
    end

    _userData.IsInGracePeriod = function(self)
        if self.Grace == nil then 
            return false
        else
            return os.time() <= self.Grace + (60 * Core.Config.Queue.Settings.Grace)
        end
    end

    for k, v in pairs(Core.Queue.Dropped) do
        if v.Identifier == _userData.Identifier then
            if v:IsInGracePeriod() then
                Core.Modules.Queue.Dropped:Remove(k)
                _userData:AddBoost('Crash Prio Boost', 1000000) -- Highest Prio Avail (If you go above this, it will interfer with server admin, staff etc.. prio levels)
            end
        end
    end

    return _userData
end

Core.Modules.Queue.JoinServer = function(self, count)
    local joined = 0
    for i = 1, #Core.Queue.Queued, 1 do
        if (GetGameTimer() < (Core.Modules.Proxy.QueueOpenTime + (Core.Config.Queue.Settings.InitialWaitTimes[Core.Queue.Queued[i].QueueSelected] * 60000))) then break end
        if joined == count then break end

        if Core.Queue.Queued[i] ~= nil and Core.Queue.Queued[i].State == Core.Queue.States.QUEUED then
            if GetPlayerEndpoint(Core.Queue.Queued[i].Source) then
                Core.Modules.DeferralCards:TextCard(Core.Queue.Queued[i].Deferrals, 'Joining City...', 'We are now connecting you to the city please hold on a few more minutes!!')
                Core.Queue.Queued[i].State = Core.Queue.States.JOINING
                joined = joined + 1
                Wait(1000)
                Core.Queue.Queued[i].Deferrals.done()
                Core.Modules.Logger:Info('Queue', string.format(Core.Config.Queue.Strings.Joined, Core.Queue.Queued[i].User.GetName, Core.Queue.Queued[i].User.SID, Core.Queue.Queued[i].Identifier), {discord = {channel = "queue"}})
            else
                Core.Queue.Queued[i].State = Core.Queue.States.DISCONNECTED
                Core.Queue.Queued[i].Grace = os.time()
                Core.Modules.Logger:Info('Queue', string.format(Core.Config.Queue.Strings.Disconnected, Core.Queue.Queued[i].User.Name, Core.Queue.Queued[i].User.SID, Core.Queue.Queued[i].Identifier))
            end
        end
    end
    playerJoining = false
end

Core.Modules.Queue.QueuePlayer = function(self, plyr)
    Citizen.CreateThread(function()
        Core.Modules.Queue:AddToQueue(plyr)
        local pos, plyr = Core.Modules.Queue:GetFromQueue(plyr.Identifier)
        while plyr == nil do
            Wait(100)
            Core.Modules.Queue:AddToQueue(plyr)
            pos, plyr = Core.Modules.Queue:GetFromQueue(plyr.Identifier)
        end
        Core.Modules.Logger:Info('Queue', plyr.User.Name..' has joined the queue in position: '..pos, {discord={channel="queue"}})

        while (GetGameTimer() < (Core.Modules.Proxy.QueueOpenTime + (Core.Config.Queue.Settings.InitialWaitTimes[plyr.QueueSelected] * 60000)) and GetPlayerEndpoint(plyr.Source)) do
            local time = ((math.floor(Core.Modules.Proxy.QueueOpenTime / 60000) + Core.Config.Queue.Settings.InitialWaitTimes[plyr.QueueSelected]) - math.floor(GetGameTimer() / 60000))
            pos, plyr = Core.Modules.Queue:GetFromQueue(plyr.Identifier)
            Wait(100)
            Core.Modules.DeferralCards:QueueInfo(plyr, pos, plyr.QueueSelected, time)
            plyr.Timer:Tick(plyr)
            Wait(900)
        end
        
        while (plyr.State == Core.Queue.States.QUEUED and GetPlayerEndpoint(plyr.Source)) do
            pos, plyr = Core.Modules.Queue:GetFromQueue(plyr.Identifier)
            Wait(100)
            Core.Modules.DeferralCards:QueueInfo(plyr, pos, plyr.QueueSelected)
            plyr.Timer:Tick(plyr)
            Wait(900)
        end
        -- Player has either been fetched from the queue or has quit the queue
        return
    end)
end

Core.Modules.Queue.AddToQueue = function(self, plyr)
    for k, v in ipairs(Core.Queue.Queued) do
        if v.Identifier == plyr.Identifier then
            if v:IsInGracePeriod() then
                -- do grace period check here b4 setting below variables.
                v.State = Core.Queue.States.QUEUED
                v.Deferrals = plyr.Deferrals
                v.Source = plyr.Source
                return
            end
        end
    end

    if plyr.Priority > 0 then
        for k, v in ipairs(Core.Queue.Queued) do
            if plyr.Priority > v.Priority then
                table.insert(Core.Queue.Queued, k, plyr)
                -- entered q in pos k with prio
                return
            end
        end 
    end

    table.insert(Core.Queue.Queued, plyr)
end

Core.Modules.Queue.RemoveFromQueue = function(self, pos)
    if Core.Queue.Queued[pos] then
        table.remove(Core.Queue.Queued, pos)
    end
end

Core.Modules.Queue.GetFromQueue = function(self, license)
    for k, v in ipairs(Core.Queue.Queued) do
        if v.Identifier == license then
            return k, v
        end
    end

    return nil
end

Core.Modules.Queue.Session = {
    AddToSession = function(self, plyr)
        if plyr then
            Core.Queue.Session[plyr.Source] = plyr
            Core.Queue.SessionCount = (Core.Queue.SessionCount + 1)
        end
    end,
    RemoveFromSession = function(self, source)
        if source then
            if Core.Queue.Session[source] then           
                Core.Queue.Session[source] = nil
                Core.Queue.SessionCount = (Core.Queue.SessionCount - 1)
                return
            end
        end
    end
}

Core.Modules.Queue.Dropped = {
    Get = function(self, identifier)
        for k, v in ipairs(Core.Queue.Dropped) do
            if v.Identifier == identifier then
                return k
            end
        end

        return nil
    end,
    Add = function(self, source, message)
        local excludedrop = false
        for _, v in ipairs(Core.Config.Queue.ExcludeDrop) do
            if string.find(message, v) then
                excludedrop = true
            end
        end

        if Core.Queue.Session[source] == nil then
            print('not ere?')
            return
        end
        if not excludedrop then
            Core.Queue.Session[source].Grace = os.time()
            Core.Modules.Logger:Info('Queue', 'Player Dropped Due to a Crash: ' .. message)
        else
            Core.Modules.Logger:Info('Queue', 'Player Dropped Client Quit ')
        end
        table.insert(Core.Queue.Dropped, Core.Queue.Session[source])

        Core.Modules.Queue.Session:RemoveFromSession(source)
    end,
    Remove = function(self, position)
        table.remove(Core.Queue.Dropped, position)
    end
}



Core.Modules.Queue.StartQueue = function(self, user, src, deferrals, identifiers)
    Citizen.CreateThread(function()
        for k, v in pairs(Core.Queue.Queued) do
            if not v:IsInGracePeriod() then
                Core.Modules.Queue:RemoveFromQueue(k)
            end
        end

        for k, v in pairs(Core.Queue.Dropped) do
            if not v:IsInGracePeriod() then
                Core.Modules.Queue.Dropped:Remove(k)
            end
        end

        local Player = BuildPlayer(user, src, deferrals, identifiers)
        if Player == nil then 
            deferrals.done("There was a problem trying to load your user profile, please try reconnecting, if this issue persists, please open a support ticket.")
            CancelEvent()
            return
        end

        if not Player:IsWhitelisted() then
            deferrals.done("You do not have permission to connect, if this issue persists and you think its a genuine error, please open a support ticket.")
            CancelEvent()
            return
        end

        Core.Modules.DeferralCards:PresentQueue(Player)
        return
    end)
end

Citizen.CreateThread(function()
    while true do
        if( Core.Queue.SessionCount < tonumber(GetConvar('sv_maxclients', '48')) and #Core.Queue.Queued > 0 and not (playerJoining or privPlayerJoining)) then
            playerJoining = true
            Core.Modules.Queue:JoinServer(tonumber(GetConvar('sv_maxclients', '48')) - Core.Queue.SessionCount)
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in ipairs(Core.Queue.Queued) do
            if v.State == Core.Queue.States.DISCONNECTED and not v:IsInGracePeriod() then
                Modules.Queue:RemoveFromQueue(k)
            end           
        end
        Citizen.Wait(10000)
    end
end)