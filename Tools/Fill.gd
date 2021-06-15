extends Control
class_name FillTool
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, StaticData.Tool.fill)
	
func drawing_area_input(_event):
	if StaticData.invalid_mouse_pos_for_tool(StaticData.Tool.fill):
		return
	
		
	if !InputManager.is_action_just_released_lbutton(_event):
		return
		
	# image 사본을 복사한다.
	var pos = NodeManager.get_current_layer().get_local_mouse_position()
	pos = GeometryMaker.get_adjusted_point_by_tile_mode(pos)
	var points = get_neighbouring_pixels(pos.x, pos.y)
	var pixel_with_colors = GeometryMaker.get_pixel_with_colors_by_brush_type(points)
	
	UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
	NodeManager.get_current_layer().set_pixel_with_colors(pixel_with_colors)
	UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(pixel_with_colors.keys())
	UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()

	
func is_inside_canvas(image:Image, x, y)->bool:
	if x < 0 || y < 0:
		return false
	if x >= image.get_width() || y >= image.get_height():
		return false
	return true
	
func get_neighbouring_pixels(pos_x: int, pos_y: int) -> Array:
	var pixels:Array = []
	
	var image = NodeManager.get_current_layer().image
	if !is_inside_canvas(image, pos_x, pos_y):
		return pixels;
#	if !NodeManager.get_current_layer().has_point(Vector2(pos_x, pos_y)):
#		return pixels;
	
	var to_check_queue = []
	var checked_queue:Dictionary = Dictionary()
	
	to_check_queue.append(GeometryMaker.to_1D(pos_x, pos_y, StaticData.canvas_width))
	
	image.lock()
	
	var width = image.get_width()
	var height = image.get_height()
	
	var to2Ds = []
	var to1Ds = [[]]
	var idx_tmp = 0
	to2Ds.resize(width * height)
	to1Ds.resize(width)
	for x in width:
		to1Ds[x] = []
		to1Ds[x].resize(height)
	
	for x in width:
		for y in height:
			idx_tmp = GeometryMaker.to_1D(x, y, width)
			to1Ds[x][y] = idx_tmp
			to2Ds[idx_tmp] = Vector2(x, y)
			
	
	var color = image.get_pixel(pos_x, pos_y)
	while not to_check_queue.empty():
		var idx = to_check_queue.pop_front()
		var p = to2Ds[idx] # GeometryMaker.to_2D(idx, width)

		
		if checked_queue.has(idx):
			continue
		checked_queue[idx] = true
		
		if !is_inside_canvas(image, p.x, p.y):
			continue
		if image.get_pixel(p.x, p.y) != color:
			continue
		
		
		# add to result
		pixels.append(p)
		
		# check neighbours
		var x = p.x - 1
		var y = p.y
		if is_inside_canvas(image, x, y):
			idx = to1Ds[x][y]# GeometryMaker.to_1D(x, y, width)
			to_check_queue.append(idx)
		
		x = p.x + 1
		if is_inside_canvas(image, x, y):
			idx = to1Ds[x][y]# GeometryMaker.to_1D(x, y, width)
			to_check_queue.append(idx)
		
		x = p.x
		y = p.y - 1
		if is_inside_canvas(image, x, y):
			idx = to1Ds[x][y]# GeometryMaker.to_1D(x, y, width)
			to_check_queue.append(idx)
		
		y = p.y + 1
		if is_inside_canvas(image, x, y):
			idx = to1Ds[x][y]# GeometryMaker.to_1D(x, y, width)
			to_check_queue.append(idx)
			
	image.unlock()
	
	GeometryMaker.append_symmetry_pixels(pixels)
	return pixels
	
