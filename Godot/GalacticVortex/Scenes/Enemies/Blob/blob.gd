extends CharacterBody2D

@export var target : Node2D
@export var tween_speed : float = 0.8
@export var stop_threshold : float = 2.0

@onready var dash_particles = $Particles/DashParticles
@onready var animated_sprite = $AnimatedSprite
@onready var projectile_sp = $ProjectileSP
@onready var detection_range = $DetectionRange
@onready var animation_player = $AnimationPlayer
@onready var particle_queue = $Particles/ParticleQueue


const BLOB_BULLET = preload("res://Scenes/Enemies/Blob/Projectile/blob_bullet.tscn")

var instance
var move_to_target : bool = false
var health = 100
var prev_health = health
var is_dead = false

func _ready():
	animated_sprite.play("Default")

func _process(delta):
	if not is_dead:
		health_handler()
		if animated_sprite.animation not in ["Hit", "Die"]:
			handle_movement_and_attack()

	if target and target.health == 0:
		target = null

func health_handler():
	if prev_health > health and not is_dead:
		animated_sprite.play("Hit")
		particle_queue.trigger()
		prev_health = health

	if health == 0:
		if not is_dead:
			is_dead = true
			animation_player.play("Die")
			await get_tree().create_timer(3).timeout
			SceneTransition.change_scene("res://Scenes/TitleScreen/title_screen.tscn")
		return

	health = clamp(health, 0, 100)

func handle_movement_and_attack():
	if move_to_target and target and detection_range.has_overlapping_bodies():
		var tween = create_tween()
		dash_particles.emitting = true
		tween.tween_property(self, "global_position:y", target.global_position.y, tween_speed)
		tween.finished.connect(_on_tween_finished)

		if abs(position.y - target.position.y) <= stop_threshold:
			move_to_target = false
			attack()

func attack():
	if not is_dead and animated_sprite.animation not in ["Hit", "Die"]:
		animated_sprite.play("Attack")
		instance = BLOB_BULLET.instantiate()
		instance.global_position = projectile_sp.global_position
		get_tree().current_scene.add_child(instance)

func _on_timer_timeout():
	if not is_dead and target:
		move_to_target = true

func _on_detection_range_body_entered(body):
	if not is_dead and body:
		target = body

func _on_tween_finished():
	if not is_dead:
		dash_particles.emitting = false

func _on_animated_sprite_animation_finished():
	if not is_dead and animated_sprite.animation != "Die":
		animated_sprite.play('Default')

func _on_animation_player_animation_finished(animation_name: String):
	if animation_name == "Die":
		queue_free()
