extends CharacterBody2D

enum BodyPart { HEAD, LEGS, ARMS, BODY }

const SPEED: float = 75.0
const JUMP_VELOCITY: float = -200.0

@onready var anim_tree: AnimationTree = $AnimTree

@onready var sprites: Dictionary = {
	BodyPart.HEAD: ($Sprites/RobotHead as Sprite2D),
	BodyPart.BODY: ($Sprites/RobotBody as Sprite2D),
	BodyPart.LEGS: ($Sprites/Legs as AnimatedSprite2D),
	BodyPart.ARMS: ($Sprites/Arms as AnimatedSprite2D)
}

func _physics_process(delta: float) -> void:
	# gravityyy
	if not is_on_floor():
		velocity += get_gravity() * delta

	# movement
	var direction: int = Input.get_axis("left", "right")

	if direction == -1:
		scale.x = direction
	elif direction == 1:
		scale.x = direction

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 3.0 * delta)

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# animation
	anim_tree.set("parameters/blend_position", abs(direction))

	move_and_slide()
