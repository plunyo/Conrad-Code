extends Control


@onready var level_menu: Panel = $LevelMenu
@onready var how_to_play_menu: Panel = $HowToPlayMenu


func _on_levels_pressed() -> void:
	level_menu.show()


func _on_back_pressed() -> void:
	level_menu.hide()
	how_to_play_menu.hide()


func _on_park_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/the_park/the_park.tscn")


func _on_classroom_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/the_classroom/the_classroom.tscn")


func _on_library_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/the_library/the_library.tscn")


func _on_how_to_play_pressed() -> void:
	how_to_play_menu.show()
