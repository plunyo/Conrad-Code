class_name Piece
extends Node2D

enum PieceType { KING, QUEEN, BISHOP, KNIGHT, ROOK, PAWN }
enum PieceColor { WHITE, BLACK }

@export var color: PieceColor
@export var type: PieceType

@onready var sprite: Sprite2D = $Sprite

static func create(piece_color: PieceColor, piece_type: PieceType) -> Piece:
	var instance: Piece = load("res://piece/piece.tscn").instantiate()
	instance.color = piece_color
	instance.type = piece_type
	return instance

func _ready() -> void:
	# set sprite to color and type
	sprite.frame_coords = Vector2i(
		int(type),
		0 if color == PieceColor.WHITE else 1
	)
