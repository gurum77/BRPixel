extends Node

enum Tool{pencil, line, rectangle, eraser, fill, change_color, circle, select, edit}

var current_tool = Tool.pencil
var current_color = Color.black
var current_palette = null
var current_layer = null
var preview_layer = null

var mouse_inside_ui:bool = false
var dragging_grip:bool = false	# grip을 dragging중인지?
var canvas_width = 64
var canvas_height = 64
var enabled_grid = true

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
	
# image로 저장한다.
func save_image(path, selected_area_only):
	var image:Image
	if selected_area_only:
		image = Util.create_image_from_selected_area()
	else:
		image = StaticData.current_layer.image
	return image.save_png(path)
	
	

# 저장 
func save_project(path):
	var save_dic={
		"canvas_width" : StaticData.canvas_width,
		"canvas_height" : StaticData.canvas_height,
		"enabled_grid" : StaticData.enabled_grid,
		"layers" : get_save_dic_layers()
	}
	var save_file = File.new()
	save_file.open(path, File.WRITE)
	save_file.store_line(to_json(save_dic))
	save_file.close()

func open_project(path):
	var open_file = File.new()
	open_file.open(path, File.READ)
	if open_file.get_position() < open_file.get_len():
		var dic = parse_json(open_file.get_line())
		StaticData.canvas_width = dic["canvas_width"]
		StaticData.canvas_height = dic["canvas_height"]
		StaticData.enabled_grid = dic["enabled_grid"]
		open_project_layers(dic)
	open_file.close()
	NodeManager.get_canvas().resize()
		
func open_project_layers(var dic:Dictionary):
	# 기존 레이어를 제거한다.
	NodeManager.get_layers().clear_normal_layers()
	if !dic.has("layers"):
		return
	var dic_layers:Dictionary = dic["layers"]
	
	for key in dic_layers.keys():
		# layer 추가
		var new_layer = NodeManager.get_layers().add_layer()
		new_layer.set_save_dic(dic_layers[key])
		
	# 첫번째 layer를 현재 레이어로 설정 
	StaticData.current_layer = NodeManager.get_layers().get_layer(0)

	# layer index 갱신
	NodeManager.get_layers().update_layer_index()
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
		
func get_save_dic_layers()->Dictionary:
	var _save_dic:Dictionary
	var layers = NodeManager.get_layers().get_normal_layers()
	for layer in layers:
		if !layer.is_need_to_save():
			continue
		_save_dic[layer.index] = layer.get_save_dic()
	return _save_dic
