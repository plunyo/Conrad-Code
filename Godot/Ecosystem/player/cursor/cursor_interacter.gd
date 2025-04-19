class_name CursorInteractor
extends Area2D

@onready var world: World = get_tree().get_first_node_in_group("world")

func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _on_body_entered(body: Node2D) -> void:
	if body is Animal:
		(body as Animal).info_panel.show()

func _on_body_exited(body: Node2D) -> void:
	if body is Animal:
		(body as Animal).info_panel.hide()
