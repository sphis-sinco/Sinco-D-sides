extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelBase.gameplay = $'../../Gameplay'
	LevelBase.pause_screen = $'../../Gameplay/Player/Camera2D/PauseScreen'
	LevelBase.can_toggle_pause = true
	LevelBase.paused = false
