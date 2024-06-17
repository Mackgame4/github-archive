Core.Modules.Functions = Core.Modules.Functions or {}

Core.Modules.Functions.SetGame = function(self)
    if GetConvar('gamename', 'gta5') == "rdr3" then
        Core.Modules.Proxy.ServerMeta = {
            Game = "rdr3",
            GameName = "Red Dead Redemption 2",
            CFXVer = "redm",
        }
    else
        Core.Modules.Proxy.ServerMeta = {
            Game = "gta5",
            GameName = "Grand Theft Auto: V",
            CFXVer = "fivem",
        }
    end
end

Core.Modules.Functions.IsRDR = function(self)
    if GetConvar('gamename', 'gta5') == "rdr3" then
        return true
    else
        return false
    end
end

Core.Modules.Functions.GetGame = function(self)
    if GetConvar('gamename', 'gta5') == "rdr3" then
        return "Red Dead Redemption 2"
    else
        return "Grand Theft Auto: V"
    end
end