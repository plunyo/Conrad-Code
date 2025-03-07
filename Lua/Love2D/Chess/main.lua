local Settings = require("src.settings")
local Board = require("src.board")
local PieceManager = require("src.pieceManager")

function love.load()
    love.window.setMode(
        Settings.BOARD_SIZE * Settings.SQUARE_SIZE,
        Settings.BOARD_SIZE * Settings.SQUARE_SIZE
    ) -- sets window size to board size

    PieceManager.setupPieces()
end

function love.draw()
    Board.draw()
    PieceManager.drawPieces()
end
