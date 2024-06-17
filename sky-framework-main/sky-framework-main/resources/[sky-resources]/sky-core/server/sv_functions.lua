Core.Modules.Functions = Core.Modules.Functions or {}

Core.Modules.Functions.GetIdentifiers = function(self, src)
    if src == nil or type(src) ~= "number" or src == 0 then return { error = "We could not load your Identifiers, Please try reconnecting"} end
    local Identifiers = {}
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(id, 1, string.len("license:")) == "license:" then
            Identifiers['License'] = string.sub(id, string.len("license:") + 1)
        end
        if string.sub(id, 1, string.len("discord:")) == "discord:" then
            Identifiers['Discord'] = string.sub(id, string.len("discord:") + 1)
        end
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            Identifiers['Steam'] = string.sub(id, string.len("steam:") + 1)
        end
        if string.sub(id, 1, string.len("license2:")) == "license2:" then
            Identifiers['License2'] = string.sub(id, string.len("license2:") + 1)
        end
        if string.sub(id, 1, string.len("fivem:")) == "fivem:" then
            Identifiers['FiveM'] = string.sub(id, string.len("fivem:") + 1)
        end
        if string.sub(id, 1, string.len("ip:")) == "ip:" then
            Identifiers['IP'] = string.sub(id, string.len("ip:") + 1)
        end
        if string.sub(id, 1, string.len("live:")) == "live:" then
            Identifiers['Live'] = string.sub(id, string.len("live:") + 1)
        end
    end

    if Identifiers and type(Identifiers) == "table" then
        if Identifiers['Steam'] == nil then return { error = "Your Steam Identifier is Required, Try Closing FiveM, Restarting Steam and Reconnecting." } end 
        if Core.Modules.Players:DuplicityCheck(Identifiers['Steam']) then return { error = "Your Steam Identifier is being used by another player, If you have recently disconnected or crashed please wait a bit longer before attempting to reconnect." } end
        if Core.Config.Main.RequiredIdentifiers.Discord and Identifiers['Discord'] == nil then return { error = "Your Discord Identifier is Required, Try Closing FiveM, Restarting Discord and Reconnecting." } end 
        if Core.Config.Main.RequiredIdentifiers.License and Identifiers['License'] == nil then return { error = "Your License Identifier is required." } end 
        if Core.Config.Main.RequiredIdentifiers.FiveM and Identifiers['FiveM'] == nil then return { error = "Your FiveM Identifier is Required, Ensure your logged into your FiveM Client with your CitizenFX forum account." } end 
        if Core.Config.Main.RequiredIdentifiers.IP and Identifiers['IP'] == nil then return { error = "Hmm? This shouldn't actually happen but your IP is not here?" } end 
        if Core.Config.Main.RequiredIdentifiers.Live and Identifiers['Live'] == nil then return { error = "Your Microsoft Live Identifier is missing." } end
        return Identifiers
    end
    return { error = "There was a problem checking your Identifiers, please try reconnecting."}
end


