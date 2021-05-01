extends Button


# 선택한 영역을 지운다.
func _on_ClearButton_pressed():
	# 선택한 영역이 없으면 리턴
	if !StaticData.enabled_selected_area():
		Util.show_message(self, "Warnning", "No selected area.")
		return
		
	UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
	UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer_by_Rect(StaticData.selected_area)
	NodeManager.get_current_layer().erase_pixels_by_rect(StaticData.selected_area)
	UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()

	StaticData.clear_selected_area()
