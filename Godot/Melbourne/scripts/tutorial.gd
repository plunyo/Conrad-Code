extends Node2D

@onready var camera = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.limit_right = 17282
	General.curr_scene = "res://scenes/maps/tutorial.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
