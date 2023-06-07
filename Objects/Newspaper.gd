extends Area2D

var picked_up = false

func _on_body_entered(body):
		if body is Player:
			Global.has_newspaper = true
			hide()
