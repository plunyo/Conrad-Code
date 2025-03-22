extends Control

enum CellType {
	MINE, EMPTY, FLAGGED
}

@onready var texture: TextureRect = $Texture

@export var type: CellType
@export var mine_count: int

func _ready() -> void:
	set_texture()

func set_texture() -> void:
	match type:
		CellType.MINE:
			texture.texture = load("res://assets/cell_" + str(mine_count) + ".png")
		CellType.EMPTY:
			texture.texture = load("res://assets/cell_empty.png")
		CellType.FLAGGED:
			texture.texture = load("res://assets/cell_flagged.png")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if type == CellType.EMPTY:
			print("clicked an empty cell")
		elif type == CellType.MINE:
			print("game over! hit a mine")
		elif type == CellType.FLAGGED:
			print("cell is flagged")
