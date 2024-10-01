# Jeff Sabol
# Level 6 scripting

extends Node2D

var remote_transform: RemoteTransform2D
var remote_transform_scene: PackedScene  # Variable to hold the PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the RemoteTransform2D scene as a PackedScene
	remote_transform_scene = preload("res://Characters/remote_transform_2d.tscn")  # Ensure this path is correct

	# Get the RemoteTransform2D reference if it exists
	remote_transform = $Player.get_node_or_null("RemoteTransform2D")

func _on_boss_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Player entered the boss zone")

		# Remove RemoteTransform2D from the player if it exists
		if remote_transform:
			remote_transform.queue_free()  # Remove the node from the scene tree
			remote_transform = null  # Reset the reference to prevent stale references

func _on_boss_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		print("Player exited the boss zone")

		# Re-add the RemoteTransform2D to the player if it was removed
		if remote_transform == null:
			# Create a new instance of the RemoteTransform2D scene
			var new_transform = remote_transform_scene.instantiate()  # Use instantiate() in Godot 4
			# Set the properties of the new RemoteTransform2D to point to the player
			new_transform.remote_path = $Camera2D.get_path()
			$Player.add_child(new_transform)  # Add it back to the player
			remote_transform = new_transform  # Update the reference to the new transform
