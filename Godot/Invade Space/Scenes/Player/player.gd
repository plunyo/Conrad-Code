extends CharacterBody2D


const BULLET = preload("res://Scenes/Player/Bullet/bullet.tscn")

@onready var health_bar = %Ui/HealthBar
@onready var animated_sprite = $AnimatedSprite
@onready var animation_player = $AnimationPlayer
@onready var particle_queue = $Particles/ParticleQueue
@onready var explosion_particles = $Particles/ExplosionParticles
@onready var fire_particles = $Particles/FireParticles
@onready var aura_particles = $Particles/AuraParticles


var health = 100
var prev_health = health
var speed = 400.0

func _ready():
	animated_sprite.play("StartUp")
	await animated_sprite.animation_finished
	animated_sprite.play("Default")

func _process(delta):
	var direction = Input.get_action_strength("down") - Input.get_action_strength("up")
	if direction != 0:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, 10)

	move_and_slide()

	health_handler()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func health_handler():
	if prev_health > health:
		animation_player.play("hit")
		particle_queue.trigger()
		prev_health = health

		var tween = create_tween()
		tween.tween_property(health_bar, "value", health, 0.2)

	if health == 0:
		die()

func die():
	explosion_particles.emitting = true
	fire_particles.emitting = false
	aura_particles.emitting = false
	animated_sprite.visible = false

	await get_tree().create_timer(3).timeout

	SceneTransition.change_scene("res://Scenes/TitleScreen/title_screen.tscn")


func shoot():
	var instance = BULLET.instantiate()
	instance.position = global_position + Vector2(100, 0)
	get_tree().current_scene.add_child(instance)


func _on_explosion_particles_finished():
	queue_free()
