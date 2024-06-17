local FMCLR = {
    white = '^7',
    yellow = '^3',
    red = '^1',
    green = '^2',
    darkred = '^8',
    lightblue = '^5',
    blue = '^4',
    darkblue = '^9',
    purple = '^6',
}

local loggingColours = {
    info = FMCLR.lightblue,
    error = FMCLR.darkred,
    warn = FMCLR.yellow,
    debug = FMCLR.green,
}

COMPONENTS.Logging = {
    _protected = false,

    Info = function(self, title, message, overrides)
        doALog('info', title, message, overrides)
    end,
    Error = function(self, title, message, overrides)
        doALog('error', title, message, overrides)
    end,
    Warn = function(self, title, message, overrides)
        doALog('warn', title, message, overrides)
    end,
    Debug = function(self, title, ...)
        local args = {...}
        if #args <= 0 then return end
        if IsDuplicityVersion() or (not IsDuplicityVersion() and GlobalState.ARP ~= nil and GlobalState.ARP.development) then 
            local logString = tostring(args[1])
            for i = 2, #args do
                logString = logString .. '\t' .. tostring(args[i])
            end
            doALog('debug', title, logString)
        end
    end,
}

function doALog(level, title, message, overrides)
    local sendToDiscord = true
    if type(overrides) == 'table' and overrides.skipDiscord then
        sendToDiscord = false
    end

    if title then 
        title = string.upper(title)
    else
        title = 'ARP'
    end

    local logMessage = ('[%s%s^7][^6%s^7]'):format(loggingColours[level], string.upper(level), title)

    if level == 'debug' then
        sendToDiscord = false
        logMessage = logMessage .. FMCLR.yellow
    end

    logMessage = logMessage .. ' ' .. message
    Citizen.Trace(logMessage .. FMCLR.white .. '\n')

    if IsDuplicityVersion() and COMPONENTS.API.Initialised then
        local log = COMPONENTS.API:DoRequest('POST', 'game/logging', {
            level = level,
            title = title, 
            log = message,
        })
    end
end