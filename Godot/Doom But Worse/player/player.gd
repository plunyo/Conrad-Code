extends CharacterBody3D
class_name Player

@onready var camera = $Camera
@onready var weapon_layer: CanvasLayer = $WeaponLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health: int = 100

const SPEED = 7.0
const JUMP_VELOCITY = 4.5
const DECELERATION = 5.0
const AIR_DECELERATION = 4.0

const SENSITIVITY = 0.004
const ZOOM_SENSITIVITY = 0.001

var is_ads = false
var mouse_visible: bool

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera/MapRayCast.add_exception(self)

func _physics_process(delta):
	if not is_on_floor(): velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * DECELERATION)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * DECELERATION)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * AIR_DECELERATION)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * AIR_DECELERATION)

	move_and_slide()

	_handle_controller_look(delta)

	if Input.is_action_just_pressed("restart"): get_tree().reload_current_scene()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		mouse_visible = not mouse_visible

		if mouse_visible: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.is_action_just_pressed("ads"):
		animation_player.play("ads")
		is_ads = true
	elif Input.is_action_just_released("ads"):
		animation_player.play_backwards("ads")
		is_ads = false

	if event is InputEventMouseMotion:
		var current_sensitivity = ZOOM_SENSITIVITY if is_zoomed else SENSITIVITY
		rotate_y(-event.relative.x * current_sensitivity)
		camera.rotate_x(-event.relative.y * current_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _handle_controller_look(_delta):
	var current_sensitivity = ZOOM_SENSITIVITY * 10 if is_zoomed else SENSITIVITY * 10

	var look_x = Input.get_axis("look_left", "look_right")
	var look_y = Input.get_axis("look_up", "look_down")

	if abs(look_x) > 0.1:
		rotate_y(-look_x * current_sensitivity)

	if abs(look_y) > 0.1:
		camera.rotate_x(-look_y * current_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
