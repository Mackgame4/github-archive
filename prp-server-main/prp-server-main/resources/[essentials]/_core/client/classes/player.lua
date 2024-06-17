RegisterNetEvent('_core:Client:SetPlayerKeyValue', function(key, value)
    ESX.Player.setValue(key, value)
end)

function Player(xPlayer)
    local self = {
        onDuty = false,
        playerPedId = nil
    }

    self.xPlayer = xPlayer

    self.PlayerPedId = function()
        if not self.playerPedId then
            self.playerPedId = PlayerPedId()
        end
        return self.playerPedId
    end

    self.HasJob = function(job)
        return self.xPlayer.job.name == job
    end

    self.HasGrade = function(level)
        return self.xPlayer.job.job_grade.level >= level
    end

    self.IsBoss = function()
        return self.xPlayer.job.boss
    end

    self.OnDuty = function()
        return self.onDuty
    end

    self.setValue = function(key, value)
        if self[key] then
            self[key] = value
        end
    end

    return self
end