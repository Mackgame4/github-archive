local resourceName = GetCurrentResourceName()

ML.Shared.Log = function(message, type, resource)
	if not type then
		type = "log"
	end
	if not resource then
		resource = resourceName
	end
	typeString = string.upper(type)
	if type == "alert" then
		print("[^1"..typeString.."^0] " .. message)
	end
	if Config.Debug then
		if type == "log" and Config.DebugLevel >= 1 then
			print("[^2"..resource.."^0][^4"..typeString.."^0] " .. message)
		elseif type == "info" and Config.DebugLevel >= 0 then
			print("[^2"..resource.."^0][^4"..typeString.."^0] " .. message)
		elseif type == "success" and Config.DebugLevel >= 1 then
			print("[^2"..resource.."^0][^2"..typeString.."^0] " .. message)
		elseif type == "warn" and Config.DebugLevel >= 2 then
			print("[^2"..resource.."^0][^3"..typeString.."^0] " .. message)
		elseif type == "error" and Config.DebugLevel == 3 then
			print("[^2"..resource.."^0][^1"..typeString.."^0] " .. message)
		elseif type == "debug" and Config.DebugLevel >= 1 then
			print("[^2"..resource.."^0][^9"..typeString.."^0] " .. message)
		end
	end
end

function getCoreConfig()
	return Config
end