extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	# Unpause the game
	get_tree().paused = false
	
	var camera = get_tree().root.get_viewport().get_camera_2d()
	#if camera:
		#camera.zoom = Vector2(1, 1)
		
	Global.goto_scene("res://Menus/MainMenu.tscn")
