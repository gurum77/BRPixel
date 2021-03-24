extends Panel
class_name LayerPanel

var layer_button_node = preload("res://Canvas/LayerButton.tscn")

onready var layer_button_parent = $ScrollContainer/HBoxContainer
# layer button을 다시 만들지는 않고 갱신만 한다.
# 설정등이 변경 되었을때 호
func update_layer_buttons():
	var nodes = layer_button_parent.get_children()
	for node in nodes:
		node.update()
		node.update_layer()
		
# layer button을 다시 만든다.
func regen_layer_buttons():
	# 기존 layer panel에 있는 layer 버튼을 제거
	var nodes = layer_button_parent.get_children()
	for node in nodes:
		node.queue_free()
		
	# layer 버튼을 새로 만든다.
	nodes = NodeManager.get_layers().get_children()
	var layer_index = 0
	for node in nodes:
		if not node is Layer:
			continue;
		var layer_button = layer_button_node.instance()
		layer_button.layer_index = layer_index
		layer_button_parent.add_child(layer_button)
		layer_button.update_layer()
		layer_index += 1
		
