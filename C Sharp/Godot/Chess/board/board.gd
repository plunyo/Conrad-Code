class_name Board
extends Node2D

const SQUARE_SIZE: Vector2 = Vector2(90, 90)
const PIECE_OFFSET: Vector2 = Vector2(45, 45)
const SQUARE_COUNT: int = 64

@export var starting_fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
@export var piece_scene: PackedScene
@export var squares: Array[Piece] = []

@onready var piece_container: Node2D = $PieceContainer
var white_to_move: bool = true

func _ready() -> void:
	if starting_fen:
		squares = Fen.parse(starting_fen)
		white_to_move = Fen.is_white_to_move(starting_fen)
	update_board()

func update_board() -> void:
	for i in range(len(squares)):
		var piece = squares[i]
		if piece:
			var file = i % 8
			var rank = i / 8.0
			piece.position = get_square_position(file, rank)
			piece_container.add_child(piece)

func get_square_position(file: int, rank: int) -> Vector2:
	return Vector2(file * SQUARE_SIZE.x + PIECE_OFFSET.x, rank * SQUARE_SIZE.y + PIECE_OFFSET.y)
