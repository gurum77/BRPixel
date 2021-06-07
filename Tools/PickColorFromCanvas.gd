extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.pick_color_from_canvas)

func drawing_area_input(event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.pick_color_from_canvas):
		return

	if InputManager.is_action_just_released_lbutton(event):
		var pos = get_local_mouse_position()
		pos.x = floor(pos.x)
		pos.y = floor(pos.y)
		NodeManager.get_current_layer().image.lock()
		var color = NodeManager.get_current_layer().image.get_pixel(pos.x, pos.y)
		if color.a != 0:
			StaticData.current_color = color
		NodeManager.get_current_layer().image.unlock()
		
		NodeManager.get_tools().run_last_drawing_tool()
		
