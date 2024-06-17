
function FetchPersonalAccount(identifier, byCID)
    local res = nil
    if byCID then 
        res = Components.DB:FindOne('bank_accounts', {
            type = 1,
            holders = identifier,
        })
    else
        res = Components.DB:FindOne('bank_accounts', {
            type = 1,
            account = identifier,
        })
    end

    if res and res.success and res.docs[1] and res.docs[1].account then 
        local theirAccount = res.docs[1]
        theirAccount.permissions = { deposit = true, withdraw = true }
        return theirAccount
    else
        return false
    end
end

function FetchPersonalAccountByCID(cid)
    return FetchPersonalAccount(cid, true)
end

function FetchPersonalAccountById(account)
    return FetchPersonalAccount(account, false)
end

function CreatePersonalAccount(cid)
    local created = CreateBankAccount(1, Config.InitialPersonalBalance, { cid })
    if created and created.account then 
        return created
    else
        return false
    end
end

