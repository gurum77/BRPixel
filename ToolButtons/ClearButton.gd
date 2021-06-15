extends Button
class_name ClearButton

# 선택한 영역을 지운다.
func _on_ClearButton_pressed():
	run()
	
func run():
	# 선택한 영역이 없으면 리턴
	if !StaticData.enabled_selected_area():
		# 메세지 표시하지 말자.(line edit에서 글자 입력하다가 delete 누르면 여기로 오기도 함)
		#Util.show_message(self, "Warnning", "No selected area.")
		return
		
	UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
	UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer_by_Rect(StaticData.selected_area)
	NodeManager.get_current_layer().erase_pixels_by_rect(StaticData.selected_area)
	UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()

	NodeManager.get_tools().finish_selected_area_editing()
	
