extends Control

# Signal to notify when the transition ends
signal transition_finished

func start_transition():
	$ColorRect/AnimationPlayer.play("close")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
