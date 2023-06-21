extends Node2D
class_name GameWorld

@export var title_screen_path: String
@export var starting_level:= 1 

var current_level := 0

signal toggle_game_paused(is_pauseed: bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = starting_level

func _input(event: InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused
		print("game_paused ", game_paused)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
