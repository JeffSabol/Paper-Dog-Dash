extends CharacterBody2D
class_name Player

# Node variables
@onready var player_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var crawl_raycast_1 = $CrawlRayCast1
@onready var crawl_raycast_2 = $CrawlRayCast2
@onready var pee_timer = $PeeTimer

# Constants
const SPEED = 180.0
const CRAWL_SPEED = 90.0
const JUMP_VELOCITY = -340.0
const STANDING_COLLISION_Y_POS = 11
const CROUCHING_COLLISION_Y_POS = 17
const ACCELERATION = 10.0
const BOOSTED_SPEED = 250.0  # Increased speed when Shift is held


# Enums and variables
enum PlayerState {STANDING, WALKING, CRAWL, JUMPING, FALLING, PEEING, HURT} 
var state = PlayerState.STANDING
var is_crouching = false 
var stuck_under_object = false
var is_peeing = false
var is_hurt = false
var standing_collision_shape = preload("res://Characters/CollisionBoxes/player.tres")
var crouching_collision_shape = preload("res://Characters/CollisionBoxes/playerCROUCHING.tres")

# Gravity and jump buffer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer_duration = 0.2
var jump_buffer_timer = 0.0
var jump_input_received = false

# Coyote Jump
var coyote_time_duration = 0.10
var coyote_time_timer = 0.0
var can_jump_during_coyote_time = false

# Physics processing
func _physics_process(delta):
	update_jump_buffer(delta)
	handle_jump_input()
	handle_gravity_and_state(delta)
	handle_input_and_movement(delta)
	update_coyote_time(delta)

# Jump input handling
func handle_jump_input():
	if is_peeing or is_hurt:
		return
		
	if Input.is_action_just_pressed("ui_accept") or Input.is_joy_button_pressed(0, JOY_BUTTON_B) or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER) and not is_peeing and not is_hurt:
		if is_on_floor() or can_jump_during_coyote_time:
			perform_jump()
			coyote_time_timer = 0
			can_jump_during_coyote_time = false
		else:
			jump_input_received = true
			jump_buffer_timer = jump_buffer_duration
	elif jump_input_received and is_on_floor():
		perform_jump()
		jump_input_received = false
		jump_buffer_timer = 0

# Jump buffer handling
func update_jump_buffer(delta):
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		if jump_buffer_timer <= 0:
			jump_input_received = false

# Gravity and state management
func handle_gravity_and_state(delta):
	if not is_on_floor():
		apply_gravity(delta)
		update_airborne_state()
	else:
		update_ground_state()

# Input and movement handling
func handle_input_and_movement(delta):
	var direction = get_input_direction()
	move_character(direction, delta)
	handle_crouch_logic()



# Apply gravity to the player
func apply_gravity(delta):
	velocity.y += gravity * delta

# Update the player's state while airborne
func update_airborne_state():
	if velocity.y < 0 and not is_peeing and not is_hurt:
		state = PlayerState.JUMPING
	elif velocity.y > 0.1 and not is_peeing and not is_hurt:
		state = PlayerState.FALLING

# Coyote jump time tracking
func update_coyote_time(delta):
	if is_on_floor():
		coyote_time_timer = coyote_time_duration
		can_jump_during_coyote_time = true
	elif coyote_time_timer > 0:
		coyote_time_timer -= delta
	else:
		can_jump_during_coyote_time = false

# Update the player's state while on the ground
func update_ground_state():
	if velocity.x == 0 and not is_crouching and not is_peeing and not is_hurt:
		state = PlayerState.STANDING
	elif velocity.x != 0 and is_crouching and not is_peeing and not is_hurt:
		state = PlayerState.CRAWL
	elif not is_peeing and not is_hurt:
		state = PlayerState.WALKING

# Get input direction
func get_input_direction() -> int:
	if is_peeing or is_hurt:  # Ignore movement input if peeing
		return 0
	if state != PlayerState.PEEING and state != PlayerState.HURT:
		return Input.get_axis("ui_left", "ui_right")
	return 0

func move_character(direction: int, delta: float):
	var target_speed = SPEED
	if Input.is_action_pressed("ui_shift") or Input.is_joy_button_pressed(0, JOY_BUTTON_A) or Input.is_joy_button_pressed(0, JOY_BUTTON_LEFT_SHOULDER) and not is_crouching:
		target_speed = BOOSTED_SPEED

	var target_velocity_x = direction * (target_speed if state != PlayerState.CRAWL else CRAWL_SPEED)
	velocity.x = lerp(velocity.x, target_velocity_x, ACCELERATION * delta)
	update_animations()
	move_and_slide()

# Handle the crouch logic
func handle_crouch_logic():
	if Input.is_action_just_pressed("ui_down"):
		crouch()
	elif Input.is_action_just_released("ui_down"):
		if above_head_is_empty():
			uncrouch()
		elif not stuck_under_object:
			stuck_under_object = true
	if stuck_under_object and above_head_is_empty() and not Input.is_action_pressed("ui_down"):
		uncrouch()
		stuck_under_object = false

# Check if the space above the player's head is empty
func above_head_is_empty() -> bool:
	return not crawl_raycast_1.is_colliding() and not crawl_raycast_2.is_colliding()

# Update animations based on player state
func update_animations():
	if is_peeing:
		player_sprite.play("pee")

	# Update state based on velocity
	if abs(velocity.x) < 10 and not is_peeing and not is_hurt:
		if velocity.y < 0: # negative velocity means you are going upgit 
			state = PlayerState.JUMPING
		elif velocity.y > 0:
			state=PlayerState.FALLING
		else:
			state = PlayerState.STANDING

	match state:
		PlayerState.STANDING:
			player_sprite.play("idle")
		PlayerState.WALKING:
			player_sprite.play("walk")
		PlayerState.JUMPING:
			player_sprite.play("jump")
		PlayerState.FALLING:
			player_sprite.play("fall")
		PlayerState.PEEING:
			player_sprite.play("pee")
		PlayerState.HURT:
			if is_crouching:
				if is_hurt:
					player_sprite.play("crawl_hurt")
				else:
					player_sprite.play("crawl")
			else:
				player_sprite.play("hurt")

	if is_crouching and player_sprite.animation != "crawl" and !is_hurt:
		player_sprite.play("crawl")
		
	# Flip sprite based on movement direction
	player_sprite.flip_h = velocity.x < 0

# Crouch functionality
func crouch():
	if state == PlayerState.PEEING or state == PlayerState.HURT or state == PlayerState.CRAWL:
		return
	state = PlayerState.CRAWL
	if is_crouching:
		return
	is_crouching = true
	collision_shape.shape = crouching_collision_shape
	collision_shape.position.y = CROUCHING_COLLISION_Y_POS

# Uncrouch functionality
func uncrouch():
	if state == PlayerState.PEEING or state == PlayerState.HURT or not is_crouching:
		return
	is_crouching = false
	state = PlayerState.STANDING  # Return to standing state when uncrouching
	collision_shape.shape = standing_collision_shape
	collision_shape.position.y = STANDING_COLLISION_Y_POS

# Pee functionality
func pee():
	if is_crouching:
		is_crouching = false
		update_collision_shape_for_standing()
	is_peeing = true
	state = PlayerState.PEEING
	player_sprite.play("pee")
	pee_timer.start(3)

# Perform jump action
func perform_jump():
	$Jump.play()
	velocity.y = JUMP_VELOCITY
	state = PlayerState.JUMPING

# Hurt functionality
func hurt():
	state = PlayerState.HURT
	is_hurt = true
	pee_timer.start(2.5)
	$Hurt.play()

# Timeout handling for pee timer
func _on_pee_timer_timeout():
	is_peeing = false
	is_hurt = false
	if above_head_is_empty():
		is_crouching = false
		update_collision_shape_for_standing()
	state = PlayerState.STANDING
	
# Update collision shape for standing
func update_collision_shape_for_standing():
	collision_shape.shape = standing_collision_shape
	collision_shape.position.y = STANDING_COLLISION_Y_POS
	
