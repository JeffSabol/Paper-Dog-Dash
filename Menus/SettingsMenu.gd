extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_exit_button_pressed():
	# Revert to the previously saved settings
	Global.load_settings()
	Global.apply_settings()
	hide()

func _on_reset_button_pressed():
	# Reset all settings to their default values
	Global.config = ConfigFile.new()
	for section in Global.default_settings.keys():
		for key in Global.default_settings[section]:
			Global.config.set_value(section, key, Global.default_settings[section][key])
	Global.apply_settings()

func _on_save_button_pressed():
	Global.config.save("res://settings.cfg")
	hide()

func _on_full_screen_button_pressed():
	# Toggle fullscreen mode and update the settings
	var fullscreen = not Global.config.get_value("display", "fullscreen", Global.default_settings["display"]["fullscreen"])
	Global.config.set_value("display", "fullscreen", fullscreen)
	Global.apply_settings()








