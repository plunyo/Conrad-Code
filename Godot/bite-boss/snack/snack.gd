extends Control

enum SnackType {
	APPLE,
	BANANA
}

@onready var eat_cooldown_timer: Timer = $EatCooldown
@onready var snack_texture: TextureRect = $Texture

@export var eat_button: BaseButton
@export var snack_button: BaseButton
@export var food_button: OptionButton

@export var coin_counter: Control

@export_group("Snack")
@export var current_snack: SnackType

@export_subgroup("Textures")
@export var apple_textures: Array[Texture2D]
@export var banana_textures: Array[Texture2D]

var snack_textures: Dictionary = {}
var snack_int_map: Dictionary = {
	0: SnackType.APPLE,
	1: SnackType.BANANA
}
var bites_taken: int = 0
var is_snack_available: bool = false

func _ready() -> void:
	snack_textures[SnackType.APPLE] = apple_textures
	snack_textures[SnackType.BANANA] = banana_textures

	eat_button.disabled = true
	eat_button.pressed.connect(_on_eat_button)
	snack_button.pressed.connect(_on_snack_button)

func _on_eat_button() -> void:
	if eat_cooldown_timer.is_stopped() and is_snack_available:
		coin_counter.coins += 1
		update_snack_texture()
		eat_cooldown_timer.start()

func _on_snack_button() -> void:
	if not is_snack_available:
		create_snack()

func update_snack_texture():
	bites_taken += 1
	if bites_taken < snack_textures[current_snack].size():
		snack_texture.texture = snack_textures[current_snack][bites_taken % snack_textures[current_snack].size()]
	else:
		snack_texture.texture = null
		is_snack_available = false
		eat_button.disabled = true

func create_snack():
	bites_taken = 0
	snack_texture.texture = snack_textures[current_snack][bites_taken]
	is_snack_available = true
	eat_button.disabled = false

func _on_food_button_item_selected(index: int) -> void:
	current_snack = snack_int_map[index]
