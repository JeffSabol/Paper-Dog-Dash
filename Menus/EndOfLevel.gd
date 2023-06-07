extends Control

var bone_count_display : Label
var time_display : Label

func _ready():
	bone_count_display = get_node("BoneCountDisplay")
	time_display = get_node("TimeDisplay")
	update_bone_count_display()
	update_time_elapsed_display()
	
func update_bone_count_display():
	bone_count_display.text = "Bones Collected: " + str(Global.total_bones)
	Global.total_bones = 0

func update_time_elapsed_display():
	time_display.text = "Time: " + str(Global.total_time)
