class_name CursorInteractor
extends Area2D

@onready var world: World = get_tree().get_first_node_in_group("world")

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
