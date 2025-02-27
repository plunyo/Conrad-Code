extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var unique_id: int

func _ready() -> void:
	if Main.is_coin_collected(unique_id):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Main.mark_coin(unique_id)
		animation_player.play("collect")
