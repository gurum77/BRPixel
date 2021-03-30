extends Node

enum Tool{pencil, line, rectangle, eraser, fill, change_color, circle, select}

var current_tool = Tool.pencil
var current_color = Color.black
var current_palette = null
var current_layer = null
var preview_layer = null

var mouse_inside_ui:bool = false
var dragging_grip:bool = false	# grip을 dragging중인지?
var canvas_width = 64
var canvas_height = 64

# selected area
var selected_area = Rect2(0, 0, 0, 0)

# mosue 좌표가 tool에 적용하기에 부적합한지?
func invalid_mouse_pos_for_tool(tool_type)->bool:
	# mouse가 ui에 있으면 false
	if StaticData.mouse_inside_ui:
		return true
		
	# 같은 tool이 아니면 false
	if StaticData.current_tool != tool_type:
		return true
		
	# grip을 dragging중이면 tool동작을 멈춘다
	if StaticData.dragging_grip:
		return true
		
	return false
	
# selected_area를 제거한다.
func clear_selected_area():
	set_selected_area([])
	
# points로 selected area를 설정한다.
func set_selected_area(var points:Array):
	if points == null || points.size() == 0:
		selected_area = Rect2(0, 0, 0, 0)
		return
		
	var left
	var right
	var top
	var bottom
	var first = true
	for point in points:
		if first:
			left = point.x
			right = point.x
			top = point.y
			bottom = point.y
			first = false
		else:
			left = min(left, point.x)
			right = max(right, point.x)
			bottom = min(bottom, point.y)
			top = max(top, point.y)
	selected_area = Rect2(left, bottom, right - left, top - bottom)
		
# selected area활성화 되어 있는지?
func enabled_selected_area()->bool:
	if selected_area.size.x == 0 && selected_area.size.y == 0:
		return false
	else:
		return true
	
# 좌표가 working area 안쪽인지?
# selected_area가 있다면 selected_area 안쪽만 유효함
# selected_area가 없다면 canvas 크기 안쪽이면 유효함
func inside_working_area(point)->bool:
	if !enabled_selected_area():
		return true
	return selected_area.has_point(point)
		
func _ready():
	pass
	
