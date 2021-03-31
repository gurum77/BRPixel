extends Node

var layers:Node = null
var grips:Node = null
var preview_layer:Layer = null
var layer_panel = null
var tools:Tools = null
var save_file_dialog:FileDialog = null


	
		
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
				var grips = node.get_children()
				for grip in grips:
					grip.lock()
				continue
		node.queue_free()
