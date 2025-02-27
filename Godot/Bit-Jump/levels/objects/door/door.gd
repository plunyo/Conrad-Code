extends Area2D


@onready var sprite: Sprite2D = $Sprite

var can_leave: bool = false
var player: CharacterBody2D

func _on_open_range_body_entered(body: Node2D) -> void: if body.is_in_group("Player"): sprite.frame = 1
func _on_open_range_body_exited(body: Node2D) -> void: if body.is_in_group("Player"): sprite.frame = 0

func _on_body_entered(body: Node2D) -> void: if body.is_in_group("Player"): can_leave = true
func _on_body_exited(body: Node2D) -> void: if body.is_in_group("Player"): can_leave = false

func _process(_delta: float) -> void:
	if can_leave and Input.is_action_just_pressed("down"):
		SceneTransition.change_scene("res://menu/level_select/level_select.tscn")
