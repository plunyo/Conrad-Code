extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

@export var word_container: FlowContainer

func _process(delta: float) -> void:
	modulate = Color("707070") if !timer.is_stopped() else Color.WHITE

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or \
	   (event is InputEventScreenTouch and timer.is_stopped()):
		animation_player.play("flip")
		timer.start()
		for fox in word_container.get_children():
			if fox.is_fox:
				fox.highlight()
