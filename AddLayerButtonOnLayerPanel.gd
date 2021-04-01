extends TextureButton
class_name AddLayerButtonOnLayerPanel


func _on_AddLayerButton_pressed():
	StaticData.current_layer = NodeManager.get_layers().add_layer()
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
