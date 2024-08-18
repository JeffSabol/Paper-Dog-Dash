# Jeff Sabol
extends Control

var bone_count_display : Label
var time_display : Label

func _ready():
	bone_count_display = get_node("BoneCountDisplay")
	time_display = get_node("TimeDisplay")
	update_bone_count_display()
	update_time_elapsed_display()
	$DateTime.text = get_datetime()
	$LevelDesc.text = Global.get_level_name(Global.level_count - 1)
	animate_success_image()

func update_bone_count_display():
	bone_count_display.text = "Bones Collected: " + str(Global.total_bones)

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
	return dooms_day_algorithm(year, month, day) + "    " + get_time_expression(hour) + "  "  + get_month_name(month) + "  " + str(day) + "  " + str(year)

# Returns a time of day expression. Such as afternoon or evening.
func get_time_expression(hour: int):
	# Morning = 6am to noon
	# Afternoon = noon - 6pm
	# Evening = 6pm - 9pm
	# Night = 9pm - 6am
	if hour >= 6 and hour <12:
		return "Morning"
	elif hour >= 12 and hour < 18:
		return "Afternoon"
	elif hour >= 18 and hour < 21:
		return "Evening"
	else:
		return "Night"

func get_month_name(month: int):
	var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	return months[month - 1]

func dooms_day_algorithm(year: int, month: int, day: int):
	# John Conaway Doom's Day Algorithm
	# https://www.youtube.com/watch?v=z2x3SSBVGJU

	# Calculate the anchor day for the century
	var century = (year / 100) * 100
	var anchor_day = (5 * ((century / 100) % 4) + 2) % 7
	
	# Calculate the doomsday for the year
	var year_of_century = year % 100
	var leap_years = year_of_century / 4
	var doomsday = (year_of_century + leap_years + anchor_day) % 7
	
	# Calculate the doomsday for the month
	var month_doomsdays = {}
	if is_leap_year(year):
		month_doomsdays[1] = 4
		month_doomsdays[2] = 29
	else:
		month_doomsdays[1] = 3
		month_doomsdays[2] = 28

	month_doomsdays[3] = 14 # Pi Day
	month_doomsdays[4] = 4
	month_doomsdays[5] = 9
	month_doomsdays[6] = 6
	month_doomsdays[7] = 11
	month_doomsdays[8] = 8
	month_doomsdays[9] = 5 # I work 9 to 5
	month_doomsdays[10] = 10
	month_doomsdays[11] = 7 # At 7/11
	month_doomsdays[12] = 12

	var doomsday_for_month = month_doomsdays[month]
	
	# Calculate the day of the week
	var day_of_week = (day - doomsday_for_month + doomsday) % 7
	if day_of_week < 0:
		day_of_week += 7  # Make the result non-negative

	# Return the result as a day name
	return day_name(day_of_week)

func calculate_leap_years(currentYear: int) -> int:
	var leap_years_counter = 0
	# currentYear+1 because currentYear could be a leap year
	for year in range(2001, currentYear + 1):
		if is_leap_year(year):
			leap_years_counter += 1
	return leap_years_counter

func is_leap_year(year: int) -> bool:
	return (year % 4 == 0) and ((year % 100 != 0) or (year % 400 == 0))

func day_name(day: int) -> String:
	var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	return days[day]
	
func animate_success_image():
	var tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property($SuccessImage, "modulate", Color.RED, 2)
	tween.tween_property($SuccessImage, "modulate", Color.GREEN, 2)

