Logger = {
    info = function(msg)
        log("^0Info^7", GetCurrentResourceName(), msg)
    end,
    warning = function(msg)
        log("^4Warning^7", GetCurrentResourceName(), msg)
    end,
    error = function(msg)
        log("^1Error^7", GetCurrentResourceName(), msg, true)
    end,
}

Logger.warn = Logger.warning

exports('info', Logger.info)

exports('warning', Logger.warning)

exports('warn', Logger.warning)

exports('error', Logger.error)

function log(level, resource, msg, verbose)
    if Config.Verbose or verbose then
        print(("[%s][^4%s^7] %s"):format(level, resource, msg))
    end
end