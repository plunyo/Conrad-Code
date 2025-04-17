class_name Prey
extends Animal


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func _handle_wandering(delta: float) -> void:
	if current_health < 100.0 or hunger < 50.0 and not current_state == AnimalState.SEEKING_FOOD:
		current_state = AnimalState.SEEKING_FOOD

	wander_timer += delta
	if next_wander_delay == 0.0:
		next_wander_delay = idle_wander_delay + randf_range(-0.5, 0.5)

	if not is_moving and wander_timer >= next_wander_delay:
		set_random_direction()
		move(direction, move_duration)
		wander_timer = 0.0
		next_wander_delay = 0.0

func _handle_seeking_food(delta: float) -> void:
	var closest_food = environment_scanner.find_nearest_food()
	if closest_food: # if cant find food wander until food
		move_to(closest_food.global_position)
	else:
		_handle_wandering(delta)

	if hunger > 85.0:
		current_state = AnimalState.WANDERING
