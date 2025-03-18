extends Node2D


@onready var animated_sprite = $AnimatedSprite

var speed = 900.0

func _ready():
	animated_sprite.play("default")

func _process(delta):
	position.x -= speed * delta


func _on_hit_range_body_entered(body):
	body.health -= 20
