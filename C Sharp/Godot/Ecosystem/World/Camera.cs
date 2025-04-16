using Godot;
using System;

public partial class Camera : Camera2D
{
    private const float MinZoom = 0.1f;
    private const float MaxZoom = 10.0f;

    [Export] private float zoomSpeed;
    [Export] private float panSpeed;

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        // Handle zooming
        if (Input.IsActionJustPressed("ZoomIn"))
            Zoom = new Vector2(
                Mathf.Clamp(Zoom.X - zoomSpeed, MinZoom, MaxZoom),
                Mathf.Clamp(Zoom.Y - zoomSpeed, MinZoom, MaxZoom)
            );
        if (Input.IsActionJustPressed("ZoomOut"))
            Zoom = new Vector2(
                Mathf.Clamp(Zoom.X + zoomSpeed, MinZoom, MaxZoom),
                Mathf.Clamp(Zoom.Y + zoomSpeed, MinZoom, MaxZoom)
            );

        // Handle panning
        float zoomFactor = 1.0f / Zoom.X;
        Vector2 panDirection = Input.GetVector("PanLeft", "PanRight", "PanUp", "PanDown").Normalized();
        GlobalPosition += panDirection * zoomFactor * panSpeed * (float)delta;
    }
}
