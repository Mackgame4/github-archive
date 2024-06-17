function LogLargeCashMovement(Character, amount, removed)
    if removed then 
        Components.Logging:Warn('Finance/Cash', ('Large Amount of Cash ($%s) Was Removed from Character %s'):format(amount, Characters:GenerateLogString(Character)))
    else
        Components.Logging:Warn('Finance/Cash', ('Large Amount of Cash ($%s) Was Added to Character %s'):format(amount, Characters:GenerateLogString(Character)))
    end
end

function IsAccountNumberEvenPossible(num)
    if type(num) == 'number' and num >= 100000000 and num <= 999999999 then
        return true
    end
    return false
end

function DoesAccountNumberExist(generated)
    local res = Components.DB:FindOne('bank_accounts', { account = generated })
    if res.success and #res.docs <= 0 then
        return false
    end
    return true
end