extends Area2D


@onready var mouse_line: Line2D = $MouseLine
@onready var win_timer: Timer = $WinTimer

var dragging: bool = false

var covering_left_eye = false
var covering_right_eye = false

func _process(_delta: float) -> void:
	mouse_line.points[1] = get_local_mouse_position()

	if dragging:
		position = get_global_mouse_position()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		mouse_line.show()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_global_mouse_position().distance_to(global_position) < 50:
					dragging = true
			else:
				dragging = false

	elif event is InputEventScreenTouch:
		mouse_line.hide()
		if event.pressed:
			if get_viewport().get_mouse_position().distance_to(global_position) < 50:
				dragging = true
		else:
			dragging = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("LeftEye"):
		covering_left_eye = true
	if area.is_in_group("RightEye"):
		covering_right_eye = true

	if covering_left_eye and covering_right_eye:
		win_timer.start()
		SceneTransition.is_blindfolded = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("LeftEye"):
		covering_left_eye = false
	if area.is_in_group("RightEye"):
		covering_right_eye = false

	win_timer.stop()
	SceneTransition.is_blindfolded = false


func _on_win_timer_timeout() -> void:
	SceneTransition.change_scene("res://scenes/win/win_scene.tscn")


func _on_mouse_entered() -> void:
	SceneTransition.is_blindfolded = true


func _on_mouse_exited() -> void:
	SceneTransition.is_blindfolded = false
