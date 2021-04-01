extends Panel
class_name LayerPanel

var layer_button_node = preload("res://Canvas/LayerButton.tscn")
var add_layer_button_on_layer_panel = preload("res://AddLayerButtonOnLayerPanel.tscn")
onready var layer_button_parent = $ScrollContainer/HBoxContainer
# layer button을 다시 만들지는 않고 갱신만 한다.
# 설정등이 변경 되었을때 호
func update_layer_buttons():
	var nodes = layer_button_parent.get_children()
	for node in nodes:
		if node is AddLayerButtonOnLayerPanel:
			continue
		node.update()
		node.update_layer()
		
# layer button을 다시 만든다.
func regen_layer_buttons():
	# 기존 layer panel에 있는 layer 버튼을 제거
	var nodes = layer_button_parent.get_children()
	for node in nodes:
		node.queue_free()
		
	# layer 버튼을 새로 만든다.
	var normal_layers = NodeManager.get_layers().get_normal_layers()
	var layer_index = 0
	for node in normal_layers:
		if not node is Layer:
			continue
		var layer_button = layer_button_node.instance()
		layer_button.layer_index = layer_index
		layer_button_parent.add_child(layer_button)
		layer_button.update_layer()
		layer_index += 1
	
	# layer 추가 버튼을 마지막에 만든다.
	var add_layer_button_ins = add_layer_button_on_layer_panel.instance()
	layer_button_parent.add_child(add_layer_button_ins)
		
