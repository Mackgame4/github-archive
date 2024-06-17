COMPONENTS.DB = {
    _protected = true,
    IsConnected = function()
        return exports['arp-mongodb']:isConnected()
    end,
    
    Find = function(self, collection, query, options, limit)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        if options == nil then options = {} end
        if limit == nil then limit = 0 end

        local p = promise.new()
        exports['arp-mongodb']:find(collection, query, options, limit, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    FindOne = function(self, collection, query, options)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:findOne(collection, query, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    Insert = function(self, collection, documents, options)
        assert(type(collection) == 'string')
        assert(type(documents) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:insert(collection, documents, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    InsertOne = function(self, collection, document, options)
        assert(type(collection) == 'string')
        assert(type(document) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:insertOne(collection, document, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    Update = function(self, collection, query, update, options)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        assert(type(update) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:update(collection, query, update, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    UpdateOne = function(self, collection, query, update, options)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        assert(type(update) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:updateOne(collection, query, update, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    Count = function(self, collection, query, options)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:count(collection, query, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    Delete = function(self, collection, query, options)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:delete(collection, query, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,
    
    DeleteOne = function(self, collection, query, options)
        assert(type(collection) == 'string')
        assert(type(query) == 'table')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:deleteOne(collection, query, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end,

    Aggregate = function(self, collection, query, options)
        assert(type(collection) == 'string')
        if options == nil then options = {} end
    
        local p = promise.new()
        exports['arp-mongodb']:aggregate(collection, query, options, function(data)
            p:resolve(data)
        end)
    
        local res = Citizen.Await(p)
        return res
    end
}