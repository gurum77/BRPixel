extends Node

var layers:Node = null
var grips:Node = null
var preview_layer:Layer = null
var layer_panel = null
var tools:Tools = null
var save_file_dialog:FileDialog = null
var color_picker_button:ColorPickerButton = null
var canvas = null
var tile_mode_manager = null
var setting_popup = null
var preload_message_popup = preload("res://MessagePopup.tscn")

func get_setting_popup()->Node:
	if setting_popup == null:
		setting_popup = get_tree().root.get_node("Main/UI/SettingButton/SettingPopup")
	return setting_popup

func get_tile_mode_manager()->Node:
	if tile_mode_manager == null:
		tile_mode_manager = get_tree().root.get_node("Main/Canvas/TileModeManager")	
	return tile_mode_manager
	
func get_canvas()->Node:
	if canvas == null:
		canvas = get_tree().root.get_node("Main/Canvas")
	return canvas
	
func get_color_picker_button()->ColorPickerButton:
	if color_picker_button == null:
		color_picker_button = get_tree().root.get_node("Main/UI/EditPanel/GridContainer/ColorPickerButton")
	return color_picker_button
		
func get_save_file_dialog()->FileDialog:
	if save_file_dialog == null:
		save_file_dialog = get_tree().root.get_node("Main/UI/SaveFileDialog")		
	return save_file_dialog
	
func get_tools()->Tools:
	if tools == null:
		tools = get_tree().root.get_node("Main/Tools")
	return tools
	
func get_layer_panel():
	if layer_panel == null:
		layer_panel = get_tree().root.get_node("Main/UI/LayerPanel")
	return layer_panel
	
func get_layers()->Node:
	if layers == null:
		layers = get_tree().root.get_node_or_null("Main/Canvas/Layers")
	return layers

	
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
