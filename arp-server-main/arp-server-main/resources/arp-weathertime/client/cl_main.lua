_current = 'EXTRASUNNY'
local _weatherState = _current
local _timeState = 0
local _timeOffset = 0
local _timer = 0
local _freezeState = false
local _blackoutState = false
local isTransionHappening = false

local _inSelectScreen = true

local _running = false

function OnComponentUpdate(c)
    if not c then 
        Citizen.CreateThread(function() 
            while not _running do
                SetRainFxIntensity(0.0)
                SetWeatherTypePersist('EXTRASUNNY')
                SetWeatherTypeNow('EXTRASUNNY')
                SetWeatherTypeNowPersist('EXTRASUNNY')
                NetworkOverrideClockTime(_inSelectScreen and 12 or 23, 0, 0)
                Citizen.Wait(5000)
            end
        end)
    end
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Sync', SYNC)
end)

function OnCharacterLoad()
    _inSelectScreen = false
    Components.Sync:Start()
end

function OnCharacterUnload()
    Components.Sync:Stop()
    _inSelectScreen = true
end

SYNC = {
    Start = function(self)
        if _running then return end
        local data = Components.Callbacks:Execute('Sync:Server:GetState', {})
        _running = true

        _current = data.weather
        _blackoutState = data.blackout
        _freezeState = data.frozen

        SetRainFxIntensity(-1.0)

        Citizen.CreateThread(function()
            local hour = 0
            local minute = 0
            while _running do
                local _timeOffset = GlobalState.timeOff
                local _timeState = GlobalState.time
                local newBaseTime = _timeState
                if GetGameTimer() - 500  > _timer then
                    newBaseTime = newBaseTime + 0.25
                    _timer = GetGameTimer()
                end
                if _freezeState then
                    _timeOffset = _timeOffset + _timeState - newBaseTime			
                end
                _timeState = newBaseTime
                hour = math.floor(((_timeState+_timeOffset)/60)%24)
                minute = math.floor((_timeState+_timeOffset)%60)
                NetworkOverrideClockTime(hour, minute, 0)
                Citizen.Wait(2000)
            end
        end)
        
        Citizen.CreateThread(function()
            while _running do
                if _weatherState ~= _current then
                    if not isTransionHappening then
                        isTransionHappening = true
                        _weatherState = _current
                        ClearOverrideWeather()
                        ClearWeatherTypePersist()
                        SetWeatherTypeOvertimePersist(_weatherState, 12.0)
                        Citizen.Wait(12000)
                        isTransionHappening = false
                    end
                end
                Citizen.Wait(100)
                SetBlackout(_blackoutState)

                StartBlackOutFixThread()

                SetWeatherTypePersist(_weatherState)
                SetWeatherTypeNow(_weatherState)
                SetWeatherTypeNowPersist(_weatherState)
                if _weatherState == 'XMAS' then
                    SetForceVehicleTrails(true)
                    SetForcePedFootstepsTracks(true)
                else
                    SetForceVehicleTrails(false)
                    SetForcePedFootstepsTracks(false)
                end
            end
        end)
    end,
    Stop = function(self)
        if not _running then return end
        Components.Logging:Debug('Sync', 'Stopping Sync')
        _running = false
        _blackOutFixThread = false
        Citizen.CreateThread(function() 
            while not _running do
                SetRainFxIntensity(0.0)
                SetWeatherTypePersist('EXTRASUNNY')
                SetWeatherTypeNow('EXTRASUNNY')
                SetWeatherTypeNowPersist('EXTRASUNNY')
                NetworkOverrideClockTime(_inSelectScreen and 12 or 23, 0, 0)
                Citizen.Wait(5000)
            end
        end)
    end,
}

RegisterNetEvent('Sync:Client:Weather')
AddEventHandler('Sync:Client:Weather', function(weather, override)
    _current = weather
end)

--[[RegisterNetEvent('Sync:Client:Time')
AddEventHandler('Sync:Client:Time', function(base, offset)
    _timeState = base
    _timeOffset = offset

    if _running then
        hour = math.floor(((_timeState+_timeOffset)/60)%24)
        minute = math.floor((_timeState+_timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)]]

RegisterNetEvent('Sync:Client:Freeze')
AddEventHandler('Sync:Client:Freeze', function(freeze)
    _freezeState = freeze
end)

RegisterNetEvent('Sync:Client:Blackout')
AddEventHandler('Sync:Client:Blackout', function(blackout)
    _blackoutState = blackout

    if not _blackoutState then 
        _blackOutFixThread = false
    end
    
    if _running then
        SetBlackout(_blackoutState)
        StartBlackOutFixThread()
    end
end)

local _blackOutFixThread = false

function StartBlackOutFixThread()
    if not _blackoutState or _blackOutFixThread then return end
    Citizen.CreateThread(function()
        while _running and _blackoutState and _blackOutFixThread do 
            Citizen.InvokeNative(0xE2B187C0939B3D32, 0)
            Citizen.Wait(5)
        end
    end)
end