using System;
using Godot;

[GlobalClass]
public partial class Prey : Animal
{
    // --- Exported Properties ---
    [Export] public bool IsPredatorNear;

    // --- Private Variables ---
    private float EscapeMultiplier = 0.8f;

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
        foreach (Prey prey in EnvironmentScanner.GetOverlappingBodies())
        {
            prey.IsPredatorNear = true;
        }
    }

    // --- State Handler Overrides ---
    protected override void HandleWandering(float delta)
    {
        WanderTimer += delta;

        if (WanderTimer >= IdleWanderDelay)
        {
            Move(GetRandomDirection(), MoveDuration);
        }
    }
}
