extends Control

const FOX_COUNT: int = 224;

@onready var word_container: FlowContainer = $WordContainer;
@onready var score_label: Label = $ScoreLabel;

@export var fox_scene: PackedScene;

var highscore: int = 0
var fox_amount: int = 0

func _ready() -> void:
	for x in range(FOX_COUNT):
		word_container.add_child(fox_scene.instantiate());

func _process(delta: float) -> void:
	score_label.text = "Score: " + str(Global.score);
	word_container.process_mode = PROCESS_MODE_DISABLED if $TimeLeft/Timer.is_stopped() else PROCESS_MODE_INHERIT

	fox_amount = 0
	for fox in word_container.get_children():
		if fox.is_fox:
			fox_amount += 1
	$FoxLabel.text = "Fox Count: " + str(fox_amount)

	highscore = max(highscore, Global.score)
	$HighscoreLabel.text = "Highscore: " + str(highscore)

func _on_reset_button_pressed() -> void:
	for fox in word_container.get_children():
		fox.queue_free();
	for x in range(FOX_COUNT):
		word_container.add_child(fox_scene.instantiate());
	Global.score = 0
	$TimeLeft/Timer.start()

func _on_timer_timeout() -> void:
	for fox in word_container.get_children():
		fox.queue_free();
	for x in range(FOX_COUNT):
		word_container.add_child(fox_scene.instantiate());
	Global.score = 0
