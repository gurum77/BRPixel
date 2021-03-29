extends Control

var start_point
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.pencil):
		return
		
	# 처음 클릭하면 첫번째 점을 보관한다.
	if InputManager.is_action_just_pressed_lbutton(_event):
		start_point = get_local_mouse_position()
	
	# 누르고 있는 동안 계속 그림
	if InputManager.is_action_pressed_lbutton(_event):
		var end_point = get_local_mouse_position()
		var points = GeometryMaker.get_pixels_in_line(start_point, end_point)
		StaticData.current_layer.set_pixels_by_current_color(points)
		start_point = end_point

	
