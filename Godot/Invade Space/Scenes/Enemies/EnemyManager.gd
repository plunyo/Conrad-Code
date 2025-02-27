extends Node

const BLOB = preload("res://Scenes/Enemies/Blob/blob.tscn")

var boss_fighting_pos = Vector2(1011, 324)
var boss_spawn_pos = Vector2(1360, 324)

var instance

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	spawn_blob()

func tween_to_fighting_position(node: Node2D):
	node.global_position = boss_spawn_pos

	var tween = create_tween()
	tween.tween_property(node, "global_position", boss_fighting_pos, 0.8)

func spawn_blob():
	instance = BLOB.instantiate()
	get_parent().add_child.call_deferred(instance)
	tween_to_fighting_position(instance)
