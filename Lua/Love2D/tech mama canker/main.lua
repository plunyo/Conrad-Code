local positionX = 111
local positionY = 111

local width = 100
local height = 100

local speed = 10

function love.update()
    if love.keyboard.isDown("down") then
        positionY = positionY + speed
    end
    if love.keyboard.isDown("up") then
        positionY = positionY - speed
    end
    if love.keyboard.isDown("left") then
        positionX = positionX - speed
    end
    if love.keyboard.isDown("right") then
        positionX = positionX + speed
    end
end

function love.draw()
    love.graphics.rectangle("fill", positionX, positionY, width, height)
end
