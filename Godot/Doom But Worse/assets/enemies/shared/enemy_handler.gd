extends Node

class_name EnemyHandler

@export var enemies: Array[PackedScene]
@export var spawn_points: Array[Marker3D]
@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(spawn_enemy)

func spawn_enemy() -> void:
	var t_enemy: CharacterBody3D = enemies.pick_random().instantiate()

	get_tree().current_scene.add_child(t_enemy)

	t_enemy.global_position = spawn_points.pick_random().global_position
