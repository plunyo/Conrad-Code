extends Node2D

@export var particle: PackedScene
@export var queue_count: int = 8

var index: int = 0

func _ready() -> void:
	for _i in range(queue_count):
		add_child(particle.instantiate())

func get_next_particle() -> Node:
	return get_child(index)

func trigger() -> void:
	var particle_instance = get_next_particle() as CPUParticles2D
	particle_instance.restart()
	index = (index + 1) % queue_count
