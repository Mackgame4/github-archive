function ClearOldTransactionLogs()
    local currentTime = ARP.GetUnix()
    local aWeekAgo = currentTime - (604800 * 2) -- It's actually 2 weeks ;)
    local res = Components.DB:Delete('bank_transaction_logs', {
        time = {
            ['$lte'] = aWeekAgo
        }
    })
    if res and res.success and res.deleted > 0 then 
        Components.Logging:Info('Finance/Banking', ('Cleared %s Old Transaction Logs'):format(res.deleted))
    end
end

function AddAccountTransactionLog(account, type, value, description, fromAccount, metaData)
    local currentTime = ARP.GetUnix()
    local res = Components.DB:InsertOne('bank_transaction_logs', {
        account = account,
        type = type,
        value = value,
        description = description,
        fromAccount = fromAccount,
        time = currentTime,
        meta = metaData,
    })
    if res and res.success and #res.inserted > 0 then 
        return res.inserted[1]
    end
    return false
end

function GetAllAccountTransactionLogs(account)
    local res = Components.DB:Find('bank_transaction_logs', { account = account })
    if res and #res.docs > 0 then 
        return res.docs
    end
    return {}
end