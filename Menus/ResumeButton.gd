extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button's pressed signal to the _on_ResumeButton_pressed function
	self.connect("pressed", Callable(self, "_on_ResumeButton_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_ResumeButton_pressed():
	# Call the pause_game function from the global.gd script
	Global.toggle_pause()
