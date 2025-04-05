extends Area2D

@onready var coin_noise = $CoinNoise

func _ready() -> void:
	coin_noise.pitch_scale = randf_range(0.5, 1.5)

func _on_body_entered(body: Node2D) -> void:
	visible = false
	set_deferred("monitoring", false)
	coin_noise.play()

	var coin_counter = get_tree().current_scene.find_child("CoinCounter")
	coin_counter.text = str(int(coin_counter.text) + 1)
 
func _on_coin_noise_finished() -> void:
	queue_free()
