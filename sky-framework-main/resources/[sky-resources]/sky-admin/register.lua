AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['sky-core']:RegisterModule('ModuleName', Module.Exports)
end)