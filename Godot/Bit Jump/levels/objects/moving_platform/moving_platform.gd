extends Path2D


@export var speed_scale: float = 1.0
@export var start_random: bool = true

@onready var follower: PathFollow2D = $Follower
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.speed_scale = speed_scale

	if start_random: play_animation_at_random_time("move")


func play_animation_at_random_time(animation_name: String):
	var animation_length = animation_player.get_animation(animation_name).length
	var random_time = randf() * animation_length
	animation_player.seek(random_time)
	animation_player.play(animation_name)
