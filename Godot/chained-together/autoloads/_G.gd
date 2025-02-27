extends Node

signal Score_Changed
signal Game_Lost

var Score: int = 0

func Increment_Score(increment: int) -> void:
	Score += increment

	emit_signal("Score_Changed", Score)

func Lose() -> void:
	emit_signal("Game_Lost")
	await get_tree().create_timer(3).timeout
	SceneTransition.change_scene("res://ui/main_menu/main_menu.tscn")
	Score = 0
