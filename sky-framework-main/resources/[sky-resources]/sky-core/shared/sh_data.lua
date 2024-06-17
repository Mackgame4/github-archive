local _stores = {}

Core.Modules.DataStore = {
    _name = 'core',
    _protected = true,
    Create = function(self, owner, key, data)
        data = data or {}
        _stores[owner] = _stores[owner] or {}

        _stores[owner][key] = data

        return {
            Owner = owner,
            Key = key,
            Set = function(self, var, data)
                _stores[self.Owner][self.Key][var] = data
            end,
            Get = function(self, var)
                if var ~= nil and var ~= '' then
                    if _stores[self.Owner][self.Key][var] ~= nil then
                        return _stores[self.Owner][self.Key][var]
                    else
                        return nil
                    end
                else
                    return _stores[self.Owner][self.Key]
                end
            end,
            Unset = function(self, var)
                _stores[self.Owner][self.Key][var] = nil
            end,
        }
    end,
    Delete = function(self, owner, key)
        _stores[owner][key] = nil
        collectgarbage()
    end
}