using Godot;
using System;

public partial class EnemySpawner : VisibleOnScreenNotifier2D
{
	[Export] public PackedScene EnemyScene;
	[Export] public Timer SpawnTimer;

    public override void _Ready()
    {
        base._Ready();

		SpawnTimer.Timeout += OnSpawnTimerTimeout;
    }

	private void OnSpawnTimerTimeout()
	{
		if (!IsOnScreen())
		{
			Enemy TEnemy = EnemyScene.Instantiate() as Enemy;

			GetTree().CurrentScene.AddChild(TEnemy);

			TEnemy.GlobalPosition = GlobalPosition;
		}
	}
}
