extends Control

func _ready():
	# Set the lives and level name labels
	$Lives.text = str(Global.total_lives)
	$LevelCount.text = "Level " + str(Global.level_count)

	# Start a timer or wait for player input to proceed to the next level
	$Timer.start()

func _on_timer_timeout():
	Global.start_next_level()
A
