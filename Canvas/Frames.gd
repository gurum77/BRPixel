extends Control
class_name Frames

var frame_node = preload("res://Canvas/Frame.tscn")

func get_frame(index)->Frame:
	var nodes = get_children()
	if index < 0 || index >= nodes.size():
		return null
	return nodes[index]
	
# 모든 frame에 layer를 추가한다.
func add_layer():
	var nodes = get_children()
	for node in nodes:
		var frame = node as Frame
		if frame == null:
			continue
		frame.get_layers().add_layer()
	
# 이름이 없으면 자동으로 변경되는 것을 그냥 사용한다.
func add_frame(name=null):
	var new_frame = frame_node.instance();
	add_child(new_frame)
	if name != null:
		new_frame.name = name
	
	# frame을 추가하면 layer의 갯수를 맞춘다.
	new_frame.make_layers()
