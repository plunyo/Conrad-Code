extends TextureProgressBar

@export var player: Player

func _process(_delta: float) -> void:
	if !is_instance_valid(player): return

	value = (player.gravity_wall_cooldown.time_left / player.gravity_wall_cooldown.wait_time) * 100 
