extends BaseWeaponState
class_name ShotgunState


@export var player: CharacterBody3D
@export var weapon_layer: CanvasLayer
@export var shotgun_raycast: RayCast3D
@export var bullet_hole: PackedScene
@export var spread: float = 0.5
@export var pellets: int = 7

func enter() -> void:
	weapon_layer.animation_player.play("ShotgunEquip")

func update(_delta) -> void:
	if Input.is_action_just_pressed("trigger"): shoot()

func shoot() -> void:
	if weapon_layer.animation_player.is_playing(): return

	weapon_layer.animation_player.play("ShotgunShoot")

	for i in range(pellets):
		shotgun_raycast.target_position.y = randf_range(-spread, spread)
		shotgun_raycast.target_position.x = randf_range(-spread, spread)

		shotgun_raycast.force_raycast_update()

		if shotgun_raycast.is_colliding():
			var collider: Node3D = shotgun_raycast.get_collider()

			if collider.is_in_group("Enemy") and collider.has_method("hit"):
				collider.hit(35, player)
			else:
				create_bullet_hole(shotgun_raycast.get_collision_point(), shotgun_raycast.get_collision_normal(), bullet_hole)
