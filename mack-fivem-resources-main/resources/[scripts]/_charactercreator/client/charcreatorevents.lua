--------------------------------------------------------------------
--#head
RegisterNetEvent('_menu:handleEvent:changeHair')
AddEventHandler('_menu:handleEvent:changeHair', function(value)
  if value ~= 23 then
    TriggerEvent('skinchanger:change', 'hair_1', value)
  end
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeHairColor1')
AddEventHandler('_menu:handleEvent:changeHairColor1', function(value)
  TriggerEvent('skinchanger:change', 'hair_color_1', value)
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeBeard')    
AddEventHandler('_menu:handleEvent:changeBeard', function(value)
  TriggerEvent('skinchanger:change', 'beard_1', value) 
  if value ~= 0 then
    TriggerEvent('skinchanger:change', 'beard_2', 10)
  else
    TriggerEvent('skinchanger:change', 'beard_2', 0)
  end
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeBeardSize')
AddEventHandler('_menu:handleEvent:changeBeardSize', function(value)
  TriggerEvent('skinchanger:change', 'beard_2', value)
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeBeardColor1')
AddEventHandler('_menu:handleEvent:changeBeardColor1', function(value)
  TriggerEvent('skinchanger:change', 'beard_3', value)
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeEyebrowType') 
AddEventHandler('_menu:handleEvent:changeEyebrowType', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_1', value)
  if value ~= 0 then 
    TriggerEvent('skinchanger:change', 'eyebrows_2', 10)
  else 
    TriggerEvent('skinchanger:change', 'eyebrows_2', 0)
  end
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeEyebrowSize')
AddEventHandler('_menu:handleEvent:changeEyebrowSize', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_2', value)
end)

--#head
RegisterNetEvent('_menu:handleEvent:changeEyebrowColor1')
AddEventHandler('_menu:handleEvent:changeEyebrowColor1', function(value)
  TriggerEvent('skinchanger:change', 'eyebrows_3', value)
end)


--------------------------------------------------------------------

--#face
RegisterNetEvent('_menu:handleEvent:changenose_1')
AddEventHandler('_menu:handleEvent:changenose_1', function(value)
    TriggerEvent('skinchanger:change', 'nose_1', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changenose_2')
AddEventHandler('_menu:handleEvent:changenose_2', function(value)
    TriggerEvent('skinchanger:change', 'nose_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changenose_3')
AddEventHandler('_menu:handleEvent:changenose_3', function(value)
    TriggerEvent('skinchanger:change', 'nose_3', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changenose_4')
AddEventHandler('_menu:handleEvent:changenose_4', function(value)
    TriggerEvent('skinchanger:change', 'nose_4', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changenose_5')
AddEventHandler('_menu:handleEvent:changenose_5', function(value)
    TriggerEvent('skinchanger:change', 'nose_5', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changenose_6')
AddEventHandler('_menu:handleEvent:changenose_6', function(value)
    TriggerEvent('skinchanger:change', 'nose_6', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changecheeks_1')
AddEventHandler('_menu:handleEvent:changecheeks_1', function(value)
    TriggerEvent('skinchanger:change', 'cheeks_1', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changecheeks_2')
AddEventHandler('_menu:handleEvent:changecheeks_2', function(value)
    TriggerEvent('skinchanger:change', 'cheeks_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changecheeks_3')
AddEventHandler('_menu:handleEvent:changecheeks_3', function(value)
    TriggerEvent('skinchanger:change', 'cheeks_3', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changejaw_1')
AddEventHandler('_menu:handleEvent:changejaw_1', function(value)
    TriggerEvent('skinchanger:change', 'jaw_1', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changejaw_2')
AddEventHandler('_menu:handleEvent:changejaw_2', function(value)
    TriggerEvent('skinchanger:change', 'jaw_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changechin_1')
AddEventHandler('_menu:handleEvent:changechin_1', function(value)
    TriggerEvent('skinchanger:change', 'chin_1', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changechin_2')
AddEventHandler('_menu:handleEvent:changechin_2', function(value)
    TriggerEvent('skinchanger:change', 'chin_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changechin_3')
AddEventHandler('_menu:handleEvent:changechin_3', function(value)
    TriggerEvent('skinchanger:change', 'chin_3', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changechin_4')
AddEventHandler('_menu:handleEvent:changechin_4', function(value)
    TriggerEvent('skinchanger:change', 'chin_4', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeneck_thickness')
AddEventHandler('_menu:handleEvent:changeneck_thickness', function(value)
    TriggerEvent('skinchanger:change', 'neck_thickness', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changewrinkles')
AddEventHandler('_menu:handleEvent:changewrinkles', function(value)
    TriggerEvent('skinchanger:change', 'age_1', value)
    TriggerEvent('skinchanger:change', 'age_2', 10)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changewrinkle_thickness')
AddEventHandler('_menu:handleEvent:changewrinkle_thickness', function(value)
    TriggerEvent('skinchanger:change', 'age_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeeye_color')
AddEventHandler('_menu:handleEvent:changeeye_color', function(value)
    TriggerEvent('skinchanger:change', 'eye_color', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeeye_squint')
AddEventHandler('_menu:handleEvent:changeeye_squint', function(value)
    TriggerEvent('skinchanger:change', 'eye_squint', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeears_1')
AddEventHandler('_menu:handleEvent:changeears_1', function(value)
    TriggerEvent('skinchanger:change', 'ears_1', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeears_2')
AddEventHandler('_menu:handleEvent:changeears_2', function(value)
    TriggerEvent('skinchanger:change', 'ears_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeblemishes_1')
AddEventHandler('_menu:handleEvent:changeblemishes_1', function(value)
    TriggerEvent('skinchanger:change', 'blemishes_1', value)
    TriggerEvent('skinchanger:change', 'blemishes_2', 10)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changeblemishes_2')
AddEventHandler('_menu:handleEvent:changeblemishes_2', function(value)
    TriggerEvent('skinchanger:change', 'blemishes_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changelip_thickness')
AddEventHandler('_menu:handleEvent:changelip_thickness', function(value)
    TriggerEvent('skinchanger:change', 'lip_thickness', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changecomplexion_1')
AddEventHandler('_menu:handleEvent:changecomplexion_1', function(value)
    TriggerEvent('skinchanger:change', 'complexion_1', value)
    TriggerEvent('skinchanger:change', 'complexion_2', 10)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changecomplexion_2')
AddEventHandler('_menu:handleEvent:changecomplexion_2', function(value)
    TriggerEvent('skinchanger:change', 'complexion_2', value)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changefreckles_1')
AddEventHandler('_menu:handleEvent:changefreckles_1', function(value)
    TriggerEvent('skinchanger:change', 'moles_1', value)
    TriggerEvent('skinchanger:change', 'moles_2', 10)
end)

--#face
RegisterNetEvent('_menu:handleEvent:changefreckles_2')
AddEventHandler('_menu:handleEvent:changefreckles_2', function(value)
    TriggerEvent('skinchanger:change', 'moles_2', value)
end)

--------------------------------------------------------------------
local gender = 0
--#General
RegisterNetEvent('_menu:handleEvent:CharChangeGender')
AddEventHandler('_menu:handleEvent:CharChangeGender', function(value)
  if value ==  false then
    gender = 0
  elseif value == true then
    gender = 1 
  end
  --TriggerEvent('skinchanger:change' , 'sex' , gender)
  StripClothes()
end)

--#General
RegisterNetEvent('_menu:handleEvent:changechest_1')
AddEventHandler('_menu:handleEvent:changechest_1', function(value)
    TriggerEvent('skinchanger:change', 'chest_1', value)
    TriggerEvent('skinchanger:change', 'chest_2', 10)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changechest_hair_1')
AddEventHandler('_menu:handleEvent:changechest_hair_1', function(value)
    TriggerEvent('skinchanger:change', 'chest_2', value)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changechest_color')
AddEventHandler('_menu:handleEvent:changechest_color', function(value)
    TriggerEvent('skinchanger:change', 'chest_3', value)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changebodyb_1')
AddEventHandler('_menu:handleEvent:changebodyb_1', function(value)
    TriggerEvent('skinchanger:change', 'bodyb_1', value)
    TriggerEvent('skinchanger:change', 'bodyb_2', 10)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changebodyb_2')
AddEventHandler('_menu:handleEvent:changebodyb_2', function(value)
    TriggerEvent('skinchanger:change', 'bodyb_2', value)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changebodyb_3')
AddEventHandler('_menu:handleEvent:changebodyb_3', function(value)
    TriggerEvent('skinchanger:change', 'bodyb_3', value)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changesun_1')
AddEventHandler('_menu:handleEvent:changesun_1', function(value)
    TriggerEvent('skinchanger:change', 'sun_1', value)
end)

--#General
RegisterNetEvent('_menu:handleEvent:changesun_2')
AddEventHandler('_menu:handleEvent:changesun_2', function(value)
    TriggerEvent('skinchanger:change', 'sun_2', value)
end)

--------------------------------------------------------------------

--#Heritage
RegisterNetEvent('_menu:handleEvent:changemom')
AddEventHandler('_menu:handleEvent:changemom', function(value)
   
    if gender == 0 then 
      if value > 20 then 
        TriggerEvent('skinchanger:change', 'mom', value + 21)
      else
        TriggerEvent('skinchanger:change', 'mom', value)
      end
    else
      if value >= 0 and value < 21 then 
        TriggerEvent('skinchanger:change', 'mom', value + 21)
      else
        if value == 21 then 
          TriggerEvent('skinchanger:change', 'mom', 45)
        end
      end
    end

end)

--#Heritage
RegisterNetEvent('_menu:handleEvent:changedad')
AddEventHandler('_menu:handleEvent:changedad', function(value)
  if gender == 0 then 
    if value > 20 then 
      TriggerEvent('skinchanger:change', 'dad', value + 21)
    else
      TriggerEvent('skinchanger:change', 'dad', value)
    end
  else
    if value >= 0 and value < 21 then 
      TriggerEvent('skinchanger:change', 'dad', value + 21)
    else
      if value == 21 then 
        TriggerEvent('skinchanger:change', 'dad', 45)
      end
    end
  end
end)

--#Heritage
RegisterNetEvent('_menu:handleEvent:changeskin_tone')
AddEventHandler('_menu:handleEvent:changeskin_tone', function(value)
    TriggerEvent('skinchanger:change', 'skin_md_weight', value)
end)

--#Heritage
RegisterNetEvent('_menu:handleEvent:changeface_md_weight')
AddEventHandler('_menu:handleEvent:changeface_md_weight', function(value)
    TriggerEvent('skinchanger:change', 'face_md_weight', value)
end)


function StripClothes()  
    if gender == 0 then
      TriggerEvent('skinchanger:loadSkin', {
        sex = 0,
        tshirt_1 = 15,
        ears_1 = -1,
        arms     = 15,
        torso_1  = 91,
        pants_1  = 14,
        shoes_1 = 5,
        glasses_1 = -1,
      })
    else
      TriggerEvent('skinchanger:loadSkin', {
        sex = 1,
	      helmet_1 = -1,
        ears_1 = -1,
        tshirt_1 = 34,
        tshirt_2 = 0,
        arms     = 15,
        torso_1  = 101,
        torso_2  = 1,
        pants_1  = 16,
		    pants_2  = 0,
		    shoes_1 = 5,
		    glasses_1 = -1,
        bags_1 = 0
      })
    end
  end

  function ReClothe()  
    ClearPedDecorations(PlayerPedId())
    if gender == 0 then
      TriggerEvent('skinchanger:loadSkin', {
        sex = 0,
        helmet_1 = -1,
        ears_1 = -1,
        tshirt_1 = 0,
        arms     = 0,
        torso_1  = 0,
        pants_1  = 0,
        shoes_1 = 0,
        glasses_1 = -1,
      })
    else
      TriggerEvent('skinchanger:loadSkin', {
        sex = 1,
        helmet_1 = -1,
        ears_1 = -1,
		tshirt_1 = 0,
		tshirt_2 = 0,
		arms     = 0,
		torso_1  = 0,
		torso_2  = 0,
		pants_1  = 0,
		pants_2  = 0,
		shoes_1 = 0,
		glasses_1 = -1,
        bags_1 = 0
      })
    end
  end

  function getGender()
    return gender
  end



