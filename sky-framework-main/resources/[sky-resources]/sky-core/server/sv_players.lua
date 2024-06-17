Core.Players = {}
local omitSave = {"Source", "SID", "Character"}

Core.Modules.Players = {
    DuplicityCheck = function(self, identifier)
        for k, v in pairs(Core.Players) do
            if v.Get then
                if v:Get('Steam') == identifier then
                    return true
                end
            end
        end
        return false
    end,
    CreatePlayer = function(self, src, data)
        math.randomseed( ( os.time() + GetGameTimer() ) )
        if not data or not src then return end
        data.Source = src
        local _userData = Core.Modules.DataStore:Create(src, 'Player', data)
        if not _userData then return end

        _userData.OneSync = {
            World = math.random(1000, 20000),
            CurrentWorld = 0,
            SetWorld = function(self, world, cb) 
                SetPlayerRoutingBucket(_userData:Get('Source'), tonumber(world))
                _userData.OneSync.CurrentWorld = tonumber(world)
                Core.Modules.Logger:Info('OneSync', _userData:Get('Name').. ' has changed to world '..world)
                if cb then cb(true) else return true end
            end,
            SetGameWorld = function(self, cb) 
                SetPlayerRoutingBucket(_userData:Get('Source'), tonumber(0))
                _userData.OneSync.CurrentWorld = tonumber(0)
                Core.Modules.Logger:Info('OneSync', _userData:Get('Name').. ' has changed to the main Game World')
                if cb then cb(true) else return true end
            end,
            SetOwnWorld = function(self, cb) 
                SetPlayerRoutingBucket(_userData:Get('Source'), tonumber(_userData.OneSync.World))
                _userData.OneSync.CurrentWorld = tonumber(_userData.OneSync.World)
                Core.Modules.Logger:Info('OneSync', _userData:Get('Name').. ' has changed to thier own World '.._userData.OneSync.World)
                if cb then cb(true) else return true end
            end,
            GetWorld = function(self)
                return GetPlayerRoutingBucket(_userData:Get('Source'))
            end,
            GetOwnWorld = function(self)
                return _userData.OneSync.World
            end,
            SetWorldLockdown = function(self, mode, cb)
                if mode == nil then return end
                SetRoutingBucketEntityLockdownMode(_userData.OneSync.World, mode)
                Core.Modules.Logger:Info('OneSync', 'World Lockdown Mode has been set to '..mode..' for world '.._userData.OneSync.World)
                if cb then cb(true) else return true end
            end,
            SetWorldPopulation = function(self, pop, cb)
                if pop == nil then pop = true end
                if type(pop) ~= "boolean" then return end
                SetRoutingBucketPopulationEnabled(_userData.OneSync.World, pop)
                Core.Modules.Logger:Info('OneSync', 'World Population has been '..(pop and "^2Enabled^7" or "^1Disabled^7")..' for world '.._userData.OneSync.World)
                if cb then cb(true) else return true end
            end,
        }
        Core.Modules.Logger:Info('OneSync', _userData:Get('Name').. '\'s Virtual Worlds Created, WorldID: '.._userData.OneSync.World)

        _userData.Functions = {
            Save = function(self, cb)
                Core.Modules.Players:SavePlayer(_userData:Get('Source'), cb)
            end
        }

        _userData.Permissions = {
            GetPermission = function(self)
                return string.lower(_userData:Get('Permission'))
            end,
            SetPermission = function(self, permission)
                _userData:Set('Permission', permission)
                return true
            end,
            IsAdmin = function(self)
                local perm = string.lower(_userData:Get('Permission'))
                if perm == "god" or perm == "admin" then
                    return true
                end
                return false
            end,
            IsStaff = function(self)
                local perm = string.lower(_userData:Get('Permission'))
                if perm == "god" or perm == "admin" or perm == "staff" then
                    return true
                end
                return false
            end,
            IsDeveloper = function(self)
                local perm = string.lower(_userData:Get('Permission'))
                if perm == "god" or perm == "admin" or perm == "staff" or perm == "developer" then
                    return true
                end
                return false
            end,
            IsModerator = function(self)
                local perm = string.lower(_userData:Get('Permission'))
                if perm == "god" or perm == "admin" or perm == "staff" or perm == "developer" or perm == "moderator" then
                    return true
                end
                return false
            end,
            IsWhitelisted = function(self)
                local perm = string.lower(_userData:Get('Permission'))
                if perm == "god" or perm == "admin" or perm == "staff" or perm == "developer" or perm == "moderator" or perm == "whitelisted" then
                    return true
                end
                return false
            end,
            IsTester = function(self)
                local perm = string.lower(_userData:Get('Permission'))
                if perm == "god" or perm == "admin" or perm == "staff" or perm == "developer" or perm == "moderator" or perm == "tester" then
                    return true
                end
                return false
            end
        }

        return _userData

    end,
    SavePlayer = function(self, src, cb)
        local Fetch = exports[GetCurrentResourceName()]:FetchModule('Fetch')
        local Player = Fetch:Player(src)
        if Player ~= nil then
            local SID = Player:Get('SID')
            local _Player = Player:Get()
            for k, v in pairs(omitSave) do
                if _Player[v] ~= nil then
                    _Player[v] = nil
                end
            end
            _Player.LastGame = Core.Modules.Functions:GetGame()
            _Player.Dates.LastSave = {
                Unix = os.time(),
                Human = os.date("%c")
            }
            Core.Modules.Database.Auth:updateOne({
                collection = 'Users',
                query = {
                    _id = SID
                },
                update = {
                    ["$set"] = _Player
                }
            }, cb)
        end
    end
}