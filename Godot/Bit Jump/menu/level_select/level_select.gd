extends MarginContainer

@onready var selectors: Array[Label] = [
	$CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
	$CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector,
	$CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/Selector
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
			SceneTransition.change_scene("res://levels/level_1.tscn")
		1:
			SceneTransition.change_scene("res://levels/level_2.tscn")
		2:
			SceneTransition.change_scene("res://levels/level_3.tscn")
		3:
			SceneTransition.change_scene("res://menu/main_menu.tscn")

func set_current_selection(selection: int):
	for i in range(selectors.size()):
		SoundMgr.sounds["ui"]["select"]
		selectors[i].text = (">" if i == selection else "")
