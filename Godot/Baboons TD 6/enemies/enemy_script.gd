extends CharacterBody2D


@export var speed: float = 250.0
@export var health: float = 100.0
@export var health_bar_anchor: Node2D
@export var health_bar: TextureProgressBar
@export var path_follow: PathFollow2D

@export_category("Money")
@export var kill_reward: float

var prev_health = health


func _ready() -> void:
	path_follow = get_parent()
	GameHandler.enemy_count += 1

func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	if path_follow.progress_ratio == 1:
		queue_free()

	handle_health()

func handle_health():
	if prev_health > health:
		health = clamp(health, 0, 100)
		tween_health()
		prev_health = health

	if health == 0:
		GameHandler.enemy_count -= 1
		GameHandler.change_coins(kill_reward, 0.4)
		if GameHandler.enemy_count == 0: GameHandler.wave += 1
		path_follow.queue_free()

	if health_bar_anchor: health_bar_anchor.rotation = -path_follow.rotation

func tween_health():
	var health_tween = create_tween()
	health_tween.set_trans(Tween.TRANS_BOUNCE)
	health_tween.tween_property(health_bar, "value", health, 0.4).set_ease(Tween.EASE_IN_OUT)
