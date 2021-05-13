extends Control
class_name LayerSettingPopup

var selected_layer:Layer
var message_box:MessageBox
func hide():
	$DraggablePopup.hide()
	
func get_selected_layer_index():
	if selected_layer == null:
		return 0
	return selected_layer.get_index()
	
func popup_centered():
	if selected_layer == null:
		return
		
	update_controls()
func update_controls():
	$DraggablePopup/GridContainer/HideButton.pressed = !selected_layer.visible
	$DraggablePopup/GridContainerTop/TransparencyHSlider.value = selected_layer.modulate.a * 100
	$DraggablePopup.popup_centered()
	
	# layer가 하나 밖에 없다면 delete/모드합치기 버튼 disable
	var layers = NodeManager.get_current_layers()
	$DraggablePopup/GridContainer/DeleteButton.disabled = layers == null || layers.get_layer_count() == 1
	$DraggablePopup/GridContainer/MergeAllButton.disabled = layers == null || layers.get_layer_count() == 1
	
	
	# 마지막 layer의 버튼이면 다음과 합치기 disable
	$DraggablePopup/GridContainer/MoveDownButton.disabled = !is_exist_prev_layer()
	$DraggablePopup/GridContainer/MoveUpButton.disabled = !is_exist_next_layer()
	$DraggablePopup/GridContainer/MergeWithPrevButton.disabled = !is_exist_prev_layer()
	$DraggablePopup/GridContainer/MergeWithNextButton.disabled = !is_exist_next_layer()

func is_exist_prev_layer()->bool:
	if get_prev_layer() == null:
		return false
	return true

func is_exist_next_layer()->bool:
	if get_next_layer() == null:
		return false
	return true	
		
func get_prev_layer()->Layer:
	return NodeManager.get_current_layers().get_layer(selected_layer.get_index()-1)
	
func get_next_layer()->Layer:
	return NodeManager.get_current_layers().get_layer(selected_layer.get_index()+1)
	

# 레이어 복제
func _on_DuplicateLayerButton_pressed():
	if selected_layer == null:
		return
	
	NodeManager.get_frames().duplicate_layer(get_selected_layer_index())
	
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	update_controls()


# 레이어 삭제
func _on_DeleteButton_pressed():
	# layer가 하나밖에 없으면 삭제 불가
	if NodeManager.get_current_layers().get_child_count() == 1:
		return
		
	hide()
	message_box = Util.show_yesno_message_box(tr("Do you really delete the selected layer.") + "\n" + tr("This operation cannot be undone."))
	var _result = message_box.connect("hide", self, "on_DeleteLayerMessageBox_hide")

func on_DeleteLayerMessageBox_hide():
	popup_centered()
	message_box.disconnect("hide", self, "on_DeleteLayerMessageBox_hide")
	if message_box.result != MessageBox.Result.yes:
		return
	delete_selected_layer()
	
func delete_selected_layer():
	if selected_layer == null:
		return
	
	# 현재 layer를 지우고 다음 layer를 현재 layer로 설정한다.
	NodeManager.get_frames().remove_layer(selected_layer.get_index())
	
	# frame button도 재생성
	NodeManager.get_frame_panel().update_frame_buttons()
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	update_controls()
	


# 아래로 이동
func _on_MoveDownButton_pressed():
	# 현재 index가 0이면 이동 불가
	if selected_layer.get_index() == 0:
		return
	# 이동
	NodeManager.get_frames().move_layer(get_selected_layer_index(), true)
	
	
	# 현재 layer 한칸 내림
	StaticData.current_layer_index -= 1
	if StaticData.current_layer_index < 0:
		StaticData.current_layer_index = 0
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	update_controls()
	

# 위로 이동
func _on_MoveUpButton_pressed():
	var current_layers = NodeManager.get_current_layers()
	if current_layers == null:
		return
	
	# 현재 index가 마지막이면 이동 불가
	if selected_layer.get_index() == current_layers.get_child_count()-1:
		return
		
	# 이동
	NodeManager.get_frames().move_layer(get_selected_layer_index(), false)
	
	# 현재 layer 한칸 올림
	StaticData.current_layer_index += 1
	if StaticData.current_layer_index >= current_layers.get_layer_count():
		StaticData.current_layer_index = current_layers.get_layer_count()-1
		
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	update_controls()

# 숨김 
func _on_HideButton_pressed():
	selected_layer.visible = !selected_layer.visible
	# layer button을 갱신
	NodeManager.get_layer_panel().update_layer_buttons()
	

# 투명도 슬라이더 변경시..
func _on_TransparencyHSlider_value_changed(_value):
	NodeManager.get_frames().set_alpha(get_selected_layer_index(), $DraggablePopup/GridContainerTop/TransparencyHSlider.value / 100.0)
	$DraggablePopup/GridContainerTop/TransparencyHSlider/TextEdit.text = str($DraggablePopup/GridContainerTop/TransparencyHSlider.value)
	


# 이전 layer와 합치기
func _on_MergeWithPrevButton_pressed():
	# 이전 layer
	var prev_layer:Layer = get_prev_layer()
	if prev_layer == null:
		return
		
	hide()
	message_box = Util.show_yesno_message_box(tr("Do you really merge with previous layer.") + "\n" + tr("This operation cannot be undone."))
	var _result = message_box.connect("hide", self, "on_MergeWithPreviousLayer_hide")
	
	
func on_MergeWithPreviousLayer_hide():		
	popup_centered()
	message_box.disconnect("hide", self, "on_MergeWithPreviousLayer_hide")	
	if message_box.result != MessageBox.Result.yes:
		return
	
	# layer를 합친다.	
	NodeManager.get_frames().merge_layer_with(get_selected_layer_index(), true)
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()		
	
	hide()
	
		

# 모든 layer 합치기
func _on_MergeAllButton_pressed():
	var layers = NodeManager.get_current_layers().get_normal_layers()
	if layers == null || layers.size() < 2:
		hide()
		return
	
	hide()
	message_box = Util.show_yesno_message_box(tr("Do you really merge all layers.") + "\n" + tr("This operation cannot be undone."))
	var _result = message_box.connect("hide", self, "on_MergeAllLayers_hide")

func on_MergeAllLayers_hide():
	popup_centered()
	message_box.disconnect("hide", self, "on_MergeAllLayers_hide")
	if message_box.result != MessageBox.Result.yes:
		return
		
	NodeManager.get_frames().merge_all_layers()
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()		
	hide()


# 다음 layer와 합치기를 한다.
func _on_MergeWithNextButton_pressed():
	# 다음 layer
	var next_layer:Layer = get_next_layer()
	if next_layer == null:
		hide()
		return
		
	hide()
	message_box = Util.show_yesno_message_box(tr("Do you really merge with next layer.") + "\n" + tr("This operation cannot be undone."))
	var _result = message_box.connect("hide", self, "on_MergeWithNextLayer_hide")
	

func on_MergeWithNextLayer_hide():
	popup_centered()
	message_box.disconnect("hide", self, "on_MergeWithNextLayer_hide")
	if message_box.result != MessageBox.Result.yes:
		return
		
	NodeManager.get_frames().merge_layer_with(get_selected_layer_index(), false)
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()		
	
	hide()


func _on_ClearButton_pressed():
	if selected_layer == null:
		return
	var clear_area = Rect2(0, 0, StaticData.canvas_width, StaticData.canvas_height)
	UndoManager.draw_pixels_on_current_layer.prepare_undo_for_draw_on_current_layer()
	UndoManager.draw_pixels_on_current_layer.append_undo_for_draw_on_current_layer_by_Rect(clear_area)
	NodeManager.get_current_layer().erase_pixels_by_rect(clear_area)
	UndoManager.draw_pixels_on_current_layer.commit_undo_for_draw_on_current_layer()

	NodeManager.get_tools().finish_selected_area_editing()


# 이미지 붙여 넣기
func _on_AttachImageButton_pressed():
	pass # Replace with function body.
