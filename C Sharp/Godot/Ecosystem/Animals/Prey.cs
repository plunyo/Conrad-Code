using System;
using Godot;

[GlobalClass]
public partial class Prey : Animal
{
    // --- Exported Properties ---
    [Export] public bool IsPredatorNear;  // Renamed for clarity (C# convention: Pascal case)

    // --- Private Variables ---
    private float EscapeSpeed => Speed * 1.25f;

    // --- Physics Processing ---
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        // Handle different animal states
        switch (CurrentState)
        {
            case AnimalState.Wandering:
                HandleWandering((float)delta);
                break;
                // Add more states like Fleeing, Attacking, etc. in future
        }
    }

    // --- Detection Logic ---
    public override void DetectSurroundings()
    {
        // Prey-specific detection logic, such as checking for nearby predators
        // Example: isPredatorNear = DetectNearbyPredators();
    }

    // --- Warning Logic ---
    public void WarnOthers()
    {
        // Logic for warning nearby prey about a predator
        // For example, triggering a visual or audio cue
    }

    // --- State Handler Overrides ---
    protected override void HandleWandering(float delta)
    {
        WanderTimer += delta;

        if (WanderTimer >= WanderTime || Direction == Vector2.Zero)
        {
            WanderTimer = 0.0f;
            SetRandomDirection();  // Set new direction to wander
        }

        Move(Direction);  // Move the prey in the random direction
    }
}
