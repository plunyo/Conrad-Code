extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var health_bar = $HealthBar
@onready var animations = $Animations
@onready var blood = $Blood
@onready var tee = $Tee

var health = 3
var prev_health = health
var max_health = 3
var target

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	handles_movement(delta)
	handles_health()

# Movement
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func handles_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0 # Reset vertical velocity when on the floor

	if target:
		move_towards_target(delta)

	move_and_slide()

func handles_health():
	if prev_health > health:
		blood.emitting = true
		animations.play("hit")
		prev_health = health

	if health <= 0:
		queue_free()

func move_towards_target(delta):
	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED

func _on_detection_range_body_entered(body):
	if body.is_in_group("Player"):
		target = body

func _on_detection_range_body_exited(body):
	if body == target:
		target = null
