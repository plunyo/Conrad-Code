extends CharacterBody2D

@onready var ray: RayCast2D = $Ray
@onready var sniper: ColorRect = $Texture/Sniper
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var range_indicator: Panel = $RangeIndicator

@export var damage: int = 50

var detected_enemies: Array = []

func _ready() -> void:
	var initialization_tween = create_tween()

	initialization_tween.tween_property(sniper, "size", Vector2(10, 40), 0.7)

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
		ray.target_position = first_enemy.position
		animation_player.play("Shoot")
		first_enemy.health -= damage
