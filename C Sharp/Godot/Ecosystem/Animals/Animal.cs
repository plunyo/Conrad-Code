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

    public EnvironmentScanner EnvironmentScanner;
    public ShapeCast2D FrontShapeCast;

    private float viewDistance = 72.0f;

    // --- Animal States ---
    public enum AnimalState { Wandering, Fleeing, Attacking, Eating }
    public AnimalState CurrentState = AnimalState.Wandering;

    // --- Private Variables ---
    protected Vector2 Direction { get; set; }
    protected float WanderTimer;

    // --- Ready ---
    public override void _Ready()
    {
        base._Ready();
        EnvironmentScanner = GetNode<EnvironmentScanner>("EnvironmentScanner");
        FrontShapeCast = GetNode<ShapeCast2D>("FrontShapeCast");
    }

    // --- Process ---
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
        UpdateFrontShapeCast();
    }

    // --- Movement ---
    public virtual void Move(Vector2 direction)
    {
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
        QueueFree();
    }

    // --- Detection Logic ---
    public virtual void DetectSurroundings()
    {

    }

    // --- State Handlers ---
    protected virtual void HandleWandering(float delta) { }
    protected virtual void HandleFleeing(float delta) { }
    protected virtual void HandleAttacking(float delta) { }
    protected virtual void HandleEating(float delta) { }

    // --- Helper Methods ---
    protected void SetRandomDirection(float maxAngleChange = 1.0f)
    {
        float currentAngle = Direction.Angle();
        float angleChange = (float)GD.RandRange(-maxAngleChange, maxAngleChange);
        float newAngle = currentAngle + angleChange;

        Direction = new Vector2(Mathf.Cos(newAngle), Mathf.Sin(newAngle)).Normalized();
    }


    private void UpdateFrontShapeCast()
    {
        FrontShapeCast.TargetPosition = Direction * viewDistance;
    }

    protected bool IsTileAhead(Vector2I tileCoords)
    {
        if (!FrontShapeCast.IsColliding())
            return false;

        int count = FrontShapeCast.GetCollisionCount();
        for (int i = 0; i < count; i++)
        {
            if (FrontShapeCast.GetCollider(i) is not World world)
                continue;

            Vector2I cell = world.LocalToMap(FrontShapeCast.GetCollisionPoint(i));
            Vector2I coords = world.GetCellAtlasCoords(cell);

            if (coords == tileCoords) { return true; }
        }

        return false;
    }
}
