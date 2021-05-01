extends Control
class_name Pencil

var drawn_points:Dictionary = Dictionary()	# 마우스를 떼기 전에 한번 그려진 포인트를 보
var current_tool = StaticData.Tool.pencil
var start_point
var pixel_perfect_drawer = PixelPerfectDrawer.new()

var released_lbutton_count = 0
class PixelPerfectDrawer:
	const neighbours = [Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1)]
	const corners = [Vector2(1, 1), Vector2(-1, -1), Vector2(-1, 1), Vector2(1, -1)]
	var last_pixels = [null, null]

	func reset() -> void:
		last_pixels = [null, null]

	func set_pixel(image: Image, position: Vector2, color: Color) -> void:
		var color_old = image.get_pixelv(position)
		last_pixels.push_back([position, color_old])
		image.set_pixelv(position, color)

		var corner = last_pixels.pop_front()
		var neighbour = last_pixels[0]

		if corner == null or neighbour == null:
			return

		if position - corner[0] in corners and position - neighbour[0] in neighbours:
			image.set_pixel(neighbour[0].x, neighbour[0].y, neighbour[1])
			last_pixels[0] = corner
			
func _ready():
	NodeManager.get_tools().init_to_start_tool(self, current_tool)
	drawn_points.clear()
	
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(current_tool):
		return

	# 마우스를 이동하면 미리보기 점을 표시한다.
	InputManager.draw_preview_pixel_cursor(self, _event, StaticData.pencil_thickness)
		
	# 처음 클릭하면 첫번째 점을 보관한다.
	if InputManager.is_action_just_pressed_lbutton(_event):
		UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
		pixel_perfect_drawer.reset()
		start_point = get_local_mouse_position()
		var points = GeometryMaker.get_pixels_in_line(start_point, start_point, StaticData.pencil_thickness)
		points = get_new_points(points)
		set_pixels(points)
		UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(points)
	# 마우스를 떼면 undo commit
	elif InputManager.is_action_just_released_lbutton(_event):
		released_lbutton_count += 1
		UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()
		drawn_points.clear()
		
	# 누르고 있는 동안 계속 그림
	if start_point != null && InputManager.is_action_pressed_lbutton(_event):
		var end_point = get_local_mouse_position()
		# 다른 점이면 그린다.
		if !is_same_pixels(start_point, end_point):
			var points = GeometryMaker.get_pixels_in_line(start_point, end_point, StaticData.pencil_thickness)
			points = get_new_points(points)
			set_pixels(points)
			UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer(points)
			start_point = end_point
	

# pixel perfect가 활성화되었는지?
func is_enabled_pixel_perfect()->bool:
	if !StaticData.pixel_perfect:
		return false
	if StaticData.pencil_thickness > 1:
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
	
func set_pixels(points):
	if is_enabled_pixel_perfect():
		NodeManager.get_current_layer().image.lock()
		for point in points:
			pixel_perfect_drawer.set_pixel(NodeManager.get_current_layer().image, point, StaticData.current_color)
		NodeManager.get_current_layer().image.unlock()	
	else:
		NodeManager.get_current_layer().set_pixels_by_current_color(points)
	
func get_key(point)->String:
	return str(point.x as int) + str(",") + str(point.y as int)
	
func get_new_points(points:Array)->Array:
	var new_points:Array = []
	for point in points:
		var key = get_key(point)
		if drawn_points.has(key):
			continue
		new_points.append(point)
		drawn_points[key] = true
	return new_points
