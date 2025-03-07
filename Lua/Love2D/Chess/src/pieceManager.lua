local Settings = require("src.settings")
local Piece = require("src.piece")

local PieceManager = {
    board = {},
    selectedPiece = nil,
}

function PieceManager.setupPieces()
    for x = 1, 8 do -- populate board
        PieceManager.board[x] = {}
        for y = 1, 8 do
            PieceManager.board[x][y] = nil
        end
    end

    local backRank = { "r", "n", "b", "q", "k", "b", "n", "r" }
    for x = 1, 8 do
        -- placing black pieces
        PieceManager.board[x][1] = Piece.new("black", backRank[x], x, 1)
        PieceManager.board[x][2] = Piece.new("black", "p", x, 2)

        -- placing white pieces
        PieceManager.board[x][7] = Piece.new("white", "p", x, 7)
        PieceManager.board[x][8] = Piece.new("white", backRank[x], x, 8)
    end
end

function PieceManager.drawPieces()
    for x = 1, 8 do
        for y = 1, 8 do
            local piece = PieceManager.board[x][y]
            if piece then
                -- drawing each piece
                piece:draw(
                    (x - 1) * Settings.SQUARE_SIZE,
                    (y - 1) * Settings.SQUARE_SIZE
                )
            end
        end
    end
end

function love.mousepressed(x, y, button)
    local boardX = math.floor(x / Settings.SQUARE_SIZE) + 1
    local boardY = math.floor(y / Settings.SQUARE_SIZE) + 1

    if boardX < 1 or boardX > 8 or boardY < 1 or boardY > 8 or button ~= 1 then
        return
    end

    local clickedPiece = PieceManager.board[boardX][boardY]

    if PieceManager.selectedPiece then
        -- if a piece is already selected
        if
            clickedPiece
            and clickedPiece.color == PieceManager.selectedPiece.color
        then
            -- selecting another piece of the same color
            PieceManager.selectedPiece = clickedPiece
        else
            -- moving the selected piece
            local movingPiece = PieceManager.selectedPiece
            PieceManager.board[movingPiece.x][movingPiece.y] = nil -- remove from old spot
            movingPiece.x, movingPiece.y = boardX, boardY

            -- if there's an enemy piece, capture it
            PieceManager.board[boardX][boardY] = movingPiece
            PieceManager.selectedPiece.highlighted = false
            PieceManager.selectedPiece = nil
        end
    else
        -- no piece selected yet
        if clickedPiece then
            -- selecting a piece
            PieceManager.selectedPiece = clickedPiece
            PieceManager.selectedPiece.highlighted = true
        end
    end
end

return PieceManager
