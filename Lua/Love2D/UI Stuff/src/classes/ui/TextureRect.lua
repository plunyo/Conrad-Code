local Control = require("src.classes.ui.Control")

local TextureRect = {
    texture = nil
}
TextureRect.__index = TextureRect

function TextureRect:new(size, position, texture, outline)
    local instance = setmetatable(Control.new(self, size, position, outline), self)

    instance.texture = texture

    return instance
end

function TextureRect:draw()
    if self.texture then
        love.graphics.draw(
            self.texture,
            self.position.x,
            self.position.y,
            0,
            self.size.x / self.texture:getWidth(),
            self.size.y / self.texture:getHeight()
        )

        if self.outline then self.outline:draw() end
    end
end

return TextureRect
