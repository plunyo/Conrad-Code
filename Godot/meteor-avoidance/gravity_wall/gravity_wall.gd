extends Node2D
class_name GravityWall

@onready var player_point: Marker2D = $PlayerPoint
@onready var sprite: Sprite2D = $Sprite

@export var player: CharacterBody2D
@export var direction: int = -1

func _ready() -> void:
	sprite.flip_h = direction == 1
	sprite.position.x = 8 if direction == 1 else -8

	player_point.position.x = 28 if direction == 1 else -28

	var player_tween = create_tween()
	player_tween.set_ease(Tween.EASE_IN_OUT)
	player_tween.set_trans(Tween.TRANS_QUAD)
	player_tween.tween_property(player, "global_position:x", player_point.global_position.x, .75)

func _process(delta: float) -> void:
	global_position.y -= Settings.spaceship_speed * delta

func _on_on_screen_notifier_screen_exited() -> void:
	queue_free()
