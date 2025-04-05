extends CharacterBody2D

var gravity = 200
var speed = 500

var jump_velocity = -1800

func _physics_process(delta):
	velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_right"):
		velocity.x = speed

	move_and_slide()
