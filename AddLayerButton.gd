extends TextureRectButton


# layer를 추가하고 추가한 layer를 현재 layer로 설정한다.
func _on_AddLayerButton_pressed():
	# layer를 추가한다.
	var _result = NodeManager.get_frame(StaticData.current_frame_index).get_layers().add_layer()
	
	# 현재 layer index를 마지막 layer로 설정한다.
	StaticData.current_layer_index = NodeManager.get_current_layers().get_child_count()-1
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	


func _on_AddLayerButton_gui_input(event):
	run_gui_input(event)
