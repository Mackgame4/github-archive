States = {
    QUEUED = 1,
    JOINING = 2,
    JOINED = 3,
    DISCONNECTED = 4
}

function Player(steam, source, deferrals)
    local user = Components.API:GetUser(source, steam)
    if not user then return false
    elseif not user.User then return false
    elseif not user.NamedGroups then return false end

    local prio = 0
    local staffMsg = false
    local staffBoost = false
    local msg = ''

    if Config.Queue.PepeLaugh[user.User.Name] then 
        staffMsg = string.format("Hello, %s%s\n", user.User.Name, Config.Queue.PepeLaugh[user.User.Name])
    end



    -- Staff Prio (They Override Everything Else)
    for k, v in ipairs(user.NamedGroups) do
        if Config.Queue.StaffPrio[v] and Config.Queue.StaffPrio[v].priority then
            local ranksPrio = tonumber(Config.Queue.StaffPrio[v].priority)
            if ranksPrio > prio then
                prio = ranksPrio
                msg = string.format('\n⚙ Staff Priority - %s (%s)', Config.Groups[v], ranksPrio)
                staffMsg = string.format("Hello, %s%s (%s)\n", user.User.Name, Config.Queue.PepeLaugh[user.User.Name] or '', Config.Groups[v])
                staffBoost = true
            end
        end
    end

    if user.User.SuperAdmin then
        prio = prio + 69 
        msg = msg .. '\n🍆 Nice (69)'
    end

    -- Add Job Priority Here Thanks Bye (Adds to Other Prio)

    local _data = {
        Source = source,
        State = States.QUEUED,

        SID = user.User.SID,
        Name = user.User.Name,
        Groups = user.NamedGroups,
        URL = user.User.URL,
        Avatar = user.User.Avatar,

        SiteBanned = user.SiteBanned,
        Banned = user.Banned,

        Staff = user.User.Staff,
        StaffLevel = user.StaffLevel,
        SuperAdmin = user.User.SuperAdmin,

        Identifier = steam,
        GameData = user.User.Data,

        Priority = prio,
        StaffMessage = staffMsg,
        StaffBoost = staffBoost,
        Message = msg,
        TimeBoost = 0,
        GraceBoost = false,
        Deferrals = deferrals,
        Grace = nil
    }

    _data.Timer = {
        Hour = 0,
        Minute = 0,
        Second = 0,
        Emoji = 1,

        Tick = function(self, plyr)
            if self.Second == 55 then -- Last Tick Before Next Second
                if self.Minute == 30 then 
                    if plyr.TimeBoost < Config.Queue.Settings.MaxTimeBoost then
                        plyr.TimeBoost = plyr.TimeBoost + 1
                        plyr.Priority = plyr.Priority + 5
                    end
                end

                if self.Minute == 59 then
                    self.Second = 0
                    self.Minute = 0
                    self.Hour = self.Hour + 1
                else
                    self.Second = 0
                    self.Minute = self.Minute + 1
                end
            else
                self.Second = self.Second + 5
            end

            if self.Emoji == #Config.Queue.Emojis then 
                self.Emoji = 1
            else
                self.Emoji = self.Emoji + 1
            end
        end,
        Output = function(self)
            if self.Hour == 0 and self.Minute < 1 then 
                if self.Second <= 30 then 
                    return "less than 30 seconds"
                else
                    return "less than a minute"
                end
            elseif self.Hour == 0 and self.Minute == 1 then
                return "1 minute"
            elseif self.Hour == 0 and self.Minute > 1 then
                return string.format("%d minutes", self.Minute)
            elseif self.Hour > 0 then 
                local outputString = string.format("%d hour", self.Hour)
                if self.Hour > 1 then
                    outputString = outputString .. "s"
                end
                if self.Minute == 1 then
                    outputString = outputString .. string.format(" %d minute", self.Minute)
                elseif self.Minute > 1 then 
                    outputString = outputString .. string.format(" %d minutes", self.Minute)
                end

                return outputString
            else
                return "5000 years"
            end
        end,
        OutputEmoji = function(self)
            return Config.Queue.Emojis[self.Emoji]
        end
    }

    _data.IsPrivileged = function(self)
        return self.StaffLevel >= 99
    end

    _data.IsBanned = function(self)
        if self.SiteBanned then
            return {
                expires = 2524608000,
                reason = 'Banned on the Forums',
            }
        elseif self.Banned then 
            return {
                expires = self.Banned.Expires / 1000,
                reason = self.Banned.Reason
            }
        else
            return false
        end
    end

    _data.IsInGracePeriod = function(self)
        if self.Grace == nil then 
            return false
        else
            return os.time() <= self.Grace + (60 * Config.Queue.Settings.Grace)
        end
    end

    return _data
end