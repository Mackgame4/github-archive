local _availableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

local _currentWeather = "CLEARING"
local _dynamicWeather = true
local _time = 0
local _timeOffset = 0
local _frozenTime = false
local _blackoutState = false

local started = false

function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        Components.Commands:AddStaff('weather', function(src, args, raw)
            if not args[1] then return end
            Components.Sync.Set:Weather(args[1])
        end, 'Set the current weather', {
            { name = 'Weather Type', help = 'The type of weather to set it to.' }
        })

        Components.Commands:AddStaff('time', function(src, args, raw)
            if args[1] then 
                Components.Sync.Set:ExactTime(args[1], 0)
            end
        end, 'Set the current time', {
            { name = 'Hour', help = 'The hour to set to. (0-23)'}
        })

        Components.Commands:AddStaff('blackout', function(src, args, raw)
            Components.Sync.Set:Blackout(not _blackoutState)
        end, 'Toggle Blackout')

        Components.Commands:AddStaff('freezetime', function(src, args, raw)
            Components.Sync.Set:Freeze('time')
        end, 'Toggle Time Freezing')

        Components.Commands:AddStaff('freezeweather', function(src, args, raw)
            Components.Sync.Set:Freeze('weather')
        end, 'Toggle Weather Freezing')
    end

    if not c or c == 'Callbacks' then 
        Components.Callbacks:Register('Sync:Server:GetState', function(src, cb)
            cb({ 
                weather = _currentWeather, 
                blackout = _blackoutState,

                frozen = _frozenTime 
            })
        end)
    end 

    if not c then 
        GlobalState.time = 0
        GlobalState.timeOff = 0

        if not started then
            started = true

            --[[Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(20000)
                    TriggerClientEvent('Sync:Client:Time', -1, _time, _timeOffset)
                end
            end)]]
            
            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(120000) -- Do you even need to send it at all - it emits when updating?
                    TriggerClientEvent('Sync:Client:Weather', -1, _currentWeather)
                end
            end)
            
            Citizen.CreateThread(function()
                Components.Sync:NextWeatherStage()
            
                while true do
                    local random = ARP.RandomNumber(90, 220) * 1000
                    Citizen.Wait(random)
                    if _isDynamic then
                        Components.Sync:NextWeatherStage()
                    end
                end
            end)
        end
    end
end

SYNC = {
    Get = {
        IsFrozen = function(self, element)
            if element == 'weather' then
                return _isDynamic
            else
                return _frozenTime
            end
        end,
        IsBlackout = function(self)
            return _blackoutState
        end,
        Weather = function(self)
            return _currentWeather
        end,
    },
    Set = {
        Freeze = function(self, element)
            if element == 'weather' then
                _isDynamic = not _isDynamic
                TriggerClientEvent('Client:Notify', -1, 'info', 'Weather ' .. (_isDynamic and 'Frozen' or 'UnFrozen'), false, 'mdi-weather-cloudy')
                Components.Logging:Debug('Sync', 'Weather ^5' .. (_isDynamic and 'Frozen' or 'UnFrozen^7'))
            else
                _frozenTime = not _frozenTime
                TriggerClientEvent('Client:Notify', -1, 'info', 'Time ' .. (_frozenTime and 'Frozen' or 'UnFrozen'), false, 'mdi-clock-outline')
                Components.Logging:Debug('Sync', 'Time ^5' .. (_isDynamic and 'Frozen' or 'UnFrozen^7'))
            end
        end,
        Blackout = function(self, state)
            _blackoutState = state
            TriggerClientEvent('Sync:Client:Blackout', -1, _blackoutState)
            Components.Logging:Debug('Sync', 'Blackout ^5' .. (_blackoutState and 'Enabled' or 'Disabled^7'))
        end,
        Weather = function(self, type)
            local actualType = string.upper(type)
            if ARP.DoesTableHaveValue(_availableWeatherTypes, actualType) then 
                _currentWeather = actualType
                TriggerClientEvent('Sync:Client:Weather', -1, _currentWeather)
                Components.Logging:Debug('Sync', 'Weather Updated: ^5' .. _currentWeather .. '^7')
                return true
            else
                return false
            end
        end,
        ExactTime = function(self, hour, minute)
            local argh = tonumber(hour)
            local argm = tonumber(minute)
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end

            local _time = GlobalState.time
            local _timeOffset = GlobalState.timeOff
            --[[local newtime = math.floor(((_time+_timeOffset)/60)%24) .. ":"
            local minute = math.floor((_time+_timeOffset)%60)
            if minute < 10 then
                newtime = newtime .. "0" .. minute
            else
                newtime = newtime .. minute
            end]]

            --TriggerClientEvent('Sync:Client:Time', -1, _time, _timeOffset)
        end,
    },
    NextWeatherStage = function(self)
        if _currentWeather == "CLEAR" or _currentWeather == "CLOUDS" or _currentWeather == "EXTRASUNNY" then
            local newWeather = ARP.RandomNumber(1, 5)
            if newWeather == 2 then
                _currentWeather = "CLEARING"
            else
                _currentWeather = "OVERCAST"
            end
        elseif _currentWeather == "CLEARING" or _currentWeather == "OVERCAST" then
            local newWeather = ARP.RandomNumber(1, 10)
            if newWeather == 1 then
                if _currentWeather == "CLEARING" then 
                    _currentWeather = "FOGGY" 
                else 
                    _currentWeather = "RAIN" 
                end
            elseif newWeather == 2 then
                _currentWeather = "CLOUDS"
            elseif newWeather == 3 or newWeather == 4 then
                _currentWeather = "CLEAR"
            elseif newWeather == 5 then
                _currentWeather = "FOGGY"
            elseif newWeather == 6 or newWeather == 7 then
                _currentWeather = "SMOG"
            else
                _currentWeather = "EXTRASUNNY"
            end
        elseif _currentWeather == "THUNDER" or _currentWeather == "RAIN" then
            _currentWeather = "CLEARING"
        elseif _currentWeather == "SMOG" or _currentWeather == "FOGGY" then
            _currentWeather = "CLEAR"
        end

        Components.Logging:Debug('Sync', 'Weather Updated: ^5' .. _currentWeather .. '^7')
        TriggerClientEvent('Sync:Client:Weather', -1, _currentWeather, false)
    end,
}

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Sync', SYNC)
end)

function ShiftToMinute(minute)
    local _time = GlobalState.time
    local _timeOffset = GlobalState.timeOff
    GlobalState.timeOff = _timeOffset - ( ( (_time+_timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    local _time = GlobalState.time
    local _timeOffset = GlobalState.timeOff
    GlobalState.timeOff = _timeOffset - ( ( ((_time+_timeOffset)/60) % 24 ) - hour ) * 60
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        local _timeOffset = GlobalState.timeOff
        if _frozenTime then
            GlobalState.timeOff = _timeOffset + _time - newBaseTime			
        end
        GlobalState.time = newBaseTime
    end
end)