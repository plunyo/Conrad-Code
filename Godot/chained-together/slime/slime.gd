extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var health_bar: TextureProgressBar = $HealthBar

@export var speed: float = 50.0
@export var health: float = 100.0

var player: CharacterBody2D = null
var direction: Vector2 = Vector2.ZERO

var stop_threshold: float = 10.0

func _ready() -> void:
	_G.Game_Lost.connect(_on_game_lost)

func _physics_process(delta: float) -> void:
	if player:
		move_toward_player(delta)

	if Input.is_action_just_pressed("instakill"): animation_player.play("Die")

func move_toward_player(delta: float) -> void:
	if !player: animation_player.play("Die"); return

	if player.global_position.distance_to(global_position) > stop_threshold:
		direction = (player.global_position - global_position).normalized()
	else:
		if attack_timer.is_stopped():
			attack_timer.start()
			player.hit(20)

	velocity = direction * speed
	move_and_slide()


func hit(amount: int) -> void:
	health -= amount

	var health_bar_tween: Tween = create_tween()
	health_bar_tween.tween_property(health_bar, "value", health, 0.2)

	if health <= 0: increment_score(1)
	animation_player.play("Die" if health <= 0 else "Hit")

func disable_scene_processing() -> void:
	get_tree().current_scene.process_mode = ProcessMode.PROCESS_MODE_DISABLED

func enable_scene_processing() -> void:
	get_tree().current_scene.process_mode = ProcessMode.PROCESS_MODE_INHERIT

func increment_score(increment: int) -> void:
	_G.Increment_Score(increment)

func _on_hit_stop_timer_timeout() -> void:
	enable_scene_processing()

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_game_lost() -> void:
	animation_player.play("Die")
