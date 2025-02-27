extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(scene: String) -> void:
	animation_player.play("slide_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	animation_player.play("slide_out")

func reload_scene() -> void:
	animation_player.play("slide_in")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play("slide_out")
