extends Control
class_name Frames

var frame_node = preload("res://Canvas/Frame.tscn")

func _ready():
	# palettes는 크기가 있으면 안됨(다른 control에 메세지가 안감)
	rect_size = Vector2(0, 0)
	
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
	
func get_layers_by_index(layer_index:int)->Array:
	var layers = []
	var frame_count = get_frame_count()
	for frame_index in frame_count:
		var frame = get_frame(frame_index)
		if frame == null:
			continue
		var layer = frame.get_layers().get_layer(layer_index)
		layers.append(layer)
	return layers

# layer의 visible 속성을 설정한다.
func set_layer_visible(layer_index:int, _visible:bool):
	var layers = get_layers_by_index(layer_index)
	if layers == null:
		return
	for layer in layers:
		layer.visible = _visible
		
# layer의 이름을 설정한다.
func set_layer_name(layer_index:int, new_name:String):
	var layers = get_layers_by_index(layer_index)
	if layers == null:
		return
	for layer in layers:
		layer.name = new_name
	
# 모든 frame에 layer를 추가한다.
# layer의 이름을 첫번째 frame layer와 동일하게 설정한다.
func add_layer():
	var nodes = get_children()
	for node in nodes:
		var frame = node as Frame
		if frame == null:
			continue
		frame.get_layers().add_layer()
	sync_layer_properties_by_first_layer()

# layer의 속성을 첫번째 layer의 속성으로 모두 동기화 한다.
func sync_layer_properties_by_first_layer():
	var first_frame = get_frame(0)
	var layer_count = first_frame.get_layers().get_normal_layers().size()
	
	var frame_count = get_frame_count()
	for fi in range(1, frame_count):
		# 두번째 이후 frame
		var cur_frame = get_frame(fi)
		if cur_frame == null:
			continue
		
		# layer 속성 복사
		for li in layer_count:
			var first_layer = first_frame.get_layers().get_layer(li)
			var cur_layer = cur_frame.get_layers().get_layer(li)
			if first_layer == null || cur_layer == null:
				continue
			cur_layer.copy_properties(first_layer)
			
			
		
# 이름이 없으면 자동으로 변경되는 것을 그냥 사용한다.
func add_frame(name=null, make_layers_as_first_frame=true)->Frame:
	var new_frame = frame_node.instance();
	add_child(new_frame)
	if name != null:
		new_frame.name = name
	
	
	if make_layers_as_first_frame:
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

func get_frames()->Array:
	var frames = []
	var frame_count = get_frame_count()
	for i in frame_count:
		var frame = get_frame(i)
		if frame == null:
			continue
		frames.append(frame)
	return frames
	
# layer에 alpha값을 설ㅈ어한다.
func set_alpha(layer_index, alpha):
	var frames = get_frames()
	for node in frames:
		var frame:Frame = node
		if frame == null:
			continue
		var layer = frame.get_layers().get_layer(layer_index)
		if layer == null:
			continue
		layer.modulate.a = alpha
			
# 모든 layer를 합친다.
func merge_all_layers():
	var frames = get_frames()
	for node in frames:
		var frame:Frame = node
		if frame == null:
			continue
			
		var layers = frame.get_layers().get_normal_layers()
		if layers == null || layers.size() < 2:
			continue
			
		# 모두 첫번째 layer로 합친다.
		var first_layer = layers[0]
		for layer in layers:
			if layer == first_layer:
				continue
			first_layer.copy_image(layer.image, first_layer.image, 0, 0)
			layer.unused = true
			layer.call_deferred("queue_free")
		
		first_layer.update_texture()
		
	StaticData.current_layer_index = 0

# layer 합치기
func merge_layer_with(layer_index:int, to_prev:bool):
	var frames = get_frames()
	for node in frames:
		var frame:Frame = node
		if frame == null:
			continue
			
		# 현재 layer
		var layer = frame.get_layers().get_layer(layer_index)
		if layer == null:
			continue
			
		# 대상 layer
		var other_layer:Layer = frame.get_layers().get_side_layer(layer_index, to_prev)
		if other_layer == null:
			return
			
		# 이미지를 대상 layer로 복사
		other_layer.copy_image(layer.image, other_layer.image, 0, 0)
		other_layer.update_texture()
		
	# 현재 layer 삭제
	remove_layer(layer_index)
		

# layer를 한칸 위/아래로 이동
func move_layer(layer_index:int, to_down:bool):		
	var frames = get_frames()
	for node in frames:
		var frame:Frame = node
		if frame == null:
			continue
		# 이동	
		var layer = frame.get_layers().get_layer(layer_index)
		if layer == null:
			continue
		if to_down:
			if layer.get_index() > 0:
				frame.get_layers().move_child(layer, layer.get_index()-1)
		else:
			if layer.get_index() < frame.get_layers().get_layer_count() - 1:
				frame.get_layers().move_child(layer, layer.get_index()+1)
	
# layer를 삭제한다.
func remove_layer(layer_index:int):
	var frames = get_frames()
	for node in frames:
		var frame:Frame = node
		if frame == null:
			continue
		frame.get_layers().remove_layer(layer_index)
		
# layer를 복제한다.
func duplicate_layer(layer_index:int):
	var frames = get_frames()
	for node in frames:
		var frame:Frame = node
		if frame == null:
			continue
		
		# src layer
		var selected_layer = frame.get_layers().get_layer(layer_index)
		if selected_layer == null:
			continue
			
		# layer를 하나 만든다.
		var new_layer = frame.get_layers().add_layer()
		
		# 이미지를 복사한다.
		new_layer.copy_image(selected_layer.image, new_layer.image, 0, 0)
		
		# 새로운 layer의 위치를 selected_layer 뒤로 이동
		var selected_layer_index = selected_layer.get_index()
		if selected_layer_index > -1:
			frame.get_layers().move_child(new_layer, selected_layer_index+1)
		
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
