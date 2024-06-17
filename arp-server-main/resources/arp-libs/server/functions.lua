
function GetPlayerSteam(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            local steamHex = string.sub(id, string.len("steam:") + 1)
            return steamHex
        end
    end
    return false
end

function GetPlayerSteamDecimal(source)
    local steamHex = GetPlayerSteam(source)
    if not steamHex then return false end
    local steam64 = tonumber(steamHex, 16)
    return tostring(steam64)
end