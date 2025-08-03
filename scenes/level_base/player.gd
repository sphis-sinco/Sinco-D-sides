extends CharacterBody2D

var controls = {
	movement = true,
	jump = true,
	double_jump = true
}

const MAX_SPEED_TICK = 200.0
var SPEED_TICK = 0.0

var CUR_SPEED = 300.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_ADDITIONAL_VELOCITY = -200.0
var double_jumped = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var random_jump_num = 1

var direction = 0

@onready var label: Label = $Camera2D/Label
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var ded = false

@onready var camera_2d: Camera2D = $Camera2D

var speed_fall = 15

var floor_angle = 0.0

func _physics_process(delta: float) -> void:
	if not ded:
		rotation_degrees = 0
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	
	# This makes 1 air, 0 floor, and .5 for the 45 degree slopes
	floor_angle = roundf(get_floor_angle()) / 2
	
	death_check_and_loop()
	
	debug_label_setup()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		double_jumped = false

	if not ded:
		if controls.movement:
			horizontal_direction()
		if controls.jump:
			jump_button_check()
	
	CUR_SPEED = SPEED
	CUR_SPEED += SPEED_TICK
	CUR_SPEED = direction * CUR_SPEED
	
	if direction:
		velocity.x = move_toward(velocity.x, CUR_SPEED, speed_fall)
	else:
		velocity.x = move_toward(velocity.x, 0, speed_fall)
	
	speed_tick()
	
	animations()
	
	move_and_slide()
	
func jump_button_check():
	if Input.is_action_pressed('Camera_Move'): return
	if Input.is_action_just_pressed('Move_Jump') and is_on_floor():
		if random_jump_num == 1:
			random_jump_num = 2
		else:
			random_jump_num =  1
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed('Move_Jump') and Input.is_action_pressed('Move_Up'):
		if not controls.double_jump: return
		if not double_jumped and not is_on_floor() and velocity.y > JUMP_VELOCITY / 2:
			double_jumped = true
			velocity.y += JUMP_VELOCITY + DOUBLE_JUMP_ADDITIONAL_VELOCITY

func horizontal_direction():
	direction = 0
	if Input.is_action_pressed('Camera_Move'): return
	direction = Input.get_axis('Move_Left', 'Move_Right')
	
	if direction < 0:
		random_jump_num = 1
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		random_jump_num = 2
		animated_sprite_2d.flip_h = false

const rotate_on_death = true
const death_rotation_speed = .01
const death_jump_velocity = -300.0

func death_check_and_loop():
	if visible == false or ded:
		if not ded:
			LevelBase.can_toggle_pause = false
			speed_fall = speed_fall * 2
			collision_shape_2d.disabled = true
			visible = true
			ded = true
			velocity.y += death_jump_velocity
		
		if rotate_on_death:
			if animated_sprite_2d.flip_h:
				rotate(-death_rotation_speed)
			else:
				rotate(death_rotation_speed)
		
		direction = move_toward(direction, 0, 0.0125)

func debug_label_setup():
	label.text = 'velocity: '+str(velocity)
	label.text +='\nreal velocity: ' + str(get_real_velocity())
	label.text +='\ncurSpeed: ' + str(CUR_SPEED)
	label.text +='\nfloor_angle: ' + str(floor_angle)
	label.text +='\nSPEED_TICK: ' + str(SPEED_TICK)
	label.text +='\ndouble_jumped: ' + str(double_jumped)

func speed_tick():
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

func animations():
	if abs(velocity.x) > 0 and is_on_floor():
		if SPEED_TICK > (MAX_SPEED_TICK / 1.5):
			animated_sprite_2d.play('run')
		elif SPEED_TICK <= 1.1 and direction or abs(velocity.x) < 100:
			animated_sprite_2d.play('pre-walk')
		else:
			animated_sprite_2d.play('walk')
	elif is_on_floor():
		animated_sprite_2d.play('idle')
	else:
		if abs(velocity.y) > JUMP_VELOCITY and double_jumped:
			animated_sprite_2d.play('jump-double')
		else:
			animated_sprite_2d.play('jump-'+str(random_jump_num))
	
	if ded:
		animated_sprite_2d.play('death')
