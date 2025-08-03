extends Node

@onready var pause_text: Label = $'../../Gameplay/Player/Camera2D/PauseScreen/ColorRect/Pause Text'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelBase.gameplay = $'../../Gameplay'
	LevelBase.pause_screen = $'../../Gameplay/Player/Camera2D/PauseScreen'
	LevelBase.can_toggle_pause = true
	LevelBase.paused = false
	
	pause_text.text = 'PAUSED\nPress enter to reset'
