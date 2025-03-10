local Settings = require("src.settings")
local Colors = require("src.colors")
local Piece = require("src.piece")

local BoardManager = {}

_G.Board = {}

function BoardManager.setup()
    local backRank = { "r", "n", "b", "q", "k", "b", "n", "r" }

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

function BoardManager.getPiece(x, y)
    return _G.Board[x] and _G.Board[x][y]
end

function BoardManager.movePiece(piece, newX, newY)
    _G.Board[piece.x][piece.y] = nil
    piece:moveTo(newX, newY)
    _G.Board[newX][newY] = piece
end

function BoardManager.drawBoard()
    for x = 1, 8 do
        for y = 1, 8 do
            love.graphics.setColor(
                (x + y) % 2 == 0 and Colors.LIGHT_TILE or Colors.DARK_TILE
            )

            love.graphics.rectangle(
                "fill",
                (x - 1) * Settings.SQUARE_SIZE,
                (y - 1) * Settings.SQUARE_SIZE,
                Settings.SQUARE_SIZE,
                Settings.SQUARE_SIZE
            )
        end
    end

    love.graphics.setColor(1, 1, 1, 1)

    for x = 1, 8 do
        for y = 1, 8 do
            if _G.Board[x][y] then
                _G.Board[x][y]:draw()
            end
        end
    end
end

return BoardManager
