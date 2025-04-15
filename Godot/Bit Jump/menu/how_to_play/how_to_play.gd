extends MarginContainer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):

		SceneTransition.change_scene("res://menu/main_menu.tscn")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		SceneTransition.change_scene("res://menu/main_menu.tscn")
