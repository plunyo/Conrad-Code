local Vector2 = require("src.Vector2")

local Diddy = {}
Diddy.__index = Diddy

function Diddy:new()
    local instance = setmetatable({}, Diddy)

    instance.position = Vector2:new(
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )

    instance.sprite = love.graphics.newImage("assets/diddy.png")
    
    instance.scale = 1
end

function Diddy:draw()
    love.graphics.draw(self.sprite, self.position.x, self.position.y)
end

return Diddy