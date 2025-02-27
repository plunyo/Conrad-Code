local Vector2 = require("src.classes.Vector2")

local Label = {
    position = Vector2:new(),

    text = "",
    color = {1, 1, 1, 1},

    font = love.graphics.getFont()
}
Label.__index = Label

function Label:new(position, text, color, font)
    local instance = setmetatable({}, Label)

    instance.position = position
    instance.text = text
    instance.color = color
    instance.font = font

    return instance
end

function Label:draw()
    local textWidth = self.font:getWidth(self.text)
    local textHeight = self.font:getHeight()

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, self.position.x - textWidth / 2, self.position.y - textHeight / 2)
    love.graphics.setColor({1, 1, 1, 1})
end


return Label