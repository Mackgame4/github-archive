FINANCE.BankAccounts = {
    Get = function(self, account)
        return FetchBankAccount(account)
    end,
    Balance = {
        Get = function(self, account)
            local bAccount = FetchBankAccount(account)
            if bAccount and bAccount.balance then
                return bAccount.balance
            end
            return false
        end,
        Add = function(self, account, amount, transactionLog)
            if type(amount) == 'number' and amount > 0 then 
                local bAccount = FetchBankAccount(account)
                if bAccount and bAccount.balance then 
                    local newBalance = bAccount.balance + amount
                    if newBalance >= bAccount.balance then
                        UpdateBankAccountBalanceQuery(account, newBalance)
                        if transactionLog and type(transactionLog) == 'table' and type(transactionLog.description) == 'string' and type(transactionLog.type) == 'number' then
                            if #transactionLog.description > 0 then
                                AddAccountTransactionLog(bAccount.account, transactionLog.type, amount, transactionLog.description, transactionLog.fromAccount, transactionLog.metaData)
                            else
                                AddAccountTransactionLog(bAccount.account, transactionLog.type, amount, 'No Description Provided', transactionLog.fromAccount, transactionLog.metaData)
                            end
                        else
                            AddAccountTransactionLog(bAccount.account, 0, amount, 'No Description Provided')
                        end
                        return { success = true, balance = newBalance }
                    end
                end
            end
            return { success = false }
        end,
        Has = function(self, account, amount)
            if type(amount) == 'number' and amount > 0 then 
                local bAccount = FetchBankAccount(account)
                if bAccount and bAccount.balance then 
                    local newBalance = bAccount.balance - amount
                    if newBalance >= 0 then
                        return true
                    end
                end
            end
            return false
        end,
        Remove = function(self, account, amount, transactionLog)
            if type(amount) == 'number' and amount > 0 then 
                local bAccount = FetchBankAccount(account)
                if bAccount and bAccount.balance then 
                    local newBalance = bAccount.balance - amount
                    if newBalance >= 0 then
                        UpdateBankAccountBalanceQuery(account, newBalance)
                        if transactionLog and type(transactionLog) == 'table' and type(transactionLog.description) == 'string' and type(transactionLog.type) == 'number' then
                            if #transactionLog.description > 0 then
                                AddAccountTransactionLog(bAccount.account, transactionLog.type, -amount, transactionLog.description, transactionLog.fromAccount, transactionLog.metaData)
                            else
                                AddAccountTransactionLog(bAccount.account, transactionLog.type, -amount, 'No Description Provided', transactionLog.fromAccount, transactionLog.metaData)
                            end
                        else
                            AddAccountTransactionLog(bAccount.account, 0, -amount, 'No Description Provided')
                        end
                        return { success = true, balance = newBalance }
                    end
                end
            end
            return { success = false }
        end,
    },
}

function FetchBankAccount(account)
    if IsAccountNumberEvenPossible(account) then 
        local res = Components.DB:FindOne('bank_accounts', {
            account = account
        })
        if res and res.success and #res.docs > 0 then 
            return res.docs[1]
        end
    end
    return false
end

function CreateBankAccount(type, initialValue, personal)
    if not initialValue then initialValue = 0 end
    local accountNumber = ARP.RandomNumber(100000000, 999999999)
    while DoesAccountNumberExist(accountNumber) do 
        accountNumber = ARP.RandomNumber(100000000, 999999999)
        Citizen.Wait(100)
    end

    local bankAccount = {
        type = type,
        account = accountNumber,
        balance = initialValue,
    }

    if personal then 
        bankAccount.holders = personal
    end

    local inserted = Components.DB:InsertOne('bank_accounts', bankAccount)
    if inserted and inserted.success and #inserted.inserted > 0 then 
        return inserted.inserted[1]
    end
    return false
end

function UpdateBankAccountBalanceQuery(account, newBalance)
    if newBalance >= 0 then 
        local res = Components.DB:UpdateOne('bank_accounts', { account = account }, { 
            ['$set'] = {
                balance = newBalance
            }
        })
        if res and res.success then 
            return true
        end
    end
    return false
end

-- ? Actions By Actual Players

function DoAccountCashWithdrawal(src, account, amount, locationData, reason)
    if locationData.atm and amount > Config.ATM.MaxWithdrawal then -- Enforce ATM Withdrawal Limits
        return false, 3
    end
    local Character = Components.Characters:Source(src)
    if Character and Character:GetData('_Loaded') and type(amount) == 'number' and amount > 0 and amount <= 900000000 then 
        local bAccount = GetAccountAccess(Character:GetData('CID'), account)
        if bAccount and bAccount.account and bAccount.permissions then 
            if bAccount.permissions.withdraw then
                local removeSuccess = Components.Finance.BankAccounts.Balance:Remove(bAccount.account, amount, {
                    description = string.format('Cash Withdrawal From %s | %s', locationData.name, #reason > 0 and reason or 'No Description Provided'),
                    type = 1,
                    metaData = {
                        executorCID = Character:GetData('CID'),
                        executorUser = Components.Users:GenerateLogStringSrc(src),
                    }
                })
                if removeSuccess.success then 
                    -- Only Once the money is removed from the account can we add the cash back to the character
                    Components.Finance.Cash:Add(src, amount)
                    return true, removeSuccess.balance
                else
                    return false, 2 -- 2 means invalid amount
                end
            else
                return false, 1 -- 1 means unable to withdraw
            end
        end 
    end
    return false, 0 -- 0 means unable to access // or just an error // invalid args
end

function DoAccountCashDeposit(src, account, amount, locationData, reason)
    local Character = Components.Characters:Source(src)
    if Character and Character:GetData('_Loaded') and type(amount) == 'number' and amount > 0 and amount <= 900000000 then 
        local bAccount = GetAccountAccess(Character:GetData('CID'), account)
        if bAccount and bAccount.account and bAccount.permissions then 
            if bAccount.permissions.withdraw then
                local addSuccess = Components.Finance.BankAccounts.Balance:Add(bAccount.account, amount, {
                    description = string.format('Cash Deposit From %s | %s', locationData.name, #reason > 0 and reason or 'No Description Provided'),
                    type = 1,
                    metaData = {
                        executorCID = Character:GetData('CID'),
                        executorUser = Components.Users:GenerateLogStringSrc(src),
                    }
                })
                if addSuccess.success then 
                    -- Only Once the money is removed from the account can we add the cash back to the character
                    Components.Finance.Cash:Remove(src, amount)
                    return true, addSuccess.balance
                else
                    return false, 2 -- 2 means invalid amount
                end
            else
                return false, 1 -- 1 means unable to
            end
        end 
    end
    return false, 0 -- 0 means unable to access // or just an error // invalid args
end

function DoAccountTransfer(src, account, target, targetByCID, amount, reason)
    local Character = Components.Characters:Source(src)
    if Character and Character:GetData('_Loaded') and type(amount) == 'number' and amount > 0 and amount <= 900000000 then 
        local fromAccount = GetAccountAccess(Character:GetData('CID'), account)
        if fromAccount and fromAccount.account and fromAccount.permissions then 
            if fromAccount.permissions.withdraw then
                local targetAccount = nil
                if targetByCID then
                    targetAccount = FetchPersonalAccountByCID(target)
                else
                    targetAccount = FetchBankAccount(target)
                end

                if targetAccount ~= nil and targetAccount.account and targetAccount.account ~= fromAccount.account then 
                    local fromTransaction = Components.Finance.BankAccounts.Balance:Remove(fromAccount.account, amount, {
                        type = 3,
                        description = string.format('Bank Transfer to %s | %s', targetAccount.account, #reason > 0 and reason or 'No Description Provided'),
                        metaData = {
                            executorCID = Character:GetData('CID'),
                            executorUser = Components.Users:GenerateLogStringSrc(src),
                        }
                    })
                    if fromTransaction.success then
                        -- Only Once the Removal is successful can we add to the target account.
                        local toTransaction = Components.Finance.BankAccounts.Balance:Add(targetAccount.account, amount, {
                            type = 3,
                            description = string.format('Bank Transfer from %s | %s', targetAccount.account, #reason > 0 and reason or 'No Description Provided'),
                            metaData = {
                                fromExecutorCID = Character:GetData('CID'),
                                fromExecutorUser = Components.Users:GenerateLogStringSrc(src),
                            }
                        })
                        return true
                    end
                end
            end
        end
    end
    return false
end