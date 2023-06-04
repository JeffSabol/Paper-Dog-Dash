extends Control

var bone_count_display : Label

func _ready():
	bone_count_display = get_node("BoneCountDisplay")
	update_bone_count_display()
	
func update_bone_count_display():
	bone_count_display.text = "Bones Collected: " + str(Global.total_bones)
	Global.total_bones = 0
