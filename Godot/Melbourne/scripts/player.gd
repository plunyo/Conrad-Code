extends CharacterBody2D

class_name Player

const JUMP_VELOCITY = -1000.0
const MAX_ZOOM = 1.4
const MIN_ZOOM = 0.4
const SPRINT_SPEED = 900.0
const WALK_SPEED = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1800.0
var isMoving = false
var isSprinting = false
var zoom = 0.5
var canMove = true
var curr_anim = "" # Initialize curr_anim with an empty string
var speed
var health = 100

@onready var walk_anims = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var jump_sound = $JumpSound
@onready var health_bar = $"../UI/HealthBar"
@onready var game_over_noise = $GameOverNoise
@onready var walk_in_door_anims = $WalkInDoorAnims

func _physics_process(delta):
	if canMove:
		if Input.is_action_pressed("walk_left"):
			walk_anims.play("walk_left", isSprinting)
			isMoving = true
			curr_anim = "walk_left"
		elif Input.is_action_pressed("walk_right"):
			walk_anims.play("walk_right", isSprinting)
			isMoving = true
			curr_anim = "walk_right"
		else:
			if not is_on_floor():
				walk_anims.frame = 1
			else:
				walk_anims.frame = 0

	if Input.is_action_pressed("sprint"):
		isSprinting = 2.5
		speed = SPRINT_SPEED
	else:
		isSprinting = 1.0
		speed = WALK_SPEED

	if Input.is_action_just_pressed("reset_position"):
		SceneTransition.change_scene(General.curr_scene)

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 2

	# Handle jump.
	if canMove:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sound.play()

	if Input.is_action_pressed("zoom_in"):
		zoom += 0.01
	elif Input.is_action_pressed("zoom_out"):
		zoom -= 0.01

	zoom = clamp(zoom, 0.3, 1.6)

	camera.zoom = Vector2(zoom, zoom)

	health_bar.value = health
	health = clamp(health, 0, 100)

	if health <= 0:
		game_over_noise.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if canMove:
		var direction = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
		velocity.x = direction * speed

	move_and_slide()

func _on_game_over_noise_finished():
	SceneTransition.change_scene("res://scenes/ui/game_over.tscn")
