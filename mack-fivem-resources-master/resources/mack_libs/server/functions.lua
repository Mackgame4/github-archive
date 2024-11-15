ML.Server.GetPlayer = function(playerId)
    for k, v in ipairs(ML.Players) do
        if tonumber(v.id) == playerId then
            return v
        end
    end
end

ML.Server.GetIdentifiers = function(playerId)
    local steamIdentifier, licenseIdentifier, ipIdentifier = GetPlayerIdentifiers(playerId)
    for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'license:') then
            steamIdentifier = string.gsub(v, 'license:', '')
        elseif string.match(v, 'steam:') then
            steamIdentifier = string.gsub(v, 'steam:', '')
        elseif string.match(v, 'ip:') then
            ipIdentifier = string.gsub(v, 'ip:', '')
        end
    end
    return steamIdentifier, licenseIdentifier, ipIdentifier
end

ML.Server.GetIdentifier = function(playerId)
    for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'license:') then
            local identifier = string.gsub(v, 'license:', '')
            return identifier
        end
    end
end

ML.Server.GetPlayerCoords = function(playerId)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(playerId), true))
    return x, y, z
end