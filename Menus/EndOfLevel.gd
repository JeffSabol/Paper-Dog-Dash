extends Control

var bone_count_display : Label
var time_display : Label

func _ready():
	bone_count_display = get_node("BoneCountDisplay")
	time_display = get_node("TimeDisplay")
	update_bone_count_display()
	update_time_elapsed_display()
	print(Time.get_datetime_dict_from_system(false))
	get_datetime()
	
	print(Global.level_count) 
	# level count will be level 2 because we already beat it
	match (Global.level_count):
		2:
			$LevelDesc.text = "Level 1 - New Route"
		3:
			$LevelDesc.text = "Level 2 - "
		4:
			$LevelDesc.text = "Level 3 - "
		5:
			$LevelDesc.text = "Level 4 - "
		6:
			$LevelDesc.text = "Level 5 - "
		7:
			$LevelDesc.text = "Level 6 - "
		_:
			$LevelDesc.text = "Level ??? - Unknown"

func update_bone_count_display():
	bone_count_display.text = "Bones Collected: " + str(Global.total_bones)
	Global.total_bones = 0

func update_time_elapsed_display():
	time_display.text = "Time: " + str(Global.total_time)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_joy_button_pressed(0,JOY_BUTTON_A) or Input.is_joy_button_pressed(0,JOY_BUTTON_B) or Input.is_joy_button_pressed(0,JOY_BUTTON_X) or Input.is_joy_button_pressed(0,JOY_BUTTON_Y):
		Global.goto_next_level()
		
func get_datetime():
	var datetime: Dictionary = Time.get_datetime_dict_from_system(false)
	var year: int = datetime["year"]
	var month: int = datetime["month"]
	var day: int = datetime["day"]
	var hour: int = datetime["hour"]
	print(str(day))
	# Morning = 6am to noon
	# Afternoon = noon - 6pm
	# Evening = 6pm - 9pm
	# Night = 9pm - 6am

func format_time_of_day(hour: int):
	# John Conaway Doom's Day Algorithm
	# TODO
	#return ""
	pass
