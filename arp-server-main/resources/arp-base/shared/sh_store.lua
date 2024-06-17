local STORE = {}
local CALLBACKS = {}

COMPONENTS.Store = {
    _protected = true,
    Create = function(self, owner, key, data, cb)
        data = data or {}
        STORE[owner] = STORE[owner] or {}
        STORE[owner][key] = data
        CALLBACKS[owner] = CALLBACKS[owner] or {}
        CALLBACKS[owner][key] = cb

        return {
            Owner = owner,
            Key = key,
            SetData = function(self, var, data)
                STORE[self.Owner][self.Key][var] = data
                if CALLBACKS[owner][key] ~= nil then
                    CALLBACKS[owner][key](var, data)
                end
            end,
            GetData = function(self, var)
                if var ~= nil and var ~= '' then
                    if STORE[self.Owner][self.Key][var] ~= nil then
                        return STORE[self.Owner][self.Key][var]
                    else
                        return nil
                    end
                else
                    return STORE[self.Owner][self.Key]
                end
            end,
        }
    end,
    Delete = function(self, owner, key)
        STORE[owner][key] = nil 
        collectgarbage()
    end
}