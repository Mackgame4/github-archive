BANKING_OPEN = false
local inZone = false

CACHED_LOCATION = false
CACHED_ISATM = false

function OnComponentUpdate(c)
    if not c or c == 'UI' then 
        Components.UI:RegisterCallback('bankStartClose', function(data, cb)
            CloseBanking()
            cb({ success = true })
        end)

        Components.UI:RegisterCallback('bankingGetTransactions', function(data, cb)
            local transactionLogs = Components.Callbacks:Execute('Finance:Server:GetTransactions', data)
            cb({ success = true, data = transactionLogs })
        end)

        Components.UI:RegisterCallback('bankDoWithdrawal', function(data, cb)
            local withdraw = Components.Callbacks:Execute('Finance:Server:DoBankCashAction', data.account, 'withdraw', data.amount, data.description)
            cb({ success = withdraw.success })
            if withdraw.success then 
                Components.UI:Send('bankUpdateSpecificBalance', {
                    accountNum = data.account,
                    newBalance = withdraw.newBalance,
                    newCash = CHAR_DATA.Cash,
                })
            end
        end)

        Components.UI:RegisterCallback('bankDoDeposit', function(data, cb)
            local deposit = Components.Callbacks:Execute('Finance:Server:DoBankCashAction', data.account, 'deposit', data.amount, data.description)
            cb({ success = deposit.success })
            if deposit.success then 
                Components.UI:Send('bankUpdateSpecificBalance', {
                    accountNum = data.account,
                    newBalance = deposit.newBalance,
                    newCash = CHAR_DATA.Cash,
                })
            end
        end)

        Components.UI:RegisterCallback('bankDoTransfer', function(data, cb)
            local success = Components.Callbacks:Execute('Finance:Server:DoBankTransfer', data.account, data.sendTo, data.sendWithCID, data.amount, data.description)
            cb({ success = success })
            local data = Components.Callbacks:Execute('Finance:Server:OpenBanking', CACHED_LOCATION, CACHED_ISATM)
            if data and data.accountList then 
                UpdateBanking(data.accountList, data.maxWithdraw)
            end
        end)
    end

    if not c or c == 'Interaction' then 
        for _, object in ipairs(_atmObjects) do 
            Components.Interaction.Targeting:AddEntityModel(object, 'mdi-atm', 2.0)
        end
    end

    if not c then 
        local addingBanks = {}
        for bankId, bData in ipairs(_bankPoints) do 
            if bData.special then 
                Components.Blips:Add("bank_".. bankId, bData.blip, 'Central Bank', 272, 1.2, 69)
            else
                Components.Blips:Add("bank_".. bankId, bData.blip, 'Bank', 272, 1.0, 7)
            end

            table.insert(addingBanks, 
                BoxZone:Create(bData.interactZone.center, bData.interactZone.length, bData.interactZone.width, {
                    name = "bank_".. bankId,
                    data = { 
                        id = bankId,
                    },
                    heading = bData.interactZone.heading,
                    minZ = bData.interactZone.minZ,
                    maxZ = bData.interactZone.maxZ,
                })
            )
        end
    
        local bankZones = ComboZone:Create(addingBanks, { name="bank_branches" })

        bankZones:onPlayerInOut(function(isPointInside, point, zone)
            if isPointInside and zone and zone.name and zone.data then 
                inZone = zone.data.id
                Components.Notify.Persistent:Set('s', 'Bank', false, 'mdi-bank', false)

            elseif inZone then
                -- Close Banking and Clear Notification
                inZone = false
                Components.Notify.Persistent:Clear()
                CloseBanking()
            end
        end)
    end
end

AddEventHandler('UI:Client:Escape', function()
    CloseBanking()
end)

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key)
    if CHAR_LOADED and not CHAR_DEAD and key == 'interactionPrimary' and inZone and _bankPoints[inZone] then 
        Components.Notify.Persistent:Clear()
        OpenBanking(_bankPoints[inZone].name, false)
    end
end)

AddEventHandler('Interaction:Targeting:ObjectAction', function(entityData)
    if CHAR_LOADED and not CHAR_DEAD and entityData and entityData.model and ARP.DoesTableHaveValue(_atmObjects, entityData.model) then 
        OpenATM()
    end
end)

RegisterNetEvent('Finance:Client:ATMCommand')
AddEventHandler('Finance:Client:ATMCommand', function()
    local pedCoords = GetEntityCoords(ARP.GblPed)
    for _, object in ipairs(_atmObjects) do
        local found = GetClosestObjectOfType(pedCoords, 2.0, object)
        local entityCoords = GetEntityCoords(found)
        if found > 0 and #(pedCoords - GetEntityCoords(found)) <= 1.5 then 
            return OpenATM()
        end
    end
end)

function OpenATM()
    local pedCoords = GetEntityCoords(ARP.GblPed)
    local currentStreetHash = GetStreetNameAtCoord(pedCoords.x, pedCoords.y, pedCoords.z)
    OpenBanking(string.format('an ATM on %s, %s', GetStreetNameFromHashKey(currentStreetHash), GetLabelText(GetNameOfZone(pedCoords))), true)
end

function UpdateBanking(accountData, atmLimit)
    Components.UI:Send('bankUpdate', {
        availableAccounts = accountData,
        atmLimit = atmLimit,
        cash = CHAR_DATA.Cash,
        charName = CHAR_DATA._FullName,
    })
end

function OpenBanking(location, isATM)
    if not BANKING_OPEN then 
        CACHED_LOCATION = location
        CACHED_ISATM = isATM
        local data = Components.Callbacks:Execute('Finance:Server:OpenBanking', location, isATM)
        if data and data.accountList then 
            BANKING_OPEN = true
            UpdateBanking(data.accountList, data.maxWithdraw)
            Components.UI:Send('openBanking', {
                isATM = isATM
            })
            Components.UI:SetFocus(true)
        end
    end
end

function CloseBanking()
    if BANKING_OPEN then 
        Components.UI:Send('closeBanking', {})
        BANKING_OPEN = false
        Components.UI:SetFocus(false)

        if inZone then 
            Components.Notify.Persistent:Set('s', 'Bank', false, 'mdi-bank', false)
        end
    end
end

RegisterNetEvent('Finance:Client:UpdatePersonalAccount')
AddEventHandler('Finance:Client:UpdatePersonalAccount', function(accountData)

end)