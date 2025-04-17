class_name Animal
extends CharacterBody2D

enum AnimalState { WANDERING, FLEEING, ATTACKING, FORAGING }

@export var move_duration: float
@export var current_health: float = 100.0
@export var hunger: float = 100.0
@export var thirst: float = 100.0
@export var idle_wander_delay: float
@export_range(0, 100) var reproductive_urge: float

@onready var environment_scanner: EnvironmentScanner = $EnvironmentScanner
@onready var world: World = get_parent()
@onready var info_panel: Control = $InfoPanel

var wander_timer: float
var next_wander_delay := 0.0

var hunger_timer := 0.0
var thirst_timer := 0.0

var current_state: AnimalState = AnimalState.WANDERING

var direction: Vector2i
var previous_direction: Vector2i

var is_moving: bool = false

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

	move_tween.finished.connect(func() -> void: is_moving = false)


func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()

func detect_surroundings() -> void:
	pass

func update_info_panel() -> void:
	$InfoPanel/HealthBar.value = current_health
	$InfoPanel/ThirstBar.value = thirst
	$InfoPanel/HungerBar.value = hunger
	$InfoPanel/ReproductiveUrgeBar.value = reproductive_urge

# --- state handlers ---
func _handle_wandering(_delta: float) -> void:
	pass

func _handle_fleeing(_delta: float) -> void:
	pass

func _handle_attacking(_delta: float) -> void:
	pass

func _handle_foraging(_delta: float) -> void:
	pass

func update_needs(delta: float) -> void:
	hunger_timer += delta
	thirst_timer += delta

	# how often to update in seconds
	var hunger_interval := 1.0
	var thirst_interval := 1.0

	if hunger_timer >= hunger_interval:
		hunger_timer = 0.0
		var hunger_loss := randf_range(0.2, 0.5)
		hunger = max(hunger - hunger_loss, 0.0)
		update_info_panel()

	if thirst_timer >= thirst_interval:
		thirst_timer = 0.0
		var thirst_loss := randf_range(0.3, 0.6)
		thirst = max(thirst - thirst_loss, 0.0)
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
		print("a")
		pool = cardinal_directions + diagonal_directions

	direction = pool.pick_random()
	previous_direction = direction
