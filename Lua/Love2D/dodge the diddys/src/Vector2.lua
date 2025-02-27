local Vector2 = {}
Vector2.__index = Vector2

function Vector2:new(x, y)
    local vec = setmetatable({}, Vector2)
    vec.x = x or 0
    vec.y = y or 0
    return vec
end

function Vector2:add(other)
    return Vector2:new(self.x + other.x, self.y + other.y)
end

function Vector2:subtract(other)
    return Vector2:new(self.x - other.x, self.y - other.y)
end

function Vector2:scale(scalar)
    return Vector2:new(self.x * scalar, self.y * scalar)
end

function Vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

function Vector2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:unpack()
    return self.x, self.y
end

function Vector2:normalize()
    local len = self:length()
    if len > 0 then
        return self:scale(1 / len)
    else
        return Vector2:new(0, 0)
    end
end

return Vector2
