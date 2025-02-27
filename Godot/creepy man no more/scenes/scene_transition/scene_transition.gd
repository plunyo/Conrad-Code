extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer

var current_scene
var is_blindfolded = false

func change_scene(target: String) -> void:
	if target == "quit":
		animationPlayer.play('dissolve')
		await animationPlayer.animation_finished
		get_tree().quit()

		return

	current_scene = target

	animationPlayer.play('dissolve')
	await animationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	animationPlayer.play_backwards("dissolve")
