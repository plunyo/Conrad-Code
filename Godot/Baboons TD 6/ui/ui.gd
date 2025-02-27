extends Control


@onready var tower_menu: Panel = $TowerMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var coin_counter: RichTextLabel = $TowerMenu/CoinPanel/CoinCounter
@onready var wave_counter: RichTextLabel = $TowerMenu/WavePanel/WaveCounter
@onready var enemy_counter: RichTextLabel = $TowerMenu/EnemyPanel/EnemyCounter


var menu_is_down = false

var drag = false
var drag_offset = Vector2.ZERO

var og_tower_menu_pos = Vector2(864, 76)
var tower_menu_is_moved = false

func _process(_delta: float) -> void:
	coin_counter.text = "Coins: " + str(GameHandler.coins)
	wave_counter.text = "Wave: " + str(GameHandler.wave) + "/40"
	enemy_counter.text = "Enemies Left: " + str(GameHandler.enemy_count)

func _on_button_pressed() -> void:
	menu_is_down = !menu_is_down

	if menu_is_down and !animation_player.is_playing() and !drag:
		animation_player.play("MenuClose")
	else:
		animation_player.play_backwards("MenuClose")
