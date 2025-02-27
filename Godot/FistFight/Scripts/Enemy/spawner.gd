extends Node2D

var enemy = preload("res://Scenes/Enemy/enemy.tscn")  # Use preload to load the resource at compile-time

var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()  # Start the timer if not started already

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	instance = enemy.instantiate()
	add_child(instance)
