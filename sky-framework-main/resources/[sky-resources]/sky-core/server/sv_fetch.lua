Core.Modules.Fetch = {
    Player = function(self, src)
        if src and Core.Players[src] then
            return Core.Players[src]
        end
        return nil
    end,
    Character = function(self, src)
        if src and Core.Players[src] then
            local Char = Core.Players[src]:Get('Character')
            if Char ~= nil then
                return Char
            end
        end
        return nil
    end,
    All = function(self)
        return Core.Players
    end
}