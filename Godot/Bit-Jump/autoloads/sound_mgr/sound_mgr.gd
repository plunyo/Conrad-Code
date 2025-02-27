extends Node

@onready var sounds = {
	"player": {
		"jump": $PlayerSounds/JumpSound,
		"die": $PlayerSounds/DieSound
	},

	"game": {
		"music": $GameSounds
	},

	"ui": {
		"select": $UiSounds/SelectSound
	}
}
