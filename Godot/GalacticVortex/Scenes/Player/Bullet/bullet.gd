extends Node2D


var speed = 1000.0

func _process(delta):
	position.x += speed * delta

func _on_os_notifier_screen_exited():
	queue_free()

func _on_hit_range_body_entered(body):
	if body.is_in_group("Blob"):
		if body.animated_sprite.animation != "Hit":
			body.health -= 5
			queue_free()

func _on_hit_range_area_entered(area):
	queue_free()
