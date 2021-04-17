extends Control
class_name Projects

func get_project(index)->Project:
	var nodes = get_children()
	if index < 0 || index >= nodes.size():
		return null
	return nodes[index] as Project
