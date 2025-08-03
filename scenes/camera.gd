extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

const final_offset = 64
const speed_fall = 5

func _process(delta: float) -> void:
	var horiz_dir = 0
	var verti_dir = 0
	if Input.is_action_pressed('Camera_Move'):
		horiz_dir = Input.get_axis('Camera_Left', 'Camera_Right')
		verti_dir = Input.get_axis('Camera_Up', 'Camera_Down')
		
	if horiz_dir:
		offset.x = move_toward(offset.x, horiz_dir * final_offset, speed_fall)
	else:
		offset.x = move_toward(offset.x, 0, speed_fall)
		
	if verti_dir:
		offset.y = move_toward(offset.y, verti_dir * final_offset, speed_fall)
	else:
		offset.y = move_toward(offset.y, 0, speed_fall)
