GovCData = false

GOV = {
    Data = function(self)
        return GovCData
    end,
    OnDuty = function(self)
        if GovCData and GovCData.Duty then 
            return true
        end
        return false
    end
}

RegisterNetEvent('Government:Client:OnGovChar')
AddEventHandler('Government:Client:OnGovChar', function(gov)
    local Character = Characters:Current()
    if gov and Character then 
        GovCData = gov
    else
        GovCData = false
    end
end)

RegisterNetEvent('Government:Client:DutyChange')
AddEventHandler('Government:Client:DutyChange', function(duty)
    local Character = Components.Characters:Current()
    if GovCData and Character then 
        GovCData.Duty = duty
        local formattedName = ('%s. %s'):format(Character:GetData('FirstName'):sub(1, 1), Character:GetData('LastName'))
        if duty then 
            Notify:Send('_', GovCData.Department, ('Welcome %s %s'):format(GovCData.RankAbbr, formattedName), 'mdi-police-badge-outline', 10000)
        else
            Notify:Send('_', GovCData.Department, ('Now Off Duty - %s %s'):format(GovCData.RankAbbr, formattedName), 'mdi-police-badge-outline', 10000)
        end
    end
end)

RegisterNetEvent('Government:Client:OnGovDataUpdate')
AddEventHandler('Government:Client:OnGovDataUpdate', function(data)
    if GovCData and data then 
        GovCData.Data = data
    end
end)


function OnComponentUpdate(c)
    if not c then 
        InitializeDutyZones()
    end
end

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Gov', GOV)
end)