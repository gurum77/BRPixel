extends Button


# layer를 추가하고 추가한 layer를 현재 layer로 설정한다.
func _on_AddLayerButton_pressed():
	var _layer = NodeManager.get_current_layers().add_layer()
	StaticData.current_layer_index = NodeManager.get_current_layers().get_child_count()-1
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
