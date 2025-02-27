extends Control

@export_file var main_scene

@export var ship_rot_speed: float = 1.0

func _ready() -> void:
	$MuteButton.button_pressed = !SoundMgr.sounds["bg_music"].playing

func _process(delta: float) -> void:
	$Spaceship.rotation += ship_rot_speed * delta
	$Spaceship2.rotation -= ship_rot_speed * delta

func _on_play_button_pressed() -> void:
	SoundMgr.sounds["button_press"].play()
	SceneTransitioner.change_scene(main_scene)

func _on_mute_button_pressed() -> void:
	SoundMgr.sounds["bg_music"].playing = !$MuteButton.button_pressed
