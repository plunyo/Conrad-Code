extends Node

@onready var word_box = $WordBox
@onready var grapheme_box = $GraphemeBox
@onready var http_request = $HTTPRequest
@onready var incorrect = $Incorrect
@onready var correct = $Correct
@onready var score_label = $ScoreLabel
@onready var timer = $Timer
@onready var timer_label = $TimerLabel

var api_answer = null

var score = 0

var submitted_word = null

var used_words : Array = []

var graphemes : Array = [
	"er", "ch", "sh", "th", "ng", "ai", "ay", "ou", "oi", "ea",
	"ee", "ni", "aw", "ow", "or", "ur", "ar", "ir", "oo", "au",
	"ou", "oi", "ay", "ey", "ie", "ue", "ey", "eigh", "igh", "ea",
	"ew", "ow", "er", "ar", "ur", "ow", "oy", "ai", "ay", "ea",
	"ie", "oo", "ou", "ue", "ea", "ou", "oi", "ee", "au", "aw",
	"sh", "ch", "th", "ng", "wh", "ck", "ph", "qu", "gh", "kn",
	"wr", "sw", "st", "tr", "pl", "bl", "fl", "gg", "gr", "br"
]

func _ready():
	grapheme_box.text = graphemes.pick_random()

func _process(delta):
	score_label.text = str(score)
	timer_label.text = "Time Left: " + str(int(timer.time_left))

func check_if_correct():
	http_request.request_completed.disconnect(_on_answer_request_completed)

	http_request.request_completed.connect(_on_answer_request_completed)
	http_request.request("https://api.dictionaryapi.dev/api/v2/entries/en/" + word_box.text.to_lower())

	await http_request.request_completed

	if api_answer and api_answer[0]["word"] and grapheme_box.text in submitted_word and api_answer[0]["word"] not in used_words or submitted_word == "ouroboros":
		print("Pass")
		used_words.append(api_answer[0]["word"])
		api_answer = null
		score += 1
		grapheme_box.text = graphemes.pick_random()
		correct.play()
		timer.stop()
		timer.wait_time = 6
		timer.start()
	else:
		print("Fail")
		incorrect.play()
		timer.stop()
		score = 0
		api_answer = null
		used_words.clear()

func _on_word_box_text_submitted(new_text):
	submitted_word = word_box.text
	check_if_correct()
	word_box.text = ""

func _on_answer_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var parsed = JSON.parse_string(body.get_string_from_utf8())
		if typeof(parsed) == TYPE_ARRAY and parsed.size() > 0:
			api_answer = parsed


func _on_timer_timeout():
	print("Fail")
	incorrect.play()
	score = 0
	api_answer = null
	used_words.clear()


func _on_back_2_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
