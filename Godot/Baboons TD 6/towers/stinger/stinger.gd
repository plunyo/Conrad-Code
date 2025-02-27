extends CharacterBody2D

@onready var ray: RayCast2D = $Ray
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var range_indicator: Panel = $RangeIndicator

@export var damage: int = 20

var detected_enemies: Array = []
var shoot_left = false

func _process(_delta: float) -> void:
	if get_first_enemy() != null:
		var enemy_position = get_first_enemy().global_position
		var direction = (enemy_position - global_position).angle()
		rotation = lerp_angle(rotation, direction + PI / 2, 0.1)

func get_first_enemy() -> CharacterBody2D:
	var first_enemy: CharacterBody2D = null
	var max_progress: float = -1.0

	for enemy in detected_enemies:
		var progress = enemy.get_parent().progress
		if progress > max_progress:
			max_progress = progress
			first_enemy = enemy

	return first_enemy

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Shootables"):
		detected_enemies.append(body)

func _on_detection_range_body_exited(body: Node2D) -> void:
	detected_enemies.erase(body)

func _on_shoot_timer_timeout() -> void:
	var first_enemy = get_first_enemy()
	if first_enemy != null:
		var target_position_local = to_local(first_enemy.global_position)
		ray.target_position = target_position_local
		first_enemy.health -= damage
		shoot_anim()

func shoot_anim():
	if animation_player.is_playing(): return

	if shoot_left:
		animation_player.play("LShoot")
	else:
		animation_player.play("RShoot")

	shoot_left = !shoot_left
