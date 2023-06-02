extends Area2D

@onready var sprite = $Sprite2D

func _on_body_entered(body):
	if body is Player:
		print("Player  touched house")
		get_tree().change_scene_to_file("res://Menus/EndOfLevel.tscn")
