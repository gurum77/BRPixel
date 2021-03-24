extends Button

var layer_node = preload("res://Canvas/Layer.tscn")
# layer를 추가하고 추가한 layer를 현재 layer로 설정한다.
func _on_AddLayerButton_pressed():
	var new_layer = layer_node.instance();
	NodeManager.get_layers().add_child(new_layer)
	StaticData.current_layer = new_layer
