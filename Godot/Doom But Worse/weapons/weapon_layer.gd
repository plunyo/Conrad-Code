extends CanvasLayer
class_name WeaponLayer

enum Weapon {
	Pistol,
	Shotgun
}

@export var initial_weapon: Weapon
@export var weapons: Array[Node2D]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_weapon(initial_weapon)

func set_weapon(new_weapon: int):
	for weapon in weapons: weapon.hide()
	weapons[new_weapon].show()
