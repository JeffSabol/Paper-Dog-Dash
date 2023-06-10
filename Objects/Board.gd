extends Sprite2D

@onready var level_desc = $LevelDesc

# Called when the node enters the scene tree for the first time.
func _ready():
	level_desc.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	level_desc.show()


func _on_area_2d_body_exited(body):
	level_desc.hide()
