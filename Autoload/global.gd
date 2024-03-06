# Jeff Sabol
# global.gd : used for managing global state or functionality that needs to persist across multiple scenes
extends Node

enum DifficultyLevel { EASY, MEDIUM, HARD }
# Easy : Infinite attempts per level.
# Medium: Enemies do not die upon the player being hurt. 3 attempts per level.
# Hard : Enemies one hit the player. Only 1 attempt per level.

# Lives
var total_lives = 9999 # Default value that is overridden by set_difficulty()

# Level changing
var current_scene = null
var level_count = 2 # We want to change to level 2 after level 1
var level_path = "res://Levels/level_" + str(level_count) + ".tscn"

# Newspaper handling
var has_newspaper = false

# Bone handling
var total_bones = 0

# Time handling
var total_time = 170 

# Difficulty handling
var current_difficulty = DifficultyLevel.EASY

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.queue_free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene

func goto_next_level():
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	call_deferred("_deferred_goto_next_level")

func _deferred_goto_next_level():
	# It is now safe to remove the current scene
	current_scene.queue_free()

	# Load the new scene.
	var s = ResourceLoader.load(level_path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
	level_count += 1
	level_path = "res://Levels/level_" + str(level_count) + ".tscn"
	has_newspaper = false

func set_difficulty(new_difficulty: int):
	current_difficulty = new_difficulty
	if(current_difficulty == DifficultyLevel.EASY):
		total_lives = 9999 # infinite lives
	if(current_difficulty == DifficultyLevel.MEDIUM):
		total_lives = 3
	if(current_difficulty == DifficultyLevel.HARD):
		total_lives = 1

func get_difficulty() -> bool:
	return current_difficulty
