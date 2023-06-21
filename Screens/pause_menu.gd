extends Control

@export var game_world: GameWorld

func _ready():
	# hide the pause menu on the game is starting
	hide()
	game_world.connect("toggle_game_paused", _on_game_world_toggle_game_paused)

func _process(delta):
	pass

func _on_game_world_toggle_game_paused(is_paused: bool):
	if(is_paused):
		show()
	else:
		hide()
	
