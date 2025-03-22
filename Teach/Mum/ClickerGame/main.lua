local positionX = 200
local positionY = 200

local width = 200
local height = 200

local counter = 000

function hexToRgb(hex)
    hex = hex:gsub("#", "") -- remove the '#' if it's there

    return {
        tonumber("0x" .. hex:sub(1, 2)) / 255,
        tonumber("0x" .. hex:sub(3, 4)) / 255,
        tonumber("0x" .. hex:sub(5, 6)) / 255,
    }
end

-- draw function
function love.draw()
    love.graphics.setColor(hexToRgb("#FFD1DC")) -- pink
    love.graphics.rectangle("fill", positionX, positionY, width, height)

    love.graphics.print(
        string.format("BEST COUNTER: %.10d", counter),
        positionY
    )
end

function love.mousepressed()
    if then
        
    counter = counter + 1
    end
end
