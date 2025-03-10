local Settings = require("src.settings")
local PieceManager = require("src.pieceManager")

local InputManager = {}

function InputManager.handleClick(x, y, button)
    if button ~= 1 then
        return
    end

    local boardX = math.floor(x / Settings.SQUARE_SIZE) + 1
    local boardY = math.floor(y / Settings.SQUARE_SIZE) + 1

    if boardX < 1 or boardX > 8 or boardY < 1 or boardY > 8 then
        return
    end

    PieceManager.tryMovePiece(boardX, boardY)
end

return InputManager
