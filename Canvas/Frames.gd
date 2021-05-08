extends Control
class_name Frames

var frame_node = preload("res://Canvas/Frame.tscn")

func get_frame_count()->int:
	return get_child_count()
	
# child의 인덱스를 리턴
func get_child_index(child)->int:
	var nodes = get_children()
	var idx = 0
	for node in nodes:
		if node == child:
			return idx
		idx += 1
	return -1
		
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

func remove_frame(index:int):
	var frame = get_frame(index)	
	if frame == null:
		return
	remove_child(frame)
	frame.queue_free()
	
	# current_frame를 갱신
	if index >= get_child_count():
		index -= 1
	StaticData.current_frame_index = index

# 모든 프레임을 각각의 image로 만들어서 배열로 리턴
func create_all_frame_images()->Array:
	var images = []
	var nodes = get_children()
	for node in nodes:
		var frame = node as Frame
		if frame == null:
			continue
		var image = frame.get_layers().create_layers_image()
		images.append(image)
		
	return images
	
# 모든 프레임을 sprite sheet image로 만들어서 리턴
func create_sprite_sheet_image()->Image:
	var frame_count = get_frame_count()
	var image = Util.create_image(StaticData.canvas_width * frame_count, StaticData.canvas_height)
	var x = 0
	var nodes = get_children()
	for node in nodes:
		var frame = node as Frame
		if frame == null:
			continue
		var cur_image = frame.get_layers().create_layers_image()
		var rect = Rect2(0, 0, cur_image.get_width(), cur_image.get_height())
		var offset = Vector2(x, 0)
		image.blit_rect(cur_image, rect, offset)
		x += StaticData.canvas_width
	return image
