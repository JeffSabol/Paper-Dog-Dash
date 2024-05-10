# Jeff Sabol
# MainMenu.gd : The scripting bhind navigating the main menu's control node. AKA the buttons and stuff.
extends Control

# Buttons
#@onready var play_button = get_node("Control/HBoxContainer/PlayButton")

# Flag to track if input has been detected
var input_detected = false

# Settings menu
var settings_menu = null

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
	$ButtonSound.play()
	# Add a slight delay so that the entire audio plays
	await get_tree().create_timer($ButtonSound.stream.get_length()).timeout
	Global.goto_scene("res://Levels/level_1.tscn")
	

func _on_settings_button_pressed():
	$ButtonSound.play()
	settings_menu = load("res://Menus/SettingsMenu.tscn").instantiate()
	add_child(settings_menu)

func _on_exit_button_pressed():
	# EXIT game
	$ButtonSound.play()
	# Add a slight delay so that the entire audio plays
	await get_tree().create_timer($ButtonSound.stream.get_length()).timeout
	get_tree().quit()

func _on_main_menu_tune_finished():
	$"../MainMenuTune".play()

func restore_focus():
	$HBoxContainer/PlayButton.grab_focus()
