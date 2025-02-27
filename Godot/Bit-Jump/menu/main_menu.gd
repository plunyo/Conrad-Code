extends MarginContainer

@onready var selectors: Array = [
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
]

var current_selection = 0


func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		current_selection = (current_selection + 1) % selectors.size()
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up"):
		current_selection = (current_selection - 1 + selectors.size()) % selectors.size()
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func handle_selection(selection: int):
	SoundMgr.sounds["ui"]["select"].play()

	match selection:
		0:
			SceneTransition.change_scene("res://menu/level_select/level_select.tscn")
		1:
			SceneTransition.change_scene("res://menu/how_to_play/how_to_play.tscn")

func set_current_selection(selection: int):
	for i in range(selectors.size()):

		selectors[i].text = (">" if i == selection else "")
