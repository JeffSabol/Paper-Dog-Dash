extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 180.0
const JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _process(delta):

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
		if(velocity.y <= 0): # up is negative on the game level
			_animated_sprite.play("jump")
		else:
			_animated_sprite.play("fall")
				
	else:
		if(velocity.x == 0):
			_animated_sprite.play("idle")
		else:
			_animated_sprite.play("walk")

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		if(velocity.x < 0):
			_animated_sprite.flip_h = true
		elif(velocity.x > 0):
			_animated_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
