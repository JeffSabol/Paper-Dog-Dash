extends Area2D

func _on_body_entered(body):
		if body is Player:
			hide()
			Global.total_bones += 1
			print(Global.total_bones)
