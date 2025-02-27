extends Node2D

@onready var level_timer: Timer = $LevelTimer

@export_file var main_menu_scene: String

func _ready() -> void:
	$Background.autoscroll.y = -Settings.spaceship_speed
	Settings.reset()

func _process(_delta: float) -> void:
	$Level.text = "Level: " + str(Settings.current_level)
	$Score.text = "Score: " + str(Settings.score)

	if Input.is_action_just_pressed("ui_cancel"):
		SceneTransitioner.change_scene(main_menu_scene)

func _on_level_timer_timeout() -> void:
	Settings.spaceship_speed *= 1.3
	Settings.current_level += 1
