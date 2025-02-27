local Vector2 = require("src.Vector2")

local currentTetromino = {
	type = "I",
	rotation = 1,
	position = Vector2:new(math.floor(_G.grid.size.x / 2), 0) -- Example initial position
}

local tetrominos = {
	I = {
		{ Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(3, 1) }, -- Horizontal
		{ Vector2:new(2, 0), Vector2:new(2, 1), Vector2:new(2, 2), Vector2:new(2, 3) }, -- Vertical
		{ Vector2:new(0, 2), Vector2:new(1, 2), Vector2:new(2, 2), Vector2:new(3, 2) }, -- Horizontal (rotated twice)
		{ Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2), Vector2:new(1, 3) }, -- Vertical (rotated twice)

		color = { 0, 1, 1 }, -- Cyan
	},
	O = {
		{ Vector2:new(1, 1), Vector2:new(1, 2), Vector2:new(2, 1), Vector2:new(2, 2) }, -- O block does not rotate
		color = { 1, 1, 0 }, -- Yellow
	},
	T = {
		{ Vector2:new(1, 0), Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1) }, -- Base pointing up
		{ Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2), Vector2:new(2, 1) }, -- Base pointing right
		{ Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(1, 2) }, -- Base pointing down
		{ Vector2:new(0, 1), Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2) }, -- Base pointing left
		color = { 0.5, 0, 0.5 }, -- Purple
	},
	J = {
		{ Vector2:new(0, 0), Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1) }, -- "J" pointing left
		{ Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2), Vector2:new(2, 0) }, -- "J" pointing up
		{ Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(2, 2) }, -- "J" pointing right
		{ Vector2:new(0, 2), Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2) }, -- "J" pointing down
		color = { 1, 0.65, 0 }, -- Orange
	},
	L = {
		{ Vector2:new(2, 0), Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1) }, -- "L" pointing right
		{ Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2), Vector2:new(2, 2) }, -- "L" pointing up
		{ Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(0, 2) }, -- "L" pointing left
		{ Vector2:new(0, 0), Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(1, 2) }, -- "L" pointing down
		color = { 0, 0, 1 }, -- Blue
	},
	S = {
		{ Vector2:new(1, 0), Vector2:new(2, 0), Vector2:new(0, 1), Vector2:new(1, 1) }, -- "S" horizontal
		{ Vector2:new(0, 0), Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(1, 2) }, -- "S" vertical
		{ Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(0, 2), Vector2:new(1, 2) }, -- "S" horizontal (rotated twice)
		{ Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(2, 2) }, -- "S" vertical (rotated twice)
		color = { 0, 1, 0 }, -- Green
	},
	Z = {
		{ Vector2:new(0, 0), Vector2:new(1, 0), Vector2:new(1, 1), Vector2:new(2, 1) }, -- "Z" horizontal
		{ Vector2:new(1, 0), Vector2:new(0, 1), Vector2:new(1, 1), Vector2:new(0, 2) }, -- "Z" vertical
		{ Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(2, 2), Vector2:new(3, 2) }, -- "Z" horizontal (rotated twice)
		{ Vector2:new(2, 0), Vector2:new(1, 1), Vector2:new(2, 1), Vector2:new(1, 2) }, -- "Z" vertical (rotated twice)
		color = { 1, 0, 0 }, -- Red
	},
}



function currentTetromino.draw()
	local color = tetrominos[currentTetromino.type].color
	love.graphics.setColor(color[1], color[2], color[3])
	for _, block in pairs(tetrominos[currentTetromino.type][currentTetromino.rotation]) do
		local position = Vector2:new(block.x, block.y) + currentTetromino.position

		love.graphics.rectangle("fill",
			(position.x - 1) * grid.blockSize + grid.position.x,
			(position.y - 1) * grid.blockSize + grid.position.y,
			grid.blockSize,
			grid.blockSize
		)
	end

	love.graphics.setColor(1, 1, 1)
end

return currentTetromino
