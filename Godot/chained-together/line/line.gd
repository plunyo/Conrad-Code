extends Node2D

@onready var line: Line2D = $Line
@onready var hit_detector: Area2D = $HitDetector

@export var player1: CharacterBody2D
@export var player2: CharacterBody2D

var segment: SegmentShape2D  # Use a single segment instead of an array
var player1_alive: bool = true
var player2_alive: bool = true

func _ready() -> void:
	# Initialize the single segment and collider
	var t_collider: CollisionShape2D = CollisionShape2D.new()
	segment = SegmentShape2D.new()
	t_collider.shape = segment
	hit_detector.add_child(t_collider)

	# Set initial positions of the line points
	if player1:
		line.add_point(player1.global_position)
	if player2:
		line.add_point(player2.global_position)

func _process(delta: float) -> void:
	# Check if players are still alive (using null checks)
	if player1 == null:
		player1_alive = false
	if player2 == null:
		player2_alive = false

	# Check if both players are dead
	if !player1_alive and !player2_alive:
		_G.Lose()
		queue_free()
		return

	# Update line points for alive players
	if player1_alive:
		line.points[0] = player1.global_position
	else:
		line.points[0] = to_local(line.points[0])  # Keep the last position for player 1

	if player2_alive:
		line.points[1] = player2.global_position
	else:
		line.points[1] = to_local(line.points[1])  # Keep the last position for player 2

	# Update segment shape between the two players
	if player1_alive and player2_alive:
		segment.a = to_local(player1.global_position)
		segment.b = to_local(player2.global_position)
	elif player1_alive:
		segment.a = to_local(player1.global_position)
	elif player2_alive:
		segment.b = to_local(player2.global_position)

func _on_hit_detector_body_entered(body: Node2D) -> void:
	# Only deal damage if both players are alive
	if body.is_in_group("Enemy"):
		body.hit(40)

# Call this function when a player dies
func on_player_death(player: CharacterBody2D) -> void:
	if player == player1:
		player1_alive = false
		player1 = null  # Remove reference to the player1 node
	elif player == player2:
		player2_alive = false
		player2 = null  # Remove reference to the player2 node
