extends Control

func _process(delta):
	if Input.is_action_just_pressed("exit") and !get_tree().paused:
		visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("exit") and get_tree().paused:
		visible = false
		get_tree().paused = false

func _on_resume_pressed():
	get_tree().paused = false
	visible = false


func _on_restart_pressed():
	get_tree().paused = false
	SceneTransition.change_scene(General.curr_scene)


func _on_quit_pressed():
	visible = false
	get_tree().paused = false
	SceneTransition.change_scene("res://scenes/menu/menu.tscn")
