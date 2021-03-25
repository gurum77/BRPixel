extends Control

func _ready():
	# 0,0으로 고정한다.
	rect_position = Vector2(0, 0)

func get_layer(index)->Layer:
	var nodes = get_children()
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
		
	
	
