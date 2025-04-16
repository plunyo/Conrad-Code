using Godot;
using System;
using System.Reflection.Metadata;

public partial class Board : Node2D
{
    public readonly Vector2 SquareSize = new Vector2(90, 90);
    public readonly Vector2 PieceOffset = new Vector2(45, 45);
    public const int SquareCount = 64;

    [Export] private string startingFen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

    Piece[] squares = new Piece[64];
    bool whiteToMove;

    public override void _Ready()
    {
        if (startingFen != null)
    }
}
