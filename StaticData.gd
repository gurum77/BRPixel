extends Node

enum Tool{none, zoom, pencil, line, rectangle, eraser, fill, change_color, 
circle, select, edit, pick_color_from_canvas, brighter, darker}

enum SymmetryType{no, horizontal, vertical}

enum BrushType{rectangle, circle}

var current_tool = Tool.pencil
var current_color = Color.black
var current_frame_index = 0
var current_layer_index = 0
var current_palette_index = 0
var preview_layer = null
var cursor_layer = null

var last_drawing_tool = null
var fill_for_last_drawing_tool = true

var mouse_inside_ui:bool = false
var dragging_grip:bool = false	# grip을 dragging중인지?
var project_name = "untitled"
var canvas_width = 64
var canvas_height = 64
var enabled_grid = true
var enabled_tilemode = false
var symmetry_type = SymmetryType.no
var brush_type = BrushType.rectangle
var horizontal_symmetry_position = 0
var vertical_symmetry_position = 0
var pencil_thickness = 1
var palette_size = 50
var pixel_perfect:bool = false
var delay_per_frame = 0.3


# selected area
var selected_area = Rect2(0, 0, 0, 0)
	
# mosue 좌표가 tool에 적용하기에 부적합한지?
func invalid_mouse_pos_for_tool(tool_type)->bool:
	# mouse가 ui에 있으면 false
	var pos = NodeManager.get_drawing_area().get_global_mouse_position()
	var rect = Rect2(NodeManager.get_drawing_area().rect_global_position, NodeManager.get_drawing_area().rect_size)
	if !rect.has_point(pos):
		return true
#	if StaticData.mouse_inside_ui:
#		return true
		
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
	if point.x < 0 || point.y < 0:
		return false
	if point.x >= StaticData.canvas_width || point.y >= StaticData.canvas_height:
		return false
	if !enabled_selected_area():
		return true
	return selected_area.has_point(point)
		
func _ready():
	pass
	
# image로 저장한다.
func save_image(path:String, selected_area_only, sprite_sheet=false):
	if selected_area_only:
		var image:Image = Util.create_image_from_selected_area()
		return image.save_png(path)
	else:
		if sprite_sheet:
			var image:Image = NodeManager.get_frames().create_sprite_sheet_image()
			return image.save_png(path)
		else:
			var err = OK
			var images = NodeManager.get_frames().create_all_frame_images()
			var num = 1
			var basename = path.get_basename()
			var ext = path.get_extension()
			for image in images:
				var cur_path = "%s_%d.%s"%[basename,num,ext]
				var cur_err = image.save_png(cur_path)
				if cur_err != OK:
					err = FAILED
				num += 1
			return err
	
# thumbnail저장을 위한 layer를 만든다.
# 현재 작업중인 frame을 저장한다.
func create_thumbnail_layer()->Layer:
	var layer:Layer = Layer.new()
	layer._ready()
	layer.image = NodeManager.get_current_frame().get_layers().create_layers_image()
	return layer
# 저장 
func save_project(path):
	# thumbnail을 저장만 하고 프로젝트를 열때 thumbnail을 읽을 필요는 없다
	# thumbnail은 file dialog에서 표시하기 위함
	var thumbnail_layer:Layer = create_thumbnail_layer()
	var save_dic={
		"thumbnail" : thumbnail_layer.get_save_dic(),
		"project_name" : StaticData.project_name,
		"canvas_width" : StaticData.canvas_width,
		"canvas_height" : StaticData.canvas_height,
		"enabled_grid" : StaticData.enabled_grid,
		"enabled_tilemode" : StaticData.enabled_tilemode,
		"symmetry_type" : StaticData.symmetry_type,
		"brush_type" : StaticData.brush_type,
		"horizontal_symmetry_position" : StaticData.horizontal_symmetry_position,
		"vertical_symmetry_position" : StaticData.vertical_symmetry_position,
		"pencil_thickness" : StaticData.pencil_thickness,
		"palette_size" : StaticData.palette_size,
		"pixel_perfect" : StaticData.pixel_perfect,
		"delay_per_frame" : StaticData.delay_per_frame,
		"current_frame_index" : StaticData.current_frame_index,
		"current_layer_index" : StaticData.current_layer_index,
		"current_palette_index" : StaticData.current_palette_index,
		"frames" : get_save_dic_frames(),
		"palettes" : get_save_dic_palettes()
	}
	var save_file = File.new()
	save_file.open(path, File.WRITE)
	save_file.store_line(to_json(save_dic))
	save_file.close()

# 이미지를 open 한다.
func open_image(parent, path, var rows=1, var cols=1):
	var image:Image = Util.load_image_file(self, path)
	if image == null:
		return
		
	var width = image.get_width() / cols
	var height = image.get_height() / rows
	
	# 이미지의 크기가 허용치를 벗어나면 오픈 불가
	if width < Define.min_canvas_size || height < Define.min_canvas_size:
		Util.show_error_message(parent, "Image is too small.")
		return
	if width > Define.max_canvas_size || height > Define.max_canvas_size:
		Util.show_error_message(parent, "Image is too large.")
		return
	# canvas 사이즈 설정
	StaticData.canvas_width = width
	StaticData.canvas_height = height
	NodeManager.get_canvas().resize()
	
	# preview layer 다시 설정
	StaticData.preview_layer.init_size()
	
	# frame을 필요한 만큼 만든다.
	NodeManager.get_frames().clear_frames()
	var rects = Util.get_rects(image.get_width(), image.get_height(), rows, cols)
	for rect in rects:
		# frame 추가
		var frame = NodeManager.get_frames().add_frame()
		if frame == null:
			continue

		# layer
		var layer = frame.get_layers().get_layer(0)
		if layer == null:
			continue
			
		# rect만큼 이미지를 뜯어 온다.
		layer.image = Util.get_image_in_rect(image, rect)
		layer.update_texture()
	
		
	# 첫번째 frame, layer를 현재 레이어로 설정 
	StaticData.current_frame_index = 0
	StaticData.current_layer_index = 0

	# frame, layer button 갱신
	NodeManager.get_frame_panel().regen_frame_buttons()
	NodeManager.get_layer_panel().regen_layer_buttons()

func get_value(dic:Dictionary, key, default_value):
	if dic.has(key):
		return dic[key]
	return default_value
		
		
func open_project(path)->bool:
	var _result = false
	var open_file = File.new()
	open_file.open(path, File.READ)
	if open_file.get_position() < open_file.get_len():
		_result = true
		var dic = parse_json(open_file.get_line())
		StaticData.project_name = get_value(dic, "project_name", StaticData.project_name)
		StaticData.canvas_width = get_value(dic, "canvas_width", StaticData.canvas_width)
		StaticData.canvas_height = get_value(dic, "canvas_height", StaticData.canvas_height)
		StaticData.enabled_grid = get_value(dic, "enabled_grid", StaticData.enabled_grid)
		StaticData.enabled_tilemode = get_value(dic, "enabled_tilemode", StaticData.enabled_tilemode)
		StaticData.symmetry_type = get_value(dic, "symmetry_type", StaticData.symmetry_type)
		StaticData.brush_type = get_value(dic, "brush_type", StaticData.brush_type)
		StaticData.horizontal_symmetry_position = get_value(dic, "horizontal_symmetry_position", StaticData.horizontal_symmetry_position)
		StaticData.vertical_symmetry_position = get_value(dic, "vertical_symmetry_position", StaticData.vertical_symmetry_position)
		StaticData.pencil_thickness = get_value(dic, "pencil_thickness", StaticData.pencil_thickness)
		StaticData.palette_size = get_value(dic, "palette_size", StaticData.palette_size)
		StaticData.pixel_perfect = get_value(dic, "pixel_perfect", StaticData.pixel_perfect)
		StaticData.delay_per_frame = get_value(dic, "delay_per_frame", StaticData.delay_per_frame)
		StaticData.current_frame_index = get_value(dic, "current_frame_index", StaticData.current_frame_index)
		StaticData.current_layer_index = get_value(dic, "current_layer_index", StaticData.current_layer_index)
		StaticData.current_palette_index = get_value(dic, "current_palette_index", StaticData.current_palette_index)
		open_project_frames(dic)
		open_project_palettes(dic)
	open_file.close()
	
	NodeManager.get_canvas().resize()
	StaticData.preview_layer.init_size()
	NodeManager.get_tile_mode_manager().init_tile_layers()
	NodeManager.get_tile_mode_manager().update_force()
	NodeManager.get_symmetry_grips().update_canvas_and_grips()
	NodeManager.get_color_panel().load_current_palette()
	return _result
		
func save_auto_saved_project():
	save_project(Define.auto_saved_project_file)
func open_auto_saved_project()->bool:
	return open_project(Define.auto_saved_project_file)
	
func open_project_palettes(var dic:Dictionary):
	if !dic.has("palettes"):
		return
	var dic_palettes:Dictionary = dic["palettes"]
	NodeManager.get_palettes().clear_palettes()
	yield(get_tree().create_timer(0.1), "timeout")
	for key in dic_palettes.keys():
		var palette = NodeManager.get_palettes().add_palette()
		if palette == null:
			continue
		palette.set_save_dic(dic_palettes[key])
	NodeManager.get_color_panel().load_current_palette()
		
func open_project_frames(var dic:Dictionary):
	if !dic.has("frames"):
		return

	var dic_frames:Dictionary = dic["frames"]
	
	NodeManager.get_frames().clear_frames()
	yield(get_tree().create_timer(0.1), "timeout")
	
	for key in dic_frames.keys():
		var frame = NodeManager.get_frames().add_frame(null, false)
		if frame == null:
			continue
		frame.set_save_dic(dic_frames[key])
	
	# frame button 갱신
	NodeManager.get_frame_panel().regen_frame_buttons()
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	
				
func get_save_dic_frames()->Dictionary:
	var _save_dic:Dictionary
	var nodes = NodeManager.get_frames().get_children()
	for node in nodes:
		_save_dic[node.get_index()] = node.get_save_dic()
	return _save_dic
	
func get_save_dic_palettes()->Dictionary:
	var _save_dic:Dictionary
	var nodes = NodeManager.get_palettes().get_children()
	for node in nodes:
		_save_dic[node.get_index()] = node.get_save_dic()
	return _save_dic	
	

