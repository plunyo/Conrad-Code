extends RichTextLabel


func _process(_delta: float) -> void:
	text = str(len(Main.collected_coins)) + " / " + str(Main.max_coins)
