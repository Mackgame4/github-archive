--[[
    Checklist:

    Lawyer/Judge - unfinished
    Find better showing ID (include licenses etc etc)
    Implement Give Car Key + other features
    Soft Cuffing

    
]]--

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('_core:getSharedObject', function(obj)
            ESX = obj
        end)
        Wait(500)
    end
end)




rootMenuConfig = {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            fuck = IsPedDeadOrDying(PlayerPedId())
            return not fuck
        end,
        subMenus = { "general:emotes" }
    }
}

newSubMenus = {
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "dp:RecieveMenu"
    },
}
