extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$"../../ButtonSound".play()
	# Add a slight delay so that the entire audio plays
	await get_tree().create_timer($"../../ButtonSound".stream.get_length()).timeout
	
	# Unpause the game
	get_tree().paused = false
	
	if Global.pause_menu:
		Global.pause_menu.hide()
		Global.is_paused = false
		Global.pause_menu = null
		
	Global.goto_scene("res://Menus/MainMenu.tscn")
