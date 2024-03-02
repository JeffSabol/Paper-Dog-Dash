# Send the player to the End of Level scene
extends Area2D

@onready var sprite = $Sprite2D

func _on_body_entered(body):
	if body is Player && Global.has_newspaper:
		Global.goto_scene("res://Menus/EndOfLevel.tscn")
