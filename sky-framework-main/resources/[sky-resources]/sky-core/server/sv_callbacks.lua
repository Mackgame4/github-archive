local _sCallbacks = {}
local _cCallbacks = {}

Core.Modules.Callbacks = {
    _required = { 'RegisterServerCallback', 'DoServerCallback', 'ClientCallback' },
    _name = 'base',
    RegisterServerCallback = function(self, event, cb)
        _sCallbacks[event] = cb
    end,
    DoServerCallback = function(self, source, event, data)
        if _sCallbacks[event] ~= nil then
            Citizen.CreateThread(function()
                _sCallbacks[event](source, data, function(...)
                    TriggerClientEvent('Callbacks:Client:ReceiveCallback', source, event, ...)
                end)
            end)
        end
    end,
    ClientCallback = function(self, source, event, data, cb)
        if data == nil then data = {} end

        id = event
        _cCallbacks[id] = cb
        TriggerClientEvent('Callbacks:Client:TriggerEvent', source, event, data)
    end
}

Core.Modules.Callbacks:RegisterServerCallback('OneSync:Server:SetWorld', function(source, world, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        cb(Player.OneSync:SetWorld(world))
        return
    end
    cb(false)
end)

Core.Modules.Callbacks:RegisterServerCallback('OneSync:Server:SetGameWorld', function(source, world, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        cb(Player.OneSync:SetGameWorld( ))
        return
    end
    cb(false)
end)

Core.Modules.Callbacks:RegisterServerCallback('Player:Server:GetPermission', function(source, data, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        cb(Player.Permissions:GetPermission())
        return
    end
    cb("user")
end)

Core.Modules.Callbacks:RegisterServerCallback('Player:Server:CheckPermission', function(source, perms, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        if Player.Permissions:GetPermission() == "god" then cb(true) return end
        if type(perms) == "table" then
            for k, v in pairs(perms) do
                if type(v) == "string" then
                    if v == "user" then cb(true) return end
                    if Player.Permissions:GetPermission() == string.lower(v) then
                        cb(true)
                        return
                    end
                end
            end
        elseif type(perms) == "string" then
            if perms == "user" then cb(true) return end
            if Player.Permissions:GetPermission() == string.lower(perms) then
                cb(true)
                return
            end
        end
    end
    cb(false)
end)

Core.Modules.Callbacks:RegisterServerCallback('OneSync:Server:SetWorldLockdown', function(source, lock, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        cb(Player.OneSync:SetWorldLockdown(lock))
        return
    end
    cb(false)
end)

Core.Modules.Callbacks:RegisterServerCallback('OneSync:Server:SetWorldPopulation', function(source, pop, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        cb(Player.OneSync:SetWorldPopulation(pop))
        return
    end
    cb(false)
end)

Core.Modules.Callbacks:RegisterServerCallback('OneSync:Server:SetOwnWorld', function(source, world, cb)
    local _src = source
    local Player = Core.Players[_src]
    if Player ~= nil then
        cb(Player.OneSync:SetOwnWorld())
        return
    end
    cb(false)
end)

RegisterServerEvent('Callbacks:Server:TriggerEvent')
AddEventHandler('Callbacks:Server:TriggerEvent', function(token, event, data)
    if Core.Modules.Tokenizer == nil or not Core.Modules.Tokenizer:ValidateToken(token, source, GetCurrentResourceName()) then return end
    if data == nil then data = {} end
    Core.Modules.Callbacks:DoServerCallback(source, event, data)
end)

RegisterServerEvent('Callbacks:Server:ReceiveCallback')
AddEventHandler('Callbacks:Server:ReceiveCallback', function(token, event, ...)
    if Core.Modules.Tokenizer == nil or not Core.Modules.Tokenizer:ValidateToken(token, source, GetCurrentResourceName()) then return end
    local id = event
    if _cCallbacks[id] ~= nil then
        _cCallbacks[id](...)
        _cCallbacks[id] = nil
    end
end)