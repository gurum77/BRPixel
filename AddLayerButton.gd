extends Button


# layer를 추가하고 추가한 layer를 현재 layer로 설정한다.
func _on_AddLayerButton_pressed():
	UndoManager.add_layer.prepare_add_layer()
	UndoManager.add_layer.commit_add_layer(StaticData.current_frame_index)
	
