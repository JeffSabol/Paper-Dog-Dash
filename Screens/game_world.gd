extends Node2D

@export var title_screen_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_back_to_menu_button_pressed():
	$"/root/Global".goto_scene(title_screen_path)
	
