extends Node

var layers:Node = null
var preview_layer:Layer = null
func get_layers()->Node:
	if layers == null:
		layers = get_tree().root.get_node_or_null("Main/Canvas/Layers")
	return layers

func get_preview_layer()->Layer:
	if preview_layer == null:
		preview_layer = get_tree().root.get_node("Main/Canvas/PreviewLayer")
	return preview_layer

