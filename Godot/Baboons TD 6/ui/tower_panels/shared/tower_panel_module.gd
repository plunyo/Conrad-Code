extends Node
class_name TowerPanelManager


@export var main_panel: Panel

@export_category("Tween")
@export var initial_scale: Vector2 = Vector2(0.8, 0.8)
@export var hover_scale: Vector2 = Vector2(1.0, 1.0)
@export var tween_duration: float = 0.2
@export_category("Tower")
@export var range_indicator: Panel
@export var tower_scene: PackedScene
@export var texture: Node
@export var placeability_indicator: Area2D
@export_category("Price")
@export var price_label: Label
@export var price: int = 100

var dragging = false
var temp_tower = null
var can_place = false

func _ready() -> void:
	main_panel.gui_input.connect(_on_gui_input)
	main_panel.mouse_entered.connect(_on_mouse_entered)
	main_panel.mouse_exited.connect(_on_mouse_exited)

	placeability_indicator.body_entered.connect(_on_can_place_indicator_body_entered)
	placeability_indicator.body_exited.connect(_on_can_place_indicator_body_exited)

	price_label.text = str(price)

func _on_mouse_entered():
	animate_texture_scale(hover_scale)

func _on_mouse_exited():
	if !dragging:
		animate_texture_scale(initial_scale)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			start_dragging(event.position)
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			stop_dragging(event.global_position)

	if dragging:
		update_drag_position(event.global_position)

func start_dragging(position: Vector2) -> void:
	if tower_scene == null: return
	if GameHandler.coins < price: return

	can_place = false

	animate_texture_scale(hover_scale)

	dragging = true
	texture.global_position = position
	placeability_indicator.visible = true

	if range_indicator:
		range_indicator.visible = true

func update_drag_position(position: Vector2) -> void:
	if texture:
		texture.global_position = position

func stop_dragging(pos: Vector2) -> void:
	dragging = false

	if can_place:
		temp_tower = tower_scene.instantiate()
		temp_tower.global_position = pos
		GameHandler.change_coins(-price, 0.3)
		get_tree().current_scene.get_node("Towers").add_child(temp_tower)

	texture.position = Vector2(28, 28)
	placeability_indicator.visible = false
	animate_texture_scale(initial_scale)

	if range_indicator:
		range_indicator.visible = false

func animate_texture_scale(target_scale: Vector2) -> void:
	if texture:
		var tween = create_tween()
		tween.tween_property(texture, "scale", target_scale, tween_duration)


func _on_can_place_indicator_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") or body.is_in_group("Path") or body.is_in_group("Tower"):
		can_place = false


func _on_can_place_indicator_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy") or body.is_in_group("Path") or body.is_in_group("Tower"):
		can_place = true
