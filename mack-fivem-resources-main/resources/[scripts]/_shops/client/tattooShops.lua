-- Create Blips
local inTattooShop = false
Citizen.CreateThread(function()
	for k,v in ipairs(_tattooShops) do
		local blip = AddBlipForCoord(v.center)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("Tattoo Shop")
		EndTextCommandSetBlipName(blip)

  local tattooShop = BoxZone:Create(v.center, v.width, v.length, {
    name="tattooShop",
    minZ=v.minZ,
    maxZ=v.maxZ,
    offset={0.0, 0.0, 0.0},
    scale={1.0, 1.0, 1.0},
    debugPoly=false
  })
  tattooShop:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
      if isPointInside then
        TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] " .._U("ChangeTattoo"))
        inTattooShop = true
      else
        TriggerEvent('_drawtextui:HideUI')
        inTattooShop = false
      end
  end)
	end
end)

function isInTattooShop()
  return inTattooShop
end

local cost = 0

local head_val = 0
local left_leg_val = 0
local right_leg_val = 0
local left_arm_val = 0
local right_arm_val = 0
local torso_val = 0

local HeadList = {}
local LeftLegList = {}
local LeftArmList = {}
local RightLegList = {}
local TorsoList = {}
local RightArmList = {}

local head_max = 0
local left_leg_max = 0
local right_leg_max = 0
local left_arm_max = 0
local right_arm_max = 0
local torso_max = 0

local PedTattooList = {}
local TempPedTattooList = {}
local gender
function UpdateTattooShop()
  local menuButtons = {
    {
        color = "error darken-4",
        icon = "cancel",
        text = _U("cancel"),
        action = "closeTattoo"
    },
    {
        color = "success darken-4",
        icon = "currency-usd",
        --text = _U("confirm"),
        text = cost,
        action = "confirmTattoo"
    }
  }

  local menuData= {  
    { text = 'Remove All tattoos', icon = 'mdi-folder', type = 'default', action = "removeAllTattoo"},
    { text = 'Remove selected tattoos', icon = 'mdi-folder', type = 'default', action = "removeTattoo"},
    --{ text = 'test', icon = 'mdi-folder', type = 'default', action = "test"},
    { text = 'Head',  icon = 'none', type = 'slider', value = head_val,  sliderMin = 0, sliderMax = head_max,  action = "changeTattooHead" },
    { text = 'Torso',  icon = 'none', type = 'slider', value = torso_val,  sliderMin = 0, sliderMax = torso_max,  action = "changeTattooTorso" },
    { text = 'Left arm',  icon = 'none', type = 'slider', value = left_arm_val,  sliderMin = 0, sliderMax = left_arm_max,  action = "changeTattooLeftArm" },
    { text = 'Right arm',  icon = 'none', type = 'slider', value = right_arm_val,  sliderMin = 0, sliderMax = right_arm_max,  action = "changeTattooRightArm" },
    { text = 'Left leg',  icon = 'none', type = 'slider', value = left_leg_val,  sliderMin = 0, sliderMax = left_leg_max,  action = "changeTattooLeftLeg" },
    { text = 'Right leg',  icon = 'none', type = 'slider', value = right_leg_val,  sliderMin = 0, sliderMax = right_leg_max,  action = "changeTattooRightLeg" },
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("TatMenuTitle"), _U("TatMenuDesc"), menuData, menuButtons)
end


function initializeTattoos()
  CreateShopCam()
  --TriggerServerEvent('getPlayerSkin')
  TriggerServerEvent("givePlayerTattoos")
  
  local playermodel = GetEntityModel(PlayerPedId())

  if playermodel == GetHashKey('mp_m_freemode_01') then 
      gender = 0  
  else
      gender = 1 
  end

  if gender == 0 then 
    for k, tattoos in pairs(Config.AllTattooList) do
      if tattoos.Zone == "ZONE_HEAD" and tattoos.HashNameMale ~= "" then
        table.insert(HeadList, tattoos)
      elseif tattoos.Zone == "ZONE_LEFT_LEG"  and tattoos.HashNameMale ~= "" then
        table.insert(LeftLegList, tattoos)
      elseif tattoos.Zone == "ZONE_LEFT_ARM"  and tattoos.HashNameMale ~= "" then
        table.insert(LeftArmList, tattoos)
      elseif tattoos.Zone == "ZONE_RIGHT_LEG" and tattoos.HashNameMale ~= "" then
        table.insert(RightLegList, tattoos)
      elseif tattoos.Zone == "ZONE_TORSO"     and tattoos.HashNameMale ~= "" then
        table.insert(TorsoList, tattoos)
      elseif tattoos.Zone == "ZONE_RIGHT_ARM" and tattoos.HashNameMale ~= "" then
        table.insert(RightArmList, tattoos)
      end 
    end
  else 
    for k, tattoos in pairs(Config.AllTattooList) do
      if tattoos.Zone == "ZONE_HEAD"          and tattoos.HashNameFemale ~= "" then
        table.insert(HeadList, tattoos)
      elseif tattoos.Zone == "ZONE_LEFT_LEG"  and tattoos.HashNameFemale ~= "" then
        table.insert(LeftLegList, tattoos)
      elseif tattoos.Zone == "ZONE_LEFT_ARM"  and tattoos.HashNameFemale ~= "" then
        table.insert(LeftArmList, tattoos)
      elseif tattoos.Zone == "ZONE_RIGHT_LEG" and tattoos.HashNameFemale ~= "" then
        table.insert(RightLegList, tattoos)
      elseif tattoos.Zone == "ZONE_TORSO"     and tattoos.HashNameFemale ~= "" then
        table.insert(TorsoList, tattoos)
      elseif tattoos.Zone == "ZONE_RIGHT_ARM" and tattoos.HashNameFemale ~= "" then
        table.insert(RightArmList, tattoos)
      end 
    end
  end 

  head_max = HeadList.length
  left_leg_max = LeftLegList.length
  right_leg_max = RightLegList.length
  left_arm_max = LeftArmList.length
  right_arm_max = RightArmList.length
  torso_max = TorsoList.length
  
  StripToUnderWear()
  DrawTattoos()
  
  UpdateTattooShop()
  TriggerEvent('_drawtextui:HideUI')
  --enableBarberInteract = true
end

function StripToUnderWear() -- an initializer for tattoo's so users can see what they're putting on
  SetPedDefaultComponentVariation(PlayerPedId())
  if gender == 0 then
			TriggerEvent('skinchanger:loadSkin', {
				helmet_1 = -1,
				tshirt_1 = 15,
				tshirt_2 = 0,
				arms     = 15,
				torso_1  = 91,
				torso_2  = 0,
				pants_1  = 14,
				pants_2  = 0,
				shoes_1 = 5,
				glasses_1 = 0,
        bags_1 = 0
			})
		else
			TriggerEvent('skinchanger:loadSkin', {
				helmet_1 = -1,
				tshirt_1 = 34,
				tshirt_2 = 0,
				arms     = 15,
				torso_1  = 101,
				torso_2  = 1,
				pants_1  = 16,
				pants_2  = 0,
				shoes_1 = 5,
				glasses_1 = 5,
        bags_1 = 0
			})
		end
end

function PutClothesBackOn()
  TriggerServerEvent('getPlayerSkin')
  TriggerEvent('skinchanger:getSkin', function(Character) 
    TriggerEvent('skinchanger:loadSkin', Character)
  end)
end

function DrawTattoos()
  ClearPedDecorations(PlayerPedId())
  if gender == 0 then 
    for k,v in pairs(PedTattooList) do 
      AddPedDecorationFromHashes(PlayerPedId(), v.Collection, v.HashNameMale)
    end
  else
    for k,v in pairs(PedTattooList) do 
      AddPedDecorationFromHashes(PlayerPedId(), v.Collection, v.HashNameFemale)
    end 
  end
end

function resetTatShop()
  head_val = 0
  left_leg_val = 0
  right_leg_val = 0
  left_arm_val = 0
  right_arm_val = 0
  torso_val = 0
end

RegisterNetEvent('_menu:handleEvent:removeAllTattoo')
AddEventHandler('_menu:handleEvent:removeAllTattoo', function()
  local cost = 0
  for k, v in pairs (PedTattooList) do 
    cost = cost + (v.Price / 20)
  end
  
  TriggerServerEvent("RemoveMoney", cost)
  PedTattooList = {}
  TempPedTattooList = {}
  resetTatShop()
  DrawTattoos()
  UpdateTattooShop()

  TriggerEvent('_menu:handleEvent:confirmTattoo')
end)

RegisterNetEvent('_menu:handleEvent:removeTattoo')
AddEventHandler('_menu:handleEvent:removeTattoo', function() 
  for k,v in pairs(PedTattooList)  do
    if head_val ~= 0 then 
      if  v.Collection      ==  HeadList[head_val].Collection     and
          v.Name            ==  HeadList[head_val].Name           and
          v.HashNameMale    ==  HeadList[head_val].HashNameMale   and
          v.HashNameFemale  ==  HeadList[head_val].HashNameFemale and
          v.Zone            ==  HeadList[head_val].Zone           and
          v.Price           ==  HeadList[head_val].Price
      then
        table.remove(PedTattooList, k)
      end
    end
    if torso_val ~= 0 then
      if  v.Collection      ==  TorsoList[torso_val].Collection     and
          v.Name            ==  TorsoList[torso_val].Name           and
          v.HashNameMale    ==  TorsoList[torso_val].HashNameMale   and
          v.HashNameFemale  ==  TorsoList[torso_val].HashNameFemale and
          v.Zone            ==  TorsoList[torso_val].Zone           and
          v.Price           ==  TorsoList[torso_val].Price
      then  
        table.remove(PedTattooList, k)
      end
    end
    if left_arm_val ~= 0 then
      if  v.Collection      ==  LeftArmList[left_arm_val].Collection     and
          v.Name            ==  LeftArmList[left_arm_val].Name           and
          v.HashNameMale    ==  LeftArmList[left_arm_val].HashNameMale   and
          v.HashNameFemale  ==  LeftArmList[left_arm_val].HashNameFemale and
          v.Zone            ==  LeftArmList[left_arm_val].Zone           and
          v.Price           ==  LeftArmList[left_arm_val].Price
      then  
        table.remove(PedTattooList, k)
      end
    end
    if right_arm_val ~= 0 then
      if  v.Collection      ==  RightArmList[right_arm_val].Collection     and
          v.Name            ==  RightArmList[right_arm_val].Name           and
          v.HashNameMale    ==  RightArmList[right_arm_val].HashNameMale   and
          v.HashNameFemale  ==  RightArmList[right_arm_val].HashNameFemale and
          v.Zone            ==  RightArmList[right_arm_val].Zone           and
          v.Price           ==  RightArmList[right_arm_val].Price
      then  
        table.remove(PedTattooList, k)
      end
    end
    if left_leg_val ~= 0 then
      if  v.Collection      ==  LeftLegList[left_leg_val].Collection     and
          v.Name            ==  LeftLegList[left_leg_val].Name           and
          v.HashNameMale    ==  LeftLegList[left_leg_val].HashNameMale   and
          v.HashNameFemale  ==  LeftLegList[left_leg_val].HashNameFemale and
          v.Zone            ==  LeftLegList[left_leg_val].Zone           and
          v.Price           ==  LeftLegList[left_leg_val].Price
      then  
        table.remove(PedTattooList, k)
      end
    end
    if right_leg_val ~= 0 then
      if  v.Collection      ==  RightLegList[right_leg_val].Collection     and
          v.Name            ==  RightLegList[right_leg_val].Name           and
          v.HashNameMale    ==  RightLegList[right_leg_val].HashNameMale   and
          v.HashNameFemale  ==  RightLegList[right_leg_val].HashNameFemale and
          v.Zone            ==  RightLegList[right_leg_val].Zone           and
          v.Price           ==  RightLegList[right_leg_val].Price
      then  
        table.remove(PedTattooList, k)
      end
    end
    
    
  end    

  for k,v in pairs(PedTattooList)  do
    print(v.Zone)
  end
  
  resetTatShop()
  DrawTattoos()
  TriggerEvent('_menu:handleEvent:confirmTattoo')
end)

function getTempTattoosCost()
  cost = 0
  for k,v in pairs(TempPedTattooList) do
    cost = cost + (v.Price / 20)
  end
end

function DrawTempTatoos()
  DrawTattoos() 
  if gender == 0 then
    for k,v in pairs(TempPedTattooList) do
      SetPedDecoration(PlayerPedId(), v.Collection, v.HashNameMale)
    end
  else
    for k,v in pairs(TempPedTattooList) do 
      SetPedDecoration(PlayerPedId(), v.Collection, v.HashNameFemale)
    end
  end
end

RegisterNetEvent('_menu:handleEvent:changeTattooHead')
AddEventHandler('_menu:handleEvent:changeTattooHead', function(value)
  for k,v in pairs(TempPedTattooList) do
    if v.Zone == "ZONE_HEAD" then
      table.remove(TempPedTattooList, k)
    end
  end
  table.insert(TempPedTattooList, HeadList[value])
  getTempTattoosCost()
  DrawTempTatoos()
  head_val = value
  UpdateTattooShop()
end)

RegisterNetEvent('_menu:handleEvent:changeTattooTorso')
AddEventHandler('_menu:handleEvent:changeTattooTorso', function(value)
  for k,v in pairs(TempPedTattooList) do
    if v.Zone == "ZONE_TORSO" then
      table.remove(TempPedTattooList, k)
    end
  end
  table.insert(TempPedTattooList, TorsoList[value])
  getTempTattoosCost()
  DrawTempTatoos()
  torso_val = value
  UpdateTattooShop()
end)

RegisterNetEvent('_menu:handleEvent:changeTattooLeftArm')
AddEventHandler('_menu:handleEvent:changeTattooLeftArm', function(value)
  for k,v in pairs(TempPedTattooList) do
    if v.Zone == "ZONE_LEFT_ARM" then
      table.remove(TempPedTattooList, k)
    end
  end
  table.insert(TempPedTattooList, LeftArmList[value])
  getTempTattoosCost()
  DrawTempTatoos()
  left_arm_val = value
  UpdateTattooShop()
end)

RegisterNetEvent('_menu:handleEvent:changeTattooRightArm')
AddEventHandler('_menu:handleEvent:changeTattooRightArm', function(value)
  for k,v in pairs(TempPedTattooList) do
    if v.Zone == "ZONE_RIGHT_ARM" then
      table.remove(TempPedTattooList, k)
    end
  end
  table.insert(TempPedTattooList, RightArmList[value])
  getTempTattoosCost()
  DrawTempTatoos()
  right_arm_val = value
  UpdateTattooShop()
end)

RegisterNetEvent('_menu:handleEvent:changeTattooLeftLeg')
AddEventHandler('_menu:handleEvent:changeTattooLeftLeg', function(value)
  for k,v in pairs(TempPedTattooList) do
    if v.Zone == "ZONE_LEFT_LEG" then
      table.remove(TempPedTattooList, k)
    end
  end
  table.insert(TempPedTattooList, LeftLegList[value])
  getTempTattoosCost()
  DrawTempTatoos()
  left_leg_val = value
  UpdateTattooShop()
end)

RegisterNetEvent('_menu:handleEvent:changeTattooRightLeg')
AddEventHandler('_menu:handleEvent:changeTattooRightLeg', function(value)
  for k,v in pairs(TempPedTattooList) do
    if v.Zone == "ZONE_RIGHT_LEG" then
      table.remove(TempPedTattooList, k)
    end
  end
  table.insert(TempPedTattooList, RightLegList[value])
  getTempTattoosCost()
  DrawTempTatoos()
  right_leg_val = value
  UpdateTattooShop()
end)

RegisterNetEvent('_menu:handleEvent:closeTattoo')
AddEventHandler('_menu:handleEvent:closeTattoo', function()
  resetTatShop()
  TempPedTattooList = {}
  TriggerServerEvent("givePlayerTattoos")
  DrawTattoos()
  PutClothesBackOn()
  DeleteShopCam()
  
  inshop = false
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] Change Tattoo")
end)

RegisterNetEvent('_menu:handleEvent:confirmTattoo')
AddEventHandler('_menu:handleEvent:confirmTattoo', function()
  TempPedTattooList = {}
  
  TriggerServerEvent("RemoveMoney", cost)

  if head_val ~= 0      then table.insert(PedTattooList, HeadList[head_val])          end
  if torso_val ~= 0     then table.insert(PedTattooList, TorsoList[torso_val])        end
  if left_arm_val ~= 0  then table.insert(PedTattooList, LeftArmList[left_arm_val])   end
  if right_arm_val ~= 0 then table.insert(PedTattooList, RightArmList[right_arm_val]) end
  if left_leg_val ~= 0  then table.insert(PedTattooList, LeftLegList[left_leg_val])   end
  if right_leg_val ~= 0 then table.insert(PedTattooList, RightLegList[right_leg_val]) end
  
  DeleteShopCam()

  TriggerServerEvent("addPlayerTattoos", PedTattooList)  -- writes to the database

  resetTatShop()
  DrawTattoos()
  PutClothesBackOn()

  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  TriggerEvent('_drawtextui:ShowNotify', 'success', 2000, _U("success"))
  Wait(2100)
  TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] Change Tattoo")
  inshop = false
end)

RegisterNetEvent('_menu:handleEvent:test')
AddEventHandler('_menu:handleEvent:test', function()
  TriggerEvent('revivePlayer')
  TriggerEvent('UpdateFoodDrink',100,100)
  TriggerServerEvent("givePlayerTattoos")
end)

RegisterNetEvent('getPlayerTattoos') 
AddEventHandler('getPlayerTattoos', function(tattooList) -- triggerServerEvent "givePlayerTattoos" to get this returned
  PedTattooList = tattooList
end)


--[[RegisterNetEvent('OnInteract')  -- this was moved to client/main.lua to prevent conflicted calls of this function
AddEventHandler('OnInteract', function(action, text)
  if enableTattooInteract then
    TriggerEvent('skinchanger:change', 'arms', 15)
    TriggerEvent('skinchanger:change', 'torso_1', 15)
    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
    TriggerEvent('skinchanger:change', 'pants_1', 14)

    openTattooShop()
    inshop = true
    Citizen.CreateThread(function()
      while inshop == true do
        InvalidateIdleCam()
        Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
      end
    end)
  end
end)]]--