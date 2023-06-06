extends Control

var bones = 0

func _ready():
	$Bones.text = str(bones)


func _on_bone_picked_up():
	bones += 1
	_ready()
