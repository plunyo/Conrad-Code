using Godot;
using Godot.Collections;
using System.Collections.Generic;

public partial class World : TileMapLayer
{
    private const int SourceID = 1;
    private const float SceneryFrequency = 0.1f;
    private const float PreyFrequency = 0.025f;

    [Export] private Vector2I worldSize;
    [Export] private PackedScene preyScene;
    [Export] private NoiseTexture2D noiseTexture;

    // Tile Coords
    static public Vector2I GrassTile = new Vector2I(6, 1);
    static public Vector2I WaterTile = new Vector2I(15, 11);
    static public Vector2I SandTile = new Vector2I(1, 1);
    static public Vector2I BorderTile = new Vector2I(15, 0);

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
        GenerateWorld();
    }

    private void InitReferences()
    {
        sceneryLayer = GetNode<TileMapLayer>("SceneryLayer");

        (noiseTexture.Noise as FastNoiseLite).Seed = (int)GD.Randi();
        noise = noiseTexture.Noise;
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

                if (noiseValue > 0.1f)
                {
                    SetCell(position, SourceID, GrassTile);
                    if (GD.Randf() < SceneryFrequency)
                        sceneryLayer.SetCell(position, SourceID, GrassScenery.PickRandom());

                    // Rabbit Spawning
                    if (GD.Randf() < PreyFrequency)
                        SpawnPrey(MapToLocal(new Vector2I(x, y)));
                }
                else if (noiseValue > 0.0f)
                {
                    SetCell(position, SourceID, SandTile);
                    if (GD.Randf() < SceneryFrequency)
                        sceneryLayer.SetCell(position, SourceID, SandScenery.PickRandom());
                }
                else
                {
                    SetCell(position, SourceID, WaterTile);
                }
            }
        }

        // build outer border
        for (int x = -halfWidth - 1; x <= halfWidth; x++)
        {
            SetCell(new Vector2I(x, -halfHeight - 1), SourceID, BorderTile);
            SetCell(new Vector2I(x, halfHeight), SourceID, BorderTile);
        }

        for (int y = -halfHeight - 1; y <= halfHeight; y++)
        {
            SetCell(new Vector2I(-halfWidth - 1, y), SourceID, BorderTile);
            SetCell(new Vector2I(halfWidth, y), SourceID, BorderTile);
        }

    }

    private void SpawnPrey(Vector2 position)
    {
        Prey preyInstance = preyScene.Instantiate() as Prey;
        preyInstance.GlobalPosition = position;
        AddChild(preyInstance);
    }
}
