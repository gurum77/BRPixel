extends Control

func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.fill)
	
func drawing_area_input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.fill):
		return
	
		
	if !InputManager.is_action_just_pressed_lbutton(_event):
		return
		
	# image 사본을 복사한다.
	var pos = NodeManager.get_current_layer().get_local_mouse_position()
	pos = GeometryMaker.get_adjusted_point_by_tile_mode(pos)
	var points = get_neighbouring_pixels(pos.x, pos.y)
	UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
	NodeManager.get_current_layer().set_pixels_by_current_color(points)
	UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(points)
	UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()

	
func is_inside_canvas(x, y)->bool:
	return NodeManager.get_current_layer().has_point(Vector2(x, y))
	
func get_neighbouring_pixels(pos_x: int, pos_y: int) -> Array:
	var pixels:Array = []
	
	if !NodeManager.get_current_layer().has_point(Vector2(pos_x, pos_y)):
		return pixels;
	
	var to_check_queue = []
	var checked_queue:Dictionary = Dictionary()
	
	to_check_queue.append(GeometryMaker.to_1D(pos_x, pos_y, StaticData.canvas_width))
	
	NodeManager.get_current_layer().image.lock()
	
	var color = NodeManager.get_current_layer().image.get_pixel(pos_x, pos_y)
	
	while not to_check_queue.empty():
		var idx = to_check_queue.pop_front()
		var p = GeometryMaker.to_2D(idx, StaticData.canvas_width)
		
		if checked_queue.has(idx):
			continue
		checked_queue[idx] = true
		
		if !is_inside_canvas(p.x, p.y):
			continue
		if NodeManager.get_current_layer().image.get_pixel(p.x, p.y) != color:
			continue
		
		# add to result
		pixels.append(p)
		
		# check neighbours
		var x = p.x - 1
		var y = p.y
		if is_inside_canvas(x, y):
			idx = GeometryMaker.to_1D(x, y, StaticData.canvas_width)
			to_check_queue.append(idx)
		
		x = p.x + 1
		if is_inside_canvas(x, y):
			idx = GeometryMaker.to_1D(x, y, StaticData.canvas_width)
			to_check_queue.append(idx)
		
		x = p.x
		y = p.y - 1
		if is_inside_canvas(x, y):
			idx = GeometryMaker.to_1D(x, y, StaticData.canvas_width)
			to_check_queue.append(idx)
		
		y = p.y + 1
		if is_inside_canvas(x, y):
			idx = GeometryMaker.to_1D(x, y, StaticData.canvas_width)
			to_check_queue.append(idx)
			
	NodeManager.get_current_layer().image.unlock()
	
	GeometryMaker.append_symmetry_pixels(pixels)
	return pixels
	
