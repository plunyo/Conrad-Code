local Vector2 = require("src.classes.Vector2")
local Outline = require("src.classes.ui.Outline")

local Control = {
    outline = Outline:new({0, 0, 0, 0}, 0),

    position = Vector2:new(),
    size = Vector2:new(),
}
Control.__index = Control

function Control:new(size, position, outline)
    local instance = setmetatable({}, self)

    instance.outline = outline
    instance.size = size
    instance.position = position

    return instance
end

function Control:hasPoint(point)
    return point.x >= self.position.x
        and point.x <= self.position.x + self.size.x
        and point.y >= self.position.y
        and point.y <= self.position.y + self.size.y
end

return Control
