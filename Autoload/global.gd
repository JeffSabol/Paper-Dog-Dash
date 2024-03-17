# Jeff Sabol
# global.gd : used for managing global state or functionality that needs to persist across multiple scenes
extends Node

enum DifficultyLevel { EASY, MEDIUM, HARD }
# Easy : Infinite attempts per level.
# Medium: Enemies do not die upon the player being hurt. 3 attempts per level.
# Hard : Enemies one hit the player. Only 1 attempt per level.

# Lives
var total_lives: int = 9999 # Default value that is overridden by set_difficulty()

# Level changing
var current_scene = null
var level_count: int = 2 # We want to change to level 2 after level 1
var level_path: String = "res://Levels/level_" + str(level_count) + ".tscn"

# Newspaper handling
var has_newspaper: bool = false

# Bone handling
var total_bones: int = 0

# Time handling
var total_time: int = 170 

# Difficulty handling
var current_difficulty: int = DifficultyLevel.EASY

# Pausing
var is_paused: bool = false
var pause_menu: Control = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # We don't want to pause our autoloader
	
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path: String) -> void:
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path: String):
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

func goto_next_level() -> void:
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	call_deferred("_deferred_goto_next_level")

func _deferred_goto_next_level() -> void:
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

func set_difficulty(new_difficulty: int) -> void:
	current_difficulty = new_difficulty
	
	match current_difficulty:
		DifficultyLevel.EASY:
			total_lives = 9999 # infinite lives
		DifficultyLevel.MEDIUM:
			total_lives = 3
		DifficultyLevel.HARD:
			total_lives = 1

func get_difficulty() -> int:
	return current_difficulty

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_select") or event.is_action_pressed("pause_button"	):
		toggle_pause()

func toggle_pause() -> void:
	# Show/hide pause menu
	is_paused = !is_paused
	
	
	if is_paused:
		if not pause_menu:
			pause_menu = load("res://Menus/pause_menu.tscn").instantiate()
			
			var hud = current_scene.get_node("Player/HUD")
			
			if hud:
				# Set the pause menu's position to the center of the HUD
				hud.add_child(pause_menu)
			else:
				print("HUD not found")
	else:
		# Remove the pause menu
		if pause_menu and pause_menu.get_parent() == current_scene.get_node("Player/HUD"):
			current_scene.remove_child(pause_menu)
			pause_menu.queue_free()
			pause_menu = null

	get_tree().paused = is_paused
