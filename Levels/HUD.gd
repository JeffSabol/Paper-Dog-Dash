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
		print(Global.level_count)
		Global.level_count=1
		Global.path_level="res://Levels/level_" + str(Global.level_count) + ".tscn"
		print(Global.level_count)
		Global._deferred_goto_next_level()
		pass
	

func _on_level_timer_timeout():
	updateTimer()
