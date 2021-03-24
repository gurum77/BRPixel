extends Control

func _input(event):
	if StaticData.current_tool != StaticData.Tool.fill:
		return
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
		
	# image 사본을 복사한다.
	var pos = StaticData.current_layer.get_local_mouse_position()
	var points = get_neighbouring_pixels(pos.x, pos.y)
	StaticData.current_layer.set_pixels_by_current_color(points)

	
func is_inside_canvas(x, y)->bool:
	return StaticData.current_layer.has_point(Vector2(x, y))
	
func get_neighbouring_pixels(pos_x: int, pos_y: int) -> Array:
	var pixels:Array
	
	if !StaticData.current_layer.has_point(Vector2(pos_x, pos_y)):
		return pixels;
	
	var to_check_queue = []
	var checked_queue:Dictionary
	
	to_check_queue.append(GeometryMaker.to_1D(pos_x, pos_y, StaticData.canvas_width))
	
	StaticData.current_layer.image.lock()
	
	var color = StaticData.current_layer.image.get_pixel(pos_x, pos_y)
	
	while not to_check_queue.empty():
		var idx = to_check_queue.pop_front()
		var p = GeometryMaker.to_2D(idx, StaticData.canvas_width)
		
		if checked_queue.has(idx):
			continue
		checked_queue[idx] = true
		
		if !is_inside_canvas(p.x, p.y):
			continue
		if StaticData.current_layer.image.get_pixel(p.x, p.y) != color:
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
			
	StaticData.current_layer.image.unlock()
	return pixels
	
