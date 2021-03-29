extends Button



func _on_DeleteLayerButton_pressed():
	# layer가 하나밖에 없으면 삭제 불가
	if NodeManager.layers.get_child_count() == 1:
		return
		
	# 현재 layer를 지우고 다음 layer를 현재 layer로 설정한다.
	NodeManager.layers.remove_layer(StaticData.current_layer.index)
	
	# layer button을 재생성 한다.
	NodeManager.layer_panel.regen_layer_buttons()
