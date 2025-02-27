local Token = {}
Token.__index = Token

function Token.new(self, value, type)
	local instance = setmetatable({}, Token)

	instance.value = value
	instance.type = type

	return instance
end

return Token