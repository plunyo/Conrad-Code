extends Control

@export var coins: int = 0
@onready var snack: Control = $"../Snack"

func _process(_delta: float) -> void:
	$Label.text = str(coins)
