extends Control

@onready var audio_name_lbl = $HBoxContainer/Audio_Name_Lbl as Label
@onready var audio_num_lbl = $HBoxContainer/Audio_Num_Lbl as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "Sfx") var bus_name : String

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)

	set_name_label_text()

func set_name_label_text() -> void:
	audio_name_lbl.text = str(bus_name) + " Volume"

func set_audio_num_label_text() -> void:
	audio_num_lbl = str(h_slider.value * 100)

func on_value_changed(value : float) -> void:
	pass
