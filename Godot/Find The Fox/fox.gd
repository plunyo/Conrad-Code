extends Control

@onready var label: Label = $Label
@onready var background: Panel = $Background

@export var is_fox: bool

func _ready() -> void:
	shuffle_letters()
	if label.text == "FOX": is_fox = true

func shuffle_letters() -> void:
	var original_string: String = label.text
	var char_array: Array = original_string.split("")
	char_array.shuffle()
	label.text = "".join(char_array)

func _on_button_pressed() -> void:
	if label.text == "FOX":
		Global.score += 1
		queue_free()

func highlight() -> void:
	$AnimationPlayer.play("flash")
