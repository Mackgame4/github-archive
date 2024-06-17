local DISCORD_TEXT = 'Character Selection'
local DISCORD_TEMP = false
local serverIP = '127.0.0.1:30120'
SetDiscordAppId(724280843765284917)

function GetPlayerCountPrefix(current, max)
    return ('[%s/%s] '):format(current, max)
end

Citizen.CreateThread(function()
    SetDiscordRichPresenceAsset('logo2')
    SetDiscordRichPresenceAssetText('AuthenticRP - Serious RP')
    SetDiscordRichPresenceAction(0, 'Get Whitelisted', "https://authenticrp.com/")
    SetRichPresence(GetPlayerCountPrefix(GlobalState.UserCount, GlobalState.UserMax) .. DISCORD_TEXT)

    if GlobalState.ARP ~= nil and GlobalState.ARP.development then 
        SetDiscordRichPresenceAssetSmall('cog')
        SetDiscordRichPresenceAssetSmallText('Development Server')
    end

    while true do 
        Citizen.Wait(30000)
        SetDiscordRichPresenceAction(1, string.format('Join %s Other Player%s', GlobalState.UserCount, GlobalState.UserCount == 1 and '' or 's'), 'https://authenticrp.com') -- Lead to main website for now // join link can be added later
        if DISCORD_TEMP then 
            SetRichPresence(GetPlayerCountPrefix(GlobalState.UserCount, GlobalState.UserMax) .. DISCORD_TEMP)
        else
            SetRichPresence(GetPlayerCountPrefix(GlobalState.UserCount, GlobalState.UserMax) .. DISCORD_TEXT)
        end
    end
end)


COMPONENTS.Discord = {
    _protected = true,
    SetText = function(self, text)
        DISCORD_TEXT = text
        if not DISCORD_TEMP then 
            SetRichPresence(GetPlayerCountPrefix(GlobalState.UserCount, GlobalState.UserMax) .. DISCORD_TEXT)
        end
    end,
    SetTemp = function(self, text, time)
        if time == nil then time = 2000 end
        DISCORD_TEMP = text
        SetRichPresence(GetPlayerCountPrefix(GlobalState.UserCount, GlobalState.UserMax) .. DISCORD_TEMP)
        Citizen.SetTimeout(time, function()
            DISCORD_TEMP = false
            SetRichPresence(GetPlayerCountPrefix(GlobalState.UserCount, GlobalState.UserMax) .. DISCORD_TEXT)
        end)
    end,
}