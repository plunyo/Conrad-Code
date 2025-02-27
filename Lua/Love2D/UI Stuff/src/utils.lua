local utils = {
    sw = love.graphics.getWidth(),
    sh = love.graphics.getHeight(),
}

function utils.adjustBrightness(color, factor)
    return {
        math.min(math.max(color[1] * factor, 0.1), 1),
        math.min(math.max(color[2] * factor, 0.1), 1),
        math.min(math.max(color[3] * factor, 0.1), 1),
        color[4]
    }
end

return utils