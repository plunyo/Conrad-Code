extends BaseWeaponState
class_name PistolState


@export var player: CharacterBody3D
@export var weapon_layer: CanvasLayer
@export var enemy_shape_cast: ShapeCast3D
@export var map_ray_cast: RayCast3D
@export var bullet_hole: PackedScene


func enter() -> void:
	weapon_layer.animation_player.play("PistolEquip")

func update(_delta) -> void:
	if Input.is_action_pressed("trigger"): shoot()

func shoot() -> void:
	if weapon_layer.animation_player.is_playing(): return

	weapon_layer.animation_player.play("PistolShoot")

	if enemy_shape_cast.is_colliding():
		var collider = enemy_shape_cast.get_collider(0)

		if collider.is_in_group("Enemy") and collider.has_method("hit"):
			collider.hit(50, player)

	if map_ray_cast.is_colliding():
		create_bullet_hole(map_ray_cast.get_collision_point(), map_ray_cast.get_collision_normal(), bullet_hole)
