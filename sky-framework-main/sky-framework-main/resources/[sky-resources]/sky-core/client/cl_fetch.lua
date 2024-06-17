Core.Modules.Fetch = {
    Player = function(self)
        if Core.Player ~= nil then
            return Core.Player
        end
        return nil
    end,
    Character = function(self)
        if Core.Player ~= nil then
            local Char = Core.Player:Get('Character')
            if Char ~= nil then
                return Char
            end
        end
        return nil
    end
}