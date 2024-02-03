@tool
extends Control

@export var device: int = 0

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	# Set the size, the layout isn't dynamic and based on something I sketched!
	size = Vector2(81, 69)
	
	# Draw the background
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.15, 0.15, 0.15, 0.45))
	
	draw_trigger(Vector2(5, 5), Input.get_joy_axis(device, JOY_AXIS_TRIGGER_LEFT))
	draw_bumper(Vector2(5, 17), Input.is_joy_button_pressed(device, JOY_BUTTON_LEFT_SHOULDER))

	draw_trigger(Vector2(52, 5), Input.get_joy_axis(device, JOY_AXIS_TRIGGER_RIGHT))
	draw_bumper(Vector2(52, 17), Input.is_joy_button_pressed(device, JOY_BUTTON_RIGHT_SHOULDER))
		
	var dpad_position = Vector2(4, 26)

	# Draw dpad going from left, top, right and bottom
	draw_dpad_arrow(dpad_position + Vector2(1, 8), deg_to_rad(-90), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_LEFT))
	draw_dpad_arrow(dpad_position + Vector2(8, 1), deg_to_rad(0), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_UP))
	draw_dpad_arrow(dpad_position + Vector2(15, 8), deg_to_rad(90), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_RIGHT))
	draw_dpad_arrow(dpad_position + Vector2(8, 15), deg_to_rad(180), Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_DOWN))
	
	draw_joystick(Vector2(30, 56), Input.get_joy_axis(device, JOY_AXIS_LEFT_X), Input.get_joy_axis(device, JOY_AXIS_LEFT_Y), Input.is_joy_button_pressed(device, JOY_BUTTON_LEFT_STICK))
	draw_joystick(Vector2(49, 56), Input.get_joy_axis(device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y), Input.is_joy_button_pressed(device, JOY_BUTTON_RIGHT_STICK))
	
	var face_buttons_position = Vector2(49, 25)
	
	# Draw face buttons going from left, top, right and bottom
	draw_face_button(face_buttons_position + Vector2(1, 9), Input.is_joy_button_pressed(device, JOY_BUTTON_X))
	draw_face_button(face_buttons_position + Vector2(9, 1), Input.is_joy_button_pressed(device, JOY_BUTTON_Y))
	draw_face_button(face_buttons_position + Vector2(17, 9), Input.is_joy_button_pressed(device, JOY_BUTTON_B))
	draw_face_button(face_buttons_position + Vector2(9, 17), Input.is_joy_button_pressed(device, JOY_BUTTON_A))
	
	draw_option_button(Vector2(33, 27), Input.is_joy_button_pressed(device, JOY_BUTTON_BACK))
	draw_option_button(Vector2(42, 27), Input.is_joy_button_pressed(device, JOY_BUTTON_START))

func draw_option_button(position: Vector2, is_pressed: bool) -> void:
	var width = 6
	var height = 5
	var color = Color.RED if is_pressed else Color.WHITE
	
	draw_rect(Rect2(position.x, position.y, width, height), Color.BLACK)
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, height - 2), color)

func draw_dpad_arrow(position: Vector2, angle: float, is_pressed: bool) -> void:
	var width = 9
	var height = 9
	var color = Color.RED if is_pressed else Color.WHITE
	
	# Points are for an arrow facing downwards
	var points: Array[Vector2] = [
		# Top left corner
		Vector2.ZERO, 
		# Top right corner
		Vector2.ZERO + Vector2(width, 0),
		# Right edge
		Vector2.ZERO + Vector2(width, height / 2),
		# Arrow point
		Vector2.ZERO + Vector2(width / 2, height),
		# Left edge
		Vector2.ZERO + Vector2(0, height / 2),
		# Top left corner again
		Vector2.ZERO,
	]
	
	var bounds = Rect2(position, Vector2.ZERO)
	
	# Rotate all the points and create a bounding box that contains them
	for index in points.size():
		var point = points[index]
		
		points[index] = point.rotated(angle)
		bounds = bounds.expand(points[index])
	
	# Re-align all the points so that the pivot point is always in the top left
	for index in points.size():
		var point = points[index]
		
		points[index] = position + (point - bounds.position)
		
	draw_polygon(points, [color])
	draw_polyline(points, Color.BLACK)

func draw_face_button(position: Vector2, is_pressed: bool) -> void:
	var radius = 5
	var color = Color.RED if is_pressed else Color.WHITE
	
	# Add the radius so that the pivot point is in the top left
	draw_circle(position + Vector2(radius, radius), radius, Color.BLACK)
	draw_circle(position + Vector2(radius, radius), radius - 1, color)

func draw_bumper(position: Vector2, is_pressed: bool) -> void:
	var width = 24
	var height = 6
	var color = Color.RED if is_pressed else Color.WHITE
	
	draw_rect(Rect2(position.x, position.y, width, height), Color.BLACK)
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, height - 2), color)
	
func draw_trigger(position: Vector2, axis: float) -> void:
	var width = 24
	var height = 10
	
	# Draw background
	draw_rect(Rect2(position.x, position.y, width, height), Color.BLACK)
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, height - 2), Color.WHITE)
	
	# Draw fill that fills up like a nice filling fill
	draw_rect(Rect2(position.x + 1, position.y + 1, width - 2, (height - 2) * axis), Color.RED)

func draw_joystick(position: Vector2, axis_x: float, axis_y: float, is_pressed: bool) -> void:
	var radius = 8
	var max_distance = 4
	var color = Color.RED if is_pressed else Color.WHITE
	
	# Draw stick container
	draw_circle(position, radius, Color.BLACK)
	draw_circle(position, radius - 1, Color.GRAY)

	# Draw the actual stick that moves around
	draw_circle(position + Vector2(axis_x, axis_y) * max_distance, radius - 2, Color.BLACK)
	draw_circle(position + Vector2(axis_x, axis_y) * max_distance, radius - 3, color)
