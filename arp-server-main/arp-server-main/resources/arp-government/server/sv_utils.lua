function DoesDepartmentExist(dep)
    if _departments[dep] then 
        return _departments[dep]
    end
    return false
end

function DoesRankExistInDepartment(dep, rank)
    if DoesDepartmentExist(dep) then 
        if _departments[dep].ranks[rank] then 
            local r = _departments[dep].ranks[rank]
            r.id = rank
            return r
        end
    end
    return false
end

function GetDepartmentType(department)
    return _govTypes[department]
end

function GetDepartmentDataFromCharacterGovData(department, rank)
    local rankData = DoesRankExistInDepartment(department, rank)
    local departmentData = DoesDepartmentExist(department)
    if departmentData and rankData then 
        return {
            Type = GetDepartmentType(department),
            Department = departmentData.name,
            DepartmentId = department,
            DepartmentAbbr = departmentData.abbr,
            Rank = rankData.name,
            RankId = rank,
            RankAbbr = rankData.abbr and rankData.abbr or rankData.name,
            RankData = rankData.data and rankData.data or {},
        }
    end
    return false
end