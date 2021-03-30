extends Control

func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.change_color)
	
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.change_color):
		return
	
	if !InputManager.is_action_just_pressed_lbutton(_event):
		return
		
	# image 사본을 복사한다.
	var pos = StaticData.current_layer.get_local_mouse_position()
	var points = get_same_color_pixels(pos.x, pos.y)
	StaticData.current_layer.set_pixels_by_current_color(points)
	
func get_same_color_pixels(x:int, y:int)->Array:
	var pixels:Array = []
	
	if !StaticData.current_layer.has_point(Vector2(x, y)):
		return pixels
		
	StaticData.current_layer.image.lock()
	
	var color = StaticData.current_layer.image.get_pixel(x, y)
	var width = StaticData.current_layer.image.get_width()
	var height = StaticData.current_layer.image.get_height()
	for x1 in range(0, width):
		for y1 in range(0, height):
			if StaticData.current_layer.image.get_pixel(x1, y1) == color:
				pixels.append(Vector2(x1, y1))
	
	
	StaticData.current_layer.image.unlock()
	return pixels
