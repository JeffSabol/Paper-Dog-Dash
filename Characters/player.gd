extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var crawl_raycast_1 = $CrawlRayCast1
@onready var crawl_raycast_2 = $CrawlRayCast2

const SPEED = 180.0
const CRAWL_SPEED = 90.0
const JUMP_VELOCITY = -340.0
const STANDING_COLLISION_Y_POS = 11
const CROUCHING_COLLISION_Y_POS = 17

enum PlayerState {STANDING, WALKING, CRAWL, JUMPING, FALLING} 
var state = PlayerState.STANDING
var is_crouching = false 
var stuck_under_object = false
var standing_collision_shape = preload("res://Characters/CollisionBoxes/player.tres")
var crouching_collision_shape = preload("res://Characters/CollisionBoxes/playerCROUCHING.tres")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0: 
			state = PlayerState.JUMPING
		elif velocity.y > 0.1: 
			state = PlayerState.FALLING

	elif velocity.x == 0 and not is_crouching:  # Only set to STANDING if not crouching
		state = PlayerState.STANDING
	elif velocity.x != 0 and is_crouching: # if moving and crouching, set to CRAWL
		state = PlayerState.CRAWL
	else:
		state = PlayerState.WALKING

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state = PlayerState.JUMPING

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")

	# Handle crouch
	if Input.is_action_just_pressed("ui_down"):
		crouch()
	elif Input.is_action_just_released("ui_down"):
		if above_head_is_empty():
			uncrouch()
		else:
			if !stuck_under_object:
				stuck_under_object = true
				
	if stuck_under_object && above_head_is_empty():
		if !Input.is_action_pressed("ui_down"):
			uncrouch()
			stuck_under_object = false
				
		
	if direction:
		velocity.x = direction * (SPEED if state != PlayerState.CRAWL else CRAWL_SPEED)
		player_sprite.flip_h = velocity.x < 0

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations()

func above_head_is_empty() -> bool:
	return !crawl_raycast_1.is_colliding() && !crawl_raycast_2.is_colliding()
	

func update_animations():
	match state:
		PlayerState.STANDING:
			player_sprite.play("idle")
		PlayerState.WALKING:
			player_sprite.play("walk")
		PlayerState.JUMPING:
			player_sprite.play("jump")
		PlayerState.FALLING:
			player_sprite.play("fall")

	if is_crouching and player_sprite.animation != "crawl":
		player_sprite.play("crawl")

	
func crouch():
	state = PlayerState.CRAWL
	if is_crouching:
		return
	is_crouching = true
	collision_shape.shape = crouching_collision_shape
	collision_shape.position.y = CROUCHING_COLLISION_Y_POS
	
func uncrouch():
	if not is_crouching:
		return
	is_crouching = false
	collision_shape.shape = standing_collision_shape
	collision_shape.position.y = STANDING_COLLISION_Y_POS
