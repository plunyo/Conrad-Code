extends Control

func _ready() -> void:
	Input.start_joy_vibration(1, 100.0, 100.0, 10)
	print("VIBRATING")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneTransition.change_scene("res://arena.tscn")
