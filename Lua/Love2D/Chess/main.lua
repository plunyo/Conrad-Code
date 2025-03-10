local BoardManager = require("src.boardManager")
local InputManager = require("src.inputManager")
local Settings = require("src.settings")

function love.load()
    love.window.setMode(8 * Settings.SQUARE_SIZE, 8 * Settings.SQUARE_SIZE)
    BoardManager.setup()
end

function love.draw()
    BoardManager.drawBoard()
end

function love.mousepressed(...)
    InputManager.handleClick(...)
end
