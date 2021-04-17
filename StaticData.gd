extends Node

enum Tool{pencil, line, rectangle, eraser, fill, change_color, 
circle, select, edit, pick_color_from_canvas, brighter, darker}

enum SymmetryType{no, horizontal, vertical}
var current_tool = Tool.pencil
var current_color = Color.black
var current_palette = null
var current_project_index = 0
var current_frame_index = 0
var current_layer_index = 0
var preview_layer = null

var last_drawing_tool = null
var fill_for_last_drawing_tool = true

var mouse_inside_ui:bool = false
var dragging_grip:bool = false	# grip을 dragging중인지?
var canvas_width = 64
var canvas_height = 64
var enabled_grid = true
var enabled_tilemode = false
var symmetry_type = SymmetryType.no
var horizontal_symmetry_position = 0
var vertical_symmetry_position = 0
var pencil_thickness = 1
var pixel_perfect:bool = false

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
		image = NodeManager.get_current_layer().image
	return image.save_png(path)
	
	

# 저장 
func save_project(path):
	var save_dic={
		"canvas_width" : StaticData.canvas_width,
		"canvas_height" : StaticData.canvas_height,
		"enabled_grid" : StaticData.enabled_grid,
		"enabled_tilemode" : StaticData.enabled_tilemode,
		"symmetry_type" : StaticData.symmetry_type,
		"horizontal_symmetry_position" : StaticData.horizontal_symmetry_position,
		"vertical_symmetry_position" : StaticData.vertical_symmetry_position,
		"pencil_thickness" : StaticData.pencil_thickness,
		"pixel_perfect" : StaticData.pixel_perfect,
		"layers" : get_save_dic_layers()
	}
	var save_file = File.new()
	save_file.open(path, File.WRITE)
	save_file.store_line(to_json(save_dic))
	save_file.close()

# 이미지를 open 한다.
func open_image(parent, path):
	var image:Image = Util.load_image_file(self, path)
	if image == null:
		return
	# 이미지의 크기가 허용치를 벗어나면 오픈 불가
	if image.get_width() < Define.min_canvas_size || image.get_height() < Define.min_canvas_size:
		Util.show_error_message(parent, "Image is too small.")
		return
	if image.get_width() > Define.max_canvas_size || image.get_height() > Define.max_canvas_size:
		Util.show_error_message(parent, "Image is too large.")
		return
	# canvas 사이즈 설정
	StaticData.canvas_width = image.get_width()
	StaticData.canvas_height = image.get_height()
	NodeManager.get_canvas().resize()
	
	# layer를 하나로 만든다.
	NodeManager.get_current_layers().clear_normal_layers()
	var new_layer = NodeManager.get_current_layers().add_layer()
	new_layer.image = image
	new_layer.update_texture()
		
	# 첫번째 layer를 현재 레이어로 설정 
	StaticData.current_layer_index = 0

	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	pass

func get_value(dic:Dictionary, key, default_value:int):
	if dic.has(key):
		return dic[key]
	return default_value
			
func open_project(path):
	var open_file = File.new()
	open_file.open(path, File.READ)
	if open_file.get_position() < open_file.get_len():
		var dic = parse_json(open_file.get_line())
		StaticData.canvas_width = get_value(dic, "canvas_width", StaticData.canvas_width)
		StaticData.canvas_height = get_value(dic, "canvas_height", StaticData.canvas_height)
		StaticData.enabled_grid = get_value(dic, "enabled_grid", StaticData.enabled_grid)
		StaticData.enabled_tilemode = get_value(dic, "enabled_tilemode", StaticData.enabled_tilemode)
		StaticData.symmetry_type = get_value(dic, "symmetry_type", StaticData.symmetry_type)
		StaticData.horizontal_symmetry_position = get_value(dic, "horizontal_symmetry_position", StaticData.horizontal_symmetry_position)
		StaticData.vertical_symmetry_position = get_value(dic, "vertical_symmetry_position", StaticData.vertical_symmetry_position)
		StaticData.pencil_thickness = get_value(dic, "pencil_thickness", StaticData.pencil_thickness)
		StaticData.pixel_perfect = get_value(dic, "pixel_perfect", StaticData.pixel_perfect)
		
		open_project_layers(dic)
	open_file.close()
	NodeManager.get_canvas().resize()
	NodeManager.get_tile_mode_manager().init_tile_layers()
	NodeManager.get_tile_mode_manager().update_force()
	NodeManager.get_symmetry_grips().update_canvas_and_grips()
		
func open_project_layers(var dic:Dictionary):
	# 기존 레이어를 제거한다.
	NodeManager.get_current_layers().clear_normal_layers()
	if !dic.has("layers"):
		return
	var dic_layers:Dictionary = dic["layers"]
	
	for key in dic_layers.keys():
		# layer 추가
		var new_layer = NodeManager.get_current_layers().add_layer()
		new_layer.set_save_dic(dic_layers[key])
		
	# 첫번째 layer를 현재 레이어로 설정 
	StaticData.current_layer_index = 0
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
		
func get_save_dic_layers()->Dictionary:
	var _save_dic:Dictionary
	var layers = NodeManager.get_current_layers().get_normal_layers()
	for layer in layers:
		if !layer.is_need_to_save():
			continue
		_save_dic[layer.index] = layer.get_save_dic()
	return _save_dic
