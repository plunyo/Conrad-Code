extends Node

var coins: int = 0
var max_coins: int = 9

var collected_coins: Array[int] = []

func mark_coin(coin_id: int):
	if coin_id not in collected_coins:
		collected_coins.append(coin_id)

func is_coin_collected(coin_id: int) -> bool:
	return coin_id in collected_coins

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
