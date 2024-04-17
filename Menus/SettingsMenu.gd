extends Control

# https://docs.godotengine.org/en/stable/classes/class_configfile.html

# Create new ConfigFile object.
var config = ConfigFile.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_exit_button_pressed():
	hide()
	# TODO Unset anything settings

func _on_save_button_pressed():
	config.set_value("Test","test2","test3")
	config.save("res://settings.cfg")

func _on_full_screen_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)





