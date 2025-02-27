class_name Player extends CharacterBody2D

const SPEED: float = 300.0
const ROT_SPEED: float = 2.5
const DECELERATION: float = 0.2
const HALF_PI: float = PI / 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_cooldown_timer: Timer = $BulletCooldownTimer
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var sprite: Sprite2D = $Sprite

@export_enum("red", "blue") var tank_colour: String = "red"
@export_enum("up", "w") var action_key: String = "w"
@export var bullet_scene: PackedScene

func _ready() -> void:
	sprite.texture = load("res://assets/tanks/tank_%s.png" % tank_colour)

func hit() -> void:
	animation_player.play("Hit")

func spawn_bullet() -> void:
	bullet_cooldown_timer.start()

	var bullet_instance: Area2D = bullet_scene.instantiate()
	bullet_instance.global_position = bullet_spawn_point.global_position
	bullet_instance.rotation = rotation
	get_parent().add_child(bullet_instance)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(action_key):
		velocity = Vector2.from_angle(rotation + HALF_PI) * SPEED
	else:
		velocity = velocity.lerp(Vector2.ZERO, DECELERATION)
		rotation += ROT_SPEED * delta

	if Input.is_action_just_pressed(action_key) and bullet_cooldown_timer.is_stopped():
		spawn_bullet()

	move_and_slide()
