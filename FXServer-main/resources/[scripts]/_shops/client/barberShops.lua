-- Create Blips
local inBarberShop = false
Citizen.CreateThread(function()
	for k,v in ipairs(_barberShops) do
		local blip = AddBlipForCoord(v.center)
		SetBlipSprite(blip, 71)
		SetBlipColour(blip, 44)
    SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("Barber Shop")
		EndTextCommandSetBlipName(blip)

  local barberShop = BoxZone:Create(v.center, v.width, v.length, {
    name="barberShop",
    minZ=v.minZ,
    maxZ=v.maxZ,
    offset={0.0, 0.0, 0.0},
    scale={1.0, 1.0, 1.0},
    debugPoly=false
  })
	
    barberShop:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
        if isPointInside then
          inBarberShop = true
          TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] " .._U("ChangeHair"))
        else
          inBarberShop = false
          TriggerEvent('_drawtextui:HideUI')
        end
    end)
  end
end)

function isInBarberShop()
  return inBarberShop
end

local PlayerSkin = {}

local hair_1_val          = 0
local hair_2_val          = 0    
local hair_color_1_val    = 0
local hair_color_2_val    = 0 
local beard_type_val      = 0
local beard_size_val      = 0    
local beard_color_1_val   = 0
local beard_color_2_val   = 0  

local eyebrow_type_val    = 0 
local eyebrow_size_val    = 0
local eyebrow_color_1_val = 0    
local eyebrow_color_2_val = 0
local eyebrow_height_val  = 0  
local eyebrow_depth_val   = 0  

local cost = 0



function UpdateBarberShop() 
  TriggerEvent('skinchanger:getData', function(comp, max) 
    hair_1_max            = max['hair_1']
    hair_1_color_max      = max['hair_color_1']
    beard_type_max        = max['beard_1']
    beard_size_max        = max['beard_2']
    beard_color_1_max     = max['beard_3']
    eyebrow_type_max      = max['eyebrows_1']
    eyebrow_size_max      = max['eyebrows_2']
    eyebrow_color_1_max   = max['eyebrows_3']
    --hair_2_max            = max['hair_2']
    --hair_2_color_max      = max['hair_color_2']
    --beard_color_2_max     = max['beard_4']
    --eyebrow_color_2_max   = max['eyebrows_4']
    --eyebrow_height_max    = max['eyebrows_5']
    --eyebrow_depth_max     = max['eyebrows_6']
  end)

  local menuButtons = {
    {
        color = "error darken-4",
        icon = "cancel",
        text = _U("cancel"),
        action = "closeBarb"
    },
    {
        color = "success darken-4",
        icon = "currency-usd",
        --text = _U("confirm"),
        text = cost,
        action = "confirmBarb"
    }
  }
  
  local menuData = {
    { text = 'Hair Type',   icon = 'none', type = 'slider', value = hair_1_val,             sliderMin = 0, sliderMax = hair_1_max,        action = "changeBarbHair" },
    { text = 'Hair Color',  icon = 'none', type = 'slider', value = hair_color_1_val,       sliderMin = 0, sliderMax = hair_1_color_max,  action = "changeBarbHairColor1" },
    { text = 'Beard Type',  icon = 'none', type = 'slider', value = beard_type_val,         sliderMin = 0, sliderMax = beard_type_max,    action = "changeBarbBeard" },
    { text = 'Beard Size',  icon = 'none', type = 'slider', value = beard_size_val,         sliderMin = 0, sliderMax = beard_size_max,    action = "changeBarbBeardSize" },
    { text = 'Beard Color', icon = 'none', type = 'slider', value = beard_color_1_val,      sliderMin = 0, sliderMax = beard_color_1_max, action = "changeBarbBeardColor1" },
    { text = 'Eyebrow Type',  icon = 'none', type = 'slider', value = eyebrow_type_val,     sliderMin = 0, sliderMax = beard_type_max,    action = "changeBarbEyebrowType" },
    { text = 'Eyebrow Size',  icon = 'none', type = 'slider', value = eyebrow_size_val,     sliderMin = 0, sliderMax = beard_size_max,    action = "changeBarbEyebrowSize" },
    { text = 'Eyebrow Color', icon = 'none', type = 'slider', value = eyebrow_color_1_val,  sliderMin = 0, sliderMax = beard_color_1_max, action = "changeBarbEyebrowColor1" },
    
    --{ text = 'eyebrow_height',  icon = 'none', type = 'slider', value = eyebrow_height_val,   sliderMin = 0, sliderMax = beard_color_1_max, action = "changeBarbEyebrowHeight" }, --alters the physical face structure
    --{ text = 'eyebrow_depth',   icon = 'none', type = 'slider', value = eyebrow_depth_val,    sliderMin = 0, sliderMax = beard_color_1_max, action = "changeBarbEyebrowDepth" },  -- with some unrealistic results

    --{ text = 'Hair_2',        icon = 'none', type = 'slider', value = hair_2_val,       sliderMin = 0, sliderMax = hair_2_max, action = "changeBarbHairColor" },  -- these do not appear to do anything
    --{ text = 'Hair_color_2',  icon = 'none', type = 'slider', value = hair_color_2_val, sliderMin = 0, sliderMax = hair_2_color_max, action = "changeBarbHairColor2" }, -- but i'll leave them here just incase
    --{ text = 'beard_color_2', icon = 'none', type = 'slider', value = beard_color_2_val,sliderMin = 0, sliderMax = beard_color_2_max, action = "changeBarbBeardColor2" },
    --{ text = 'eyebrow_color_2', icon = 'none', type = 'slider', value = eyebrow_color_2_val,  sliderMin = 0, sliderMax = beard_size_max,    action = "changeBarbEyebrowColor2" },
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("barbMenuTitle"), _U("barbMenuDesc"), menuData, menuButtons)
end

function getBarberPrice()
  cost = 0
  if hair_1_val       ~= 0 then cost = cost +  50 end
  if beard_type_val   ~= 0 then cost = cost +  50 end
  if eyebrow_type_val ~= 0 then cost = cost +  50 end
end

function resetBarber()
  hair_1_val          = 0
  hair_color_1_val    = 0
  beard_type_val      = 0
  beard_size_val      = 0
  beard_color_1_val   = 0
  eyebrow_type_val    = 0
  eyebrow_size_val    = 0
  eyebrow_color_1_val = 0
end

function initializeBarber()
    CreateBarbCam()
    resetBarber()
    getBarberPrice()
    UpdateBarberShop()
    TriggerEvent('_drawtextui:HideUI')
end

RegisterNetEvent('_menu:handleEvent:changeBarbHair')
AddEventHandler('_menu:handleEvent:changeBarbHair', function(value)
    if value ~= 23 then
      TriggerEvent('skinchanger:change', 'hair_1', value)  
      hair_1_val = value
      getBarberPrice()
      UpdateBarberShop()
    end
end)

RegisterNetEvent('_menu:handleEvent:changeBarbHairColor')
AddEventHandler('_menu:handleEvent:changeBarbHairColor', function(value)
  TriggerEvent('skinchanger:change', 'hair_2', value)
  hair_2_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbHairColor1')
AddEventHandler('_menu:handleEvent:changeBarbHairColor1', function(value)
  TriggerEvent('skinchanger:change', 'hair_color_1', value)  
  hair_color_1_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbHairColor2')
AddEventHandler('_menu:handleEvent:changeBarbHairColor2', function(value)
  TriggerEvent('skinchanger:change', 'hair_color_2', value)
  hair_color_2_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbBeard')    
AddEventHandler('_menu:handleEvent:changeBarbBeard', function(value)
  TriggerEvent('skinchanger:change', 'beard_1', value) 
  if value ~= 0 then 
    beard_size_val = 10
    TriggerEvent('skinchanger:change', 'beard_2', 10)
  else 
    beard_size_val = 0
    TriggerEvent('skinchanger:change', 'beard_2', 0)
  end
  
  beard_type_val = value
  getBarberPrice()
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbBeardSize')
AddEventHandler('_menu:handleEvent:changeBarbBeardSize', function(value)
  TriggerEvent('skinchanger:change', 'beard_2', value)
  beard_size_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbBeardColor1')
AddEventHandler('_menu:handleEvent:changeBarbBeardColor1', function(value)
  TriggerEvent('skinchanger:change', 'beard_3', value)  
  beard_color_1_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbBeardColor2')
AddEventHandler('_menu:handleEvent:changeBarbBeardColor2', function(value)
  TriggerEvent('skinchanger:change', 'beard_4', value)
  beard_color_2_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbEyebrowType') 
AddEventHandler('_menu:handleEvent:changeBarbEyebrowType', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_1', value)  
  if value ~= 0 then 
    eyebrow_size_val = 10
    TriggerEvent('skinchanger:change', 'eyebrows_2', 10)
  else 
    eyebrow_size_val = 0
    TriggerEvent('skinchanger:change', 'eyebrows_2', 0)
  end
  eyebrow_type_val = value
  getBarberPrice()
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbEyebrowSize')
AddEventHandler('_menu:handleEvent:changeBarbEyebrowSize', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_2', value)
  eyebrow_size_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbEyebrowColor1')
AddEventHandler('_menu:handleEvent:changeBarbEyebrowColor1', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_3', value)  
  eyebrow_color_1_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbEyebrowColor2')
AddEventHandler('_menu:handleEvent:changeBarbEyebrowColor2', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_4', value)
  eyebrow_color_2_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbEyebrowHeight')
AddEventHandler('_menu:handleEvent:changeBarbEyebrowHeight', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_5', value)  
  eyebrow_height_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:changeBarbEyebrowDepth')
AddEventHandler('_menu:handleEvent:changeBarbEyebrowDepth', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_6', value)
  eyebrow_depth_val = value
  UpdateBarberShop()
end)

RegisterNetEvent('_menu:handleEvent:closeBarb')
AddEventHandler('_menu:handleEvent:closeBarb', function()
  TriggerServerEvent('getPlayerSkin')
  TriggerEvent('skinchanger:getSkin', function(Character) 
    TriggerEvent('skinchanger:loadSkin', Character)
  end)
  
  DeleteShopCam()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] Change Hair")
end)

RegisterNetEvent('_menu:handleEvent:confirmBarb')
AddEventHandler('_menu:handleEvent:confirmBarb', function()
  TriggerEvent('skinchanger:getSkin', function(Character) 
    TriggerServerEvent("addPlayerSkin", Character)
  end)

  TriggerServerEvent("RemoveMoney" , cost)

  DeleteShopCam()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  TriggerEvent('_drawtextui:ShowNotify', 'success', 2000, _U("success"))
  Wait(2100)
  TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] Change Hair")
end)



--[[RegisterNetEvent('OnInteract') -- this was moved to client/main.lua to prevent conflicted calls of this function
AddEventHandler('OnInteract', function(action, text)
  if enableBarberInteract then
    openBarberShop()
    inshop = true
    Citizen.CreateThread(function()
      while inshop == true do
        InvalidateIdleCam()
        Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
      end
    end)
  end
end)]]--

