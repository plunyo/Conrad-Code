local Vec2 = {}
Vec2.__index = Vec2

setmetatable(Vec2, {
    __call = function(_, x, y)
        return setmetatable({ x = x or 0, y = y or 0 }, Vec2)
    end,
})

function Vec2:__tostring()
    return string.format("(x: %d, y: %d)", self.x, self.y)
end

return Vec2
