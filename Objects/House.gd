# Jeff Sabol
# Play a closing animation transition scene
# Send the player to the End of Level scene

extends Area2D

@onready var transition_scene = load("res://Menus/IrisOut.tscn")
# Fixes the player re-entering the house and messing up the scene transition animation
var is_already_ending = false

func _on_body_entered(body):
	if body is Player and Global.has_newspaper and not is_already_ending:
		is_already_ending = true
		$"../Level Music".stop()
		$SuccessMusic.play()
		var transition = transition_scene.instantiate()
		# Make the animation appears on top of all other nodes
		transition.z_index = 20
		$"../Camera2D".add_child(transition)
		transition.start_transition()
		await get_tree().create_timer(2).timeout
		Global.goto_scene("res://Menus/EndOfLevel.tscn")
