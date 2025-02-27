extends CharacterBody3D

signal died

@export var health: int = 100

@onready var damage_animation_player: AnimationPlayer = $DamageAnimationPlayer
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var hit_sound: AudioStreamPlayer3D = $HitSound
@onready var walk_animation_player: AnimationPlayer = $WalkAnimationPlayer
@onready var player_cast: RayCast3D = $DetectionRange/PlayerCast

const SPEED: float = 3.0
const ACCELARATION: float = 10.0
const ROTATION_SPEED: float = 5.0

var player: CharacterBody3D
var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta

	if damage_animation_player.current_animation != "Die": move_and_slide()

	if player and !player_cast.is_colliding():
		look_at_player(delta)

		navigation_agent.target_position = player.global_position
		direction = (navigation_agent.get_next_path_position() - global_position).normalized()

		velocity = velocity.lerp(direction * SPEED, ACCELARATION * delta)

func look_at_player(delta):
	var current_forward = -transform.basis.z
	var target_direction = (player.global_position - global_position).normalized()
	var new_direction = current_forward.slerp(target_direction, ROTATION_SPEED * delta)

	look_at(global_position + new_direction, Vector3.UP)

func hit(damage: int, target: CharacterBody3D = null):
	player = target

	health -= damage

	if health > 0:
		damage_animation_player.stop()
		damage_animation_player.play("Hit")
	else:
		damage_animation_player.play("Die")
		emit_signal("died")


func _on_detection_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_detection_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"): player = null

func _on_hit_timer_timeout():
	if player and player.has_method("hit"):
		player.hit()
