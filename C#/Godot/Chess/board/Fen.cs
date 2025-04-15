using Godot;
using Godot.Collections;

static class Fen
{
    public static readonly Dictionary<char, Piece.Type> FenSymbolToType = new Dictionary<char, Piece.Type>
    {
        { 'k', Piece.Type.King },
        { 'q', Piece.Type.Queen },
        { 'b', Piece.Type.Bishop },
        { 'n', Piece.Type.Knight },
        { 'r', Piece.Type.Rook },
        { 'p', Piece.Type.Pawn }
    };

}
