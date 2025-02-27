extends Camera2D

# Variables for zooming
var zoom_speed: float = 0.1
var min_zoom: float = 1.0
var max_zoom: float = 5.0

# Variables for panning
var is_panning: bool = false
var last_mouse_position: Vector2

func _ready():
	# Set initial zoom
	zoom = Vector2(1, 1)

func _input(event):
	if SceneTransition.is_blindfolded:
		return  # Skip input handling if holding a blindfold

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_panning = true
				last_mouse_position = event.position
			else:
				is_panning = false

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_camera(get_global_mouse_position(), -zoom_speed)

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_camera(get_global_mouse_position(), zoom_speed)

	if event is InputEventMouseMotion and is_panning:
		var mouse_delta = event.position - last_mouse_position
		position -= mouse_delta / zoom  # Adjust position based on zoom
		last_mouse_position = event.position

	if event is InputEventScreenTouch:
		if event.pressed:
			is_panning = true
			last_mouse_position = event.position
		else:
			is_panning = false

	if event is InputEventScreenDrag and is_panning:
		var touch_delta = event.position - last_mouse_position
		position -= touch_delta / zoom  # Adjust position based on zoom
		last_mouse_position = event.position

func _zoom_camera(global_mouse_pos: Vector2, zoom_change: float):
	# Convert global mouse position to local coordinates
	var mouse_pos_in_camera = global_mouse_pos - global_position

	# Adjust zoom level
	zoom += Vector2(zoom_change, zoom_change)
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)

	# Convert mouse position to local coordinates after zoom change
	var mouse_pos_after_zoom = mouse_pos_in_camera / zoom

	# Adjust camera position to keep the mouse position in the same place
	position += (mouse_pos_in_camera - mouse_pos_after_zoom) * zoom
