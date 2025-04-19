class_name Animal
extends CharacterBody2D

signal state_changed
signal died

enum AnimalState { WANDERING, FLEEING, SEEKING_FOOD, SEEKING_MATE }

const DIRECTIONS = [
	Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
	Vector2i(1, 1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1)
]

const HUNGER_DAMAGE = 5.0
const HUNGER_DELAY := 20

@export var move_duration: float = randf_range(0.8, 1.2)
@export var current_health: float = 100.0
@export var hunger: float = randf_range(20.0, 90.0)
@export var reproductive_urge: float = randf_range(0.0, 30.0)

@onready var environment_scanner: EnvironmentScanner = $EnvironmentScanner
@onready var mating_range: MatingRange = $MatingRange
@onready var world: World = get_tree().get_first_node_in_group("world")
@onready var info_panel: Control = $InfoPanel
@onready var state_label: Label = $StateLabel

var update_counter: int = 0

var previous_direction: Vector2i = Vector2i.ZERO
var wants_to_mate_with: Animal = null
var current_state: AnimalState = AnimalState.WANDERING
var direction: Vector2i = Vector2i.ZERO
var is_moving: bool = false
var mate: Animal

func _ready() -> void:
	# start world update trigger
	world.update.connect(_on_world_update)
	update_info()

# world update trigger
func _on_world_update() -> void:
	update_counter += 1

	update_hunger()
	match current_state:
		AnimalState.WANDERING: _handle_wandering()
		AnimalState.FLEEING: _handle_fleeing()
		AnimalState.SEEKING_FOOD: _handle_seeking_food()
		AnimalState.SEEKING_MATE: _handle_seeking_mate()

func update_hunger() -> void:
	if update_counter % HUNGER_DELAY == 0:
		var loss = randf_range(0.2, 0.5)
		hunger = max(hunger - loss, 0)
		if hunger <= 0:
			take_damage(HUNGER_DAMAGE)
		update_info()

func move(dir: Vector2i, duration: float) -> void:
	if is_moving: return

	var current_map_pos = world.local_to_map(global_position)
	var target_map_pos = current_map_pos + dir

	var tile_at_target = world.get_cell_atlas_coords(target_map_pos)
	if tile_at_target == World.BORDER_TILE or tile_at_target == World.WATER_TILE:
		set_random_direction()
		return

	var target_global_pos = world.map_to_local(target_map_pos)

	is_moving = true

	var move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_global_pos, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	move_tween.finished.connect(func() -> void: is_moving = false )

func move_to(target_position: Vector2) -> void:
	var current_map_pos = world.local_to_map(global_position)
	var best_direction: Vector2i = Vector2i.ZERO
	var shortest_distance = INF

	for direction in DIRECTIONS:
		var potential_map_pos = current_map_pos + direction

		if world.get_cell_atlas_coords(potential_map_pos) in [World.BORDER_TILE, World.WATER_TILE]:
			continue

		var potential_global_pos = world.map_to_local(potential_map_pos)
		var distance = potential_global_pos.distance_squared_to(target_position)

		if distance < shortest_distance:
			shortest_distance = distance
			best_direction = direction

	move(best_direction, move_duration)

func move_away_from(target: Vector2) -> void:
	var current_pos = world.local_to_map(global_position)
	var best_direction = Vector2i.ZERO
	var max_distance = -INF

	for dir in DIRECTIONS:
		var next_pos = current_pos + dir
		if world.get_cell_atlas_coords(next_pos) in [World.BORDER_TILE, World.WATER_TILE]:
			continue

		var world_pos = world.map_to_local(next_pos)
		var dist = world_pos.distance_squared_to(target)

		if dist > max_distance:
			max_distance = dist
			best_direction = dir

	move(best_direction, move_duration)


func take_damage(amount: float, _from: Animal = null) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	if mate:
		mate.mate = null
		mate.wants_to_mate_with = null
	mate = null
	wants_to_mate_with = null
	died.emit()
	queue_free()

func update_info() -> void:
	info_panel.get_node("HealthBar").value = current_health
	info_panel.get_node("HungerBar").value = hunger
	info_panel.get_node("ReproductiveUrgeBar").value = reproductive_urge

	state_label.text = {
			AnimalState.WANDERING: "Wandering",
			AnimalState.SEEKING_FOOD: "Seeking Food",
			AnimalState.FLEEING: "Fleeing",
			AnimalState.SEEKING_MATE: "Seeking Mate"
	}[current_state]

func _handle_wandering() -> void:
	# state transitions
	if current_health < 100.0 or (hunger < 50.0 and current_state != AnimalState.SEEKING_FOOD):
		change_state_to(AnimalState.SEEKING_FOOD)
	elif reproductive_urge > hunger and hunger > 20.0 and current_state != AnimalState.SEEKING_MATE:
		change_state_to(AnimalState.SEEKING_MATE)

	set_random_direction()
	move(direction, move_duration)

func _handle_seeking_food() -> void:
	# implement food seeking logic here
	pass

func _handle_fleeing() -> void:
	pass

func _handle_seeking_mate() -> void:
	if mate:
		move_to(mate.global_position)
		return

	@warning_ignore("incompatible_ternary")
	var potential = environment_scanner.find_nearest_predator() if self is Prey else environment_scanner.find_nearest_prey()
	
	if not potential or potential.current_state != AnimalState.SEEKING_MATE:
		_handle_wandering(); return

	if potential.mate or potential == self:
		_handle_wandering(); return

	wants_to_mate_with = potential

	if potential.wants_to_mate_with == self:
		mate = potential
		potential.mate = self
	else:
		move_to(potential.global_position)

func change_state_to(new_state: AnimalState) -> void:
	if current_state != new_state:
		current_state = new_state
		state_changed.emit(new_state)

		state_label.text = {
			AnimalState.WANDERING: "Wandering",
			AnimalState.SEEKING_FOOD: "Seeking Food",
			AnimalState.FLEEING: "Fleeing",
			AnimalState.SEEKING_MATE: "Seeking Mate"
		}[current_state]

func set_random_direction() -> void:
	var pool = DIRECTIONS.filter(func(d): return d != -previous_direction)

	if pool.is_empty():
		pool = DIRECTIONS

	direction = pool.pick_random()
	previous_direction = direction
