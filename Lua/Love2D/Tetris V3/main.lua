local InputManager = require("src.input")
local Vector2 = require("src.Vector2")
local GridManager = require("src.Grid")

local screenDimensions = Vector2:new(love.graphics.getWidth(), love.graphics.getHeight())
local blockSize = math.min(screenDimensions.x / 10, screenDimensions.y / 20)
local gridSize = Vector2:new(10, 20)

_G.grid = GridManager:new(Vector2:new(), gridSize, blockSize)
grid.position = Vector2:new(screenDimensions.x / 2, screenDimensions.y / 2) - grid.rect / 2

local currentTetromino = require("src.Tetromino")

function love.draw()
	grid:draw()
	currentTetromino.draw()
end

function love.keypressed(key)
	InputManager.system(key)
end
