extends CharacterBody2D

const MAX_SPEED_TICK = 255.0
var SPEED_TICK = 0.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var random_jump_num = 1

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		animated_sprite_2d.play('jump-'+str(random_jump_num))
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed('Move_Jump') and is_on_floor():
		random_jump_num = RandomNumberGenerator.new().randi_range(1,2)
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis('Move_Left', 'Move_Right')
	
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
	
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
		
	if abs(velocity.x) > 0 and is_on_floor():
		random_jump_num = RandomNumberGenerator.new().randi_range(1,2)
		if SPEED_TICK > (MAX_SPEED_TICK * (3/4)):
			animated_sprite_2d.play('run')
		else:
			animated_sprite_2d.play('walk')
	elif is_on_floor():
		random_jump_num = RandomNumberGenerator.new().randi_range(1,2)
		animated_sprite_2d.play('idle')
	
	# print(SPEED_TICK)

	move_and_slide()
