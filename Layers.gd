extends Control

var layer_node = preload("res://Canvas/Layer.tscn")

func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)

# 이름이 없으면 자동으로 변경되는 것을 그냥 사용한다.
func add_layer(name=null)->Layer:
	var new_layer = layer_node.instance();
	add_child(new_layer)
	if name != null:
		new_layer.name = name
	return new_layer
	
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
	
	# index를 다시 설정
	update_layer_index()
	
	# current_layer를 갱신
	if index >= get_child_count():
		index -= 1
	StaticData.current_layer = NodeManager.layers.get_layer(index)

func update_layer_index():
	var nodes = get_children()
	var idx = 0
	for node in nodes:
		node.index = idx
		idx += 1
		
	
	
