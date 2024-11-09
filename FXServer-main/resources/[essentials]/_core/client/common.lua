AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

function ServerFirstStart()
	return nil
end

function getDebug()
	return Config.EnableDebug
end