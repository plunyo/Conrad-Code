extends Label

@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	text = "Time Left: " + str(int(timer.time_left))
