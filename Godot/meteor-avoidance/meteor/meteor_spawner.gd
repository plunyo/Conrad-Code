extends Node
class_name MeteorSpawner

@export var meteor_scene: PackedScene
@export var meteor_spawn_timer: Timer

# Define meteor spawn positions
const LEFT_POSITION: Vector2 = Vector2(30, 200)
const RIGHT_POSITION: Vector2 = Vector2(60, 200)

const DOUBLE_OFFSET: float = 15.0

# Define meteor spawn patterns
var meteor_combinations: Array[Callable] = [spawn_left, spawn_right, spawn_double]

func _ready() -> void:
	meteor_spawn_timer.timeout.connect(func() -> void: meteor_combinations.pick_random().call())

func spawn_meteor(position: Vector2, scale: float = 1.0) -> void:
	var meteor: Area2D = meteor_scene.instantiate() as Area2D
	meteor.global_position = position
	meteor.scale = Vector2(scale, scale)
	get_tree().current_scene.add_child(meteor)

func spawn_left() -> void:
	spawn_meteor(LEFT_POSITION)

func spawn_right() -> void:
	spawn_meteor(RIGHT_POSITION)

func spawn_double() -> void:
	spawn_meteor(LEFT_POSITION - Vector2(DOUBLE_OFFSET, 0), .8)
	spawn_meteor(RIGHT_POSITION + Vector2(DOUBLE_OFFSET, 0), .8)
