extends Area2D

var picked_up = false

func _on_body_entered(body):
		if body is Player:
			Global.has_newspaper = true
			hide()
			$Newspaper.play()
			await get_tree().create_timer(1.0).timeout
			queue_free() 
