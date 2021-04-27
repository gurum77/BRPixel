extends Button



func _on_DeleteLayerButton_pressed():
	# layer가 하나밖에 없으면 삭제 불가
	if NodeManager.get_current_layers().get_child_count() == 1:
		return

	UndoRedoManager.prepare_undo_for_delete_layer()		
	UndoRedoManager.commit_undo_for_delete_layer(StaticData.current_frame_index, StaticData.current_layer_index)
