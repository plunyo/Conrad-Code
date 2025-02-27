extends Area2D

@onready var sprite: Sprite2D = $Sprite

@export var rot_speed: float = 2.0
@export var meteor_variations: Array[Texture2D]

func _ready() -> void:
	sprite.texture = meteor_variations.pick_random()

func _process(delta: float) -> void:
	rotation += rot_speed * delta
	global_position.y -= (Settings.spaceship_speed * 2) * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("die"):
		body.die()

func _on_on_screen_notifier_screen_exited() -> void:
	if Settings.game_lost: return
	Settings.score += 1
	queue_free()
