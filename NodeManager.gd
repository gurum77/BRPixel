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
var user_brushes:Control = null
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
var camera:Camera2D = null
var copy_button:Button = null
var cut_button:Button = null
var redo_button:TextureRect = null
var undo_button:TextureRect = null
var select_popup_button:TextureRectButton = null
var new_button:NewButton = null
var open_button:TextureRectButton = null
var save_button:TextureRectButton = null
var pencil_button:TextureRectButton = null
var line_button:LineButton = null
var rectangle_button:RectangleButton = null
var fill_rectangle_button:RectangleButton = null
var circle_button:CircleButton = null
var fill_circle_button:CircleButton = null
var eraser_button:EraserButton = null
var fill_button:FillButton = null
var select_button:SelectButton = null
var pick_color_from_canvas_button:PickColorFromCanvasButton = null
var move_button:MoveButton = null
var brighter_button:BrighterButton = null
var darker_button:DarkerButton = null
var change_color_button:Control = null
var add_layer_button:AddLayerButton = null
var share_button:ShareButton = null
var clear_button:Control = null
var palette_setting_popup:PaletteSettingPopup = null
var brush_type_button:BrushTypeButton = null
var add_brush_button:Control = null
var start_button:Control = null
var prev_button:Control = null
var play_button:Control = null
var next_button:Control = null
var end_button:Control = null

func get_start_button()->Control:
	if start_button == null:
		start_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/AnimationPopup/HBoxContainer/FramePanel/VBoxContainer/HBoxContainer/StartButton")
	return start_button
	
func get_prev_button()->Control:
	if prev_button == null:
		prev_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/AnimationPopup/HBoxContainer/FramePanel/VBoxContainer/HBoxContainer/PrevButton")
	return prev_button
	
func get_play_button()->Control:
	if play_button == null:
		play_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/AnimationPopup/HBoxContainer/FramePanel/VBoxContainer/HBoxContainer/PlayButton")
	return play_button
	
func get_next_button()->Control:
	if next_button == null:
		next_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/AnimationPopup/HBoxContainer/FramePanel/VBoxContainer/HBoxContainer/NextButton")
	return next_button	
	
func get_end_button()->Control:
	if end_button == null:
		end_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/AnimationPopup/HBoxContainer/FramePanel/VBoxContainer/HBoxContainer/EndButton")
	return end_button
		
func get_add_brush_button()->Control:
	if add_brush_button == null:
		add_brush_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/SelectPopup/HBoxContainer/AddBrushButton")
	return add_brush_button
	
func get_brush_type_button()->BrushTypeButton:
	if brush_type_button == null:
		brush_type_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/ToolSettingPopup/HBoxContainer/BrushTypeButton")
	return brush_type_button
	
func get_palette_setting_popup()->PaletteSettingPopup:
	if palette_setting_popup == null:
		palette_setting_popup = get_tree().root.get_node("Main/UI/ColorPanel/VBoxContainer/HBoxContainer/PaletteSettingButton/PaletteSettingPopup")
	return palette_setting_popup
	
func get_clear_button()->Control:
	if clear_button == null:
		clear_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/SelectPopup/HBoxContainer/ClearButton")
	return clear_button

func get_move_button()->MoveButton:
	if move_button == null:
		move_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/MoveButton")
	return move_button
	
func get_brighter_button()->BrighterButton:
	if brighter_button == null:
		brighter_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/BrighterButton")
	return brighter_button
	
func get_darker_button()->DarkerButton:
	if darker_button == null:
		darker_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/DarkerButton")
	return darker_button

func get_change_color_button()->Control:
	if change_color_button == null:
		change_color_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/ChangeColorButton")
	return change_color_button	
	
func get_add_layer_button()->AddLayerButton:
	if add_layer_button == null:
		add_layer_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/AddLayerButton")
	return add_layer_button	

func get_share_button()->ShareButton:
	if share_button == null:
		share_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/ShareButton")
	return share_button		
	
func get_pick_color_from_canvas_button()->PickColorFromCanvasButton:
	if pick_color_from_canvas_button == null:
		pick_color_from_canvas_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/PickColorFromCanvasButton")
	return pick_color_from_canvas_button
	
func get_select_button()->SelectButton:
	if select_button == null:
		select_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/SelectPopup/HBoxContainer/SelectButton")
	return select_button


func get_fill_button()->FillButton:
	if fill_button == null:
		fill_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/FillButton")
	return fill_button
	
	
func get_eraser_button()->EraserButton:
	if eraser_button == null:
		eraser_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/EraserButton")
	return eraser_button

	
func get_fill_circle_button()->CircleButton:
	if fill_circle_button == null:
		fill_circle_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/GeometryPopup/HBoxContainer/FillCircleButton")
	return fill_circle_button
		
func get_circle_button()->CircleButton:
	if circle_button == null:
		circle_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/GeometryPopup/HBoxContainer/CircleButton")
	return circle_button
	
func get_fill_rectangle_button()->RectangleButton:
	if fill_rectangle_button == null:
		fill_rectangle_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/GeometryPopup/HBoxContainer/FillRectangleButton")
	return fill_rectangle_button
		
func get_rectangle_button()->RectangleButton:
	if rectangle_button == null:
		rectangle_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/GeometryPopup/HBoxContainer/RectangleButton")
	return rectangle_button
		
func get_line_button()->LineButton:
	if line_button == null:
		line_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/GeometryPopup/HBoxContainer/LineButton")
	return line_button
	
func get_pencil_button()->TextureRectButton:
	if pencil_button == null:
		pencil_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/PencilButton")
	return pencil_button

func get_save_button()->TextureRectButton:
	if save_button == null:
		save_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/SaveButton")
	return save_button

func get_open_button()->TextureRectButton:
	if open_button == null:
		open_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/OpenButton")
	return open_button

func get_new_button()->NewButton:
	if new_button == null:
		new_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/NewButton")
	return new_button
	
func get_select_popup_button()->TextureRectButton:
	if select_popup_button == null:
		select_popup_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/SelectPopupButton")
	return select_popup_button
	
func get_undo_button()->TextureRect:
	if undo_button == null:
		undo_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/UndoButton")
	return undo_button
	
func get_redo_button()->TextureRect:
	if redo_button == null:
		redo_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/RedoButton")
	return redo_button


func get_cut_button()->Button:
	if cut_button == null:
		cut_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/SelectPopup/HBoxContainer/CutButton")
	return cut_button
	
func get_copy_button()->Button:
	if copy_button == null:
		copy_button = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/SelectPopup/HBoxContainer/CopyButton")
	return copy_button
			
func get_camera()->Camera2D:
	if camera == null:
		camera = get_tree().root.get_node("Main/Camera")
	return camera
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
		
		
func get_user_brushes()->Control:
	if user_brushes == null:
		user_brushes = get_tree().root.get_node("Main/UserBrushes")
	return user_brushes
	
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
		color_picker_button = get_tree().root.get_node("Main/UI/EditPanel/ScrollContainer/GridContainer/ColorPickerButton")
	return color_picker_button
	
func get_tools()->Tools:
	if tools == null:
		tools = get_tree().root.get_node("Main/Tools")
	return tools
	
func get_frame_panel():
	if frame_panel == null:
		frame_panel = get_tree().root.get_node("Main/UI/EditPanel/SubmenuPopups/AnimationPopup/HBoxContainer/FramePanel")
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
