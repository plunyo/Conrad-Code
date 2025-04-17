using Godot;
using System;
using System.Reflection;
using System.Threading.Tasks;

[GlobalClass]
public partial class Animal : CharacterBody2D
{
    // --- Exported Properties ---
    [Export] public float MoveDuration;
    [Export] public float MaxHealth; // this one can stay, tbh
    [Export] public float CurrentHealth;
    [Export] public float Hunger;
    [Export] public float IdleWanderDelay; // like a delay between random slides
    [Export(PropertyHint.Range, "0,100")] public float ReproductiveUrge;

    public EnvironmentScanner EnvironmentScanner;
    public World World;
    public Control InfoPanel;

    private float viewDistance = 72.0f;
    public float WanderTimer;

    // --- Animal States ---
    public enum AnimalState { Wandering, Fleeing, Attacking, Eating }
    public AnimalState CurrentState = AnimalState.Wandering;

    // --- Private Variables ---
    protected Vector2I Direction { get; set; }

    // --- Ready ---
    public override void _Ready()
    {
        base._Ready();

        EnvironmentScanner = GetNode<EnvironmentScanner>("EnvironmentScanner");
        World = GetParent<World>();
        InfoPanel = GetNode<Control>("InfoPanel");
    }

    // --- Process ---
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
    }

    // --- Movement ---
    public virtual void Move(Vector2 direction, float duration)
    {
        Vector2I currentWorldPosition = World.LocalToMap(GlobalPosition);
        Vector2I targetWorldPosition = currentWorldPosition + Direction;
        Vector2 targetGlobalPosition = World.MapToLocal(targetWorldPosition);

        if (World.GetCellAtlasCoords(targetWorldPosition) == World.BorderTile || World.GetCellAtlasCoords(targetWorldPosition) == World.WaterTile)
        {
            Direction = GetRandomDirection();
            return;
        }

        Tween moveTween = CreateTween();

        moveTween.TweenProperty(this, "global_position", targetGlobalPosition, duration)
            .SetTrans(Tween.TransitionType.Sine)
            .SetEase(Tween.EaseType.InOut);
    }

    // --- Health Management ---
    public void TakeDamage(float amount)
    {
        CurrentHealth -= amount;
        if (CurrentHealth <= 0)
        {
            Die();
        }
    }

    public virtual void Die()
    {
        QueueFree();
    }

    // --- Detection Logic ---
    public virtual void DetectSurroundings() { }

    // --- Info Panel ---
    public virtual void UpdateInfoPanel() { }

    // --- State Handlers ---
    protected virtual void HandleWandering(float delta) { }
    protected virtual void HandleFleeing(float delta) { }
    protected virtual void HandleAttacking(float delta) { }
    protected virtual void HandleEating(float delta) { }

    // --- Helper Methods ---
    protected Vector2I GetRandomDirection(float maxAngleChange = 1.0f)
    {
        return new Vector2I[]
        {
            new Vector2I(1, 0),   // right
            new Vector2I(1, 1),   // down-right
            new Vector2I(0, 1),   // down
            new Vector2I(-1, 1),  // down-left
            new Vector2I(-1, 0),  // left
            new Vector2I(-1, -1), // up-left
            new Vector2I(0, -1),  // up
            new Vector2I(1, -1)   // up-right
        }[GD.Randi() % 8];
    }
}
