extends Node2D

var paused = false

var gameplay: Node = null
var pause_screen: Node = null

var can_toggle_pause = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pause_screen != null:
		pause_screen.visible = paused
		
	if gameplay != null:
		gameplay.process_mode = Node.PROCESS_MODE_INHERIT
		if paused:
			gameplay.process_mode = Node.PROCESS_MODE_DISABLED
			
	if Input.is_action_just_pressed('Pause') and can_toggle_pause:
		paused = !paused
	if Input.is_action_just_pressed('Pause_Reset') and can_toggle_pause and paused:
		get_tree().reload_current_scene()

	
