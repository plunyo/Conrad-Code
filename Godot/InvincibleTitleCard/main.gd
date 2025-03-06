extends Control

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		if video_stream_player.is_playing():
			video_stream_player.stop()
		else:
			video_stream_player.play()
