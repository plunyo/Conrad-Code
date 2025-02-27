extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	label.text = str(_G.Score)

	_G.Score_Changed.connect(func(Score: int) -> void:
		label.text = str(_G.Score)
		)
