ARP = {}

ARP.FormatTable = function(tbl, indent)
    if type(tbl) ~= "table" then return tbl end
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2 
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "   
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. ARP.FormatTable(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
end 

ARP.PrintTable = function(table)
    print("\n-----------------------\n", ARP.FormatTable(table), "\n-----------------------\n")
end

ARP.GetTableLength = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

ARP.GetTableKeys = function(t)
    local keys = {}
    for k,v in pairs(t) do
        table.insert(keys,k)
    end
    return keys
end

ARP.DoesTableHaveValue = function(t, val)
    for k, v in pairs(t) do 
        if v == val then 
            return true 
        end
    end
    return false
end

ARP.GetPositionInOrderedTable = function(t, elem)
    for k, v in ipairs(t) do 
        if v == elem then 
            return k 
        end
    end
    return nil
end

ARP.GetPositionInTable = function(t, elem)
    for k, v in pairs(t) do 
        if v == elem then 
            return k 
        end
    end
    return nil
end


-- split a string
function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
        table.insert( result, string.sub( self, from , delim_from-1 ) )
        from  = delim_to + 1
        delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

-- Maths - How Fun...

ARP.Round = function(num, decimals)
    return tonumber(string.format("%." .. (decimals or 0) .. "f", num))
end

ARP.RoundVector3 = function(vect, decimals)
    return vector3(
        ARP.Round(vect.x, decimals),
        ARP.Round(vect.y, decimals),
        ARP.Round(vect.z, decimals)
    )
end

ARP.RandomNumber = function(min, max) -- why are random numbers so dumb in lua
    math.randomseed(GetGameTimer() * math.random(1, 999)) -- just please
    math.random(); math.random(); math.random()
    return math.random(min, max)
end

ARP.RoundEven = function(num)
    return 2 * ARP.Round(num / 2, 0)
end

ARP.StringStartsWith = function(str, start)
    return str:sub(1, #start) == start
end

ARP.StringSplit = function(inputstr, sep) -- Does this even work
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

ARP.StringToTable = function(inputstr)
    local res = {}
    inputstr:gsub(".", function(c) 
        table.insert(res, c) 
    end)
    return res
end

ARP.RandomFromArrayTable = function(table)
    if #table <= 0 then return end
    return table[ARP.RandomNumber(1, #table)]
end

ARP.RandomFromString = function(length, charset)
    if length <= 0 then return '' end
    local availableChars = ARP.StringToTable(charset)
    local randomStringSet = {}
    for i = 1, length do 
        table.insert(randomStringSet, ARP.RandomFromArrayTable(availableChars))
    end
    return table.concat(randomStringSet, '')
end

if IsDuplicityVersion() then 
    ARP.GetUnix = function()
        return os.time(os.date("!*t"))
    end
end