extends Control
class_name Layers
var layer_node = preload("res://Canvas/Layer.tscn")

func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)

# src_layer를 복사해서 layer를 추가한다.
func add_layer_by_layer(src_layer:Layer, index=-1)->Layer:
	var new_layer = NodeManager.get_current_layers().layer_node.instance()
	add_child(new_layer)
	new_layer.copy(src_layer)
	if index != -1:
		move_child(new_layer, index)
	if name != null:
		new_layer.name = name
	return new_layer
	
# 이름이 없으면 자동으로 변경되는 것을 그냥 사용한다.
func add_layer(name=null, index=-1)->Layer:
	var new_layer = layer_node.instance();
	add_child(new_layer)
	if index != -1:
		move_child(new_layer, index)
	if name != null:
		new_layer.name = name
	else:
		new_layer.name = get_new_layer_name()
	
	return new_layer
	
# 새 layer 이름을 리턴
func get_new_layer_name()->String:
	# Layer뒤의 마지막수
	var last_num = 0
	var nodes = get_normal_layers()
	for node in nodes:
		var layer = node as Layer
		var layer_name:String = layer.name
		if !layer_name.begins_with("Layer "):
			continue
		var num_text = layer_name.replace("Layer ", "")
		var num = num_text.to_int()
		if num > last_num:
			last_num = num
	
	return "Layer %d" % [last_num+1]
	
# 일반 레이어를 모두 가져온다.
func get_normal_layers()->Array:
	var normal_layers = []
	var nodes = get_children()
	for node in nodes:
		if node.preview_layer:
			continue
		if node.minimap_layer:
			continue
		if node.unused:
			continue
		normal_layers.append(node)
	return normal_layers
	
# layer를 모두 제거한다.
# preview와 minimap layer는 제거하지 않는다.
func clear_normal_layers():
	var layers = get_normal_layers()
	for layer in layers:
		layer.unused = true
		layer.call_deferred("queue_free")
			
func get_layer_count():
	return get_normal_layers().size()

# 바로 옆(이전, 이후) layer를 리턴한다.
func get_side_layer(index, prev:bool)->Layer:
	var side_index = index
	if prev:
		side_index -= 1
	else:
		side_index += 1
	return get_layer(side_index)
		
	
		
func get_layer(index)->Layer:
	var nodes = get_normal_layers()
	if index < 0 || index >= nodes.size():
		return null
	return nodes[index]

# layer를 하나 삭제한다.
func remove_layer(index):
	var layer = get_layer(index)	
	if layer == null:
		return
	remove_child(layer)
	layer.queue_free()
	
	# current_layer를 갱신
	if index >= get_child_count():
		index -= 1
	StaticData.current_layer_index = index
		
# child의 인덱스를 리턴
func get_child_index(child)->int:
	var nodes = get_children()
	var idx = 0
	for node in nodes:
		if node == child:
			return idx
		idx += 1
	return -1
	
# 모든 layer를 병합해서 하나의 이미지로 리턴
func create_layers_image(background_color:Color=Color.transparent)->Image:
	var image = Util.create_image(StaticData.canvas_width, StaticData.canvas_height)
	if background_color != Color.transparent:
		image.fill(background_color)
	
	# 모든 layer를 돌면서 image를 복사한다.
	var nodes = get_normal_layers()
	for node in nodes:
		var layer = node as Layer
		Util.copy_image(layer.image, image, 0, 0)
		
	return image
	
	
