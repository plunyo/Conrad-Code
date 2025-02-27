local Outline = {
    color = {0, 0, 0, 1},

    thickness = 1
}
Outline.__index = Outline

function Outline:new(color, thickness)
    local instance = setmetatable({}, Outline)

    instance.color = color
    instance.thickness = thickness

    return instance
end

function Outline:draw(position, size)
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(self.thickness)
    love.graphics.rectangle("line", position.x - size.x / 2, position.y - size.y / 2, size.x, size.y)
    love.graphics.setColor({1, 1, 1, 1})
end

return Outline