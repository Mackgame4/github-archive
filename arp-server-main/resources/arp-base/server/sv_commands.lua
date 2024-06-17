AddEventHandler('chatMessage', function(source)
    CancelEvent()
end)

RegisteredCommands = {}

local function doCommandFailed(src, message)
    if src > 0 then 
        TriggerClientEvent('ARP:Chat:SystemMessage', src, 'Command Failed', message)
    else 
        print('Command Failed -', message)
    end
end

local function checkCommandArguments(realArgs, passedArgs)
    if type(realArgs) ~= 'table' then return true end
    for k, v in ipairs(realArgs) do
        if v.required and (passedArgs[k] == nil or not passedArgs[k]) then 
            return false
        end
    end
    return true
end

COMPONENTS.Commands = {
    _protected = false,
    Add = function(self, command, cb, help, parameters, log)
        RegisteredCommands[command] = {
            command = command,
            cb = cb,
            help = help,
            parameters = parameters,
            log = log,
        }

        RegisterCommand(command, function(src, args, raw)
            local cmd = RegisteredCommands[command]
            if not cmd then return end
            if src <= 0 then return end
            local User = COMPONENTS.Users:Source(src)
            if User and checkCommandArguments(cmd.parameters, args) then 
                cmd.cb(src, args, raw)
                if cmd.log then 
                    COMPONENTS.Logging:Info('Commands', ('Command "/%s" Executed By %s. Arguments: %s'):format(cmd.command, COMPONENTS.Users:GenerateLogString(User), json.encode(args)))
                end
            else
                doCommandFailed(src, 'Missing Arguments')
            end
        end, false)
    end,
    AddStaff = function(self, command, cb, help, parameters, allowConsole, log)
        if help then help = '[Staff] '.. help end
        
        RegisteredCommands[command] = {
            command = command,
            cb = cb,
            help = help,
            parameters = parameters,
            console = allowConsole,
            log = log,
        }

        RegisterCommand(command, function(src, args, raw)
            local cmd = RegisteredCommands[command]
            if not cmd then return end
            local fromConsole = src == 0
            if fromConsole and not cmd.console then return end
            local User = COMPONENTS.Users:Source(src)
            if fromConsole or (User and User.Permissions.IsStaff) then 
                if checkCommandArguments(cmd.parameters, args) then 
                    cmd.cb(src, args, raw)
                    if cmd.log then 
                        if fromConsole then 
                            COMPONENTS.Logging:Info('Commands', ('Staff Command "/%s" Executed By Console.'):format(cmd.command))
                        else 
                            COMPONENTS.Logging:Info('Commands', ('Staff Command "/%s" Executed By %s. Arguments: %s'):format(cmd.command, COMPONENTS.Users:GenerateLogString(User), json.encode(args)))
                        end
                    end
                else
                    doCommandFailed(src, 'Missing Arguments')
                end
            else
                doCommandFailed(src, 'Insufficient Permissions')
            end
        end, false)
    end,
    AddDeveloper = function(self, command, cb, help, parameters, allowConsole, log)
        if help then help = '[Dev] '.. help end

        RegisteredCommands[command] = {
            command = command,
            cb = cb,
            help = help,
            parameters = parameters,
            console = allowConsole,
            log = log,
        }

        RegisterCommand(command, function(src, args, raw)
            local cmd = RegisteredCommands[command]
            if not cmd then return end
            local fromConsole = src == 0
            if fromConsole and not cmd.console then return end
            local User = COMPONENTS.Users:Source(src)
            if fromConsole or (User and User.Permissions.IsDev) then 
                if checkCommandArguments(cmd.parameters, args) then 
                    cmd.cb(src, args, raw)
                    if cmd.log then 
                        if fromConsole then 
                            COMPONENTS.Logging:Info('Commands', ('Developer Command "/%s" Executed By Console.'):format(cmd.command))
                        else 
                            COMPONENTS.Logging:Info('Commands', ('Developer Command "/%s" Executed By %s. Arguments: %s'):format(cmd.command, COMPONENTS.Users:GenerateLogString(User), json.encode(args)))
                        end
                    end
                else
                    doCommandFailed(src, 'Missing Arguments')
                end
            else
                doCommandFailed(src, 'Insufficient Permissions')
            end
        end, false)
    end,
    AddConsole = function(self, command, cb)
        RegisteredCommands[command] = {
            command = command,
            cb = cb,
            consoleOnly = true
        }
        RegisterCommand(command, function(src, args, raw)
            local cmd = RegisteredCommands[command]
            if not cmd then return end
            if src ~= 0 then return end
            cmd.cb(args, raw)
            COMPONENTS.Logging:Info('Commands', ('Console Command "/%s" Executed.'):format(command), { skipDiscord = true })
        end, true)
    end,
    CommandFailure = function(self, src, message)
        doCommandFailed(src, message)
    end
}

exports('GetChatSuggestions', function()
    local Suggestions = {}
    for cmd, cmdData in pairs(RegisteredCommands) do 
        if not cmdData.consoleOnly then 
            Suggestions[cmd] = {
                name = cmd,
                help = cmdData.help,
                params = cmdData.parameters
            }
        end
    end
    return Suggestions
end)