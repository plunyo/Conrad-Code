extends Node2D

var winnnnn = false
var change_to = "res://scenes/menu.tscn"

@onready var doorL = $LeftDoorSide
@onready var doorR = $RightDoorSide
@onready var anims = $AnimationPlayer
@onready var level_complete_noise = $LevelCompleteNoise
@onready var player_walk_anims = $"../Player/AnimatedSprite2D"
@onready var player_door_anims = $"../Player/WalkInDoorAnims"
@onready var player = $"../Player"
@onready var input_prompts = $InputPrompts

# Called when the node enters the scene tree for the first time.
func _ready():
	doorL.play("close_left")
	doorR.play("close_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and winnnnn and player.is_on_floor():
		level_complete_noise.play()
		player.canMove = false
		player.position = Vector2(position.x, position.y + 100)
		player.gravity = 0
		player_walk_anims.play("walk_up")
		player_door_anims.play("walkindoow")

func _on_area_2d_body_entered(body):
	input_prompts.visible = true
	winnnnn = true

func _on_enter_area_body_exited(body):
	input_prompts.visible = false
	winnnnn = false

func _on_open_close_area_body_entered(body):
	doorL.play("open_left")
	doorR.play("open_right")
	await doorL.animation_finished
	await doorR.animation_finished
	doorL.frame = 6
	doorR.frame = 6


func _on_open_close_area_body_exited(body):
	doorL.play_backwards("open_left")
	doorR.play_backwards("open_right")
	await doorL.animation_finished
	await doorR.animation_finished
	doorL.frame = 6
	doorR.frame = 6


func _on_level_complete_noise_finished():
	SceneTransition.change_scene(change_to)
