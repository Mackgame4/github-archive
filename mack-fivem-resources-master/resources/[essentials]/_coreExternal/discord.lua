local WaitTime = 5000
local ShowActions = false
local UseKMH = true

local DiscordAppId = "888128405399289929"
local DiscordAppAsset = "logo"
local DiscordAppAssetText = "Prodigy RP"
local DiscordAppAssetSmall = "info"
local DiscordAppAssetSmallText = "discord.gg/vVfSErvs52"
local DiscordAppButtons = {
	{id = 0, name = "Website", url = "https://github.com/prodigyar"},
	{id = 1, name = "Discord", url = "https://discord.gg/vVfSErvs52"}
}

if not ShowActions then
	Citizen.CreateThread(function()
		SetDiscordAppId(DiscordAppId)
		SetDiscordRichPresenceAsset(DiscordAppAsset) 
		SetDiscordRichPresenceAssetText(DiscordAppAssetText) 
		SetDiscordRichPresenceAssetSmall(DiscordAppAssetSmall)
		SetDiscordRichPresenceAssetSmallText(DiscordAppAssetSmallText)
		for k, v in ipairs(DiscordAppButtons) do
			SetDiscordRichPresenceAction(v.id, v.name, v.url)
		end
		while true do
			SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | Playing with " .. #GetActivePlayers() .. " players") 
			Wait(WaitTime)
		end
	end)
else
	Citizen.CreateThread(function()
		SetDiscordAppId(DiscordAppId)
		SetDiscordRichPresenceAsset(DiscordAppAsset) 
		SetDiscordRichPresenceAssetText(DiscordAppAssetText) 
		SetDiscordRichPresenceAssetSmall(DiscordAppAssetSmall)
		SetDiscordRichPresenceAssetSmallText(DiscordAppAssetSmallText)
		for k, v in ipairs(DiscordAppButtons) do
			SetDiscordRichPresenceAction(v.id, v.name, v.url)
		end
		while true do
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
			local StreetHash = GetStreetNameAtCoord(x, y, z)
			Citizen.Wait(WaitTime)
			if StreetHash ~= nil then
				StreetName = GetStreetNameFromHashKey(StreetHash)
				if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
					if IsPedSprinting(PlayerPedId()) then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Sprinting down "..StreetName)
					elseif IsPedRunning(PlayerPedId()) then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Running down "..StreetName)
					elseif IsPedWalking(PlayerPedId()) then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Walking down "..StreetName)
					elseif IsPedStill(PlayerPedId()) then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Standing on "..StreetName)
					end
				elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
					local VehSpeed = GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId()))
					local CurSpeed = UseKMH and math.ceil(VehSpeed * 3.6) or math.ceil(VehSpeed * 2.236936)
					local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
					if CurSpeed > 50 then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Speeding down "..StreetName.." In a "..VehName)
					elseif CurSpeed <= 50 and CurSpeed > 0 then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Cruising down "..StreetName.." In a "..VehName)
					elseif CurSpeed == 0 then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Parked on "..StreetName.." In a "..VehName)
					end
				elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
					local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
					if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Flying over "..StreetName.." in a "..VehName)
					else
						SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Landed at "..StreetName.." in a "..VehName)
					end
				elseif IsEntityInWater(PlayerPedId()) then
					SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Swimming around")
				elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
					local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
					SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."Sailing around in a "..VehName)
				elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
					SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. #GetActivePlayers() .. " players | ".."In a yellow submarine")
				end
			end
		end
	end)
end