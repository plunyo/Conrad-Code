extends Area2D

const SPEED: float = 1000.0

@export var explosion_scene: PackedScene

func spawn_explosion() -> void:
	var explosion_instance: Node2D = explosion_scene.instantiate() as Node2D
	explosion_instance.global_position = global_position
	get_tree().current_scene.add_child(explosion_instance)

func _physics_process(delta: float) -> void:
	global_position += Vector2.from_angle(rotation + PI / 2).normalized() * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body as Player
		player.hit()
		spawn_explosion()
		queue_free()
