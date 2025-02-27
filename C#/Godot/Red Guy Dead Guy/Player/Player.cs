using Godot;
using System;

public partial class Player : CharacterBody2D
{
    [ExportCategory("Movement")]
    [Export] float Speed = 400f;
    [Export] float MovementSmoothing = 0.3f;

    [ExportCategory("Rotation")]
    [Export] bool RotationEnabled = true;
    [Export] float RotationSmoothing = 0.15f;

    public Vector2 LastDirection = Vector2.Zero;

    private Vector2 targetVelocity = Vector2.Zero;
    private Vector2 direction = Input.GetVector("Left", "Right", "Up", "Down").Normalized();

    public override void _PhysicsProcess(double delta)
    {
        direction = Input.GetVector("Left", "Right", "Up", "Down").Normalized();

        if (direction != Vector2.Zero)
        {
            LastDirection = direction;
        }

        targetVelocity = direction * Speed;
        Velocity = Velocity.Lerp(targetVelocity, MovementSmoothing);

        MoveAndSlide();

        if (RotationEnabled)
        {
            RotateTowardsMouse();
        }
    }

    private void RotateTowardsMouse()
    {

        Vector2 mousePosition = GetGlobalMousePosition();

        Vector2 directionToMouse = (mousePosition - GlobalPosition).Normalized();

        float targetAngle = directionToMouse.Angle() + Mathf.Pi / 2;

        Rotation = Mathf.LerpAngle(Rotation, targetAngle, RotationSmoothing);
    }
}
