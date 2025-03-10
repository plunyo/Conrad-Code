local BoardManager = require("src.boardManager")

local PieceManager = { selectedPiece = nil, currentTurn = "white" }

function PieceManager.selectPiece(piece)
    if PieceManager.selectedPiece then
        PieceManager.selectedPiece.highlighted = false
    end

    PieceManager.selectedPiece = piece
    piece.highlighted = true
end

function PieceManager.tryMovePiece(x, y)
    local selectedPiece = PieceManager.selectedPiece

    if not selectedPiece then
        local targetPiece = BoardManager.getPiece(x, y)

        if targetPiece and targetPiece.color == PieceManager.currentTurn then
            PieceManager.selectPiece(targetPiece)
        end
        return
    end

    if selectedPiece.color ~= PieceManager.currentTurn then
        return
    end

    local targetPiece = BoardManager.getPiece(x, y)

    if targetPiece and targetPiece.color == selectedPiece.color then
        PieceManager.selectPiece(targetPiece)
    elseif selectedPiece:canMoveTo(x, y, targetPiece) then
        BoardManager.movePiece(selectedPiece, x, y)

        selectedPiece.highlighted = false
        PieceManager.selectedPiece = nil

        PieceManager.currentTurn = (
            { ["white"] = "black", ["black"] = "white" }
        )[PieceManager.currentTurn]
    end
end

return PieceManager
