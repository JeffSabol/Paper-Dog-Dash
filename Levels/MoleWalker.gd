extends Area2D

@onready var path_follower = get_parent()
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):
	_animated_sprite.play("default")
	
	path_follower.progress += 1 # moves the mole along the path
	
	if path_follower.progress < 215:
		$AnimatedSprite2D.flip_h = true 
	elif path_follower.progress > 215:
		$AnimatedSprite2D.flip_h = false 
		
func _on_body_entered(body):
	if body is Player:
		body.hurt()
