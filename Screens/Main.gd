extends Node2D

@export var MainMenu: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_main_menu():
	var main_menu = MainMenu.instantiate()
	add_child(main_menu)
