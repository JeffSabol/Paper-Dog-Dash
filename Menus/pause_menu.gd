extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var resume_button = get_node("VBoxContainer/ResumeButton")
	resume_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
