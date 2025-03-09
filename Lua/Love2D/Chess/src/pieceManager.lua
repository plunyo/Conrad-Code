local Settings = require("src.settings")
local Piece = require("src.piece")

local PieceManager = { selectedPiece = nil }
_G.Board = {}

local backRank = { "r", "n", "b", "q", "k", "b", "n", "r" }

function PieceManager.setupPieces()
    for x = 1, 8 do
        _G.Board[x] = {}
    end

    for x = 1, 8 do
        _G.Board[x][1], _G.Board[x][2] =
            Piece.new("black", backRank[x], x, 1), Piece.new("black", "p", x, 2)

        _G.Board[x][7], _G.Board[x][8] =
            Piece.new("white", "p", x, 7), Piece.new("white", backRank[x], x, 8)
    end
end

function PieceManager.drawPieces()
    for x = 1, 8 do
        for y = 1, 8 do
            if _G.Board[x][y] then
                _G.Board[x][y]:draw()
            end
        end
    end
end

local function boardToString()
    local res = { "  a b c d e f g h", "  ----------------" }

    for y = 1, 8 do
        local row = { tostring(y) .. "|" }

        for x = 1, 8 do
            table.insert(row, _G.Board[x][y] and _G.Board[x][y].type or ".")
        end

        table.insert(res, table.concat(row, " ") .. " |" .. y)
    end

    table.insert(res, "  ----------------\n  a b c d e f g h")
    return table.concat(res, "\n")
end

function love.mousepressed(x, y, button)
    if button ~= 1 then
        return
    end

    local boardX, boardY =
        math.floor(x / Settings.SQUARE_SIZE) + 1,
        math.floor(y / Settings.SQUARE_SIZE) + 1

    if boardX < 1 or boardX > 8 or boardY < 1 or boardY > 8 then
        return
    end

    local clickedPiece = _G.Board[boardX][boardY]
    local selectedPiece = PieceManager.selectedPiece

    if selectedPiece then
        if clickedPiece and clickedPiece.color == selectedPiece.color then
            selectedPiece.highlighted = false

            PieceManager.selectedPiece = clickedPiece

            clickedPiece.highlighted = true
        elseif selectedPiece:canMoveTo(boardX, boardY, clickedPiece) then
            _G.Board[selectedPiece.x][selectedPiece.y] = nil

            selectedPiece:moveTo(boardX, boardY)

            _G.Board[boardX][boardY] = selectedPiece

            selectedPiece.highlighted = false
            PieceManager.selectedPiece = nil

            print(boardToString())
        end
    elseif clickedPiece then
        PieceManager.selectedPiece = clickedPiece
        clickedPiece.highlighted = true
    end
end

return PieceManager
