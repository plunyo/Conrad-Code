extends CharacterBody2D


@export var current_state: States = States.IDLE

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var owp_top: ShapeCast2D = $OWPDetectors/Top
@onready var owp_bottom: ShapeCast2D = $OWPDetectors/Bottom

enum States { IDLE, RUNNING, JUMPING, CLIMBING, FALLING }

const SPEED = 400.0
const JUMP_VELOCITY = -850.0
const GRAVITY = 50.0
const CLIMB_SPEED = -200.0

var can_climb = false


func _physics_process(_delta: float) -> void:
	move_and_slide()
	handle_owps()

	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = direction * SPEED

	match current_state:
		States.IDLE:
			handle_idle_state(direction)
		States.RUNNING:
			handle_running_state(direction)
		States.JUMPING:
			handle_jumping_state()
		States.FALLING:
			handle_falling_state()
		States.CLIMBING:
			handle_climbing_state()

	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func handle_idle_state(direction: float) -> void:
	animation_player.play("idle")
	velocity.x = lerp(velocity.x, 0.0, 0.7)

	if direction != 0:
		change_state(States.RUNNING)
	elif !is_on_floor():
		change_state(States.FALLING)
	elif can_climb and Input.is_action_pressed("up"):
		change_state(States.CLIMBING)
	elif !can_climb and Input.is_action_just_pressed("up"):
		change_state(States.JUMPING)

func handle_running_state(direction: float) -> void:
	animation_player.play("walk")

	if !is_on_floor():
		change_state(States.FALLING)
	elif direction == 0:
		change_state(States.IDLE)
	elif can_climb and Input.is_action_pressed("up"):
		change_state(States.CLIMBING)
	elif !can_climb and Input.is_action_just_pressed("up"):
		change_state(States.JUMPING)

func handle_jumping_state() -> void:
	animation_player.play("jump")
	if !get_meta("can_leave"): velocity.y = JUMP_VELOCITY
	SoundMgr.sounds["player"]["jump"].play()

	if velocity.y < 0:
		change_state(States.FALLING)

func handle_falling_state() -> void:
	animation_player.play("jump")
	velocity.y += GRAVITY

	if can_climb and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		change_state(States.CLIMBING)
	elif is_on_floor():
		change_state(States.IDLE)

func handle_climbing_state() -> void:
	animation_player.play("climb")
	velocity.x = 0

	if Input.is_action_pressed("up"):
		velocity.y = CLIMB_SPEED
		animation_player.play()
	elif Input.is_action_pressed("down"):
		velocity.y = -CLIMB_SPEED
		animation_player.play()
	else:
		animation_player.pause()
		velocity.y = 0

	var direction = Input.get_axis("left", "right")

	if direction != 0 or is_on_floor():
		change_state(States.FALLING)

	if !can_climb:
		change_state(States.FALLING)

func change_state(new_state: States) -> void:
	current_state = new_state

func handle_owps():
	if owp_bottom.is_colliding(): set_collision_mask_value(5, true)
	if owp_top.is_colliding(): set_collision_mask_value(5, false)

	if Input.is_action_pressed("down"):
		if owp_bottom.is_colliding(): set_collision_mask_value(5, false)

func _on_off_screen_detector_screen_exited() -> void:
	SoundMgr.sounds["player"]["die"]
	SceneTransition.reload()

func _on_ladder_detector_body_entered(_body: Node2D) -> void: can_climb = true
func _on_ladder_detector_body_exited(_body: Node2D) -> void: can_climb = false
