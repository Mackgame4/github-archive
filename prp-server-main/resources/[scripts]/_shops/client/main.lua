local enableShopInteract

local tattooShop
local barberShop
local clotheShop

local shop

AddEventHandler('OnInteract', function(action, text)  -- this handles all 'on user pressed e' events. might be a good idea to centralize this to one function
    tattooShop = isInTattooShop()
    barberShop = isInBarberShop()
    clotheShop = isInClotheShop()
    
    if tattooShop == true then
        openShop('tattoo')
    end
    if barberShop == true then
        openShop('barber')
    end
    if clotheShop == true then
        openShop('Clothe')
    end
    
    --[[if enableShopInteract then
      openShop()
      inshop = true
      Citizen.CreateThread(function()
        while inshop == true do
          InvalidateIdleCam()
          Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
        end
      end)
    end-]]--
  end)

  function openShop(shop)  -- this is handling all the shops 'OnInteract' event to prevent conflicts
    if shop == 'barber' then 
        initializeBarber()
    end
    if shop == 'tattoo' then
      initializeTattoos()
    end 
    if shop == 'Clothe' then
        initializeClothe()
    end  
  end

  local cam
  function CreateShopCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
  
    local playerPed = PlayerPedId()
    SetEntityHeading(PlayerPedId(), 0.0)
    FreezeEntityPosition(PlayerPedId(), true)

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
  
    local xyz = GetEntityCoords(playerPed)
    SetCamCoord(cam,  xyz.x,xyz.y + 3, xyz.z)
    SetCamFov(cam, 40.0)
    PointCamAtCoord(cam, xyz.x , xyz.y , xyz.z)
    
    --SetCamRot(cam, 0.0, 0.0, 270.0, true)
  end
  
  function DeleteShopCam()
    --local isCameraActive = false
    FreezeEntityPosition(PlayerPedId(), false)
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
  end

  function CreateBarbCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()
    SetEntityHeading(PlayerPedId(), 0.0)
    FreezeEntityPosition(PlayerPedId(), true)

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    local xyz = GetEntityCoords(playerPed)
    SetCamCoord(cam, xyz.x , xyz.y + 2.5 , xyz.z + 1)
    SetCamFov(cam, 10.0)
    PointCamAtCoord(cam, xyz.x , xyz.y , xyz.z + 0.7 )
    
    --SetCamRot(cam, 0.0, 0.0, 270.0, true)
  end
  
  
