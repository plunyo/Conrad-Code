extends Camera2D

# --- constants ---
const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 20.0

# --- exported vars ---
@export var zoom_speed: float
@export var pan_speed: float

# --- physics process ---
func _physics_process(delta: float) -> void:
	# --- zooming ---
	if Input.is_action_just_pressed("zoom_in"):
		zoom.x = clamp(zoom.x - zoom_speed, MIN_ZOOM, MAX_ZOOM)
		zoom.y = clamp(zoom.y - zoom_speed, MIN_ZOOM, MAX_ZOOM)

	if Input.is_action_just_pressed("zoom_out"):
		zoom.x = clamp(zoom.x + zoom_speed, MIN_ZOOM, MAX_ZOOM)
		zoom.y = clamp(zoom.y + zoom_speed, MIN_ZOOM, MAX_ZOOM)

	# --- panning ---
	var zoom_factor: float = 1.0 / (zoom.x + zoom.y) / 2
	var pan_direction: Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down").normalized()

	global_position = global_position.lerp(
		global_position + pan_direction * zoom_factor * pan_speed * delta,
		0.1
	)
