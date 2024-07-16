extends Control

var settings_menu = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	var resume_button = get_node("VBoxContainer/ResumeButton")
	resume_button.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restore_focus():
	$VBoxContainer/ResumeButton.grab_focus()

func _on_settings_button_pressed():
	$ButtonSound.play()
	settings_menu = load("res://Menus/SettingsMenu.tscn").instantiate()
	var new_scale = Vector2(0.375, 0.375)
	settings_menu.set_scale(new_scale)
	settings_menu.set_position(Vector2(64,80))
	# Place the settings menu on top of any sprites
	settings_menu.z_index = 1
	add_child(settings_menu)
