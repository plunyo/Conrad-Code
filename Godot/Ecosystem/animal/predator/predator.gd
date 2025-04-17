class_name Predator
extends Animal


func _handle_wandering(delta: float) -> void:
	if current_health < 100.0 or hunger < 50.0 and not current_state == AnimalState.seeking_food:
		current_state = AnimalState.seeking_food

	wander_timer += delta
	if next_wander_delay == 0.0:
		next_wander_delay = idle_wander_delay + randf_range(-0.5, 0.5)

	if not is_moving and wander_timer >= next_wander_delay:
		set_random_direction()
		move(direction, move_duration)
		wander_timer = 0.0
		next_wander_delay = 0.0

func _handle_fleeing(delta: float) -> void:
	pass

func _handle_attacking(delta: float) -> void:
	pass

func _handle_foraging(delta: float) -> void:
	pass
