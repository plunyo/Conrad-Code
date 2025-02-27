extends Sprite3D

@onready var active_cam: Camera3D = get_viewport().get_camera_3d()
@onready var parent_body: Node = get_parent()

@export var damage_animation_player: AnimationPlayer
@export var textures: Array[Texture2D]

@export_range(-180, 180) var rotation_offset: float

func _process(_delta: float) -> void:
	if damage_animation_player.current_animation == "Die": return

	var direction_to_camera: Vector3 = (global_position - active_cam.global_position).normalized()
	var angle_to_camera: float = atan2(direction_to_camera.x, direction_to_camera.z)
	var relative_y_rotation: float = angle_to_camera - parent_body.global_rotation.y + deg_to_rad(rotation_offset) + PI
	var rotation_fraction: float = relative_y_rotation / TAU + .5
	texture = textures[floori(rotation_fraction * textures.size()) % textures.size()]
