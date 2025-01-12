# Jeff Sabol
# Play a closing animation transition scene
# Send the player to the End of Level scene

extends Area2D

@onready var transition_scene = load("res://Menus/IrisOut.tscn")

func _on_body_entered(body):
	if body is Player and Global.has_newspaper:
		$"../Level Music".stop()
		$SuccessMusic.play()
		var transition = transition_scene.instantiate()
		$"../Camera2D".add_child(transition)
		transition.start_transition()
		await get_tree().create_timer(2).timeout
		Global.goto_scene("res://Menus/EndOfLevel.tscn")
