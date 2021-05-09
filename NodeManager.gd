extends Node
var grips:Node = null
var preview_layer:Layer = null
var layer_panel = null
var frame_panel = null
var tools:Tools = null
var color_picker_button:ColorPickerButton = null
var canvas:Canvas = null
var tile_mode_manager = null
var setting_popup = null
var symmetry_grips = null
var frames:Frames = null
var palettes:Palettes = null
var file_dialog:DraggableFileDialog = null
var color_panel:ColorPanel = null
var preload_message_popup = preload("res://MessagePopup.tscn")
var message_box:MessageBox = null
var debug_label:Label = null
var color_setting_popup:ColorSettingPopup = null
var import_image_popup:ImportImagePopup = null
var save_options_popup:SaveOptionsPopup = null
var preview:Preview = null
var layer_setting_popup:LayerSettingPopup = null
var drawing_area:Control = null

func get_drawing_area()->Control:
	if drawing_area == null:
		drawing_area = get_tree().root.get_node("Main/UI/DrawingArea")
	return drawing_area
	
func get_layer_setting_popup()->LayerSettingPopup:
	if layer_setting_popup == null:
		layer_setting_popup = get_tree().root.get_node("Main/UI/LayerSettingPopup")
	return layer_setting_popup
	
func get_preview()->Preview:
	if preview == null:
		preview = get_tree().root.get_node("Main/UI/Preview")
	return preview
	
func get_save_options_popup()->SaveOptionsPopup:
	if save_options_popup == null:
		save_options_popup = get_tree().root.get_node("Main/UI/SaveOptionsPopup")
	return save_options_popup
	
func get_import_image_popup()->ImportImagePopup:
	if import_image_popup == null:
		import_image_popup = get_tree().root.get_node("Main/UI/ImportImage")
	return import_image_popup
	
func get_color_setting_popup()->ColorSettingPopup:
	if color_setting_popup == null:
		color_setting_popup = get_color_panel().get_node("ColorSettingPopup")
	return color_setting_popup

func get_undo()->UndoRedo:
	if get_current_layer() == null:
		return null
	return get_current_layer().undo_redo
	
func get_undo_count()->int:
	if get_current_layer() == null:
		return 0
	return get_current_layer().undo_count
	
func increase_undo_count():
	get_current_layer().undo_count += 1
	
func get_frame(frame_index:int)->Frame:
	return NodeManager.get_frames().get_frame(frame_index)
	
func get_layer(frame_index:int, layer_index:int)->Layer:
	var frame = NodeManager.get_frames().get_frame(frame_index)
	if frame == null:
		return null
	return frame.get_layers().get_layer(layer_index)
	
func get_debug_label()->Label:
	if debug_label == null:
		debug_label = get_tree().root.get_node("Main/UI/DebugLabel")
	return debug_label
	
func get_color_panel()->ColorPanel:
	if color_panel == null:
		color_panel = get_tree().root.get_node("Main/UI/ColorPanel")
	return color_panel
	
func get_current_palette()->Palette:
	palettes = NodeManager.get_palettes()
	if palettes == null:
		return null
	return palettes.get_palette(StaticData.current_palette_index)
		
		
func get_palettes()->Palettes:
	if palettes == null:
		palettes = get_tree().root.get_node("Main/Palettes")
	return palettes
	
func get_message_box()->MessageBox:
	if message_box == null:
		message_box = get_tree().root.get_node("Main/UI/MessageBox")
	return message_box
	
func get_file_dialog()->DraggableFileDialog:
	if file_dialog == null:
		file_dialog = get_tree().root.get_node("Main/UI/DraggableFileDialog")
	return file_dialog
	
func get_frames()->Frames:
	if frames == null:
		frames = get_tree().root.get_node("Main/Canvas/Frames")
	return frames
	
func get_current_frame()->Frame:
	var _frames = get_frames()
	if _frames == null:
		return null
	return _frames.get_frame(StaticData.current_frame_index)
	
func get_current_layers()->Layers:
	if get_current_frame() == null:
		return null
		
	return get_current_frame().get_layers()
	
func get_current_layer()->Layer:
	if get_current_layers() == null:
		return null
		
	return get_current_layers().get_layer(StaticData.current_layer_index)
	
func get_symmetry_grips()->Node:
	if symmetry_grips == null:
		symmetry_grips = get_tree().root.get_node("Main/Canvas/SymmetryGrips")
	return symmetry_grips
	
func get_setting_popup()->Node:
	if setting_popup == null:
		setting_popup = get_tree().root.get_node("Main/UI/SettingButton/SettingPopup")
	return setting_popup

func get_tile_mode_manager()->Node:
	if tile_mode_manager == null:
		tile_mode_manager = get_tree().root.get_node("Main/Canvas/TileModeManager")	
	return tile_mode_manager
	
func get_canvas()->Canvas:
	if canvas == null:
		canvas = get_tree().root.get_node("Main/Canvas")
	return canvas
	
func get_color_picker_button()->ColorPickerButton:
	if color_picker_button == null:
		color_picker_button = get_tree().root.get_node("Main/UI/EditPanel/GridContainer/ColorPickerButton")
	return color_picker_button
	
func get_tools()->Tools:
	if tools == null:
		tools = get_tree().root.get_node("Main/Tools")
	return tools
	
func get_frame_panel():
	if frame_panel == null:
		frame_panel = get_tree().root.get_node("Main/UI/EditPanel/GridContainer/AnimationPopupButton/DraggableWindow/HBoxContainer/FramePanel")
	return frame_panel
	
func get_layer_panel()->LayerPanel:
	if layer_panel == null:
		layer_panel = get_tree().root.get_node("Main/UI/LayerPanel")
	return layer_panel
	
func get_preview_layer()->Layer:
	if preview_layer == null:
		preview_layer = get_tree().root.get_node("Main/Canvas/PreviewLayer")
	return preview_layer
	
# 현재 활성화 되어 있는 모든 tool을 제거한다.
func clear_other_tools(var current_tool, var except_select_tool=true):
	var nodes = get_tools().get_children()
	for node in nodes:
		# 현재 tool은 제거하지 않음
		if node == current_tool:
			continue
			
		# select 툴은 제거하지 않음.
		# 단 select 툴의 grip는 lock을 건다.
		if except_select_tool:
			if node is Select:
				var grips_tmp = node.get_children()
				for grip in grips_tmp:
					grip.lock()
				continue
		node.queue_free()
