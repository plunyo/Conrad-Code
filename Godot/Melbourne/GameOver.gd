extends Node2D

func _on_restart_pressed():
	SceneTransition.change_scene(General.curr_scene)

func _on_menu_pressed():
	SceneTransition.change_scene("res://scenes/menu.tscn")
