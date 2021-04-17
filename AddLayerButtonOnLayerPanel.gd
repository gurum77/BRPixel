extends TextureButton
class_name AddLayerButtonOnLayerPanel


func _on_AddLayerButton_pressed():
	# 모든 frame에 layer를 추가한다.
	NodeManager.get_frames().add_layer()
	
	StaticData.current_layer_index = NodeManager.get_current_layers().get_child_count()-1
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
