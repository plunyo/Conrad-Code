local Control = require("src.classes.ui.Control")

local ColorRect = {
    color = {1, 1, 1, 1}
}
ColorRect.__index = ColorRect

function ColorRect:new(size, position, color, outline)
    local instance = setmetatable(Control.new(self, size, position, outline), ColorRect)

    instance.color = color

    return instance
end

function ColorRect:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.position.x - self.size.x / 2, self.position.y - self.size.y / 2, self.size.x, self.size.y)

    if self.outline then self.outline:draw(self.position, self.size) end

    love.graphics.setColor({1, 1, 1, 1})
end

return ColorRect