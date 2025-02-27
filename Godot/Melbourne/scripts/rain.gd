extends Node2D

var player_in = false
var rain_sky = false

@onready var player = $"../../Player"
@onready var umbrella = $"../../Umbrella"
@onready var timer = $Timer
@onready var damage_noise = $DamageNoise
@onready var sky_anims = $"../../Sky/Changes"

func _on_damage_area_body_entered(body):
	if body == player:
		player_in = true

func _on_damage_area_body_exited(body):
	if body == player:
		player_in = false

func _on_timer_timeout():
	if player_in and not umbrella.umbrella_equipped:
		player.health -= 5
		damage_noise.play()

func _on_sky_change_body_entered(body):
	if body == player:
		General.rain_count += 1
		if General.rain_count == 1:
			sky_anims.play("RainSeen")

func _on_sky_change_body_exited(body):
	if body == player:
		General.rain_count -= 1
		if General.rain_count == 0:
			sky_anims.play("RainAway")
