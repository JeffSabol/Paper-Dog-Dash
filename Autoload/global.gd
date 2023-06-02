extends Node

var current_scene = null
var level_count = 2 # we want to change to level 2 after level 1
var path = "res://Levels/level_" + str(level_count) + ".tscn"

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene():
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	call_deferred("_deferred_goto_scene")


func _deferred_goto_scene():
	# It is now safe to remove the current scene
#	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
	level_count += 1
	path = "res://Levels/level_" + str(level_count) + ".tscn"
