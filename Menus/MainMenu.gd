extends Control

# Buttons
#@onready var play_button = get_node("Control/HBoxContainer/PlayButton")

# Flag to track if input has been detected
var input_detected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not input_detected:
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			var play_button = get_node($"HBoxContainer/PlayButton".get_path())
			if play_button:
				input_detected = true
				play_button.grab_focus()
			else:
				print("PlayButton not found")


func _on_play_button_pressed():
	Global.goto_scene("res://Levels/level_1.tscn")
	


func _on_exit_button_pressed():
	# EXIT game
	get_tree().quit()
