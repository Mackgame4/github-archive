AddEventHandler('Logger:Log', function(component, log, flags, extra) Core.Modules.Logger:Log(component, log, flags, extra) end)
AddEventHandler('Logger:Trace', function(component, log, flags, extra) Core.Modules.Logger:Trace(component, log, flags, extra) end)
AddEventHandler('Logger:Info', function(component, log, flags, extra) Core.Modules.Logger:Info(component, log, flags, extra) end)
AddEventHandler('Logger:Success', function(component, log, flags, extra) Core.Modules.Logger:Success(component, log, flags, extra) end)
AddEventHandler('Logger:Warn', function(component, log, flags, extra) Core.Modules.Logger:Warn(component, log, flags, extra) end)
AddEventHandler('Logger:Error', function(component, log, flags, extra) Core.Modules.Logger:Error(component, log, flags, extra) end)
AddEventHandler('Logger:Critical', function(component, log, flags, extra) Core.Modules.Logger:Critical(component, log, flags, extra) end)
Core.Modules.Logger = {
    _required = { 'Log' },
    _name = 'base',
    Trace = function(self, component, log, flags, data)
        doLog(1, component, log, flags, data)
    end,
    Info = function(self, component, log, flags, data)
        doLog(2, component, log, flags, data)
    end,
    Success = function(self, component, log, flags, data)
        doLog(3, component, log, flags, data)
    end,
    Warn = function(self, component, log, flags, data)
        doLog(4, component, log, flags, data)
    end,
    Error = function(self, component, log, flags, data)
        doLog(5, component, log, flags, data)
    end,
    Critical = function(self, component, log, flags, data)
        doLog(6, component, log, flags, data)
    end,
}

function doLog(level, component, log, flags, data)
    Citizen.CreateThread(function()
        local prefix = '[TRACE]'
        local mPrefix = '[TRACE]'

        if level > 1 then
            if level == 2 then
                prefix = '[^5INFO^7]'
                mPrefix = '[INFO]'
            elseif level == 3 then
                prefix = '[^2SUCCESS^7]'
                mPrefix = '[SUCCESS]'
            elseif level == 4 then
                prefix = '[^3WARN^7]'
                mPrefix = '[WARN]'
            elseif level == 5 then
                prefix = '[^1ERROR^7]'
                mPrefix = '[ERROR]'
            elseif level == 6 then
                prefix = '[^9CRITICAL^7]'
                mPrefix = '[CRITICAL]'
            end
        end

        if flags == nil then flags = { console = true } end
        if flags.console then
            local formattedLog = string.format('%s [^5%s^7] %s', prefix, component, log)
            print(formattedLog)
        end
    end)
end