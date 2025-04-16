using Godot;
using System;

public partial class Piece : Node2D
{
    public enum Type { King, Queen, Bishop, Knight, Rook, Pawn }
    public enum Color { White, Black }

    private const String pieceScenePath = "res://piece/piece.tscn";

    [Export] private Color color;
    [Export] private Type type;

    private Sprite2D sprite = null;

    public static Piece Create(Color pieceColor, Type pieceType)
    {
        Piece instance = GD.Load<PackedScene>(pieceScenePath).Instantiate() as Piece;
        instance.color = pieceColor;
        instance.type = pieceType;
        return instance;
    }

    public override void _Ready()
    {
        sprite = GetNode<Sprite2D>("Sprite");

        sprite.FrameCoords = new Vector2I(
            (int)type,
            (color == Color.White) ? 0 : 1
        );
    }
}
