extends RichTextLabel

@export var hover_height: float = 5.0
@export var hover_speed: float = 2.0

var original_y: float = 121.0

func _process(delta: float) -> void:
	position.y = lerp(position.y, original_y + sin(Time.get_ticks_msec() * hover_speed / 1000.0) * hover_height, 0.5)
