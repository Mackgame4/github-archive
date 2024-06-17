-- Create Blips
local inClotheShop = false
Citizen.CreateThread(function()
	for k,v in ipairs(_clothingStores) do
		local blip = AddBlipForCoord(v.blip)
		SetBlipSprite(blip, 73)
		SetBlipColour(blip, 47)
    SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U("shopName"))
		EndTextCommandSetBlipName(blip)

    local clotheShop = PolyZone:Create(v.points, {
      name="clotheShop",
      minZ=v.minZ,
      maxZ=v.maxZ,
      debugGrid=false,
      debugPoly=false
    })
    clotheShop:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
        if isPointInside then
          TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".._U("changeClothes"))
          inClotheShop = true
        else
          TriggerEvent('_drawtextui:HideUI')
          inClotheShop = false
        end
    end)
	end
end)

function isInClotheShop()
  return inClotheShop
end

local helmet_1_val    = 0
local helmet_2_val    = 0     
local tshirt_1_val    = 0   
local tshirt_2_val    = 0     
local pants_1_val     = 0   
local pants_2_val     = 0 
local shoes_1_val     = 0
local shoes_2_val     = 0
local mask_1_val      = 0
local mask_2_val      = 0
local chain_1_val     = 0
local chain_2_val     = 0
local bags_1_val      = 0
local bags_2_val      = 0
local glasses_1_val   = 0
local glasses_2_val   = 0
local watches_1_val   = 0
local watches_2_val   = 0
local bracelets_1_val = 0
local bracelets_2_val = 0
local torso_1_val     = 0
local torso_2_val     = 0
--local arms_val        = 0
--local arms_2_val      = 0
--moms_val = 0
--dads_val = 0

local gender = 0
local PlayerSkin = {}
local cost = 0

function updateClotheShop()
  TriggerEvent('skinchanger:getData', function(comp, max)
    helmet_1_max     = max['helmet_1']
    helmet_2_max     = max['helmet_2']
    tshirt_1_max     = max['tshirt_1']
    tshirt_2_max     = max['tshirt_2']
    pants_1_max      = max['pants_1']
    pants_2_max      = max['pants_2']
    shoes_1_max      = max['shoes_1']
    shoes_2_max      = max['shoes_2']
    mask_1_max       = max['mask_1']
    mask_2_max       = max['mask_2']
    chain_1_max      = max['chain_1']
    chain_2_max      = max['chain_2']
    bags_1_max       = max['bags_1']
    bags_2_max       = max['bags_2']
    glasses_1_max    = max['glasses_1']
    glasses_2_max    = max['glasses_2']
    watches_1_max    = max['watches_1']
    watches_2_max    = max['watches_2']
    bracelets_1_max  = max['bracelets_1']
    bracelets_2_max  = max['bracelets_2']
    torso_1_max      = max['torso_1']
    torso_2_max      = max['torso_2']
    arms_max         = max['arms']
    arms_2_max       = max['arms_2']
    --gloves_max     = arms_max / 15
    --moms_max     = max['mom']
    --dads_max     = max['dad']
  end)

  local menuButtons = {
    {
        color = "error darken-4",
        icon = "cancel",
        text = _U("cancel"),
        action = "closeClothe"
    },
    {
        color = "success darken-4",
        icon = "currency-usd",
        --text = _U("confirm"),
        text = cost,
        action = "confirmClothe"
    }
  }

  local menuData = {
    --{ text = 'moms', icon = 'none', type = 'slider', value = moms_val, sliderMin = 0, sliderMax = moms_max, action = "changeMom" }, --just seeing what these do
    --{ text = 'dads', icon = 'none', type = 'slider', value = dads_val, sliderMin = 0, sliderMax = dads_max, action = "changeDad" },
    --{ text = 'arms', icon = 'none', type = 'slider', value = arms_val, sliderMin = 0, sliderMax = arms_max, action = "changeClotheArms" },
    --{ text = 'arms_2', icon = 'none', type = 'slider', value = arms_2_val, sliderMin = 0, sliderMax = arms_2_max, action = "changeClotheArms2" },
    --{ text = 'Gloves', icon = 'none', type = 'slider', value = gloves_val, sliderMin = 0, sliderMax = gloves_max, action = "changeClotheGloves" },
    --{ text = 'Gloves Colors', icon = 'none', type = 'slider', value = gloves_2_val, sliderMin = 0, sliderMax = arms_2_max, action = "changeGlovesTexture" },
    --{ text = 'Your Presets', icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = 100, action = "changeClothePreset" }, -- should build this after db implementation
    { text = 'Clear Clothes', icon = 'mdi-folder', type = 'default', action = "clearPed"},
    --{ text = 'Male/Female', icon = 'none', type = 'switch', value = gender_val, action = "changeGender" }, --no need to let them change their gender
    { text = 'Hat', icon = 'none', type = 'slider', value = helmet_1_val, sliderMin = 0, sliderMax = helmet_1_max + 1, action = "changeClotheHat" },
    { text = 'Hat Colors', icon = 'none', type = 'slider', value = helmet_2_val, sliderMin = 0, sliderMax = helmet_2_max, action = "changeClotheHatTexture" },
    { text = 'Glasses', icon = 'none', type = 'slider', value = glasses_1_val, sliderMin = 0, sliderMax = glasses_1_max + 1, action = "changeClotheGlasses" },
    { text = 'Glasses Colors', icon = 'none', type = 'slider', value = glasses_2_val, sliderMin = 0, sliderMax = glasses_2_max, action = "changeClotheGlassesTexture" },
    { text = 'Mask', icon = 'none', type = 'slider', value = mask_1_val, sliderMin = 0, sliderMax = mask_1_max, action = "changeClotheMask" },
    { text = 'Mask Colors', icon = 'none', type = 'slider', value = mask_2_val, sliderMin = 0, sliderMax = mask_2_max, action = "changeClotheMaskTexture" },
    { text = 'Chain', icon = 'none', type = 'slider', value = chain_1_val, sliderMin = 0, sliderMax = chain_1_max, action = "changeClotheChain" },
    { text = 'Chain Colors', icon = 'none', type = 'slider', value = chain_2_val, sliderMin = 0, sliderMax = chain_2_max, action = "changeClotheChainTexture" },
    { text = 'Over-shirt', icon = 'none', type = 'slider', value = torso_1_val, sliderMin = 0, sliderMax = torso_1_max, action = "changeClotheTorso" },
    { text = 'Over-shirt Colors', icon = 'none', type = 'slider', value = torso_2_val, sliderMin = 0, sliderMax = torso_2_max, action = "changeClotheTorsoTexture" },
    { text = 'Under-shirt', icon = 'none', type = 'slider', value = tshirt_1_val, sliderMin = 0, sliderMax = tshirt_1_max, action = "changeClotheTShirt" },
    { text = 'Under-shirt Colors', icon = 'none', type = 'slider', value = tshirt_2_val, sliderMin = 0, sliderMax = tshirt_2_max, action = "changeClotheTShirtTexture" },
    { text = 'Bags', icon = 'none', type = 'slider', value = bags_1_val, sliderMin = 0, sliderMax = bags_1_max, action = "changeClotheBags" },
    { text = 'Bags Colors', icon = 'none', type = 'slider', value = bags_2_val, sliderMin = 0, sliderMax = bags_2_max, action = "changeClotheBagsTexture" },
    { text = 'Watches', icon = 'none', type = 'slider', value = watches_1_val, sliderMin = 0, sliderMax = watches_1_max + 1, action = "changeClotheWatches" },
    { text = 'Watches Colors', icon = 'none', type = 'slider', value = watches_2_val, sliderMin = 0, sliderMax = watches_2_max, action = "changeClotheWatchesTexture" },
    { text = 'Bracelets', icon = 'none', type = 'slider', value = bracelets_1_val, sliderMin = 0, sliderMax = bracelets_1_max + 1, action = "changeClotheBracelets" },
    { text = 'Bracelets Colors', icon = 'none', type = 'slider', value = bracelets_2_val, sliderMin = 0, sliderMax = bracelets_2_max, action = "changeClotheBraceletsTexture" },
    { text = 'Pants', icon = 'none', type = 'slider', value = pants_1_val, sliderMin = 0, sliderMax = pants_1_max, action = "changeClothePants" },
    { text = 'Pants Colors', icon = 'none', type = 'slider', value = pants_2_val, sliderMin = 0, sliderMax = pants_2_max, action = "changeClothePantsTexture" },
    { text = 'Shoes', icon = 'none', type = 'slider', value = shoes_1_val, sliderMin = 0, sliderMax = shoes_1_max, action = "changeClotheShoes"},
    { text = 'Shoes Colors', icon = 'none', type = 'slider', value = shoes_2_val, sliderMin = 0, sliderMax = shoes_2_max, action = "changeClotheShoesTexture"},
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("menuTitle"), _U("menuDesc"), menuData, menuButtons)
end

--[[function openClotheShop() -- this has been moved to barberShops.lua, as the onInteract function conflicted between all the stores
  -- Menu Config
  if shop == 'Clothe' then 
    updateClotheShop()
    enableShopInteract = false
    TriggerEvent('_drawtextui:HideUI')
    --enableBarberInteract = true
  end 
end]]--

function getClothingPrice()
  cost = 0
  if torso_1_val      ~= 0 then cost = cost +  200 end 
  if bags_1_val       ~= 0 then cost = cost +  150 end 
  if watches_1_val    ~= 0 then cost = cost +  300 end 
  if tshirt_1_val     ~= 0 then cost = cost +  150 end 
  if pants_1_val      ~= 0 then cost = cost +  200 end 
  if shoes_1_val      ~= 0 then cost = cost +  150 end 
  if mask_1_val       ~= 0 then cost = cost +  100 end 
  if chain_1_val      ~= 0 then cost = cost +  300 end 
  if glasses_1_val    ~= 0 then cost = cost +  150 end 
  if bracelets_1_val  ~= 0 then cost = cost +  150 end 
  if helmet_1_val     ~= 0 then cost = cost +  100 end 
end

function getGender()
  local playermodel = GetEntityModel(PlayerPedId())

  if playermodel == GetHashKey('mp_m_freemode_01') then 
      gender = 0
      gender_val = false
  else
      gender = 1
      gender_val = true
  end
end

function initializeClothe()
    CreateShopCam()
    TriggerServerEvent('getPlayerSkin')
    getGender()
    resetClotheShop() 
    updateClotheShop()
    TriggerEvent('_drawtextui:HideUI')
    --enableBarberInteract = true
end

function resetClotheShop()
  helmet_1_val    = 0
  helmet_2_val    = 0     
  tshirt_1_val    = 0   
  tshirt_2_val    = 0     
  pants_1_val     = 0   
  pants_2_val     = 0 
  shoes_1_val     = 0
  shoes_2_val     = 0
  mask_1_val      = 0
  mask_2_val      = 0
  chain_1_val     = 0
  chain_2_val     = 0
  bags_1_val      = 0
  bags_2_val      = 0
  glasses_1_val   = 0
  glasses_2_val   = 0
  watches_1_val   = 0
  watches_2_val   = 0
  bracelets_1_val = 0
  bracelets_2_val = 0
  torso_1_val     = 0
  torso_2_val     = 0
end

RegisterNetEvent('_menu:handleEvent:changeClothePreset')
AddEventHandler('_menu:handleEvent:changeClothePreset', function(value)
  ExecuteCommand(gender..value)  
  print(gender..value)
end)


RegisterNetEvent('_menu:handleEvent:clearPed')
AddEventHandler('_menu:handleEvent:clearPed', function()
  TriggerEvent('skinchanger:clearPed')
  resetClotheShop()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeGender')
AddEventHandler('_menu:handleEvent:changeGender', function(value)
  if value ==  false then
    gender = 0
    gender_val = false
  elseif value == true then
    gender = 1
    gender_val = true
  end
  --LoadDefaultModel(value)
  TriggerEvent('skinchanger:change' , 'sex' , gender)
  TriggerEvent('skinchanger:getJacketVariations' , torso_1_val , gender)
end)

RegisterNetEvent('_menu:handleEvent:changeClotheHat')
AddEventHandler('_menu:handleEvent:changeClotheHat', function(value)
    TriggerEvent('skinchanger:change', 'helmet_1', value - 1)  
    helmet_1_val = value
    getClothingPrice()
    updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheHatTexture')
AddEventHandler('_menu:handleEvent:changeClotheHatTexture', function(value)
  TriggerEvent('skinchanger:change', 'helmet_2', value)
  helmet_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheGlasses')
AddEventHandler('_menu:handleEvent:changeClotheGlasses', function(value)
  TriggerEvent('skinchanger:change', 'glasses_1', value - 1)
  glasses_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheGlassesTexture')
AddEventHandler('_menu:handleEvent:changeClotheGlassesTexture', function(value)
  TriggerEvent('skinchanger:change', 'glasses_2', value)
  glasses_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheMask')
AddEventHandler('_menu:handleEvent:changeClotheMask', function(value)
  TriggerEvent('skinchanger:change', 'mask_1', value)
  mask_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheMaskTexture')
AddEventHandler('_menu:handleEvent:changeClotheMaskTexture', function(value)
  TriggerEvent('skinchanger:change', 'mask_2', value)
  mask_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheChain')
AddEventHandler('_menu:handleEvent:changeClotheChain', function(value)
  TriggerEvent('skinchanger:change', 'chain_1', value)
  chain_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheChainTexture')
AddEventHandler('_menu:handleEvent:changeClotheChainTexture', function(value)
  TriggerEvent('skinchanger:change', 'chain_2', value)
  chain_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheArms')
AddEventHandler('_menu:handleEvent:changeClotheArms', function(value)
  TriggerEvent('skinchanger:change', 'arms', value)
  arms_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheArms2')
AddEventHandler('_menu:handleEvent:changeClotheArms2', function(value)
  TriggerEvent('skinchanger:change', 'arms_2', value)
  arms_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheTShirt')
AddEventHandler('_menu:handleEvent:changeClotheTShirt', function(value)
  if value == 0 then                                    -- clear the torso to default 
    TriggerEvent('skinchanger:change', 'arms', 15)
    TriggerEvent('skinchanger:change', 'torso_1', 15)
    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
    tshirt_1_val = value
    torso_1_val = 0
  else
    TriggerEvent('skinchanger:change', 'tshirt_1', value)
    TriggerEvent('skinchanger:checkShirtClipping', torso_1_val , gender)
    tshirt_1_val = value
  end
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheTShirtTexture')
AddEventHandler('_menu:handleEvent:changeClotheTShirtTexture', function(value)
  TriggerEvent('skinchanger:change', 'tshirt_2', value)
  tshirt_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheTorso')
AddEventHandler('_menu:handleEvent:changeClotheTorso', function(value)
  if value == 0 then                                    -- clear the torso to default 
    TriggerEvent('skinchanger:change', 'arms', 15)
    TriggerEvent('skinchanger:change', 'torso_1', 15)
    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
    torso_1_val = value
    getClothingPrice()
    updateClotheShop()
  else
    if gender == 0 then
      if 
        value ~= 314  and -- all below is firefighter + police torso's
        value ~= 315  and -- this solution just ignores these entries... 
        value ~= 316  and -- it's a stopgap until i figure out a more elegant solution
        value ~= 317  and
        value ~= 318  and 
        value ~= 319  and
        value ~= 320
      then 
        TriggerEvent('skinchanger:change', 'tshirt_1', 15)  -- male chest value without clipping shirts 
        TriggerEvent('skinchanger:getJacketVariations', value, gender)
        TriggerEvent('skinchanger:change', 'torso_1', value)
      end
    elseif gender == 1 then
      if
        value ~= 82   and -- full nude torso
        value ~= 260  and -- full nude torso
        value ~= 325  and -- all below is firefighter + police torso's
        value ~= 326  and -- this solution just ignores these entries... 
        value ~= 327  and -- it's a stopgap until i figure out a more elegant solution
        value ~= 328  and
        value ~= 329  and 
        value ~= 330  and
        value ~= 331
      then 
        TriggerEvent('skinchanger:change', 'tshirt_1', 6)   -- female chest value without clipping brassiers
        TriggerEvent('skinchanger:getJacketVariations', value, gender)
        TriggerEvent('skinchanger:change', 'torso_1', value)
      end    
    end
    
    tshirt_1_val = 0
    torso_1_val = value
    getClothingPrice()
    updateClotheShop()
  end
end)

RegisterNetEvent('_menu:handleEvent:changeClotheTorsoTexture')
AddEventHandler('_menu:handleEvent:changeClotheTorsoTexture', function(value)
  TriggerEvent('skinchanger:change', 'torso_2', value)
  torso_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheBags')
AddEventHandler('_menu:handleEvent:changeClotheBags', function(value)
  TriggerEvent('skinchanger:change', 'bags_1', value)
  bags_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheBagsTexture')
AddEventHandler('_menu:handleEvent:changeClotheBagsTexture', function(value)
  TriggerEvent('skinchanger:change', 'bags_2', value)
  bags_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheWatches')
AddEventHandler('_menu:handleEvent:changeClotheWatches', function(value)
  TriggerEvent('skinchanger:change', 'watches_1', value -1)
  watches_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheWatchesTexture')
AddEventHandler('_menu:handleEvent:changeClotheWatchesTexture', function(value)
  TriggerEvent('skinchanger:change', 'watches_2', value)
  watches_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheBracelets')
AddEventHandler('_menu:handleEvent:changeClotheBracelets', function(value)
  TriggerEvent('skinchanger:change', 'bracelets_1', value - 1)
  bracelets_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheBraceletsTexture')
AddEventHandler('_menu:handleEvent:changeClotheBraceletsTexture', function(value)
  TriggerEvent('skinchanger:change', 'bracelets_2', value)
  bracelets_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClothePants')
AddEventHandler('_menu:handleEvent:changeClothePants', function(value)
  if 
  value ~= 11   and  -- invisible legs
  value ~= 30   and  -- this solution just ignores these entries... 
  value ~= 41   and  -- it's a stopgap until i figure out a more elegant solution
  value ~= 93   and
  value ~= 111  and
  value ~= 112  and
  value ~= 113  and
  value ~= 115  and
  value ~= 121  and
  value ~= 122  and
  value ~= 123  and
  value ~= 127  and
  value ~= 131  and
  value ~= 133
  then
    TriggerEvent('skinchanger:change', 'pants_1', value)
    pants_1_val = value
    getClothingPrice()
    updateClotheShop()
  end  
end)

RegisterNetEvent('_menu:handleEvent:changeClothePantsTexture')
AddEventHandler('_menu:handleEvent:changeClothePantsTexture', function(value)
  TriggerEvent('skinchanger:change', 'pants_2', value)
  pants_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheShoes')
AddEventHandler('_menu:handleEvent:changeClotheShoes', function(value)
  TriggerEvent('skinchanger:change', 'shoes_1', value)
  shoes_1_val = value
  getClothingPrice()
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:changeClotheShoesTexture')
AddEventHandler('_menu:handleEvent:changeClotheShoesTexture', function(value)
  TriggerEvent('skinchanger:change', 'shoes_2', value)
  shoes_2_val = value
  updateClotheShop()
end)

RegisterNetEvent('_menu:handleEvent:closeClothe')
AddEventHandler('_menu:handleEvent:closeClothe', function()
  TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] Change Clothes")
  
  TriggerServerEvent('getPlayerSkin')
  TriggerEvent('skinchanger:getSkin', function(Character) 
    TriggerEvent('skinchanger:loadSkin', Character)
  end)
  
  DeleteShopCam()

  enableShopInteract = true
  inshop = false
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
end)

RegisterNetEvent('_menu:handleEvent:confirmClothe')
AddEventHandler('_menu:handleEvent:confirmClothe', function()
  
  TriggerEvent('skinchanger:getSkin', function(Character) 
    TriggerServerEvent("addPlayerSkin", Character)
  end)

  TriggerServerEvent("RemoveMoney" , cost)
  DeleteShopCam()

  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  TriggerEvent('_drawtextui:ShowNotify', 'success', 2000, _U("success"))
  Wait(2100)
  TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] Change Clothes")
  inshop = false
end)

RegisterNetEvent('clotheShops:getPlayerSkin')
AddEventHandler('clotheShops:getPlayerSkin', function(Character)
  TriggerEvent('skinchanger:loadSkin',Character)
end)

--[[RegisterNetEvent('OnInteract') --this was moved to client/main.lua to prevent conflicted calls of this function
AddEventHandler('OnInteract', function(action, text)
  if enableClotheInteract then
    openClotheShop()
    inshop = true
    Citizen.CreateThread(function()
      while inshop == true do
        InvalidateIdleCam()
        Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
      end
    end)
  end
end)]]--