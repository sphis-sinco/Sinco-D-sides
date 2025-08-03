extends CharacterBody2D

const MAX_SPEED_TICK = 255.0
var SPEED_TICK = 0.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed('Move_Jump') and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis('Move_Left', 'Move_Right')
	if direction:
		velocity.x = direction * (SPEED + SPEED_TICK)
	else:
		velocity.x = move_toward(velocity.x, 0, 15 + (SPEED_TICK * 0.05))
		
	if abs(velocity.x) > 0 and not is_on_wall():
		if abs(SPEED_TICK) < 1:
			SPEED_TICK = 1
		else:
			SPEED_TICK = SPEED_TICK * 1.05
			if (SPEED_TICK > MAX_SPEED_TICK):
				SPEED_TICK = MAX_SPEED_TICK
	else:
		SPEED_TICK = move_toward(SPEED_TICK, 0, (SPEED + SPEED_TICK))
	
	# print(SPEED_TICK)

	move_and_slide()
