extends Node2D

const UMBRELLA_GRAVITY = 800.0
const NORMAL_GRAVITY = 1800.0
const REGEN_DELAY_TICKS = 50  # Number of ticks to wait before regenerating

@onready var player = $"../Player"
@onready var umbrella_anims = $AnimatedSprite2D
@onready var umbrella_indicator = $"../UI/Hotbar2/ColorRect"
@onready var umbrella_shrink_anims = $AnimationPlayer
@onready var equipt_prompt = $EquiptPrompt
@onready var umbrella_bar = $"../UI/UmbrellaBattery"
@onready var umbrella_timer = $Timer

var speed = 1000

var umbrella_out = true
var umbrella_equippable = false
var umbrella_equipped = false
var umbrella_battery = 100
var regen_counter = REGEN_DELAY_TICKS  # Counter to track ticks for regeneration

# Called when the node enters the scene tree for the first time.
func _ready():
	equipt_prompt.visible = false
	umbrella_indicator.color = Color(1, 0, 0)
	umbrella_out = false
	umbrella_shrink_anims.play("umbrella_shrink")
	await umbrella_shrink_anims.animation_finished
	position = Vector2(10000000, 10000000)
	visible = false
	umbrella_indicator.color = Color(1, 0, 0)
	umbrella_timer.start() # Start the timer

func handles_umbrella():
	if Input.is_action_just_pressed("umbrella_away"):
		umbrella_equipped = false
		if not umbrella_out and umbrella_battery > 0:
			position = player.position
			visible = true
			umbrella_shrink_anims.play("umbrella_unshrink")
			umbrella_indicator.color = Color(0, 0, 1)
			await umbrella_shrink_anims.animation_finished
			umbrella_out = true
		else:
			umbrella_shrink_anims.play("umbrella_shrink")
			await umbrella_shrink_anims.animation_finished
			umbrella_out = false
			position = Vector2(10000000, 10000000)
			visible = false
			umbrella_indicator.color = Color(1, 0, 0)
			player.gravity = NORMAL_GRAVITY

func handles_umbrella_equip():
	if umbrella_equippable and Input.is_action_just_pressed("umbrella_equip"):
		umbrella_equipped = !umbrella_equipped
		if umbrella_equipped:
			umbrella_indicator.color = Color(0, 1, 0)
			player.gravity = UMBRELLA_GRAVITY
		else:
			player.gravity = NORMAL_GRAVITY
			if umbrella_out == true:
				umbrella_indicator.color = Color(0, 0, 1)
			else:
				umbrella_indicator.color = Color(1, 0, 0)

	if umbrella_equipped:
		position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_position = player.position
	var distance = 5  # Distance to maintain from the player
	var direction = (position - player.position).normalized()
	var vertical_speed_multiplier = 5.0  # Speed multiplier for vertical movement
	var lerp_factor = 0.01

	# Check if the umbrella is moving vertically
	if abs(direction.y) > abs(direction.x):
		lerp_factor *= vertical_speed_multiplier

	if Input.is_action_pressed("umbrella_left") and !umbrella_equipped:
		umbrella_anims.play("sway_left")
		position.x -= speed * delta
	elif Input.is_action_pressed("umbrella_right") and !umbrella_equipped:
		umbrella_anims.play("sway_right")
		position.x += speed * delta
	else:
		umbrella_anims.play("still")

	handles_umbrella()
	handles_umbrella_equip()

	position = position.lerp(target_position + direction * distance, lerp_factor)

func _on_area_2d_body_entered(_body):
	equipt_prompt.visible = true
	umbrella_equippable = true

func _on_area_2d_body_exited(body):
	equipt_prompt.visible = false
	umbrella_equippable = false

func _on_timer_timeout():
	if umbrella_out:
		umbrella_battery -= 1
		if umbrella_battery <= 0:
			umbrella_equipped = false
			umbrella_battery = 0
			umbrella_shrink_anims.play("umbrella_shrink")
			await umbrella_shrink_anims.animation_finished
			umbrella_out = false
			position = Vector2(10000000, 10000000)
			visible = false
			umbrella_indicator.color = Color(1, 0, 0)
			player.gravity = NORMAL_GRAVITY
			regen_counter = REGEN_DELAY_TICKS  # Reset the regen counter
	else:
		if regen_counter > 0:
			regen_counter -= 1
		else:
			umbrella_battery += 0.5

	umbrella_battery = clamp(umbrella_battery, 0, 100)
	umbrella_bar.value = umbrella_battery
