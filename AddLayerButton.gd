extends Button


# layer를 추가하고 추가한 layer를 현재 layer로 설정한다.
func _on_AddLayerButton_pressed():
	StaticData.current_layer = NodeManager.get_layers().add_layer()
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
