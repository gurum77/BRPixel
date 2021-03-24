extends Control

var pressed = false

var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
func _ready():
	pass
	
func _draw():
	if StaticData.current_tool != StaticData.Tool.circle:
		return
	var points = GeometryMaker.get_pixels_in_circle(start_point, end_point)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixels_by_current_color(points)
		
		
	return points
		
func _input(_event):
	if StaticData.current_tool != StaticData.Tool.circle:
		return
	
	if Input.is_action_just_pressed("left_button"):
		start_point = get_local_mouse_position()
		pressed = true
	elif Input.is_action_just_released("left_button"):
		end_point = get_local_mouse_position()
		var points = GeometryMaker.get_pixels_in_circle(start_point, end_point)
		StaticData.current_layer.set_pixels_by_current_color(points)
		StaticData.preview_layer.clear(true)
		pressed = false
		
	if pressed:
		end_point = get_local_mouse_position()
		update()
