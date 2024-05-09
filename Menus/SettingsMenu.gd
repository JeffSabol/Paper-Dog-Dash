# Jeff Sabol
# SettingsMenu.gd : The scripting behind the settings menu. Makes the buttons actually work and affect game.
extends Control

# Difficulty button textures
var easy_button_normal = preload("res://Assets/Menu/Settings/Easy.png")
var medium_button_normal = preload("res://Assets/Menu/Settings/Medium.png")
var hard_button_normal = preload("res://Assets/Menu/Settings/Hard.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Fixes the difficulty button always being the easy texture upon opening the settings menu.
	match Global.current_difficulty:
		Global.DifficultyLevel.EASY:
			$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = easy_button_normal
		Global.DifficultyLevel.MEDIUM:
			$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = medium_button_normal
		Global.DifficultyLevel.HARD:
			$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = hard_button_normal

func _on_exit_button_pressed():
	$ButtonSound.play()
	
	# Revert to the previously saved settings
	Global.load_settings()
	Global.apply_settings()
	hide()

func _on_reset_button_pressed():
	$ButtonSound.play()
	
	# Reset all settings to their default values
	Global.config = ConfigFile.new()
	for section in Global.default_settings.keys():
		for key in Global.default_settings[section]:
			Global.config.set_value(section, key, Global.default_settings[section][key])
	Global.apply_settings()
	
	# Set the difficulty button texture to the default (easy) texture
	$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = easy_button_normal
	Global.current_difficulty = Global.DifficultyLevel.EASY
	Global.config.set_value("game", "difficulty", Global.current_difficulty)
	Global.config.save("res://settings.cfg")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()
		
func _on_save_button_pressed():
	Global.config.save("res://settings.cfg")
	$ButtonSound.play()
	hide()

func _on_full_screen_button_pressed():
	$ButtonSound.play()
	
	# Toggle fullscreen mode and update the settings
	var fullscreen = not Global.config.get_value("display", "fullscreen", Global.default_settings["display"]["fullscreen"])
	Global.config.set_value("display", "fullscreen", fullscreen)
	Global.apply_settings()

func _on_difficulty_button_pressed():
	$ButtonSound.play()
	
	Global.current_difficulty = (Global.current_difficulty + 1) % 3 # enum DifficultyLevel { EASY, MEDIUM, HARD }
	
	match Global.current_difficulty:
		Global.DifficultyLevel.EASY:
			$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = easy_button_normal
		Global.DifficultyLevel.MEDIUM:
			$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = medium_button_normal
		Global.DifficultyLevel.HARD:
			$ScrollContainer/VBoxContainer/DifficultyButton.texture_normal = hard_button_normal
	Global.config.set_value("game", "difficulty", Global.current_difficulty)
	Global.config.save("res://settings.cfg")
