ACCESSING_LOCATIONS_CACHE = {}
FINANCE = {}

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Finance', FINANCE)
end)

function OnComponentUpdate(c)
    if not c or c == 'Callbacks' then 
        Components.Callbacks:Register('Finance:Server:OpenBanking', function(src, cb, location, fromATM)
            local Character = Components.Characters:Source(src)
            if Character and Character:GetData('_Loaded') and type(location) == 'string' and type(fromATM) == 'boolean' then 
                local cid = Character:GetData('CID')
                ACCESSING_LOCATIONS_CACHE[cid] = { name = location, atm = fromATM }
                local accountList = {}
                local personalAccount = FetchPersonalAccountByCID(cid)
                if personalAccount then 
                    table.insert(accountList, personalAccount)
                end
                cb({ accountList = accountList, maxWithdraw = Config.ATM.MaxWithdrawal })
                return
            end
            cb(false)
        end)

        Components.Callbacks:Register('Finance:Server:DoBankCashAction', function(src, cb, account, action, amount, reason)
            local Character = Components.Characters:Source(src)
            if Character and Character:GetData('_Loaded') and type(account) == 'number' and type(amount) == 'number' and type(action) == 'string' then 
                local cid = Character:GetData('CID')
                local fromLocation = ACCESSING_LOCATIONS_CACHE[cid]
                if cid and fromLocation and fromLocation.name and amount > 0 then 
                    if action == 'withdraw' then 
                        local success, reason = DoAccountCashWithdrawal(src, account, amount, fromLocation, reason)
                        cb({ success = success, newBalance = reason })
                        if not success then 
                            if reason == 0 then
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Withdrawal Failed', 'There was an error.', 'mdi-bank')
                            elseif reason == 1 then 
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Withdrawal Failed', 'You don\'t have access to withdraw from this account.', 'mdi-bank')
                            elseif reason == 2 then 
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Withdrawal Failed', 'Invalid amount to withdraw.', 'mdi-bank')
                            elseif reason == 3 then
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Withdrawal Failed', string.format('Cannot withdraw more than $%s from an ATM.', Config.ATM.MaxWithdrawal), 'mdi-bank')
                            end
                        end
                    elseif action == 'deposit' and not fromLocation.atm then 
                        local success, reason = DoAccountCashDeposit(src, account, amount, fromLocation, reason)
                        cb({ success = success, newBalance = reason })
                        if not success then 
                            if reason == 0 then
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Deposit Failed', 'There was an error.', 'mdi-bank')
                            elseif reason == 1 then 
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Deposit Failed', 'You don\'t have access to deposit into this account.', 'mdi-bank')
                            elseif reason == 2 then 
                                TriggerClientEvent('Client:Notify', src, 'error', 'Cash Deposit Failed', 'Invalid amount to deposit.', 'mdi-bank')
                            end
                        end
                    end
                end
            end
            cb(false)
        end)

        Components.Callbacks:Register('Finance:Server:DoBankTransfer', function(src, cb, account, target, targetByCID, amount, reason)
            local success = DoAccountTransfer(src, account, target, targetByCID, amount, reason)
            cb(success)
        end)

        Components.Callbacks:Register('Finance:Server:GetTransactions', function(src, cb, accountNum)
            local Character = Components.Characters:Source(src)
            if Character and Character:GetData('_Loaded') then 
                local cid = Character:GetData('CID')
                local bAccount = GetAccountAccess(cid, accountNum)
                if bAccount and bAccount.account and bAccount.permissions then 
                    local transactions = GetAllAccountTransactionLogs(bAccount.account)
                    cb(transactions)
                    return
                end
            end
            cb(false)
        end)
    end

    if not c or c == 'Commands' then 
        Components.Commands:Add('atm', function(src)
            TriggerClientEvent('Finance:Client:ATMCommand', src)
        end, 'Open an ATM')
    end

    if not c then 
        ClearOldTransactionLogs()
        local totalMoney = Components.DB:Aggregate('bank_accounts', { 
            {
                ['$group'] = {
                    _id = 'dicks',
                    total = { ['$sum'] = '$balance' }
                }
            }
        }, {
            allowDiskUse = true
        })
        local personalQ = Components.DB:Count('bank_accounts', { type = { ['$in'] = { 1, 2 } } })
        local businessQ = Components.DB:Count('bank_accounts', { type = 3 })
        local governmentQ = Components.DB:Count('bank_transaction_logs', { type = 4 })
        if totalMoney.success and #totalMoney.docs > 0 and totalMoney.docs[1].total then 
            Components.Logging:Info('Finance', ('[Bank Accounts] All Accounts Combined Total: $%s'):format(totalMoney.docs[1].total))
        end

        if personalQ.success and businessQ.success and governmentQ.success then 
            Components.Logging:Info('Finance', ('[Bank Accounts] Loaded %s Personal Account(s), %s Business Account(s), and %s Government Account(s)'):format(personalQ.count, businessQ.count, governmentQ.count))
        end

    end
end

AddEventHandler('Characters:Server:Login', function(src)
    local Character = Components.Characters:Source(src)
    if not Character then return end
    local cid = Character:GetData('CID')
    local cash = Character:GetData('Cash')
    if cash == nil then 
        Character:SetData('Cash', 500)
    end
    local currentAccount = FetchPersonalAccountByCID(cid)
    if not currentAccount then 
        currentAccount = CreatePersonalAccount(cid)
    end
end)

AddEventHandler('Characters:Server:Logout', function(src, cid)
    if ACCESSING_LOCATIONS_CACHE[cid] then 
        ACCESSING_LOCATIONS_CACHE[cid] = nil
    end
end)

--[[

Financials

Cash

Bank Accounts

? Bank Account Types: 
    1 - Personal Account
    2 - Personal Savings Account (Can be Joint)
    3 - Business Accounts
    4 - Government Accounts


DB: bank_accounts
{
    type :number = 1,
    account :number = 123456789, -- Random 9 Digit Number
    balance :number = 0,

    -- for the personal kind of accounts
    holders: [ 10000, 20000 ],

}

? Transaction Log Types:
1 - Cash Deposit/Withdrawal
2 - Direct Purchase From Bank Account
3 - Transfer from another account
4 - Paychecks


DB: bank_transaction_logs
{
    account: number = 123456789,
    value: number = -100,
    type: number = 1,
    description: string = 'What',
    fromAccount: number = 1212, -- When from another account
}


]]