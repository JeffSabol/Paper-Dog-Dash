extends Control

@export var game_world_path: String
@export var settings_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_button_pressed():
	$"/root/Global".goto_scene(game_world_path)


func _on_settings_button_pressed():
	$"/root/Global".goto_scene(settings_scene_path)
	pass # Replace with function body.
