
function getDirectionFromHeading(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "N"
    elseif (heading >= 45 and heading < 135) then
        return "E"
    elseif (heading >= 135 and heading < 225) then
        return "S"
    elseif (heading >= 225 and heading < 315) then
        return "W"
    end
end