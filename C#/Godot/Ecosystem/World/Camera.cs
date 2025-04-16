using Godot;
using System;

public partial class Camera : Camera2D
{
    private const float MinZoom = 0.1f;
    private const float MaxZoom = 10.0f;

    [Export] private float speed;
    [Export] private float zoomSpeed;

    public override void _Process(double delta)
    {
        base._Process(delta);

        // handle zoom
        if (Input.IsActionJustPressed("ZoomIn"))
            Zoom -= new Vector2(zoomSpeed, zoomSpeed).Clamp(new Vector2(MinZoom, MinZoom), new Vector2(MaxZoom, MaxZoom));
        if (Input.IsActionJustPressed("ZoomOut"))
            Zoom += new Vector2(zoomSpeed, zoomSpeed).Clamp(new Vector2(MinZoom, MinZoom), new Vector2(MaxZoom, MaxZoom));
    }
}
