local defaultSkin = 
{
    sex				  = 0,
    mom				  = 0, 
    dad				  = 0, 
    face_md_weight	= 0,
    skin_md_weight	= 0,
    nose_1			= 0,
    nose_2			= 0,
    nose_3			= 0,
    nose_4			= 0,
    nose_5			= 0,
    nose_6			= 0,
    cheeks_1		= 0,
    cheeks_2		= 0,
    cheeks_3		= 0,
    lip_thickness	= 0,
    jaw_1			  = 0,
    jaw_2			  = 0,
    chin_1			= 0,
    chin_2			= 0,
    chin_3			= 0,
    chin_4			= 0,
    neck_thickness	= 0,
    age_1			  = 0,
    age_2			  = 0,
    beard_1			= 0,
    beard_2			= 0,
    beard_3			= 0,
    beard_4			= 0,
    hair_1			= 0,
    hair_2			= 0,
    hair_color_1= 0,
    hair_color_2= 0,
    eye_color		= 0,
    eye_squint	= 0,
    eyebrows_1	= 0,
    eyebrows_2	= 0,
    eyebrows_3	= 0,
    eyebrows_4	= 0,
    eyebrows_5	= 0,
    eyebrows_6	= 0,
    makeup_1		= 0,
    makeup_2		= 0,
    makeup_3		= 0,
    makeup_4		= 0,
    lipstick_1	= 0,
    lipstick_2	= 0,
    lipstick_3	= 0,
    lipstick_4	= 0,
    blemishes_1	= 0,
    blemishes_2	= 0,
    blush_1			= 0,
    blush_2			= 0,
    blush_3			= 0,
    complexion_1= 0,
    complexion_2= 0,
    sun_1			  = 0,
    sun_2			  = 0,
    moles_1			= 0,
    moles_2			= 0,
    chest_1			= 0,
    chest_2			= 0,
    chest_3			= 0,
    bodyb_1			= 0,
    bodyb_2			= 0,
    bodyb_3			= 0,
    bodyb_4			= 0,
    ears_1			= -1,
    ears_2			= 0,
    tshirt_1		= 0,
    tshirt_2		= 0,
    torso_1			= 0,
    torso_2			= 0,
    decals_1		= 0,
    decals_2		= 0,
    arms			  = 0,
    arms_2			= 0,
    pants_1			= 0,
    pants_2			= 0,
    shoes_1			= 1,
    shoes_2			= 0,
    mask_1			= 0,
    mask_2			= 0,
    bproof_1		= 0,
    bproof_2		= 0,
    chain_1			= 0,
    chain_2			= 0,
    bags_1			= 0,
    bags_2			= 0,
    helmet_1		= -1,   --accessories are weird
    helmet_2		= 0,
    glasses_1		= -1,
    glasses_2		= 0,
    watches_1		= -1,
    watches_2		= 0,
    bracelets_1	= -1,
    bracelets_2	= 0
}

local hair_1_max, hair_1_color_max, beard_type_max, beard_size_max, beard_color_1_max, eyebrow_type_max,      
eyebrow_size_max, eyebrow_color_1_max,face_md_weight_max, nose_1_max, nose_2_max, nose_3_max, nose_4_max,            
nose_5_max, nose_6_max, cheeks_1_max, cheeks_2_max, cheeks_3_max, jaw_1_max, jaw_2_max, chin_1_max,            
chin_2_max, chin_3_max, chin_4_max, neck_thickness_max, wrinkles_max, wrinkle_thickness_max, eye_color_max,
eye_squint_max, ears_1_max, ears_2_max, blemishes_1_max, blemishes_2_max,
bodyb_1_max, bodyb_2_max, bodyb_3_max, complexion_1_max, complexion_2_max, sun_1_max, sun_2_max, freckles_1_max,
freckles_2_max, mom_max, dad_max, skin_tone_max, lip_thickness_max, chest_1_max, chest_hair_1_max, chest_color_max     
    --hair_2_max,            
    --hair_2_color_max,      
    --beard_color_2_max,     
    --eyebrow_color_2_max,   
    --eyebrow_height_max,   
    --eyebrow_depth_max,  
local enable = true

function getMaxVals()
  TriggerEvent('skinchanger:getData', function(comp, max)
    hair_1_max            = max['hair_1']
    hair_1_color_max      = max['hair_color_1']
    beard_type_max        = max['beard_1']
    beard_size_max        = max['beard_2']
    beard_color_1_max     = max['beard_3']
    eyebrow_type_max      = max['eyebrows_1']
    eyebrow_size_max      = max['eyebrows_2']
    eyebrow_color_1_max   = max['eyebrows_3']
    face_md_weight_max    = max['face_md_weight']
    nose_1_max            = max['nose_1']
    nose_2_max            = max['nose_2']
    nose_3_max            = max['nose_3']
    nose_4_max            = max['nose_4']
    nose_5_max            = max['nose_5']
    nose_6_max            = max['nose_6']
    cheeks_1_max          = max['cheeks_1']
    cheeks_2_max          = max['cheeks_2']
    cheeks_3_max          = max['cheeks_3']
    jaw_1_max             = max['jaw_1']
    jaw_2_max             = max['jaw_2']
    chin_1_max            = max['chin_1']
    chin_2_max            = max['chin_2']
    chin_3_max            = max['chin_3']
    chin_4_max            = max['chin_4']
    neck_thickness_max    = max['neck_thickness']
    wrinkles_max          = max['age_1']
    wrinkle_thickness_max = max['age_2']
    eye_color_max         = max['eye_color']
    eye_squint_max        = max['eye_squint']
    ears_1_max            = max['ears_1']
    ears_2_max            = max['ears_2']
    blemishes_1_max       = max['blemishes_1']
    blemishes_2_max       = max['blemishes_2']
    lip_thickness_max     = max['lip_thickness']
    complexion_1_max      = max['complexion_1']
    complexion_2_max      = max['complexion_2']
    freckles_1_max        = max['moles_1']
    freckles_2_max        = max['moles_2']
    skin_tone_max         = max['skin_md_weight']
    chest_1_max           = max['chest_1']
    chest_hair_1_max      = max['chest_2']
    chest_color_max       = max['chest_3']
    bodyb_1_max           = max['bodyb_1']
    bodyb_2_max           = max['bodyb_2']
    bodyb_3_max           = max['bodyb_3']
    sun_1_max             = max['sun_1']
    sun_2_max             = max['sun_2']
    mom_max               = max['mom']
    dad_max               = max['dad']
    --hair_2_max            = max['hair_2']
    --hair_2_color_max      = max['hair_color_2']
    --beard_color_2_max     = max['beard_4']
    --eyebrow_color_2_max   = max['eyebrows_4']
    --eyebrow_height_max    = max['eyebrows_5']
    --eyebrow_depth_max     = max['eyebrows_6']
  end)
end

RegisterNetEvent('charactercreator:initialize')
AddEventHandler('charactercreator:initialize', function()
  --Wait(1000)
  SetEntityCoords(PlayerPedId(), 402.89, -996.87, -100.0, 0.0, 0.0, 0.0, true)    -- double called this for testing purposes
  SetEntityHeading(PlayerPedId(), 175.0)

	FreezeEntityPosition(PlayerPedId(), true)
  
  TriggerEvent('skinchanger:loadSkin', defaultSkin)
  TriggerServerEvent("addPlayerSkin", defaultSkin)       
  
  TriggerServerEvent("addPlayerTattoos", {})
  
  TriggerEvent('_drawtextui:HideUI')
  
  getMaxVals()
  CharacterCreatorMenu()
  CreateGeneralCam()

  enable = true
  Visible()
  
  --TriggerServerEvent('instance:set')
end)

function CharacterCreatorMenu() 
  local menuButtons = {
    {
        color = "success darken-4",
        --icon = "currency-usd",
        text = _U('confirm'),
        action = "confirmCharacter"
    }
  }
  local menuData = {
    { text = _U('Male/Female'), icon = 'none', type = 'switch', value = false, action = "CharChangeGender" },
    { text = _U('HeritageMenuTitle'), icon = 'mdi-folder', type = 'default', action = "openHeritageMenu"},
    { text = _U('GeneralMenuTitle'), icon = 'mdi-folder', type = 'default', action = "openGeneralMenu"},
    { text = _U('FaceMenuTitle'), icon = 'mdi-folder', type = 'default', action = "openFaceMenu"},
    { text = _U('HairMenuTitle'), icon = 'mdi-folder', type = 'default', action = "openHeadHairMenu"},
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("CharacterMenuTitle"), _U("CharacterMenuDesc"), menuData, menuButtons)
end

function HeadHairMenu() 
  local menuButtons = {
    {
        color = "success darken-4",
        --icon = "currency-usd",
        text = _U('back'),
        action = "OpenCharacterMenu"
    }
  }
  local menuData = {
    { text = _U('hair_1'),      icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = hair_1_max,          action = "changeHair" },
    { text = _U('hair_color_1'),icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = hair_1_color_max,    action = "changeHairColor1" },
    { text = _U('beard_1'),     icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = beard_type_max,      action = "changeBeard" },
    { text = _U('beard_2'),     icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = beard_size_max,      action = "changeBeardSize" },
    { text = _U('beard_3'),     icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = beard_color_1_max,   action = "changeBeardColor1" },
    { text = _U('eyebrows_1'),  icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = eyebrow_type_max ,   action = "changeEyebrowType" },
    { text = _U('eyebrows_2'),  icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = eyebrow_size_max,    action = "changeEyebrowSize" },
    { text = _U('eyebrows_3'),  icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = eyebrow_color_1_max, action = "changeEyebrowColor1" },
    --{text = 'eyebrow_height',  icon = 'none', type = 'slider', value = eyebrow_height_val,   sliderMin = 0, sliderMax = beard_color_1_max, action = "changeBarbEyebrowHeight" }, --alters the physical face structure
    --{ text = 'eyebrow_depth',   icon = 'none', type = 'slider', value = eyebrow_depth_val,    sliderMin = 0, sliderMax = beard_color_1_max, action = "changeBarbEyebrowDepth" },  -- with some unrealistic result
    --{ text = 'Hair_2',        icon = 'none', type = 'slider', value = hair_2_val,       sliderMin = 0, sliderMax = hair_2_max, action = "changeBarbHairColor" },  -- these do not appear to do anything
    --{ text = 'Hair_color_2',  icon = 'none', type = 'slider', value = hair_color_2_val, sliderMin = 0, sliderMax = hair_2_color_max, action = "changeBarbHairColor2" }, -- but i'll leave them here just incase
    --{ text = 'beard_color_2', icon = 'none', type = 'slider', value = beard_color_2_val,sliderMin = 0, sliderMax = beard_color_2_max, action = "changeBarbBeardColor2" },
    --{ text = 'eyebrow_color_2', icon = 'none', type = 'slider', value = eyebrow_color_2_val,  sliderMin = 0, sliderMax = beard_size_max,    action = "changeBarbEyebrowColor2" },
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("HairMenuTitle"), _U("HairMenuDesc"), menuData, menuButtons)
end

function FaceMenu()
  local menuButtons = {
    {
        color = "success darken-4",
        --icon = "currency-usd",
        text = _U('back'),
        action = "OpenCharacterMenu"
    }
  }

  local menuData = {
    { text = _U('eye_color'),     icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = eye_color_max,         action = "changeeye_color" },
    { text = _U('eye_squint'),    icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = eye_squint_max,        action = "changeeye_squint" },
    { text = _U('nose_1'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = nose_1_max,            action = "changenose_1" },
    { text = _U('nose_2'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = nose_2_max,            action = "changenose_2" },
    { text = _U('nose_3'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = nose_3_max,            action = "changenose_3" },
    { text = _U('nose_4'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = nose_4_max,            action = "changenose_4" },
    { text = _U('nose_5'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = nose_5_max,            action = "changenose_5" },
    { text = _U('nose_6'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = nose_6_max,            action = "changenose_6" },
    { text = _U('lip_thickness'), icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = lip_thickness_max,     action = "changelip_thickness" },
    { text = _U('cheeks_1'),      icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = cheeks_1_max,          action = "changecheeks_1" },
    { text = _U('cheeks_2'),      icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = cheeks_2_max,          action = "changecheeks_2" },
    { text = _U('cheeks_3'),      icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = cheeks_3_max,          action = "changecheeks_3" },
    { text = _U('jaw_1'),         icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = jaw_1_max,             action = "changejaw_1" },
    { text = _U('jaw_2'),         icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = jaw_2_max,             action = "changejaw_2" },
    { text = _U('chin_1'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = chin_1_max,            action = "changechin_1" },
    { text = _U('chin_2'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = chin_2_max,            action = "changechin_2" },
    { text = _U('chin_3'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = chin_3_max,            action = "changechin_3" },
    { text = _U('chin_4'),        icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = chin_4_max,            action = "changechin_4" },
    { text = _U('neck_thickness'),icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = neck_thickness_max,    action = "changeneck_thickness" },
    { text = _U('moles_1'),       icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = freckles_1_max,        action = "changefreckles_1" },
    { text = _U('moles_2'),       icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = freckles_2_max,        action = "changefreckles_2" },
    { text = _U('blemishes_1'),   icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = blemishes_1_max,       action = "changeblemishes_1" },
    { text = _U('blemishes_2'),   icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = blemishes_2_max,       action = "changeblemishes_2" },
    { text = _U('age_1'),         icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = wrinkles_max,          action = "changewrinkles" },
    { text = _U('age_2'),         icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = wrinkle_thickness_max, action = "changewrinkle_thickness" },
    { text = _U('complexion_1'),  icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = complexion_1_max,      action = "changecomplexion_1" },
    { text = _U('complexion_2'),  icon = 'none', type = 'slider', value = 0, sliderMin = 0, sliderMax = complexion_2_max,      action = "changecomplexion_2" },
    --{ text = 'ears_1_max',  icon = 'none', type = 'slider', value = 0,            sliderMin = 0, sliderMax = ears_1_max,            action = "changeears_1" }, --earrings
    --{ text = 'ears_2_max',  icon = 'none', type = 'slider', value = 10,           sliderMin = 0, sliderMax = ears_2_max,            action = "changeears_2" },
   
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("FaceMenuTitle"), _U("FaceMenuDesc"), menuData, menuButtons)
end

function GeneralCreatorMenu() 
  local menuButtons = {
    {
        color = "success darken-4",
        --icon = "currency-usd",
        text = _U('back'),
        action = "OpenCharacterMenu"
    }
  }
  local menuData = {
    { text = _U('chest_1'),   icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = chest_1_max,       action = "changechest_1"},
    { text = _U('chest_2'),   icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = chest_hair_1_max,  action = "changechest_hair_1"},
    { text = _U('chest_3'),   icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = chest_color_max,   action = "changechest_color" },
    { text = _U('bodyb_1'),   icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = bodyb_1_max,       action = "changebodyb_1" },
    { text = _U('bodyb_2'),   icon = 'none', type = 'slider', value = 0,  sliderMin = 0, sliderMax = bodyb_2_max,       action = "changebodyb_2" },
    
    --{ text = 'bodyb_3_max',  icon = 'none', type = 'slider', value = 10,        sliderMin = 0, sliderMax = bodyb_3_max,       action = "changebodyb_3" }, -- doesnt appear to do anything
    --{ text = 'sun_1_max', icon = 'none', type = 'slider', value = 0,            sliderMin = 0, sliderMax = sun_1_max,         action = "changesun_1" }, --supposed to be sun damage, but i can't
    --{ text = 'sun_2_max', icon = 'none', type = 'slider', value = 0,            sliderMin = 0, sliderMax = sun_2_max,         action = "changesun_2" }, --see it doing anything regardless of context
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("GeneralMenuTitle"), _U("GeneralMenuTitle"), menuData, menuButtons)
end

function HeritageMenu()
  local menuButtons = {
    {
        color = "success darken-4",
        --icon = "currency-usd",
        text = _U('back'),
        action = "OpenCharacterMenu"
    }
  }

  if getGender() == 0 then 
    mom_max = 23
    dad_max = 24
  else
    mom_max = 22
    dad_max = 20
  end  

  local menuData = {
    { text = _U('mom'),              icon = 'none', type = 'slider',  value = 0,  sliderMin = 0, sliderMax = mom_max,           action = "changemom" },
    { text = _U('dad'),              icon = 'none', type = 'slider',  value = 0,  sliderMin = 0, sliderMax = dad_max,           action = "changedad" },
    { text = _U('face_md_weight'),   icon = 'none', type = 'slider',  value = 0,  sliderMin = 0, sliderMax = face_md_weight_max,action = "changeface_md_weight" },
    { text = _U('skin_md_weight'),   icon = 'none', type = 'slider',  value = 0,  sliderMin = 0, sliderMax = skin_tone_max,     action = "changeskin_tone" },
    
  }
  TriggerEvent('_menu:handleMenu', 'show', 'menu', _U("HeritageMenuTitle"), _U("HeritageMenuDesc"), menuData, menuButtons)
end

RegisterNetEvent('_menu:handleEvent:OpenCharacterMenu')
AddEventHandler('_menu:handleEvent:OpenCharacterMenu', function()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  CharacterCreatorMenu()
  CreateGeneralCam()
  ReClothe()
end)

RegisterNetEvent('_menu:handleEvent:openGeneralMenu')
AddEventHandler('_menu:handleEvent:openGeneralMenu', function()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')

  StripClothes()
  GeneralCreatorMenu() 
  CreateGeneralCam()
end)

RegisterNetEvent('_menu:handleEvent:openHeadHairMenu')
AddEventHandler('_menu:handleEvent:openHeadHairMenu', function()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  HeadHairMenu()
  CreateHeadCam()
end)

RegisterNetEvent('_menu:handleEvent:openHeritageMenu')
AddEventHandler('_menu:handleEvent:openHeritageMenu', function()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  
  HeritageMenu()
  CreateGeneralCam()
end)

RegisterNetEvent('_menu:handleEvent:openFaceMenu')
AddEventHandler('_menu:handleEvent:openFaceMenu', function()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  FaceMenu()
  CreateHeadCam()
end)

RegisterNetEvent('_menu:handleEvent:confirmCharacter')
AddEventHandler('_menu:handleEvent:confirmCharacter', function()
  TriggerEvent('_menu:handleMenu', 'hide', 'menu')
  ReClothe()
  DeleteHeadCam()
  FreezeEntityPosition(GetPlayerPed(-1), false)
  TriggerEvent('skinchanger:getSkin', function(Character) 
    TriggerServerEvent("addPlayerSkin", Character)
  end)
  SetEntityCoords(PlayerPedId(), -475.60, -705.9495, 19.9, 0.0, 0.0, 0.0, true)
  SetEntityHeading(PlayerPedId(), 315.78)
  enable = false
  Visible()
  --Wait(1000)
  FreezeEntityPosition(PlayerPedId(), false)
  --TriggerServerEvent('instance:set', 0)
  
  TriggerEvent("PlayerStatus", {{hunger = 100, thirst = 100}})
  TriggerServerEvent('savePlayerStatus',100,100)
end)

RegisterCommand("character", function(source, args, rawCommand) -- These are temporary. Uses chat box commands. TODO: Implement menu
	TriggerEvent('charactercreator:initialize')
end, false)

local cam

function CreateHeadCam()
  if not DoesCamExist(cam) then
      cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  end

  local playerPed = PlayerPedId()

  SetCamActive(cam, true)
  RenderScriptCams(true, true, 500, true, true)

  local xyz = GetEntityCoords(playerPed)
  SetCamCoord(cam, 402.92, -1000.72, -98.45)
  SetCamFov(cam, 10.0)
  PointCamAtCoord(cam, xyz.x , xyz.y , xyz.z + 0.6 )
  
  --SetCamRot(cam, 0.0, 0.0, 270.0, true)
end

function DeleteHeadCam()
  --local isCameraActive = false
  SetCamActive(cam, false)
  RenderScriptCams(false, true, 500, true, true)
  cam = nil
end

function CreateGeneralCam()
  if not DoesCamExist(cam) then
      cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  end

  local playerPed = PlayerPedId()

  SetCamActive(cam, true)
  RenderScriptCams(true, true, 500, true, true)

  local xyz = GetEntityCoords(playerPed)
  SetCamCoord(cam,  402.92,-1000.72, -99.01)
  SetCamFov(cam, 30.0)
  PointCamAtCoord(cam, xyz.x , xyz.y , xyz.z)
  
  --SetCamRot(cam, 0.0, 0.0, 180, true)
end

function Collision()
  for i=1,256 do
      if NetworkIsPlayerActive(i) then
          SetEntityVisible(GetPlayerPed(i), false, 0)
          SetEntityVisible(PlayerPedId(), true, 0)
          SetEntityNoCollisionEntity(GetPlayerPed(i), GetPlayerPed(-1), false)
      end
  end
end

function Visible()
  while enable == true do
      Wait(0)
      DisableAllControlActions(0)
      Collision()
  end
end