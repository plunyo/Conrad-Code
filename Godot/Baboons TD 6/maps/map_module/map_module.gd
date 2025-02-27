extends Node

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

@export var path: Path2D
@export var enemies: Array[PackedScene]
@export var powerups: Array[PackedScene]

@export var spawn_interval: float = 1.0
@export var wave_duration: float = 15.0
@export var powerup_chance: float = 0.1
@export var enemies_per_wave: int = 5

var extra_enemies: int = 0
var enemies_to_spawn: int = 0

func _ready() -> void:
	start_wave()

func start_wave() -> void:
	enemies_to_spawn = enemies_per_wave + extra_enemies

	spawn_timer.start()
	wave_timer.start()

func _on_spawn_timer_timeout() -> void:
	if enemies_to_spawn > 0:
		spawn_enemy()
		enemies_to_spawn -= 1
	else:
		spawn_timer.stop()

func spawn_enemy() -> void:
	if enemies.size() > 0:
		var enemy_scene: PackedScene = enemies[randi() % enemies.size()]
		var enemy_instance: Node2D = enemy_scene.instantiate() as Node2D
		path.add_child(enemy_instance)

		if randf() < powerup_chance and powerups.size() > 0:
			spawn_powerup()

func spawn_powerup() -> void:
	var powerup_scene: PackedScene = powerups[randi() % powerups.size()]
	var powerup_instance: Node2D = powerup_scene.instantiate() as Node2D
	powerup_instance.position = path.curve.get_point_position(randi() % path.curve.get_point_count())
	path.add_child(powerup_instance)

func advance_wave() -> void:
	extra_enemies += 1
	start_wave()
