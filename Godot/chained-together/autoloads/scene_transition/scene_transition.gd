extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: String) -> void:
	animation_player.play('dissolve')
	await animation_player.animation_finished

	if target == "quit":
		get_tree().quit()
	else:
		get_tree().change_scene_to_file(target)
		animation_player.play_backwards("dissolve")
