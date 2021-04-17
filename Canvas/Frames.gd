extends Control
class_name Frames

var frame_node = preload("res://Canvas/Frame.tscn")

func get_frame_count()->int:
	return get_child_count()
	
# frame을 리턴하는데, 없으면 만들어서 리턴한다.
func get_frame(index, create_if_none=false)->Frame:
	var nodes = get_children()
	if index < 0:
		return null
	if index >= nodes.size():
		if !create_if_none:
			return null
		# 부족한 만큼 만든다.
		var create_count = (index + 1) - nodes.size()
		for i in create_count:
			var _frame = add_frame()
		nodes = get_children()
		
	if index >= nodes.size():
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
func add_frame(name=null)->Frame:
	var new_frame = frame_node.instance();
	add_child(new_frame)
	if name != null:
		new_frame.name = name
	
	# frame을 추가하면 layer의 갯수를 맞춘다.
	# frame이 1개라면 그냥 둔다.(기본 1개 그대로 둔다)
	if get_child_count() == 1:
		return new_frame
		
	new_frame.make_layers()
	return new_frame

func clear_frames():
	var nodes = get_children()
	for node in nodes:
		node.unused = true
		node.call_deferred("queue_free")
