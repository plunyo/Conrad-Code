using Godot;
using System;

[GlobalClass]
public partial class Animal : CharacterBody2D
{
    // --- Exported Properties ---
    [Export] public float Speed;
    [Export] public float Health;
    [Export] public float MaxHealth;
    [Export] public float Hunger;
    [Export] public float WanderTime;
    [Export(PropertyHint.Range, "0,100")] public float ReproductiveUrge;

    public EnvironmentScanner EnvironmentScanner => GetNode<EnvironmentScanner>("EnvironmentScanner");
    public ShapeCast2D FrontRaycast => GetNode<ShapeCast2D>("FrontRaycast");

    private float viewDistance = 72f;

    // --- Animal States ---
    public enum AnimalState { Wandering, Fleeing, Attacking, Eating }
    public AnimalState CurrentState = AnimalState.Wandering;

    // --- Private Variables ---
    protected Vector2 Direction { get; set; }
    protected float WanderTimer;

    // --- Process ---
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        UpdateFrontRaycast();
    }


    // --- Movement ---
    public virtual void Move(Vector2 direction)
    {
        // If there's a raycast collision, move away from the water
        if (IsTileAhead(World.WaterCoords))
        {
            Direction = FrontRaycast.GetCollisionNormal(0).Normalized();
        }

        // Update velocity and apply movement
        Velocity = Direction * Speed;
        MoveAndSlide();
    }


    // --- Health Management ---
    public void TakeDamage(float amount)
    {
        Health -= amount;
        if (Health <= 0)
        {
            Die();
        }
    }

    public virtual void Die()
    {
        // Clean up and remove the animal
        QueueFree();
    }

    // --- Detection Logic ---
    public virtual void DetectSurroundings()
    {
        // Logic to detect nearby entities, tiles, or obstacles
        // This can be done with Area2D or raycasting in subclasses
    }

    // --- State Handlers ---
    protected virtual void HandleWandering(float delta) { }
    protected virtual void HandleFleeing(float delta) { }
    protected virtual void HandleAttacking(float delta) { }
    protected virtual void HandleEating(float delta) { }

    // --- Helper Methods ---
    protected void SetRandomDirection(float maxAngleChange = 0.5f)
    {
        float currentAngle = Direction.Angle();
        float angleChange = (float)GD.RandRange(-maxAngleChange, maxAngleChange);
        float newAngle = currentAngle + angleChange;

        Direction = new Vector2(Mathf.Cos(newAngle), Mathf.Sin(newAngle)).Normalized();
    }


    private void UpdateFrontRaycast()
    {
        FrontRaycast.TargetPosition = Direction * viewDistance;
    }

    protected bool IsTileAhead(Vector2I tileCoords)
    {
        if (!FrontRaycast.IsColliding() || FrontRaycast.GetCollider(0) is not World world)
            return false;

        Vector2I cell = world.LocalToMap(FrontRaycast.GetCollisionPoint(0));
        Vector2I coords = world.GetCellAtlasCoords(cell);

        return coords == tileCoords;
    }

}
