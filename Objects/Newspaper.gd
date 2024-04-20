extends Area2D

var picked_up = false

func _on_body_entered(body):
		if body is Player:
			Global.has_newspaper = true
			hide()
			$Newspaper.play()
			var root = get_tree().root
			var current_scene = root.get_child(root.get_child_count() - 1)
			var hud = current_scene.get_node("Player/HUD")
			hud.show_newspaper_text()
			await get_tree().create_timer(1.0).timeout
			queue_free() 
