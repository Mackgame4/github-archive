ActiveEmployees = {}

function OnComponentUpdate(c)
    if not c or c == 'Commands' then 
        Components.Commands:AddStaff('setgov', function(src, args)
            local cid, dep, rank = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

            if not Characters:IsValid(cid) then 
                TriggerClientEvent('Client:Notify', src, 'error', 'Government Whitelisting', 'Can\'t Whitelist a CID that Doesn\'t Exist', 'mdi-police-badge-outline')
                return
            end

            local success = Components.Gov:Add(cid, dep, rank)
            if success then 
                TriggerClientEvent('Client:Notify', src, '_', 'Government Whitelisting', ('CID %s Was Added to Department: %s, Rank: %s'):format(cid, dep, rank), 'mdi-police-badge-outline')
                Components.Logging:Info('Gov', ('CID %s Was Added to Department: %s, Rank: %s'):format(cid, dep, rank))
            else
                TriggerClientEvent('Client:Notify', src, 'error', 'Government Whitelisting', 'Invalid Department or Rank', 'mdi-police-badge-outline')
            end
        end, 'Add a Government Employee', { 
            { name = 'CID', help = 'Character\'s CID' },
            { name = 'Department', help = 'Department\'s ID' },
            { name = 'Rank', help = 'Rank ID' },
        }, true)

        Components.Commands:Add('mygov', function(src, args)
            local Character = Components.Characters:Source(src)
            if not Character then return end
            local CID = Character:GetData('CID')
            local activeGov = Components.Gov.Active:Get(CID)
            if not activeGov then 
                local gov = Components.Gov:Get(CID)
                if gov then 
                    gov.Source = src
                    gov.Duty = false
                    ActiveEmployees[CID] = gov
                    TriggerClientEvent('Government:Client:OnGovChar', src, gov)
                    activeGov = gov
                end
            end
            TriggerClientEvent('ARP:Chat:SystemMessage', src, activeGov.Department, activeGov.Rank)
        end, 'View Your Character\'s Government Info')
    end
end

GOV = {
    Add = function(self, cid, dep, rank, metadata)
        if Components.Characters:IsValid(cid) and DoesDepartmentExist(dep) and DoesRankExistInDepartment(dep, rank) then 
            local s = UpdateCharacterGovData(cid, dep, rank, metadata)
            return s
        end
        return false
    end,
    Get = function(self, cid)
        if Components.Characters:IsValid(cid) then 
            local gov = GetCharacterGovData(cid)
            if gov and gov.Department and gov.Rank then 
                local data = GetDepartmentDataFromCharacterGovData(gov.Department, gov.Rank)
                if not data then return false end
                data.CID = gov.CID
                data.Data = gov.Data

                return data
            end
        end
        return false
    end,
    Active = {
        Get = function(self, cid, duty)
            if ActiveEmployees[cid] and (not duty or (duty and ActiveEmployees[cid].Duty)) then 
                return ActiveEmployees[cid]
            end
            return false
        end,
        GetAll = function(self, duty)
            local retval = {}
            for cid, v in pairs(ActiveEmployees) do 
                if not duty or (duty and v.Duty) then 
                    table.insert(retval, v)
                end
            end
            return retval
        end,
        GetAllFromDepartment = function(self, departmentId, duty)
            local retval = {}
            for cid, v in pairs(ActiveEmployees) do 
                if (v.Department == departmentId) and (not duty or (duty and v.Duty)) then 
                    table.insert(retval, v)
                end
            end
            return retval
        end,
        GetAllFromDepartmentType = function(self, departmentType, duty)
            local retval = {}
            for cid, v in pairs(ActiveEmployees) do 
                if (GetDepartmentType(v.Department) == departmentType) and (not duty or (duty and v.Duty)) then 
                    table.insert(retval, v)
                end
            end
            return retval
        end,
    },
    Data = {
        Set = function(self, cid, k, v)
            local currentData = GetGovMetaData(cid)
            if currentData == nil then 
                currentData = {}
            end

            currentData[k] = v
        
            local update = Components.DB:UpdateOne('gov_employees', { CID = cid }, { 
                ['$set'] = currentData
            })

            if update.success then 
                UpdateActiveCharactersMetaData(cid, currentData)
            end

            return update.success
        end,
        Get = function(self, cid, k)
            local metadata = false
            local active = GOV.Active:Get(cid)
            if active then 
                if active.Data then metadata = active.Data end
            else
                local gov = GetCharacterGovData(cid)
                if gov and gov.Data then metadata = gov.Data end
            end
        
            if not metadata then return nil end
        
            if k == nil then 
                return active.Data
            else
                return active.Data[k]
            end
        end,
    }
}

function UpdateActiveCharactersMetaData(cid, data)
    if ActiveEmployees[cid] then 
        TriggerClientEvent('Government:Client:OnGovDataUpdate',  ActiveEmployees[cid].Source, data)
        ActiveEmployees[cid].Data = data
    end
end

function GetCharacterGovData(cid)
    local fetch = Components.DB:FindOne('gov_employees', { CID = cid })
    if fetch.success and #fetch.docs > 0 then 
        return fetch.docs[1]
    end
    return false
end

function UpdateCharacterGovData(cid, department, rank, data)
    local doc = {
        CID = cid, 
        Department = department,
        Rank = rank,
        Data = type(data) == 'table' and data or {},
    }

    if GetCharacterGovData(cid) then 
        local updated = Components.DB:UpdateOne('gov_employees', { CID = cid }, doc)
        return updated.success 
    else
        local inserted = Components.DB:InsertOne('gov_employees', doc)
        if inserted.success and #inserted.inserted > 0 then 
            return true 
        end
    end
    return false
end

AddEventHandler('Characters:Server:Login', function(src)
    local Character = Components.Characters:Source(src)
    if not Character then return end
    local CID = Character:GetData('CID')
    local gov = Components.Gov:Get(CID)
    if gov then 
        gov.Source = src
        gov.Duty = false
        ActiveEmployees[CID] = gov
        TriggerClientEvent('Government:Client:OnGovChar', src, gov)
    end
end)

AddEventHandler('Characters:Server:Logout', function(src, cid)
    if ActiveEmployees[cid] then 
        ActiveEmployees[cid] = nil
    end
end)

RegisterNetEvent('Government:Server:ToggleDuty')
AddEventHandler('Government:Server:ToggleDuty', function()
    local src = source
    local Character = Characters:Source(src)
    if not Character then return end
    local CID = Character:GetData('CID')
    local isGov = Components.Gov.Active:Get(CID)
    if isGov then 
        if isGov.Duty then 
            isGov.Duty = false
            TriggerClientEvent('Government:Client:DutyChange', src, false)
        else
            isGov.Duty = true
            TriggerClientEvent('Government:Client:DutyChange', src, true)
        end
        Components.Logging:Info('Government', ('%s %s Duty: (%s %s)'):format(Components.Characters:GenerateLogString(Character), isGov.Duty and 'On' or 'Off', isGov.DepartmentAbbr, isGov.Rank))
    end
end)


--[[ 
* gov_employees db

? Departments
    ! Police
    1 - Los Santos Police Department - LSPD
    2 - Los Santos County Sheriff's Department - LSSD

    ! Medical
    4 - Los Santos Fire Department - LSFD
    5 - San Andreas Hospital Services
    ! Justice
    6 - Department of Justice - DOJ
    7 - Los Santos County District Attorney's Office - LSCDA


{
    CID = @number - cid,
    Department = a number,
    Rank = a number,
    Data = {} - whatever data needed
}



* Return data with the department and rank stuff formatted

{
    CID = number,
    Type = string of type of department,
    Duty = boolean of if they are on duty,
    Department = string,
    DepartmentId = number,
    DepartmentAbbr = string,
    Rank = string,
    RankId = number,
    RankAbbr = string,
    RankData = table,
    Data = table,
}


]]