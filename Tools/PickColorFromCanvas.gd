extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.pick_color_from_canvas)

func _input(event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.pick_color_from_canvas):
		return

	if InputManager.is_action_just_pressed_lbutton(event):
		var pos = get_global_mouse_position()
		StaticData.current_layer.image.lock()
		StaticData.current_color = StaticData.current_layer.image.get_pixel(pos.x, pos.y)
		StaticData.current_layer.image.unlock()
		
		NodeManager.get_tools().run_last_drawing_tool()
