using Godot;
using System;

public partial class Enemy : CharacterBody2D
{
    [ExportCategory("Navigation")]
    [Export] NavigationAgent2D NavigationAgent;
    [Export] AnimationPlayer AnimationPlayer;
    [Export] Timer PositionUpdateTimer;
    [Export] Area2D PlayerDetector;

	[ExportCategory("Wander")]
	[Export] float WanderSpeed = 150f;
	[Export] bool Wandering = true;
	[Export] Timer WanderTimer;

    public int Health = 100;

    private Player player;
    private float Speed = 200f;

	private Vector2 wanderDirection = Vector2.Zero;

    public override void _Ready()
    {
        PlayerDetector.BodyEntered += OnPlayerDetectorBodyEntered;
        PlayerDetector.BodyExited += OnPlayerDetectorBodyExited;

        PositionUpdateTimer.Timeout += OnPositionUpdateTimerTimeout;
		WanderTimer.Timeout += OnWanderTimerTimeout;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (player != null && AnimationPlayer.CurrentAnimation != "Die")
        {
			Wandering = false;

            Vector2 nextPathPoint = NavigationAgent.GetNextPathPosition();
            if (GlobalPosition.DistanceTo(nextPathPoint) > 10.0f)
            {
                Vector2 direction = (nextPathPoint - GlobalPosition).Normalized();
                Velocity = direction * Speed;
            }
            else
            {
                Velocity = Vector2.Zero;
				// Attack Logic Here
            }

            MoveAndSlide();

            float targetAngle = (player.GlobalPosition - GlobalPosition).Angle() + Mathf.Pi / 2;
            Rotation = Mathf.LerpAngle(Rotation, targetAngle, (float)delta * 5.0f);
        }
		else
		{
			Wandering = true;
		}
    }

    private void OnPositionUpdateTimerTimeout()
    {
        if (player != null)
        {
            NavigationAgent.TargetPosition = player.GlobalPosition;
        }
    }

	private void OnWanderTimerTimeout()
	{
		if (Wandering)
		{
			wanderDirection = new Vector2(
				GD.Randf() < 0.5f ? -1 : 1,
				GD.Randf() < 0.5f ? -1 : 1
			).Normalized();

			Velocity = wanderDirection * WanderSpeed;
		}
	}

    public void Hit(int damage)
    {
        if (AnimationPlayer.IsPlaying()) return;

        Health = Mathf.Clamp(Health - damage, 0, 100);

        if (Health > 0)
        {
            AnimationPlayer.Play("Hit");
        }
        else if (Health == 0)
        {
            AnimationPlayer.Play("Die");
        }
    }

    private void OnPlayerDetectorBodyEntered(Node2D otherBody)
    {
        if (otherBody.IsInGroup("Player"))
        {
            player = otherBody as Player;
            NavigationAgent.TargetPosition = player.GlobalPosition;
        }
    }

    private void OnPlayerDetectorBodyExited(Node2D otherBody)
    {
        if (otherBody.IsInGroup("Player"))
        {
            player = null;
        }
    }
}
