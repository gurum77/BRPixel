extends Control


func get_layer(index)->Layer:
	var nodes = get_children()
	if index < 0 || index >= nodes.size():
		return null
	return nodes[index]
