class_name Animal
extends CharacterBody2D

signal state_changed
signal died

enum AnimalState { WANDERING, FLEEING, SEEKING_FOOD, SEEKING_MATE }

const DIRECTIONS := [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
	Vector2i(1, 1),
	Vector2i(-1, -1),
	Vector2i(1, -1),
	Vector2i(-1, 1),
]

const HUNGER_DAMAGE := 5.0
const HUNGER_INTERVAL := 1.0

@export var move_duration: float = randf_range(0.8, 1.2)
@export var current_health: float = 100.0
@export var hunger: float = randf_range(20.0, 90.0)
@export var reproductive_urge: float = randf_range(0.0, 30.0)

@onready var environment_scanner: EnvironmentScanner = $EnvironmentScanner
@onready var mating_range: MatingRange = $MatingRange
@onready var world: World = get_tree().get_first_node_in_group("world")
@onready var info_panel: Control = $InfoPanel
@onready var state_label: Label = $StateLabel

var wander_timer: float
var next_wander_delay := 0.0
var idle_wander_delay: float

var direction_change_cooldown := 0.0
var direction_change_interval := 2.5

var hunger_timer := 0.0

var current_state: AnimalState = AnimalState.WANDERING

var direction: Vector2i
var previous_direction: Vector2i

var is_moving: bool = false

var mate: Animal
var wants_to_mate_with: Animal = null

func _ready() -> void:
	mouse_entered.connect(func() -> void: info_panel.show() )
	mouse_exited.connect(func() -> void: info_panel.hide() )

func _physics_process(delta: float) -> void:
	state_label.text = {
		AnimalState.WANDERING: "Wandering",
		AnimalState.SEEKING_FOOD: "Seeking Food",
		AnimalState.FLEEING: "Fleeing",
		AnimalState.SEEKING_MATE: "Seeking Mate"
	}[current_state]

	update_needs(delta)

	match current_state:
		AnimalState.WANDERING:
			_handle_wandering(delta)
		AnimalState.SEEKING_FOOD:
			_handle_seeking_food(delta)
		AnimalState.SEEKING_MATE:
			_handle_seeking_mate(delta)
		AnimalState.FLEEING:
			_handle_fleeing(delta)

func move(dir: Vector2i, duration: float) -> void:
	if is_moving:
		return

	var current_world_pos: Vector2i = world.local_to_map(global_position)
	var target_world_pos: Vector2i = current_world_pos + dir
	var target_global_pos: Vector2 = world.map_to_local(target_world_pos)

	var tile = world.get_cell_atlas_coords(target_world_pos)
	if tile == World.BORDER_TILE or tile == World.WATER_TILE:
		set_random_direction()
		return

	is_moving = true
	var move_tween: Tween = create_tween()
	move_tween.tween_property(self, "global_position", target_global_pos, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	move_tween.finished.connect(func() -> void:
		is_moving = false
	)

func move_to(target_position: Vector2) -> void:
	var current_world_pos: Vector2i = world.local_to_map(global_position)

	var best_dir: Vector2i = Vector2i.ZERO
	var best_distance: float = INF

	for dir in DIRECTIONS:
		var candidate_world_pos: Vector2i = current_world_pos + dir
		var candidate_global_pos: Vector2 = world.map_to_local(candidate_world_pos)
		var tile = world.get_cell_atlas_coords(candidate_world_pos)
		if tile == World.BORDER_TILE or tile == World.WATER_TILE:
			continue

		var distance: float = candidate_global_pos.distance_to(target_position)
		if distance < best_distance:
			best_distance = distance
			best_dir = dir

	move(best_dir, move_duration)

func move_away_from(target_position: Vector2) -> void:
	var current_world_pos: Vector2i = world.local_to_map(global_position)

	var best_dir: Vector2i = Vector2i.ZERO
	var best_distance: float = -INF

	for dir in DIRECTIONS:
		var candidate_world_pos: Vector2i = current_world_pos + dir
		var candidate_global_pos: Vector2 = world.map_to_local(candidate_world_pos)
		var distance: float = candidate_global_pos.distance_to(target_position)
		var tile = world.get_cell_atlas_coords(candidate_world_pos)
		if tile == World.BORDER_TILE or tile == World.WATER_TILE:
			continue
		if distance > best_distance:
			best_distance = distance
			best_dir = dir

	move(best_dir, move_duration)

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

func update_info_panel() -> void:
	$InfoPanel/HealthBar.value = current_health
	$InfoPanel/HungerBar.value = hunger
	$InfoPanel/ReproductiveUrgeBar.value = reproductive_urge

# --- state handlers ---
func _handle_wandering(delta: float) -> void:
	if current_health < 100.0 or (hunger < 30.0 and not current_state == AnimalState.SEEKING_FOOD):
		change_state_to(AnimalState.SEEKING_FOOD)
	elif reproductive_urge > hunger and hunger > 20.0 and not current_state == AnimalState.SEEKING_MATE:
		change_state_to(AnimalState.SEEKING_MATE)

	wander_timer += delta
	direction_change_cooldown += delta

	if next_wander_delay == 0.0:
		next_wander_delay = idle_wander_delay + randf_range(-0.5, 0.5)

	if not is_moving and wander_timer >= next_wander_delay:
		if direction_change_cooldown >= direction_change_interval:
			set_random_direction()
			direction_change_cooldown = 0.0

		move(direction, move_duration)
		wander_timer = 0.0
		next_wander_delay = 0.0


func _handle_fleeing(_delta: float) -> void:
	pass

func _handle_seeking_food(_delta: float) -> void:
	pass

func _handle_seeking_mate(delta: float) -> void:
	if not mating_range.mate_cooldown_timer.is_stopped():
		return

	if mate:
		move_to(mate.global_position)
		return

	@warning_ignore("incompatible_ternary")
	var potential_mate: Animal = environment_scanner.find_nearest_prey() if self is Prey else environment_scanner.find_nearest_predator()

	if not potential_mate or not potential_mate.current_state == AnimalState.SEEKING_MATE:
		_handle_wandering(delta)
		return

	if potential_mate.mate or potential_mate == self:
		_handle_wandering(delta)
		return

	wants_to_mate_with = potential_mate

	if potential_mate.wants_to_mate_with == self:
		mate = potential_mate
		potential_mate.mate = self
	else:
		move_to(potential_mate.global_position)

func change_state_to(new_state: AnimalState) -> void:
	state_changed.emit(new_state)
	current_state = new_state

func update_needs(delta: float) -> void:
	hunger_timer += delta

	if hunger_timer >= HUNGER_INTERVAL:
		hunger_timer = 0.0
		var hunger_loss := randf_range(0.2, 0.5)
		hunger = max(hunger - hunger_loss, 0.0)
		if hunger <= 0:
			take_damage(HUNGER_DAMAGE)
		update_info_panel()

func set_random_direction() -> void:
	var cardinal_directions: Array[Vector2i] = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1),
	]

	var diagonal_directions: Array[Vector2i] = [
		Vector2i(1, 1),
		Vector2i(-1, -1),
		Vector2i(1, -1),
		Vector2i(-1, 1),
	]

	cardinal_directions = cardinal_directions.filter(func(dir): return dir != -previous_direction)
	diagonal_directions = diagonal_directions.filter(func(dir): return dir != -previous_direction)

	var use_diagonal := randf() < 0.2
	var pool = diagonal_directions if use_diagonal else cardinal_directions

	if pool.is_empty():
		pool = cardinal_directions + diagonal_directions

	direction = pool.pick_random()
	previous_direction = direction
