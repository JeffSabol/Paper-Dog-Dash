extends Control

var bones = 0
var time_left = 50
@onready var timer = $LevelTimer

func _ready():
	$BoneCounter/Bones.text = str(bones)
	$TimeCounter/Seconds.text = str(time_left)

func _on_bone_picked_up():
	bones += 1
	_ready()

func updateTimer():
	time_left -= 1
	Global.total_time = time_left
	$TimeCounter/Seconds.text = str(time_left)
	
	if time_left <= 0:
		# TODO show death screen and restart level
		pass
	


func _on_level_timer_timeout():
	updateTimer()
