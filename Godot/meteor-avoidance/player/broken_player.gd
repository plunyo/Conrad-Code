extends Node2D

@onready var spaceships: Array = [
	$SpaceshipBl,
	$SpaceshipBr,
	$SpaceshipBr2
]
@export var rot_speed: float = 2.0

var directions: Array

func _ready():
	SoundMgr.sounds["crash"].play()
	Settings.game_lost = true
	randomize()
	directions = [
		compute_direction(randf_range(PI - PI/4, PI + PI/4)),  # Left direction (-135° to -225°)
		compute_direction(randf_range(-PI/4, PI/4)),          # Right direction (-45° to 45°)
		compute_direction(randf_range(-PI/4, PI/4))           # Right direction 2 (-45° to 45°)
	]

func _process(delta: float) -> void:
	for i in range(spaceships.size()):
		spaceships[i].global_position += directions[i] / 2
		spaceships[i].rotation += rot_speed * delta

func compute_direction(angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle))

func _on_restart_timer_timeout() -> void:
	SceneTransitioner.reload_scene()
