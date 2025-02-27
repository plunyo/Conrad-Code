extends BaseState
class_name BaseWeaponState


enum Weapon { PISTOL, SHOTGUN }

func create_bullet_hole(collision_point: Vector3, collision_normal: Vector3, bullet_hole: PackedScene) -> void:
	var t_bullet_hole: Sprite3D = bullet_hole.instantiate()
	get_tree().current_scene.add_child(t_bullet_hole)

	var offset = 0.01
	t_bullet_hole.global_position = collision_point + collision_normal * offset

	var up_vector = Vector3.UP
	if collision_normal.is_equal_approx(Vector3.UP) or collision_normal.is_equal_approx(Vector3.DOWN):
		up_vector = Vector3.FORWARD

	t_bullet_hole.look_at_from_position(t_bullet_hole.global_position, t_bullet_hole.global_position + collision_normal, up_vector)
