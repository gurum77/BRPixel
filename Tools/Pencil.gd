extends Control


func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.pencil):
		return
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		return

	# mouse 좌표가 layer위가 아니면 리턴
	var pos = StaticData.current_layer.get_local_mouse_position()	
	if !StaticData.current_layer.has_point(pos):
		return
		
	StaticData.current_layer.set_pixel_by_current_color(pos)
	
