extends CharacterBody2D

const SPEED = 600
const JUMP_VELOCITY = -700.0
const SLAM_VELOCITY = 800.0

@onready var animations = $Animations
@onready var arms = $Arms
@onready var attack_range_l = $Arms/LeftArm/AttackRangeL
@onready var attack_range_r = $Arms/RightArm/AttackRangeR
@onready var left_arm = $Arms/LeftArm
@onready var right_arm = $Arms/RightArm
@onready var top_tap_range = $VerticalDamage/TopTapRange
@onready var ground_pound = $VerticalDamage/GroundPound

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attack_range_l_enemys = []
var attack_range_r_enemys = []

# READY
func _ready():
	pass

# PROCESS
func _physics_process(delta):
	handle_movement(delta)
	handle_attacks()

# MOVEMENT
func handle_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# ATTACKS
func handle_attacks():
	if Input.is_action_pressed("left_punch") and !Input.is_action_pressed("right_punch"):
		punch("left")
	if Input.is_action_pressed("right_punch") and !Input.is_action_pressed("left_punch"):
		punch("right")
	if Input.is_action_pressed("left_punch") and Input.is_action_pressed("right_punch"):
		punch("up")
	if Input.is_action_just_pressed("floor_slam") and !is_on_floor():
		punch("down")

	vert_damage()

func punch(side):
	if side == "left":
		arms.rotation = deg_to_rad(0)
		if animations.current_animation != "LeftAttack" and animations.current_animation != "TopTap":
			animations.play("LeftAttack")
			for enemy in attack_range_l.get_overlapping_bodies():
				if enemy.is_in_group("Enemy"):
					enemy.health -= 1
	elif side == "right":
		arms.rotation = deg_to_rad(0)
		if animations.current_animation != "RightAttack" and animations.current_animation != "TopTap":
			animations.play("RightAttack")
			for enemy in attack_range_r.get_overlapping_bodies():
				if enemy.is_in_group("Enemy"):
					enemy.health -= 1
	elif side == "up":
		arms.rotation = deg_to_rad(0)
		if animations.current_animation != "TopTap":
			animations.play("TopTap")
	elif side == "down":
		arms.rotation = deg_to_rad(180)
		velocity.y = SLAM_VELOCITY
		if animations.current_animation != "TopTap":
			animations.play("TopTap")

func vert_damage():
	if animations.current_animation != "TopTap" and arms.rotation == deg_to_rad(180) and is_on_floor():
		print(ground_pound.get_overlapping_bodies())
		for enemy in ground_pound.get_overlapping_bodies():
				if enemy.is_in_group("Enemy"):
					enemy.health -= 1
	elif animations.current_animation != "TopTap" and arms.rotation == deg_to_rad(0):
		print(ground_pound.get_overlapping_bodies())
		for enemy in ground_pound.get_overlapping_bodies():
				if enemy.is_in_group("Enemy"):
					enemy.health -= 1
