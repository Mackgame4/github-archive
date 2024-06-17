local _blips = {}

BLIPS = {
    Add = function(self, id, coords, text, sprite, scale, colour, display, category) -- ? will override
        if _blips[id] then Components.Blips:Remove(id) end

        if display == nil then display = 2 end -- use 3 for only main map, 

        local newBlipId = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipDisplay(newBlipId, display)
        SetBlipSprite(newBlipId, sprite)
        SetBlipScale(newBlipId, scale)
        SetBlipColour(newBlipId, colour)
        SetBlipAsShortRange(newBlipId, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(text)
        EndTextCommandSetBlipName(newBlipId)

        if category then 
            SetBlipCategory(newBlipId, category)
        end

        _blips[id] = {
            blip = newBlipId,
            coords = coords,
            text = text,
            sprite = sprite,
            scale = scale,
            colour = colour,
            display = display
        }
    end,
    Remove = function(self, id)
        if _blips[id] and _blips[id].blip then 
            RemoveBlip(_blips[id].blip)
            _blips[id] = nil
        end
    end,
    RemoveAll = function(self)
        for id, data in pairs(_blips) do 
            RemoveBlip(data.blip)
        end
        _blips = {}
    end
}