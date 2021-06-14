extends Button

# brush를 등록한다.
func _on_AddBrushButton_pressed():
	if !StaticData.enabled_selected_area():
		Util.show_message("No selected area")
		return
	
	# 선택영역을 이미지로 만든
	var image = Util.create_image_from_selected_area()
	
	# brush로 등록
	var new_user_brush = NodeManager.get_user_brushes().add_user_brush(image)
	
	# brush button 갱신
	NodeManager.get_brush_type_button().update_user_brush_buttons()
	
	# 선택영역 해제
	NodeManager.get_tools().finish_selected_area_editing()
	
	# 마지막에 추가한 브러쉬를 사용하도록 설정
	StaticData.brush_type = StaticData.BrushType.User
	StaticData.set_current_user_brush(new_user_brush)
	
func _process(_delta):
	disabled = !StaticData.enabled_selected_area()
