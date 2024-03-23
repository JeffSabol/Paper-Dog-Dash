extends Control

# Buttons
@onready var play_button = get_node("Control/HBoxContainer/PlayButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	Global.goto_scene("res://Levels/level_1.tscn")
	
