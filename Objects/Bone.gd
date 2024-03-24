extends Area2D

signal bone_picked_up

func _on_body_entered(body):
		if body is Player:
			$Pickup.play()
			self.visible = false
			Global.total_bones += 1
			bone_picked_up.emit()
			await get_tree().create_timer(0.1).timeout
			queue_free()
