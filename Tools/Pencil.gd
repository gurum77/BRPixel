extends Control
class_name Pencil

var drawn_points:Dictionary = Dictionary()	# 마우스를 떼기 전에 한번 그려진 포인트를 보
var current_tool = StaticData.Tool.pencil
var start_point
var pixel_perfect_drawer = PixelPerfectDrawer.new()
var symmetry_pixel_perfect_drawer = PixelPerfectDrawer.new()
var released_lbutton_count = 0
var draw_symmetry_pixels = false	# symmetry pixel을 그리는 차례인지?
class PixelPerfectDrawer:
	const neighbours = [Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1)]
	const corners = [Vector2(1, 1), Vector2(-1, -1), Vector2(-1, 1), Vector2(1, -1)]
	var last_pixels = [null, null]

	func reset() -> void:
		last_pixels = [null, null]

	func set_symmetry_pixel(image:Image, position:Vector2, color:Color):
		if StaticData.symmetry_type != StaticData.SymmetryType.no:
			var symmetry_position = GeometryMaker.get_symmetry_pixel(position)
			if NodeManager.get_current_layer().has_point(symmetry_position):
				image.set_pixelv(symmetry_position, color)
				var symmetry_positions = []
				symmetry_positions.append(symmetry_position)
				UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(symmetry_positions)
				
				
	func set_pixel(image: Image, position: Vector2, color: Color) -> void:
		if position.x < 0 || position.y < 0:
			return
		if position.x >= image.get_width() || position.y >= image.get_height():
			return
		var color_old = image.get_pixelv(position)
		last_pixels.push_back([position, color_old])
		image.set_pixelv(position, color)
		

		var corner = last_pixels.pop_front()
		var neighbour = last_pixels[0]

		if corner == null or neighbour == null:
			return

		if position - corner[0] in corners and position - neighbour[0] in neighbours:
			image.set_pixelv(neighbour[0], neighbour[1])
			
			last_pixels[0] = corner
			
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, current_tool)
	drawn_points.clear()
	
func drawing_area_input(_event):
	if StaticData.invalid_mouse_pos_for_tool(current_tool):
		return

	# 마우스를 이동하면 미리보기 점을 표시한다.
	InputManager.draw_preview_pixel_cursor(self, _event, StaticData.pencil_thickness)
		
	# 처음 클릭하면 첫번째 점을 보관한다.
	# test
	if _event is InputEventScreenTouch && _event.pressed:

#		NodeManager.get_debug_label().text = "touch"
		pass
	elif _event is InputEventScreenTouch && !_event.pressed:
#		NodeManager.get_debug_label().text = "untouch"
		pass
		
	if InputManager.is_action_just_pressed_lrbutton(_event):
#		NodeManager.get_debug_label().text = "lbutton pressed"
		UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
		pixel_perfect_drawer.reset()
		symmetry_pixel_perfect_drawer.reset()
		start_point = get_local_mouse_position()
		StaticData.current_user_brush_destination_point = start_point
		var points = GeometryMaker.get_pixels_in_line(start_point, start_point, StaticData.pencil_thickness, false)
		var pixel_with_colors = get_new_pixel_with_colors(points)
		set_pixel_with_colors(pixel_with_colors)
		UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(pixel_with_colors.keys())
		set_symmetry_pixel_with_colors(pixel_with_colors)
	# 마우스를 떼면 undo commit
	elif InputManager.is_action_just_released_lrbutton(_event):
		released_lbutton_count += 1
		UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()
		drawn_points.clear()
		
	# 누르고 있는 동안 계속 그림
	if start_point != null && InputManager.is_action_pressed_lrbutton(_event):
		var end_point = get_local_mouse_position()
		# 다른 점이면 그린다.
		if !is_same_pixels(start_point, end_point):
			var points = GeometryMaker.get_pixels_in_line(start_point, end_point, StaticData.pencil_thickness, false)
			var pixels = get_new_pixel_with_colors(points)
			set_pixel_with_colors(pixels)
			UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(pixels.keys())
			set_symmetry_pixel_with_colors(pixels)
			start_point = end_point
	
# symmetry pixels를 적용한다.
func set_symmetry_pixel_with_colors(pixels:Dictionary):
	if StaticData.symmetry_type == StaticData.SymmetryType.no:
		return
	var symmetry_points = Dictionary()
	for point in pixels.keys():
		var new_point = GeometryMaker.get_symmetry_pixel(point)
		if new_point == null:
			continue
		symmetry_points[new_point] = pixels[point]
	draw_symmetry_pixels = true
	set_pixel_with_colors(symmetry_points)
	UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(symmetry_points.keys())
	draw_symmetry_pixels = false
	
	
# pixel perfect가 활성화되었는지?
func is_enabled_pixel_perfect()->bool:
	if !StaticData.pixel_perfect:
		return false
	if StaticData.pencil_thickness > 1:
		return false
	if StaticData.brush_type == StaticData.BrushType.User:
		return false
		
	return true

		
# point 2개가 같은 pixel인지 비교
func is_same_pixels(point1, point2)->bool:
	var x1:int = floor(point1.x) as int
	var y1:int = floor(point1.y) as int
	var x2:int = floor(point2.x) as int
	var y2:int = floor(point2.y) as int
	if x1 != x2:
		return false
	if y1 != y2:
		return false
	return true
	
func set_pixel_with_colors(pixels:Dictionary):
	if is_enabled_pixel_perfect():
		NodeManager.get_current_layer().image.lock()
		
		for point in pixels.keys():
			if draw_symmetry_pixels:
				symmetry_pixel_perfect_drawer.set_pixel(NodeManager.get_current_layer().image, point, pixels[point])
			else:
				pixel_perfect_drawer.set_pixel(NodeManager.get_current_layer().image, point, pixels[point])
		
		
		NodeManager.get_current_layer().image.unlock()	
		NodeManager.get_current_layer().update_texture()
	else:
		NodeManager.get_current_layer().set_pixel_with_colors(pixels)
	
func get_key(point)->String:
	return str(point.x as int) + str(",") + str(point.y as int)
	
func get_new_pixel_with_colors(points:Array)->Dictionary:
	points = get_new_points(points)
	return GeometryMaker.get_pixel_with_colors_by_brush_type(points)
	
func get_new_points(points:Array)->Array:
	var new_points:Array = []
	for point in points:
		var key = get_key(point)
		if drawn_points.has(key):
			continue
		new_points.append(point)
		drawn_points[key] = true
	return new_points
