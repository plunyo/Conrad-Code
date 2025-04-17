using System;
using Godot;

[GlobalClass]
public partial class Predator : Animal
{
    // --- Exported Properties ---
    [Export] public float HuntingSpeed;   // Speed at which the predator hunts
    [Export] public float AttackPower;    // Damage dealt when attacking
    [Export] public float AttackRange;    // Range at which the predator can attack prey

    // --- Detection Logic ---
    public override void DetectSurroundings()
    {
        // Predator-specific detection logic (e.g., find prey or enemies)
        // Example: Check if prey is within range, etc.
        // Example: preyDetected = DetectNearbyPrey();
    }

    // --- Hunting Logic ---
    public void HuntPrey(Prey prey)
    {
        // Logic for hunting prey:
        // - Chase prey
        // - Attack
        // - Kill prey once it's caught
        // Example: Move towards prey, check attack range, etc.
    }
}
