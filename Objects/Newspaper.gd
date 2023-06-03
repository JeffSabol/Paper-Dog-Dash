extends Area2D

var picked_up = false

func _ready():
	print("test")

func _on_body_entered(body):
		if body is Player:
			Global.has_newspaper = true
			print("dog picked up newspaper")
			hide()
