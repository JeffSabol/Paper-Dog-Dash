extends Control

func _ready():
	# Set the lives and level name labels
	$Lives.text = str(Global.total_lives)
	$LevelName.text = Global.get_level_name(Global.level_count)
	
	# Start a timer or wait for player input to proceed to the next level
	$Timer.start()

func _on_timer_timeout():
	Global.start_next_level()
