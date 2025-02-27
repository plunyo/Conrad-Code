local Vector2 = require("src.Vector2")
local Utils = {}

function Utils.getAxis(negativeKeys, positiveKeys)
    local axis = 0

    for _, key in ipairs(negativeKeys) do
        if love.keyboard.isDown(key) then
            axis = axis - 1
            break
        end
    end

    for _, key in ipairs(positiveKeys) do
        if love.keyboard.isDown(key) then
            axis = axis + 1
            break
        end
    end

    return axis
end

function Utils.clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

function Utils.clampVector(vector, minX, maxX, minY, maxY)
    return Vector2:new(
        math.max(minX, math.min(maxX, vector.x)),
        math.max(minY, math.min(maxY, vector.y))
    )
end

function Utils.lerp(startingValue, endValue, interpolationFactor)
    return startingValue + (endValue - startingValue) * interpolationFactor
end

function Utils.lerpAngle(startingValue, endValue, interpolationFactor)
    local difference = (endValue - startingValue) % (2 * math.pi)
    
    if difference > math.pi then difference = difference - (2 * math.pi) end
    
    return startingValue + difference * interpolationFactor
end

function Utils.getVector(upKey, downKey, leftKey, rightKey)
    return Vector2:new(
        Utils.getAxis(leftKey, rightKey),
        Utils.getAxis(upKey, downKey)
    )
end

return Utils
