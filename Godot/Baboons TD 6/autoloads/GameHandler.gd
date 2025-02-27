extends Node


var coins: int = 200
var wave: int = 1
var enemy_count: int = 0.0


func change_coins(amount, duration: float):
	var tween = create_tween()
	var result = coins + amount

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "coins", result, duration).set_trans(Tween.TRANS_QUAD)
