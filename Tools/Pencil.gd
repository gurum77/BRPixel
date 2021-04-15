extends Control
class_name Pencil

var drawn_points:Dictionary = Dictionary()	# 마우스를 떼기 전에 한번 그려진 포인트를 보
var current_tool = StaticData.Tool.pencil
var start_point
var origin_pixels = []	# pixel perfect가 적용되지 않은 곳의 원래 pixel(OriginPixel의 array)

func _ready():
	NodeManager.get_tools().init_to_start_tool(self, current_tool)
	drawn_points.clear()
	
func _input(_event):
	if StaticData.invalid_mouse_pos_for_tool(current_tool):
		return

	if InputManager.is_action_just_released_lbutton(_event)		:
		drawn_points.clear()
		
	# 마우스를 이동하면 미리보기 점을 표시한다.
	InputManager.draw_preview_pixel_cursor(self, _event, StaticData.pencil_thickness)
		
	# 처음 클릭하면 첫번째 점을 보관한다.
	if InputManager.is_action_just_pressed_lbutton(_event):
		origin_pixels.clear()
		start_point = get_local_mouse_position()
		var points = GeometryMaker.get_pixels_in_line(start_point, start_point, StaticData.pencil_thickness)
		if is_enabled_pixel_perfect():
			append_origin_pixels(points)
		points = get_new_points(points)
		set_pixels(points)
	
	# 누르고 있는 동안 계속 그림
	if start_point != null && InputManager.is_action_pressed_lbutton(_event):
		var end_point = get_local_mouse_position()
		# 다른 점이면 그린다.
		if !is_same_pixels(start_point, end_point):
			var points = GeometryMaker.get_pixels_in_line(start_point, end_point, StaticData.pencil_thickness)
			if is_enabled_pixel_perfect():
				append_origin_pixels(points)
			points = get_new_points(points)
			set_pixels(points)
			
			# pixel perfect때문에 원래 pixel로 그려야 할 곳을 찾아서 그린다.
			if is_enabled_pixel_perfect():
				var origin_pixels_to_ = get_origin_pixels_to_(points)
				StaticData.current_layer.set_origin_pixels(pixels_by_current_color(points)
			start_point = end_point

# pixel perfect가 활성화되었는지?
func is_enabled_pixel_perfect()->bool:
	if !StaticData.pixel_perfect:
		return false
	if StaticData.pencil_thickness > 1:
		return false
	return true
	
# pixel perfect 적용되는 곳에 원래 pixel을 그려넣기 위해 보관한다.
func append_origin_pixels(new_points):
	StaticData.current_layer.image.lock()
	for new_point in new_points:
		var color = StaticData.current_layer.image.get_pixel(new_point.x, new_point.y)
		var origin_pixel = OriginPixel.new()
		origin_pixel.point = new_point
		origin_pixel.color = color
		origin_pixels.append(origin_pixel)
	StaticData.current_layer.image.unlock()
		
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
	StaticData.current_layer.set_pixels_by_current_color(points)
	
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
