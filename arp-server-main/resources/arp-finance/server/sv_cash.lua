FINANCE.Cash = {
    Add = function(self, src, amount)
        local Character = Components.Characters:Source(src)
        if type(amount) == 'number' and amount > 0 and amount < 900000000 and Character and Character:GetData('Cash') ~= nil then 
            local currentCash = Character:GetData('Cash')
            local newCash = currentCash + amount
            if newCash >= 0 then
                Character:SetData('Cash', newCash)
                if amount >= 50000 then LogLargeCashMovement(Character, amount, false) end
                return newCash
            end
        end
        return false
    end,
    Remove = function(self, src, amount)
        local Character = Components.Characters:Source(src)
        if type(amount) == 'number' and amount > 0 and amount < 900000000 and Character and Character:GetData('Cash') ~= nil then 
            local currentCash = Character:GetData('Cash')
            local newCash = currentCash - amount
            if newCash >= 0 then
                Character:SetData('Cash', newCash)
                if amount >= 50000 then LogLargeCashMovement(Character, amount, false) end
                return newCash
            end
        end
        return false
    end,
    Has = function(self, src, amount) -- The same as remove but doesn't actually remove the money - just checks if it is possible to do so.
        local Character = Components.Characters:Source(src)
        if type(amount) == 'number' and amount > 0 and amount < 900000000 and Character and Character:GetData('Cash') ~= nil then 
            local currentCash = Character:GetData('Cash')
            local newCash = currentCash - amount
            if newCash >= 0 then
                return newCash
            end
        end
        return false
    end,
    Get = function(self, src)
        local Character = Components.Characters:Source(src)
        if Character and Character:GetData('Cash') ~= nil then 
            local currentCash = Character:GetData('Cash')
            if currentCash >= 0 then
                return currentCash
            end
        end
        return false
    end
}