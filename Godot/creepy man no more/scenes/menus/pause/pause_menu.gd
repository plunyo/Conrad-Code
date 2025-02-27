extends CanvasLayer


@onready var panel: Panel = $Panel
@onready var pause: Button = $Pause


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		panel.visible = !panel.visible
		pause.hide()


func _on_restart_pressed() -> void:
	get_tree().paused = !get_tree().paused
	panel.visible = !panel.visible
	SceneTransition.change_scene(SceneTransition.current_scene)
	pause.show()


func _on_menu_pressed() -> void:
	SceneTransition.change_scene("res://scenes/menus/main/main_menu.tscn")
	get_tree().paused = !get_tree().paused
	panel.visible = !panel.visible
	pause.show()


func _on_resume_pressed() -> void:
	get_tree().paused = !get_tree().paused
	panel.visible = !panel.visible
	pause.show()


func _on_pause_pressed() -> void:
	get_tree().paused = !get_tree().paused
	panel.visible = !panel.visible
	pause.hide()
