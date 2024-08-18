extends Control


var can_return_to_menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	$Timer.start()  # Assuming the Timer node is called "Timer"
	$OneMoreTime.hide()  # Ensure the label is hidden initially

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_return_to_menu and Input.is_anything_pressed():
		_go_to_first_level()
		
func _on_timer_timeout():
	can_return_to_menu = true
	$OneMoreTime.show()
	pass
	
func _go_to_first_level():
		# Go back to the first level
		Global.total_bones = 0
		Global.level_count = 1
		Global.level_path = "res://Levels/level_" + str(Global.level_count) + ".tscn"
		Global.goto_next_level()
