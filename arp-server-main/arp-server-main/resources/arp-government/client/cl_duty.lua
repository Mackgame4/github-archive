_dutyPoints = {
    { -- Mission Row PD Lobby
        center = vector3(440.31, -974.96, 30.69),
        length = 0.8,
        width = 1.0,
        heading = 0,
        minZ = 30.44,
        maxZ = 31.04,
    },
    { -- Mission Row PD Upstairs
        center = vector3(449.23, -985.56, 35.93),
        length = 0.8,
        width = 0.9,
        heading = 272,
        minZ = 35.63,
        maxZ = 35.83,
    },
    { -- Davis PD
        center = vector3(357.47, -1592.16, 29.29),
        length = 0.8,
        width = 1.2,
        heading = 321,
        minZ = 29.04,
        maxZ = 29.59
    },
    { -- Paleto Bay Front Desk
        center = vector3(-450.13, 6012.86, 31.72),
        length = 0.8,
        width = 1.2,
        heading = 45,
        minZ = 31.47,
        maxZ = 32.07
    }
}

function InitializeDutyZones()
    for k, v in ipairs(_dutyPoints) do 
        Interaction.Targeting:AddBoxZone('govDuty_' .. k, 'mdi-police-badge', v.center, v.length, v.width, {
            heading = v.heading,
            minZ = v.minZ,
            maxZ = v.maxZ,
            debugPoly = false,
        }, 1.5, { id = k }, true)
    end
end

AddEventHandler('Interaction:Targeting:ZoneAction', function(zone, data, key, mod)
    if ARP.StringStartsWith(zone, 'govDuty') then 
        local isGov = GOV:Data()
        if isGov then 
            Interaction:Menu({ title = 'Government', icon = 'mdi-police-badge-outline', text = 'Clock In/Out' }, {
                {
                    id = 'job',
                    title = isGov.Department,
                    text = isGov.Rank,
                    secondary = {
                        {
                            id = 'duty',
                            title = isGov.Duty and 'Go Off Duty' or 'Go On Duty',
                        }
                    },
                }
            }, function(p, s)
                if p == 'job' then 
                    if s == 'duty' then 
                        TriggerServerEvent('Government:Server:ToggleDuty')
                    end
                end
            end)
        else
            Notify:Error('Sorry, No Access', false, 'mdi-police-badge-outline')
        end
    end
end)