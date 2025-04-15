class_name Fen
extends Node

const FEN_SYMBOL_TO_TYPE: Dictionary = {
	'k': Piece.PieceType.KING,
	'q': Piece.PieceType.QUEEN,
	'b': Piece.PieceType.BISHOP,
	'n': Piece.PieceType.KNIGHT,
	'r': Piece.PieceType.ROOK,
	'p': Piece.PieceType.PAWN
}

static func parse(fen: String) -> Array[Piece]:
	var squares: Array[Piece] = []

	for _i in range(Board.SQUARE_COUNT):
		squares.append(null)

	var sections = fen.split(" ")
	var piece_layout = sections[0]

	var file := 0
	var rank := 7

	for symbol in piece_layout:
		match symbol:
			'/':
				file = 0
				rank -= 1
			_:
				if symbol.is_valid_int():
					file += symbol.to_int()
				else:
					var color = Piece.PieceColor.WHITE if (symbol.to_upper() == symbol) else Piece.PieceColor.BLACK
					var type = FEN_SYMBOL_TO_TYPE.get(symbol.to_lower())
					var piece = Piece.create(color, type)
					squares[rank * 8 + file] = piece
					file += 1

	return squares

static func is_white_to_move(fen: String) -> bool:
	var sections = fen.split(" ")
	return sections[1] == "w"
