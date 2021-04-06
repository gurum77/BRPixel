extends Control

var selected_layer:Layer

func hide():
	$DraggablePopup.hide()
	
func popup_centered():
	$DraggablePopup/GridContainer/HideButton.pressed = !selected_layer.visible
	$DraggablePopup/GridContainerTop/TransparencyHSlider.value = selected_layer.modulate.a * 100
	$DraggablePopup.popup_centered()

# 레이어 복제
func _on_DuplicateLayerButton_pressed():
	if selected_layer == null:
		return
	
	# layer를 하나 만든다.
	var new_layer = NodeManager.get_layers().add_layer()
	
	# 이미지를 복사한다.
	new_layer.copy_image(selected_layer.image, new_layer.image, 0, 0)
	
	# 새로운 layer의 위치를 selected_layer 뒤로 이동
	var selected_layer_index = NodeManager.get_layers().get_child_index(selected_layer)
	if selected_layer_index > -1:
		NodeManager.get_layers().move_child(new_layer, selected_layer_index+1)
	
	# laye button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()


# 레이어 삭제
func _on_DeleteButton_pressed():
	# layer가 하나밖에 없으면 삭제 불가
	if NodeManager.layers.get_child_count() == 1:
		return
		
	# 현재 layer를 지우고 다음 layer를 현재 layer로 설정한다.
	NodeManager.get_layers().remove_layer(selected_layer.index)
	
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()


# 아래로 이동
func _on_MoveDownButton_pressed():
	# 현재 index가 0이면 이동 불가
	if selected_layer.index == 0:
		return
	# 이동	
	NodeManager.get_layers().move_child(selected_layer, selected_layer.index-1)
	# 인덱스 갱신
	NodeManager.get_layers().update_layer_index()
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()
	

# 위로 이동
func _on_MoveUpButton_pressed():
	# 현재 index가 마지막이면 이동 불가
	if selected_layer.index == NodeManager.get_layers().get_child_count()-1:
		return
	# 이동	
	NodeManager.get_layers().move_child(selected_layer, selected_layer.index+1)
	# 인덱스 갱신
	NodeManager.get_layers().update_layer_index()
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()

# 숨김 
func _on_HideButton_pressed():
	selected_layer.visible = !selected_layer.visible
	# layer button을 갱신
	NodeManager.get_layer_panel().update_layer_buttons()
	

# 투명도 슬라이더 변경시..
func _on_TransparencyHSlider_value_changed(value):
	selected_layer.modulate.a = $DraggablePopup/GridContainerTop/TransparencyHSlider.value / 100.0
	$DraggablePopup/GridContainerTop/TransparencyHSlider/TextEdit.text = str($DraggablePopup/GridContainerTop/TransparencyHSlider.value)


# 이전 layer와 합치기
func _on_MergeWithPrevButton_pressed():
	# 이전 layer
	var prev_layer:Layer = NodeManager.get_layers().get_layer(StaticData.current_layer.index-1)
	if prev_layer == null:
		return
		
	# 이미지를 이전 layer로 복사
	prev_layer.copy_image(StaticData.current_layer.image, prev_layer.image, 0, 0)
	
	# 현재 layer 삭제
	_on_DeleteButton_pressed()
		

# 이후 layer와 합치기
func _on_MergeAllButton_pressed():
	var layers = NodeManager.get_layers().get_normal_layers()
	if layers == null || layers.size() < 2:
		return
	
	# 모두 첫번째 layer로 합친다.
	var first_layer = layers[0]
	for layer in layers:
		if layer == first_layer:
			continue
		first_layer.copy_image(layer.image, first_layer.image, 0, 0)
		layer.unused = true
		layer.call_deferred("queue_free")
	
	StaticData.current_layer = first_layer	
	StaticData.current_layer.update_texture()
	# 인덱스 갱신
	NodeManager.get_layers().update_layer_index()
	# layer button을 재생성 한다.
	NodeManager.get_layer_panel().regen_layer_buttons()		
	


func _on_MergeWithNextButton_pressed():
	# 다음 layer
	var next_layer:Layer = NodeManager.get_layers().get_layer(StaticData.current_layer.index+1)
	if next_layer == null:
		return
		
	# 이미지를 다음 layer로 복사
	next_layer.copy_image(StaticData.current_layer.image, next_layer.image, 0, 0)
	
	# 현재 layer 삭제
	_on_DeleteButton_pressed()
