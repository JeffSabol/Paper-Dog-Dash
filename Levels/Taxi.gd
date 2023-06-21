extends CharacterBody2D

@onready var path_follower = get_parent()
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _collision_polygon = $CollisionPolygon2D

func _physics_process(_delta):
	_animated_sprite.play("default")
	
	path_follower.progress += 1 # moves the mole along the path
	
	if path_follower.progress < 215:
		$AnimatedSprite2D.flip_h = true 
		_collision_polygon.scale.x = -abs(_collision_polygon.scale.x)
	elif path_follower.progress > 215:
		$AnimatedSprite2D.flip_h = false 
		_collision_polygon.scale.x = abs(_collision_polygon.scale.x)
