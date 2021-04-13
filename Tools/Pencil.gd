extends Control
class_name Pencil

var drawn_points:Dictionary = Dictionary()	# 마우스를 떼기 전에 한번 그려진 포인트를 보
var current_tool = StaticData.Tool.pencil
var start_point
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
		start_point = get_local_mouse_position()
	
	# 누르고 있는 동안 계속 그림
	if start_point != null && InputManager.is_action_pressed_lbutton(_event):
		var end_point = get_local_mouse_position()
		var points = GeometryMaker.get_pixels_in_line(start_point, end_point, StaticData.pencil_thickness)
		points = get_new_points(points)
		set_pixels(points)
		start_point = end_point

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
