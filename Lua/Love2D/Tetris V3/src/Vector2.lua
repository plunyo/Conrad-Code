local Vector2 = { x = 0, y = 0 }
Vector2.__index = Vector2

function Vector2:new(x, y)
	local instance = setmetatable({}, Vector2)

	instance.x = x or 0
	instance.y = y or 0

	return instance
end

-- Metamethods for arithmetic operations
function Vector2:__add(other)
	return Vector2:new(self.x + other.x, self.y + other.y)
end

function Vector2:__sub(other)
	return Vector2:new(self.x - other.x, self.y - other.y)
end

function Vector2:__mul(scalar)
	return Vector2:new(self.x * scalar, self.y * scalar)
end

function Vector2:__div(scalar)
	if scalar == 0 then
		error("Division by zero")
	end
	return Vector2:new(self.x / scalar, self.y / scalar)
end

function Vector2:__unm()
	return Vector2:new(-self.x, -self.y)
end

function Vector2:__tostring()
	return "(" .. self.x .. ", " .. self.y .. ")"
end

function Vector2:__eq(other)
	return self.x == other.x and self.y == other.y
end

function Vector2:__lt(other)
	return self:length() < other:length()
end

function Vector2:__le(other)
	return self:length() <= other:length()
end

function Vector2:__len()
	return self:length()
end

function Vector2:length()
	return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function Vector2:normalize()
	local len = self:length()
	if len > 0 then
		return self:__div(len)
	else
		return Vector2:new(0, 0)
	end
end

function Vector2:scale(scalar)
	return self:__mul(scalar)
end

return Vector2
