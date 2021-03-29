extends Control

var pressed = false

var start_point = Vector2(0, 0)
var end_point = Vector2(0, 0)
func _ready():
	pass
	
func _draw():
	if StaticData.current_tool != StaticData.Tool.line:
		return
	var points = GeometryMaker.get_pixels_in_line(start_point, end_point)
	StaticData.preview_layer.clear()
	StaticData.preview_layer.set_pixels_by_current_color(points)
		
func _gui_input(event):
	pass
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.line):
		return
	if StaticData.current_tool != StaticData.Tool.line:
		return
	
	if InputManager.is_action_just_pressed_lbutton(_event):
		start_point = get_local_mouse_position()
		pressed = true
	elif InputManager.is_action_just_released_lbutton(_event):
		# 빠르게 움직이면서 마우스를 떼면 두번 그려지는 현상을 방지하지 위해서 pressed일때만 사각형을 추가한다.
		if pressed:
			end_point = get_local_mouse_position()
			if start_point == null:
				start_point = end_point
				
			var points = GeometryMaker.get_pixels_in_line(start_point, end_point)
			StaticData.current_layer.set_pixels_by_current_color(points)
			StaticData.preview_layer.clear(true)
			pressed = false
		
	if pressed:
		end_point = get_local_mouse_position()
		update()
		
