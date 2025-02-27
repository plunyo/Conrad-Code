extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_counter: Timer = $TimeCounter

@export var enemy_scene: PackedScene

var elapsed_time: int = 0

var can_spawn: bool = true

func _ready() -> void:
	_G.Game_Lost.connect(func() -> void: can_spawn = false)

	time_counter.timeout.connect(func() -> void: elapsed_time += 1)

	spawn_timer.timeout.connect(spawn_enemy)

func spawn_enemy() -> void:
	if !can_spawn: return

	var t_enemy: CharacterBody2D = enemy_scene.instantiate()

	var spawn_pos: Vector2 = Vector2(
		randf_range(0, get_viewport_rect().size.x),
		randf_range(0, get_viewport_rect().size.y)
	)

	get_tree().current_scene.add_child(t_enemy)
	t_enemy.global_position = spawn_pos

	spawn_timer.wait_time = max(0.5, 3.0 - (elapsed_time / 20.0))  
