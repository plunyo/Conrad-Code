using Godot;
using System;

public partial class Gun : Node2D
{
	[Export] bool ShootingEnabled = true;
	[Export] Marker2D BulletSpawnPoint;
    [Export] PackedScene BulletScene;
    [Export] RayCast2D WallDetector;
    [Export] Player Player;
    [Export] Timer ShootDelayTimer;

    public override void _Process(double delta)
    {
        if (Input.IsActionJustPressed("Shoot") && ShootingEnabled && !WallDetector.IsColliding())
        {
            Shoot();
        }
    }

    private void Shoot()
    {
		Bullet tBullet = BulletScene.Instantiate() as Bullet;

        tBullet.GlobalPosition = BulletSpawnPoint.GlobalPosition;
        tBullet.Direction = -(GetGlobalMousePosition() - GlobalPosition).Normalized();

        GetTree().CurrentScene.AddChild(tBullet);
    }
}
