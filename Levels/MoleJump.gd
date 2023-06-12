extends Area2D

const SPEED = 180.0
const CRAWL_SPEED = 90.0
const JUMP_VELOCITY = -340.0
const GRAVITY = 980
var jumping = false

var velocity = Vector2(0, 0)

@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(_delta):
	if jumping:
		_animated_sprite.play("jump")
		$CollisionShape2D.disabled = false
		velocity.y -= GRAVITY * _delta
#		position += velocity * _delta
	else:
		_animated_sprite.play("dirt")
		$CollisionShape2D.disabled = true
		velocity.y = 0

func _on_body_entered(body):
	if body is Player:
		print("player touched the mole!")


func _on_jump_timer_timeout():
	jumping = true
	pass # time to jump!
