class_name Hotbar
extends Control

enum Item { EMPTY, PREDATOR, PREY, FOOD }

@export var currently_selected: Item = Item.EMPTY

func _ready() -> void:
	for icon: HotbarIcon in $IconFlowContainer.get_children():
		icon.pressed.connect(func() -> void:
			if currently_selected != icon.item_type:
				currently_selected = icon.item_type
			else:
				currently_selected = Item.EMPTY
		)
