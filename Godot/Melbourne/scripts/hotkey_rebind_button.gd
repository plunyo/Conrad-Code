class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "move_left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"

	match action_name:
		"walk_left":
			label.text = "Move Left"
		"walk_right":
			label.text = "Move Right"
		"jump":
			label.text = "Jump"
		"exit":
			label.text = "Escape To Menu"
		"sprint":
			label.text = "Sprint"
		"reset_position":
			label.text = "Restart"
		"umbrella_left":
			label.text = "Umbrella Left"
		"umbrella_right":
			label.text = "Umbrella Right"
		"umbrella_away":
			label.text = "Spawn Umbrella"
		"umbrella_equip":
			label.text = "Equip Umbrella"
		"save":
			label.text = "Save Game"
		"load":
			label.text = "Load Game"
		"zoom_in":
			label.text = "Zoom In"
		"zoom_out":
			label.text = "Zoom Out"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var action_event = action_events[0]
		if action_event is InputEventKey:
			var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
			button.text = "%s" % action_keycode
		else:
			button.text = "Unknown Key"
	else:
		button.text = "No Key Assigned"


func _on_button_toggled(button_pressed):
	pass

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.pressed = false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
