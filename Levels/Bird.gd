extends CharacterBody2D

var moving_direction = -1
var speed = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimatedSprite2D.play()
	
func _physics_process(delta):
	# Apply horizontal movement based on the direction
	velocity.x = speed * moving_direction
	move_and_slide()

	# Match bird to direction.
	if velocity.x > 0:
		update_direction(1)
		$AnimatedSprite2D.play("fly")
	elif velocity.x < 0:
		update_direction(-1)
		$AnimatedSprite2D.play("fly")
	elif velocity.x == 0:
		$AnimatedSprite2D.pause()
		moving_direction *= -1

func update_direction(direction):
	moving_direction = direction
	$Body.scale.x = -direction
	$Area2D/AttackZone.scale.x = -direction
	$AnimatedSprite2D.scale.x = -direction
