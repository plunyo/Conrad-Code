class_name Predator
extends Animal

@export var damage: float = 20.0

@onready var attack_timer: Timer = $AttackTimer
@onready var kill_range: Area2D = $KillRange

func _on_world_update() -> void:
	super()
	kill_range.monitoring = current_state == AnimalState.SEEKING_FOOD
	attack_timer.paused = not current_state == AnimalState.SEEKING_FOOD

func _handle_seeking_food() -> void:
	var closest_prey: Prey = environment_scanner.find_nearest_prey()
	if closest_prey: # if cant find food wander until food
		move_to(closest_prey.global_position)
	else:
		_handle_wandering()

	if hunger > 80.0:
		change_state_to(AnimalState.WANDERING)

func _on_hunger_timer_timeout() -> void:
	var loss = randf_range(0.2, 0.5)
	hunger = max(hunger - loss, 0)
	if hunger <= 0:
		take_damage(HUNGER_DAMAGE)
	update_info()

func _on_attack_timer_timeout() -> void:
	for body: Node2D in kill_range.get_overlapping_bodies():
		if body is Prey:
			(body as Prey).take_damage(damage, self)
