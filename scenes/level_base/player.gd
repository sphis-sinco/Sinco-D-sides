extends CharacterBody2D

const MAX_SPEED_TICK = 200.0
var SPEED_TICK = 0.0

var CUR_SPEED = 300.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var random_jump_num = 1

var direction = 0

@onready var label: Label = $Camera2D/Label

func _physics_process(delta: float) -> void:
	var speed_fall = 15
	
	label.text = 'velocity: '+str(velocity)
	label.text +='\ncurSpeed: ' + str(CUR_SPEED)
	
	if not is_on_floor():
		animated_sprite_2d.play('jump-'+str(random_jump_num))
		velocity += get_gravity() * delta

	direction = Input.get_axis('Move_Left', 'Move_Right')
	
	if direction < 0:
		random_jump_num = 1
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		random_jump_num = 2
		animated_sprite_2d.flip_h = false

	if Input.is_action_just_pressed('Move_Jump') and is_on_floor():
		if random_jump_num == 1:
			random_jump_num = 2
		else:
			random_jump_num =  1
		velocity.y = JUMP_VELOCITY
	
	CUR_SPEED = SPEED
	CUR_SPEED += SPEED_TICK
	CUR_SPEED = direction * CUR_SPEED
	
	if direction:
		velocity.x = move_toward(velocity.x, CUR_SPEED, speed_fall)
	else:
		velocity.x = move_toward(velocity.x, 0, speed_fall)
	
	if abs(direction) > 0 and not is_on_wall():
		if abs(direction) > 0:
			if abs(SPEED_TICK) < 1:
				SPEED_TICK = 1
			else:
				SPEED_TICK = SPEED_TICK * 1.025
				if (SPEED_TICK > MAX_SPEED_TICK):
					SPEED_TICK = MAX_SPEED_TICK
	else:
		SPEED_TICK = move_toward(SPEED_TICK, 0, speed_fall)
	
	if abs(velocity.x) > 0 and is_on_floor():
		# random_jump_num = RandomNumberGenerator.new().randi_range(1,2)
		if SPEED_TICK > (MAX_SPEED_TICK / 1.5):
			animated_sprite_2d.play('run')
		else:
			animated_sprite_2d.play('walk')
	elif is_on_floor():
		# random_jump_num = RandomNumberGenerator.new().randi_range(1,2)
		animated_sprite_2d.play('idle')
	
	# print(SPEED_TICK)

	move_and_slide()
