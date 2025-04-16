using Godot;
using Godot.Collections;
using System.Collections.Generic;

public partial class World : TileMapLayer
{
    private const int SourceID = 1;

    [Export] private Vector2I worldSize;
    [Export] private NoiseTexture2D noiseHeightTexture;

    // Tile Coords
    static public Vector2I GrassCoords = new Vector2I(6, 1);
    static public Vector2I WaterCoords = new Vector2I(15, 11);
    static public Vector2I SandCoords = new Vector2I(1, 1);

    // Scenery Coords
    static public Array<Vector2I> GrassScenery = new Array<Vector2I>
    {
        new Vector2I(8, 2),
        new Vector2I(9, 2),
        new Vector2I(8, 3),
        new Vector2I(9, 3)
    };
    static public Array<Vector2I> SandScenery = new Array<Vector2I>
    {
        new Vector2I(3, 2),
        new Vector2I(4, 2),
        new Vector2I(3, 3),
        new Vector2I(4, 3)
    };

    private TileMapLayer sceneryLayer;
    private Noise noise;

    public override void _Ready()
    {
        base._Ready();
        InitReferences();
        // GenerateWorld();
    }

    private void InitReferences()
    {
        sceneryLayer = GetNode<TileMapLayer>("SceneryLayer");
        noise = noiseHeightTexture.Noise;
    }

    private void GenerateWorld()
    {
        int halfWidth = worldSize.X / 2;
        int halfHeight = worldSize.Y / 2;

        for (int x = -halfWidth; x < halfWidth; x++)
        {
            for (int y = -halfHeight; y < halfHeight; y++)
            {
                Vector2I position = new(x, y);
                float noiseValue = noise.GetNoise2D(x, y);

                if (noiseValue > 0.0f)
                {
                    SetCell(position, SourceID, GrassCoords);
                }
                else if (noiseValue > -0.1f)
                {
                    SetCell(position, SourceID, SandCoords);
                }
                else
                {
                    SetCell(position, SourceID, WaterCoords);
                }
            }
        }
    }
}
