extends Node

var spaceship_speed: float = 30.0;
var game_lost: bool = false;
var current_level: int = 1;
var score: int = 0;

func reset():
	spaceship_speed = 30.0;
	game_lost = false;
	current_level = 1;
	score = 0;
