extends Node

var layers:Node = null
var grips:Node = null
var preview_layer:Layer = null
var layer_panel = null

func get_layer_panel():
	if layer_panel == null:
		layer_panel = get_tree().root.get_node("Main/UI/LayerPanel")
	return layer_panel
	
func get_layers()->Node:
	if layers == null:
		layers = get_tree().root.get_node_or_null("Main/Canvas/Layers")
	return layers

func get_grips()->Node:
	if grips == null:
		grips = get_tree().root.get_node_or_null("Main/Canvas/Grips")
	return grips
	
func get_preview_layer()->Layer:
	if preview_layer == null:
		preview_layer = get_tree().root.get_node("Main/Canvas/PreviewLayer")
	return preview_layer

