using Godot;

public partial class Bullet : Area2D
{
	[Export] float Speed = 20.0f;
	[Export] int Damage = 40;
	
	public Vector2 Direction;

    public override void _Ready()
    {
        BodyEntered += _OnBodyEntered;

		Rotation = Direction.Angle() + Mathf.Pi / 2;
    }

    public override void _PhysicsProcess(double delta)
	{
		GlobalPosition -= Direction * Speed;
	}

	private void _OnBodyEntered(Node2D otherBody)
	{
		if (otherBody.IsInGroup("Enemy"))
		{
			Enemy enemy = otherBody as Enemy;

			enemy.Hit(Damage);
		}

		QueueFree();
	}
}