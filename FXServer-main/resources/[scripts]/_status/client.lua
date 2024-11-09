-- Status bars
local hunger = 100
local thirst = 100

-- Get speed velocity while Ped is running
function getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(GetPlayerPed(-1)))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function updateStatus()
  Citizen.Wait(Config.StatusTimer)
  local ped = GetPlayerPed(-1)
  local IsPlayerDead = IsEntityDead(ped)

  -- If no more hunger
  if hunger <= 0 then
    hunger = 0
    if not IsPlayerDead then
      SetEntityHealth(ped, GetEntityHealth(ped)-20)
      TriggerEvent('_drawtextui:ShowNotify', 'error', 800, "Damage taken")
    end
  end

  -- If no more thirst
  if thirst <= 0 then
    thirst = 0
    if not IsPlayerDead then
      SetEntityHealth(ped, GetEntityHealth(ped)-20)
      TriggerEvent('_drawtextui:ShowNotify', 'error', 800, "Damage taken")
    end
  end

  -- Increase hunger / thirst if running
  if IsPedOnFoot(ped) then
    local x = math.min(getSpeed(), 10) + 1
    if IsPedInMeleeCombat(ped) then -- If Ped is using his fist, it consumes more hunger + thirst than while running
      x = x + 10
      hunger = hunger - (Config.factorhunger * x)
      thirst = thirst - (Config.factorthirst * x)
    else -- If Ped running
      hunger = hunger - (Config.factorhunger * x)
      thirst = thirst - (Config.factorthirst * x)
    end
  else
    hunger = hunger - Config.factorhunger
    thirst = thirst - Config.factorthirst
  end

  if Config.UpdateHUD then
    TriggerEvent('ui-hud:UpdateStatusHUD', hunger, thirst)
  end

  if Config.Debug then
    ESX.Log("[^5"..GetCurrentResourceName().."^7]", hunger, thirst)
  end
end

-- Pick status from DB
AddEventHandler('playerSpawned', function(spawn)
	TriggerServerEvent("getPlayerStatus")
end)

-- Receive status from DB
RegisterNetEvent("PlayerStatus")
AddEventHandler("PlayerStatus", function(result)
  if result[1].hunger == nil and result[1].thirst == nil then  --i'm adding this here for db's that are not yet initialized.. causes some issues
    TriggerServerEvent('savePlayerStatus',100,100)
    TriggerServerEvent("getPlayerStatus")
  end 
  hunger = result[1].hunger
  thirst = result[1].thirst
end)

-- Update value if used item
RegisterNetEvent("UpdateFoodDrink")
AddEventHandler("UpdateFoodDrink", function(newhunger, newthirst)
  hunger = hunger + newhunger
  thirst = thirst + newthirst

  if hunger > 100 then hunger = 100 end
  if thirst > 100 then thirst = 100 end
end)

-- Update hunger and thirst
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1)
      SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
      updateStatus()
    end
end)

-- Save status to the DB
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(Config.AutoSaveStatusTimer)
      TriggerServerEvent("savePlayerStatus", hunger, thirst)
    end
end)

RegisterNetEvent('revivePlayer')
AddEventHandler('revivePlayer', function()
	hunger = 100
  thirst = 100
  TriggerServerEvent("savePlayerStatus", hunger, thirst)
  TriggerEvent('ui-hud:UpdateStatusHUD', hunger, thirst)
	local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

  SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
	ESX.RespawnPed(playerPed, formattedCoords, 0.0)
end)