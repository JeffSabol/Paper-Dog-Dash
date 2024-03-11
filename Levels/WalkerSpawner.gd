extends Node2D

@export var mole_walker: PackedScene  = preload("res://Characters/Enemies/MoleRoamer.tscn")
@export var spawn_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if mole_walker:
		var mole = mole_walker.instantiate()
		mole.position = spawn_position
		add_child(mole)
	else:
		null
