extends CharacterBody2D

@export var color: Color
@export var speed: float = 100

@export var health: int = 100:
	set = set_health

@export_category("Movement Inputs")
@export var up_input: StringName
@export var down_input: StringName
@export var left_input: StringName
@export var right_input: StringName

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	animated_sprite.modulate = color

func set_health(value: int) -> void:
	health = clamp(value, 0, 100)

	var health_bar_tween: Tween = create_tween()
	health_bar_tween.tween_property(health_bar, "value", health, 0.2)

func hit(amount: int) -> void:
	health -= amount

	if health <= 0:
		animation_player.play("die")

func _physics_process(delta: float) -> void:
	if !up_input or !down_input or !left_input or !right_input: return

	direction = Input.get_vector(left_input, right_input, up_input, down_input).normalized()

	animated_sprite.play("Run" if direction != Vector2.ZERO else "Idle")
	if direction.x != 0: animated_sprite.flip_h = velocity.x < 0

	velocity = direction * speed if direction != Vector2.ZERO else velocity.lerp(Vector2.ZERO, 10.0 * delta)

	move_and_slide()
