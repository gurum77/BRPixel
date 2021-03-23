extends Control

func _input(event):
	if StaticData.current_tool != StaticData.Tool.eraser:
		return
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	var pos = StaticData.current_layer.get_local_mouse_position()	
	if !StaticData.current_layer.has_point(pos):
		return

	StaticData.current_layer.erase_pixel(pos)
