class_name Predator
extends Animal

@export var damage: float = 20.0

@onready var attack_timer: Timer = $AttackTimer
@onready var kill_range: Area2D = $KillRange

func _physics_process(delta: float) -> void:
	super(delta)
	kill_range.monitoring = current_state == AnimalState.SEEKING_FOOD
	attack_timer.paused = not current_state == AnimalState.SEEKING_FOOD

func _handle_seeking_food(delta: float) -> void:
	var closest_prey: Prey = environment_scanner.find_nearest_prey()
	if closest_prey: # if cant find food wander until food
		move_to(closest_prey.global_position)
	else:
		_handle_wandering(delta)

	if hunger > 80.0:
		change_state_to(AnimalState.WANDERING)

func _handle_fleeing(_delta: float) -> void:
	pass

func _handle_foraging(_delta: float) -> void:
	pass

func _on_attack_timer_timeout() -> void:
	for body: Node2D in kill_range.get_overlapping_bodies():
		if body is Prey:
			(body as Prey).take_damage(damage, self)
