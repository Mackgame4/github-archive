Core.Modules.Utils = Core.Modules.Utils or {}

Core.Modules.Utils.Print = function(self, t, s)
    if t then
        if type(t) ~= 'table' then 
            Core.Modules.Logger:Trace("Utils", "^1 [^3debug^1] ["..type(t).."] ^7 "..t, { console = true })
            return
        else
            for k, v in pairs(t) do
                local kfmt = '["' .. tostring(k) ..'"]'
                if type(k) ~= 'string' then
                    kfmt = '[' .. k .. ']'
                end
                local vfmt = '"'.. tostring(v) ..'"'
                if type(v) == 'table' then
                    self:Print(v, (s or '')..kfmt)
                else
                    if type(v) ~= 'string' then
                        vfmt = tostring(v)
                    end
                    Core.Modules.Logger:Trace("Utils", " ^1[^3debug^1] ["..type(t).."]^7 "..(s or '')..kfmt..' = '..vfmt, { console = true })
                end
            end
        end
    else
        Core.Modules.Logger:Error("Utils", "^1Error Printing Request - The Passed through variable seems to be nil^7", { console = true })
    end
end

Core.Modules.Utils.GetMockChars = function(self)
    return { {_new = true, Slot = 1}, {_new = true, Slot = 2}, {_new = true, Slot = 3}, {_new = true, Slot = 4} }
end

Core.Modules.Utils.GetTableLength = function(self, t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

Core.Modules.Utils.GetTableKeys = function(self, t)
    local keys = {}
    for k,v in pairs(t) do
        table.insert(keys,k)
    end
    return keys
end

Core.Modules.Utils.Round = function(self, n, precision)
    if precision then
        return math.floor( (n * 10^precision) + 0.5 ) / (10^precision)
    end
    return math.floor( n + 0.5 )
end

Core.Modules.Utils.FormatCoord = function(self, coord)
	if coord == nil then return "unknown" end 
	return tonumber(string.format("%.2f", coord))
end