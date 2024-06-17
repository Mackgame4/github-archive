_started = false

AddEventHandler('ModuleName:Shared:DependencyUpdate', RetrieveModules)
function RetrieveModules()
    Callbacks = exports['sky-core']:FetchModule('Callbacks')
    Utils = exports['sky-core']:FetchModule('Utils')
    Logger = exports['sky-core']:FetchModule('Logger')
    Module.Internal:StartLoops()
    Module.Internal:RegisterCallbacks()
    _started = true
end

AddEventHandler('Core:Shared:Ready', function()
    exports['sky-core']:RequestDependencies('ModuleName', {
        'Callbacks',
        'Utils',
        'Logger',
    }, function(error)  
        if #error > 0 then return; end
        RetrieveModules()
    end)
end)