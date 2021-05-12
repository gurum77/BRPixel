extends Control

var selected_frame:Frame
var message_box:MessageBox
func hide():
	$DraggablePopup.hide()
	
func popup_centered():
	$DraggablePopup/GridContainerTop/TransparencyHSlider.value = selected_frame.modulate.a * 100
	$DraggablePopup.popup_centered()
	
	
	# 마지막 layer의 버튼이면 다음과 합치기 disable
	$DraggablePopup/GridContainer/MoveFrontButton.disabled = !is_exist_prev_frame()
	$DraggablePopup/GridContainer/MoveRearButton.disabled = !is_exist_next_frame()
	
	update_frame_info()

func update_frame_info():
	if selected_frame != null:
		$DraggablePopup/FrameInfoLabel.text = "%d of %d frame" % [selected_frame.get_index() + 1, NodeManager.get_frames().get_frame_count()]
	else:
		$DraggablePopup/FrameInfoLabel.text = ""
		
func is_exist_prev_frame()->bool:
	if get_prev_frame() == null:
		return false
	return true

func is_exist_next_frame()->bool:
	if get_next_frame() == null:
		return false
	return true	
		
func get_prev_frame()->Frame:
	return NodeManager.get_frames().get_frame(selected_frame.get_index()-1)
	
func get_next_frame()->Frame:
	return NodeManager.get_frames().get_frame(selected_frame.get_index()+1)
	
	
func _on_DuplicateButton_pressed():
	if selected_frame == null:
		return
	
	# frame를 하나 만든다.
	var new_frame = NodeManager.get_frames().add_frame()
	
	# layer 이미지를 모두 복사한다.
	var new_normal_layers = new_frame.get_layers().get_normal_layers()
	var selected_normal_layers = selected_frame.get_layers().get_normal_layers()
	for i in new_normal_layers.size():
		if i >= selected_normal_layers.size():
			continue
		var new_normal_layer = new_normal_layers[i]
		var selected_normal_layer = selected_normal_layers[i]
		new_normal_layer.copy_image(selected_normal_layer.image, new_normal_layer.image, 0, 0)
		
	# 새로운 frame의 위치를 selected_frame 뒤로 이동
	var selected_frame_index = NodeManager.get_frames().get_child_index(selected_frame)
	if selected_frame_index > -1:
		NodeManager.get_frames().move_child(new_frame, selected_frame_index+1)
	
	# frame button 갱신
	NodeManager.get_frame_panel().regen_frame_buttons()


func _on_DeleteButton_pressed():
	# frame이 하나밖에 없으면 삭제 불가
	if NodeManager.get_frames().get_child_count() == 1:
		return
		
	hide()
	message_box = Util.show_yesno_message_box(tr("Do you really delete the selected frame.") + "\n" + tr("This operation cannot be undone."))
	var _result = message_box.connect("hide", self, "on_DeleteFrameMessageBox_hide")

func on_DeleteFrameMessageBox_hide():
	popup_centered()
	message_box.disconnect("hide", self, "on_DeleteFrameMessageBox_hide")
	if message_box.result != MessageBox.Result.yes:
		return
	delete_selected_frame()


func delete_selected_frame():
	# 현재 frame을 지우고 다음 frame을 현재 frame으로 설정한다.
	NodeManager.get_frames().remove_frame(selected_frame.get_index())
	
	# frame button을 재생성 한다.
	NodeManager.get_frame_panel().regen_frame_buttons()
	
func _on_MoveUpButton_pressed():
	# 현재 index가 마지막이면 이동 불가
	if selected_frame.get_index() == NodeManager.get_frames().get_child_count()-1:
		return
	# 이동	
	NodeManager.get_frames().move_child(selected_frame, selected_frame.get_index()+1)
	
	# 현재 frame 한칸 올림
	StaticData.current_frame_index += 1
	if StaticData.current_frame_index >= NodeManager.get_frames().get_frame_count():
		StaticData.current_frame_index = NodeManager.get_frames().get_frame_count()-1
		
	# frame button을 재생성 한다.
	NodeManager.get_frame_panel().regen_frame_buttons()
	
	


func _on_MoveDownButton_pressed():
	# 현재 index가 0이면 이동 불가
	if selected_frame.get_index() == 0:
		return
	# 이동	
	NodeManager.get_frames().move_child(selected_frame, selected_frame.get_index()-1)
	
	# 현재 frame 한칸 내림
	StaticData.current_frame_index -= 1
	if StaticData.current_frame_index < 0:
		StaticData.current_frame_index = 0
	
	# frame button을 재생성 한다.
	NodeManager.get_frame_panel().regen_frame_buttons()

# 투명도 슬라이더 변경시..
func _on_TransparencyHSlider_value_changed(_value):
	selected_frame.modulate.a = $DraggablePopup/GridContainerTop/TransparencyHSlider.value / 100.0
	$DraggablePopup/GridContainerTop/TransparencyHSlider/TextEdit.text = str($DraggablePopup/GridContainerTop/TransparencyHSlider.value)
