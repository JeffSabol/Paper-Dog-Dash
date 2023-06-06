extends Area2D

signal bone_picked_up

func _on_body_entered(body):
		if body is Player:
			queue_free()
			Global.total_bones += 1
			bone_picked_up.emit()
