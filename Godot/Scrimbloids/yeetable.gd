class_name Yeetable
extends RigidBody2D

const DRAG_FORCE: float = 500.0
const STOP_THRESHOLD: float = 200.0

var can_hold: bool = false

func _ready() -> void:
	mouse_entered.connect(func() -> void: can_hold = true)
	mouse_exited.connect(func() -> void: can_hold = false)

func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()

	if can_hold and Input.is_action_pressed("drag") and global_position.distance_to(mouse_pos) < STOP_THRESHOLD:
		var direction: Vector2 = mouse_pos - global_position
		var velocity: Vector2 = direction.normalized() * DRAG_FORCE
		apply_central_impulse(velocity)
