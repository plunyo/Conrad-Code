class_name Prey
extends Animal

@export var is_predator_near: bool = false

var escape_multiplier: float = 0.8

func _physics_process(delta: float) -> void:
	update_needs(delta)

	match current_state:
		AnimalState.WANDERING:
			_handle_wandering(delta)
		AnimalState.FORAGING:
			_handle_foraging(delta)

func detect_surroundings() -> void:
	# prey-specific detection logic, like checking for nearby predators
	# example: is_predator_near = _detect_nearby_predators()
	pass

func warn_others() -> void:
	for body in environment_scanner.get_overlapping_bodies():
		if body is Prey:
			body.is_predator_near = true

# states
func _handle_wandering(delta: float) -> void:
	if current_health < 100.0 or hunger < 50.0 or thirst < 50.0:
		current_state = AnimalState.FORAGING
		return

	wander_timer += delta

	if next_wander_delay == 0.0:
		next_wander_delay = idle_wander_delay + randf_range(-0.5, 0.5)

	if not is_moving and wander_timer >= next_wander_delay:
		set_random_direction()
		move(direction, move_duration)
		wander_timer = 0.0
		next_wander_delay = 0.0

func _handle_foraging(delta: float) -> void:
	pass

func _on_mouse_entered() -> void: info_panel.show()
func _on_mouse_exited() -> void: info_panel.hide()
