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
		
		var find_color = StaticData.current_color
		var first = true
		
		# 모든 layer를 돌면서 색을 찾는다.
		# visible인 것만 모두 돈다.
		var layers = NodeManager.get_current_layers().get_normal_layers()		
		for layer in layers:
			if !layer.visible:
				continue
				
			layer.image.lock()
			var color = layer.image.get_pixel(pos.x, pos.y)
			if color.a == 0:
				continue
			if first:
				find_color = color
				first = false
			else:
				find_color = find_color.blend(color)
				
			layer.image.unlock()
		
		StaticData.current_color = find_color
		NodeManager.get_tools().run_last_drawing_tool()
		
