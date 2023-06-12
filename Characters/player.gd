extends CharacterBody2D
class_name Player

@onready var player_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var crawl_raycast_1 = $CrawlRayCast1
@onready var crawl_raycast_2 = $CrawlRayCast2
@onready var pee_timer = $PeeTimer

const SPEED = 180.0
const CRAWL_SPEED = 90.0
const JUMP_VELOCITY = -340.0
const STANDING_COLLISION_Y_POS = 11
const CROUCHING_COLLISION_Y_POS = 17

enum PlayerState {STANDING, WALKING, CRAWL, JUMPING, FALLING, PEEING, HURT} 
var state = PlayerState.STANDING
var is_crouching = false 
var stuck_under_object = false
var is_peeing = false # New variable to track whether the player is peeing
var is_hurt = false # Tracks whether the player is currently stunned from being hurt
var standing_collision_shape = preload("res://Characters/CollisionBoxes/player.tres")
var crouching_collision_shape = preload("res://Characters/CollisionBoxes/playerCROUCHING.tres")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0 and not is_peeing and not is_hurt:  
			state = PlayerState.JUMPING
		elif velocity.y > 0.1 and not is_peeing and not is_hurt: 
			state = PlayerState.FALLING

	elif velocity.x == 0 and not is_crouching and not is_peeing and not is_hurt:
		state = PlayerState.STANDING
	elif velocity.x != 0 and is_crouching and not is_peeing and not is_hurt: # if moving, crouching, and not peeing, set to CRAWL
		state = PlayerState.CRAWL
	elif not is_peeing and not is_hurt:
		state = PlayerState.WALKING

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_peeing and not is_hurt: # Only allow jump if not peeing or hurt
		velocity.y = JUMP_VELOCITY
		state = PlayerState.JUMPING

	# Get the input direction and handle the movement/deceleration.
	var direction = 0;
	if state != PlayerState.PEEING && state != PlayerState.HURT:
		direction = Input.get_axis("ui_left", "ui_right")
		
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

	
func crouch():
	if state == PlayerState.PEEING or state == PlayerState.HURT or state == PlayerState.CRAWL:
		return
	state = PlayerState.CRAWL
	if is_crouching:
		return
	is_crouching = true
	collision_shape.shape = crouching_collision_shape
	collision_shape.position.y = CROUCHING_COLLISION_Y_POS

func uncrouch():
	if state == PlayerState.PEEING or state == PlayerState.HURT or not is_crouching:
		return
	is_crouching = false
	state = PlayerState.STANDING  # Return to standing state when uncrouching
	collision_shape.shape = standing_collision_shape
	collision_shape.position.y = STANDING_COLLISION_Y_POS

func pee():
	if is_crouching:
		is_crouching = false
		collision_shape.shape = standing_collision_shape
		collision_shape.position.y = STANDING_COLLISION_Y_POS

	is_peeing = true
	state = PlayerState.PEEING
	pee_timer.start(3)

func hurt():
	state = PlayerState.HURT
	is_hurt = true
	pee_timer.start(2.5)

func _on_pee_timer_timeout():
	is_peeing = false
	is_hurt = false
	if above_head_is_empty():
		is_crouching = false
		collision_shape.shape = standing_collision_shape
		collision_shape.position.y = STANDING_COLLISION_Y_POS
	state = PlayerState.STANDING
