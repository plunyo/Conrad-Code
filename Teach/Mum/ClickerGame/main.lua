local button = {
    width = 200,
    height = 200,
}

button.posX = love.graphics.getWidth() / 2 - button.width / 2
button.posY = love.graphics.getHeight() / 2 - button.height / 2

local score = 0

local function isMouseInButton()
    local mouseX, mouseY = love.mouse.getPosition()

    if
        mouseX >= button.posX
        and mouseX <= button.posX + button.width
        and mouseY >= button.posY
        and mouseY <= button.posY + button.height
    then
        return true
    else
        return false
    end
end

function love.draw()
    love.graphics.rectangle(
        "fill",
        button.posX,
        button.posY,
        button.width,
        button.height
    )

    love.graphics.print("Score: " .. score)
end

function love.mousepressed()
    if isMouseInButton() then
        score = score + 1
    end
end
