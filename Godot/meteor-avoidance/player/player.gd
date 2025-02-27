extends CharacterBody2D
class_name Player

@export var gravity_wall_cooldown: Timer
@export var gravity_wall_scene: PackedScene
@export var broken_player_scene: PackedScene

func _ready() -> void:
	SoundMgr.sounds["rocket"].play()

func _process(_delta: float) -> void:
	if !gravity_wall_cooldown.is_stopped(): return

	if Input.is_action_just_pressed("right"): spawn_gravity_wall(Vector2(90, global_position.y + 60), -1)
	elif Input.is_action_just_pressed("left"): spawn_gravity_wall(Vector2(0, global_position.y + 60), 1)

func spawn_gravity_wall(pos: Vector2, direction: int) -> void:
	gravity_wall_cooldown.start()

	var t_gravity_wall: GravityWall = gravity_wall_scene.instantiate() as GravityWall

	t_gravity_wall.direction = direction
	t_gravity_wall.global_position = pos
	t_gravity_wall.player = self

	get_tree().current_scene.add_child(t_gravity_wall)

func die() -> void:
	var t_broken_player: Node2D = broken_player_scene.instantiate() as Node2D
	get_tree().current_scene.add_child(t_broken_player)
	t_broken_player.global_position = global_position
	queue_free()

func _on_tree_exiting() -> void:
	SoundMgr.sounds["rocket"].stop()
