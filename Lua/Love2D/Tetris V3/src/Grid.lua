local Vector2 = require("src.Vector2")

local Grid = {}
Grid.__index = Grid

function Grid:new(position, size, blockSize)
	local instance = setmetatable({}, Grid)

	instance.position = position
	instance.size = size
	instance.blockSize = blockSize

	instance.rect = Vector2:new(
		instance.blockSize * instance.size.x,
		instance.blockSize * instance.size.y
	)

	return instance
end

function Grid:draw()
	for x = 1, self.size.x do
		for y = 1, self.size.y do
			local pos = Vector2:new(
				(x - 1) * self.blockSize + self.position.x,
				(y - 1) * self.blockSize + self.position.y
			)

			love.graphics.rectangle("line", pos.x, pos.y, self.blockSize, self.blockSize)
		end
	end
end

return Grid
