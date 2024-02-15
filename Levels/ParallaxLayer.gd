extends ParallaxBackground
 
var speed: float = 100.0

func _process(delta: float) -> void:
	for child in get_children():
		if child is Sprite:
			child.position.x -= speed * delta
			if child.global_position.x + child.texture.get_width() < 0:
				child.position.x += child.texture.get_width() * 2
