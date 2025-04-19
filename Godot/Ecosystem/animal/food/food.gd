class_name Food
extends Area2D

signal consumed

@export var restore_amount: float = 5.0
@export var claimed: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Prey:
		var prey: Prey = body as Prey
		prey.hunger += restore_amount + randf_range(-2, 2)
		prey.reproductive_urge = min(prey.reproductive_urge + randf_range(10.0, 20.0), 100.0)
		prey.update_info()
		consumed.emit()
