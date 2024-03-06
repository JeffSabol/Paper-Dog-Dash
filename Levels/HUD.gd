extends Control

var bones = 0
var time_left = 170

func _ready():
	$BoneCounter/Bones.text = str(bones)
	$TimeCounter/Seconds.text = str(time_left)
	Global.total_time = time_left

func _on_bone_picked_up():
	bones += 1
	_ready()
func updateTimer():
	time_left = Global.total_time
	time_left -= 1
	Global.total_time = time_left
	$TimeCounter/Seconds.text = str(time_left)
	
	if time_left <= 0:
		print(str(Global.total_lives))
		Global.total_lives -= 1
		print(str(Global.total_lives))
		
		if (Global.total_lives > 0):
			# Restart the current level
			Global._deferred_goto_scene("res://Levels/level_" + str(Global.level_count-1) + ".tscn")
		else:
			# Reset the lives depending on the difficulty
			if (Global.current_difficulty == Global.DifficultyLevel.EASY):
				Global.total_lives = 9999
			if (Global.current_difficulty == Global.DifficultyLevel.MEDIUM):
				Global.total_lives = 3
			if (Global.current_difficulty == Global.DifficultyLevel.HARD):
				Global.total_lives = 1
			
			# Go back to the first level
			Global.level_count=1
			Global.level_path="res://Levels/level_" + str(Global.level_count) + ".tscn"
			Global._deferred_goto_next_level()
			pass
	

func _on_level_timer_timeout():
	updateTimer()
