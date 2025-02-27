extends Node2D


@onready var particle_queue = $StartButton/ParticleQueue

func _on_start_button_area_entered(area):
	SceneTransition.change_scene("res://Scenes/Map/space_place.tscn")
	particle_queue.trigger()
