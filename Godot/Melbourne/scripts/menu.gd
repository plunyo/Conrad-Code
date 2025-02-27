extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartGame as Button
@onready var settings_button = $MarginContainer/HBoxContainer/VBoxContainer/Settings as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitGame as Button


@onready var settings_menu = $SettingsMenu as OptionsMenu
@onready var margin_container = $MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	General.curr_scene = "res://scenes/menu/menu.tscn"
	connect_signals()

func on_start_pressed() -> void:
	SceneTransition.change_scene("res://scenes/maps/tutorial.tscn")

func on_exit_button_up() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true
	settings_menu.visible = false

func on_settings_pressed() -> void:
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true

func connect_signals():
	start_button.button_down.connect(on_start_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	exit_button.button_down.connect(on_exit_button_up)
	settings_menu.exit_button.button_down.connect(on_exit_options_menu)
