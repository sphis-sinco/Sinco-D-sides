extends Node2D

var paused = false

var gameplay: Node = null
var player: CharacterBody2D = null
var pause_screen: Node2D = null
var pause_screen_rect: ColorRect = null
var camera: Camera2D = null

var can_toggle_pause = false

func _process(delta: float) -> void:
	# print(player.position.y)
	# print(camera.limit_bottom * 0.5)
	# print(player.position.y > camera.limit_bottom * 0.5)
	
	if pause_screen != null:
		pause_screen.visible = paused
		
	if gameplay != null:
		gameplay.process_mode = Node.PROCESS_MODE_INHERIT
		if paused:
			gameplay.process_mode = Node.PROCESS_MODE_DISABLED
			
	if Input.is_action_pressed('Pause') and can_toggle_pause:
		paused = !paused
		
		if paused:
			if player != null && camera != null:
				if player.position.y > camera.limit_bottom * 0.8:
					paused = !paused
	
	if Input.is_action_just_pressed('Pause_Reset') and can_toggle_pause and paused:
		get_tree().reload_current_scene()

	
