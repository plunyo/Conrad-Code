class_name Prey
extends Animal

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var hunger_amount: float = 50.0

func _physics_process(delta: float) -> void:
	if not animation_player.is_playing():
		super(delta)

	var closest_predator: Predator = environment_scanner.find_nearest_predator()
	if closest_predator:
		change_state_to(AnimalState.FLEEING)

func _handle_seeking_food(delta: float) -> void:
	var closest_food = environment_scanner.find_nearest_food()
	if closest_food: # if cant find food wander until food
		move_to(closest_food.global_position)
	else:
		_handle_wandering(delta)

	if hunger > 85.0:
		change_state_to(AnimalState.SEEKING_FOOD)

func _handle_fleeing(_delta: float) -> void:
	var closest_predator = environment_scanner.find_nearest_predator()
	if closest_predator:
		move_away_from(closest_predator.global_position)
	else:
		change_state_to(AnimalState.WANDERING)

func take_damage(amount: float, from: Animal = null) -> void:
	current_health -= amount
	if current_health <= 0:
		if from != null:
			from.hunger += hunger_amount
			from.reproductive_urge += min(from.reproductive_urge + randf_range(2.0, 5.0), 100.0)
		die()

var is_dead := false

func die() -> void:
	if is_dead:
		return
	is_dead = true

	if mate:
		mate.mate = null
		mate.wants_to_mate_with = null

	mate = null
	wants_to_mate_with = null
	died.emit()
	animation_player.play("die")
	await animation_player.animation_finished
	queue_free()
