function GetAccountAccess(cid, account)
    local Character = Components.Characters:CID(cid)
    if Character and Character:GetData('_Loaded') then 
        local bAccount = FetchBankAccount(account)
        if bAccount and bAccount.account then 
            if (bAccount.type == 1 or bAccount.type == 2) and bAccount.holders and type(bAccount.holders) == 'table' then
                if ARP.DoesTableHaveValue(bAccount.holders, cid) then -- The CID is on the holders list // in personal accounts all holders have access to withdraw/deposit
                    bAccount.permissions = { withdraw = true, deposit = true }
                    return bAccount
                end
            elseif bAccount.type == 3 then -- Business Bank Accounts

            elseif bAccount.type == 4 then -- Government Bank Accounts

            end
        end
    end
    return false
end